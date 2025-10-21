resource "esxi_guest" "web" {
  guest_name = "web"
  disk_store = var.disk_store
  memsize    = var.vm_memsize
  numvcpus   = var.vm_numvcpus

  ovf_source = var.ovf_source
  network_interfaces {
    virtual_network = var.virtual_network
  }

  guestinfo = {
    "metadata"          = filebase64("${path.module}/../cloudinit/metadata.yml")
    "metadata.encoding" = "base64"
    "userdata"          = filebase64("${path.module}/../cloudinit/userdata.yml")
    "userdata.encoding" = "base64"
  }
}

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

resource "azurerm_virtual_network" "main" {
  name                = var.virtual_network_name
  address_space       = var.address_space
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
}

resource "azurerm_subnet" "internal" {
  name                 = var.subnet_name
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.subnet_address_prefixes
}

resource "azurerm_public_ip" "pip" {
  name                = "azurerm-pip"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  allocation_method   = var.allocation_method
  sku                 = var.sku
}

resource "azurerm_network_interface" "main" {
  name                = "azurerm-nic"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "ssh-nsg"
    priority                   = 100
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "22"
    destination_address_prefix = "*"
  }
  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "http-nsg"
    priority                   = 200
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "8080"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = azurerm_subnet.internal.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

data "azurerm_ssh_public_key" "key" {
  name                = "azure-ssh-key"
  resource_group_name = data.azurerm_resource_group.main.name
}

resource "azurerm_linux_virtual_machine" "main" {
  name                            = "azurerm-vm"
  resource_group_name             = data.azurerm_resource_group.main.name
  location                        = data.azurerm_resource_group.main.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.main.id]
  # custom_data                     = base64encode(file("cloud-init.yml"))

  admin_ssh_key {
    username   = var.admin_username
    public_key = data.azurerm_ssh_public_key.key.public_key
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}


# Genereer inventory
resource "local_file" "inventory" {
  content = templatefile("${path.module}/inventory.ini.tpl", {
    web_vms  = esxi_guest.web
    azure_vm = azurerm_linux_virtual_machine.main
    azure_ip = azurerm_public_ip.pip.ip_address
  })
  filename = "${path.module}/../ansible/inventory.ini"

}
