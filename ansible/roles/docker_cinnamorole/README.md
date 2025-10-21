# Docker Cinnamorole

An Ansible role that installs Docker and Docker Compose, then deploys and runs your Docker Compose applications on Ubuntu systems.

## Role Variables

Available variables with default values (see `defaults/main.yml`):
```yaml
# Directory where docker-compose.yml will be placed
docker_compose_dir: /opt/docker-compose

# Source path for the compose file (relative to playbook or absolute path)
compose_file_src: docker-compose.yml

# User to add to docker group (defaults to ansible_user)
docker_user: "{{ ansible_user | default('root') }}"
```

## Dependencies

This role requires the following collections:

- `community.docker`

## License

GPL-3.0
