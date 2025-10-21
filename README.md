# Week 6 - Infrastructure as Code

This repository demonstrates a hybrid cloud deployment combining **Terraform**, **Cloud-init**, **Ansible**, and **Docker Compose** to automatically provision and configure both **ESXi** and **Azure** virtual machines with a containerized Flask application.

---

## Table of Contents
- [Installation](#installation)
- [Usage](#usage)
- [Testing](#testing)
- [Development Guidelines](#development-guidelines)
- [CI/CD](#cicd)
- [Technical Overview](#technical-overview)
- [Documentation](#documentation)

---

## Installation

Clone this repository using SSH or HTTPS:

### SSH
```bash
git clone git@github.com:xTCKx/week6.git
cd week6
```

### HTTPS
```bash
git clone https://github.com/xTCKx/week6.git
cd week6
```

### Initialize Terraform
```bash
cd terraform
terraform init
```

### Install Ansible dependencies
```bash
cd ../ansible
ansible-galaxy install -r requirements.yml
```

---

## Usage

### Step 1: Deploy Infrastructure
Provision both ESXi and Azure virtual machines:
```bash
cd terraform
terraform apply -auto-approve
```

This creates the inventory file automatically at `ansible/inventory.ini`.

### Step 2: Deploy Application
Configure VMs and deploy the Dockerized Flask application:
```bash
cd ../ansible
ansible-playbook docker.yml
```

This installs Docker via the external role and starts the application container on port 8080.

### Step 3: Access Application
Open your browser and navigate to:
```
http://<azure-vm-ip>:8080
```

---

## Testing

Validate your infrastructure and configuration before deployment:

### Terraform
```bash
terraform validate
```

### Ansible
```bash
ansible-playbook --syntax-check ansible/docker.yml
```

### YAML Linting
```bash
yamllint .
```

### Application Testing
Test the deployed application:
```bash
curl http://<AZURE_IP>:8080
```

---

## Development Guidelines

- **Branching**: Use conventional branch names (`feat/...`, `fix/...`, `chore/...`)
- **Commits**: Follow conventional commit format (`feat: add docker deployment`)
- **Code Management**: Archive old code instead of deletion
- **Best Practices**: Keep sensitive data out of version control using `.gitignore`

---

## CI/CD

This repository includes GitHub Actions workflows in `.github/workflows/` that automatically run on push and pull requests:

- Terraform validation
- Ansible syntax checking
- YAML linting

These checks ensure code quality before deployment.

---

## Technical Overview

### Terraform
- Provisions ESXi VM using OVF template
- Creates Azure VM with public IP, network security groups, and SSH access
- Automatically generates Ansible inventory from infrastructure outputs

### Cloud-Init
- Configures initial VM setup with user accounts
- Installs necessary packages
- Sets up SSH keys for secure access

### Ansible
- Installs Docker using external Galaxy role (`xTCKx.docker_cinnamorole`)
- Deploys containerized Flask application via Docker Compose
- Manages application lifecycle and dependencies

### Application Stack
- **Flask**: Python web framework serving static content
- **Docker**: Containerization platform
- **Docker Compose**: Multi-container orchestration

---

## Documentation

- **`terraform/`** - Infrastructure definitions for ESXi and Azure
- **`ansible/`** - Configuration management playbooks and inventory
- **`app/`** - Flask application source code and Dockerfile
- **`cloudinit/`** - VM initialization configurations
- **`.github/workflows/`** - CI/CD pipeline definitions

---

## License
GPLv3 [LICENSE](LICENSE)