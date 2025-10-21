[all:vars]
ansible_user=kuromi
ansible_ssh_common_args="-o StrictHostKeyChecking=no"

[skylab]
${web_vms.guest_name} ansible_host=${web_vms.ip_address} ansible_ssh_private_key_file=~/.ssh/id_ed25519-skylab

[azure]
${azure_vm.name} ansible_host=${azure_ip} ansible_ssh_private_key_file=~/.ssh/id_ed25519-azure

[azure:vars]
ansible_user=iac