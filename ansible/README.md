## Ansible

Ansible is the most powerful automation tool that can automate cloud provisioning, configuration management, application deployment, and many other IT needs.

### Manage your Inventory

Ansible represents what machines it manages using a very simple INI file that puts all of your managed machines in groups of your own choosing.

It looks like this -

```
  [digitalocean]
  example.com ansible_user=root

  [aws]
  example.me ansible_user=ubuntu
```
Once inventory hosts are listed under `ansible/inventories`, variables can be assigned to them in yml files (in a subdirectory called `group_vars`)

It looks like this -

```yml

  remote_user: ubuntu
  docker_group: docker
  github_repo: 'https://github.com/ankitjain28may/drupal-best-practices.git'
  staging_branch: 'develop'
  env_file: 'ansible'
  backup_dir: '/var/www'
  project_dir: '/var/www'
  project_folder_name: 'html'
  backup_folder_name: 'backup'

```

**Note** : Configure default path to your inventory in `ansible.cfg` in root directory

### Ansible Playbooks

Anisble Playbooks can be used to manage configurations of and deployments to remote machines.

Ansible playbooks looks like -

```yml

  ---
  - name: Name of the playbook
  hosts: <hostname>
  roles:
  - role1
  - role2
```
Add your hosts name in existing playbooks defined in `drupal.*.yml` under `ansible` dir or create your own custom playbooks.

### Playbooks

In this project, Total 8 playbooks are defined to help you, Detailed description of these playbooks-

1. **drupal.development.yml** is configured for your development environment -

  ```shell
    ansible-playbook ansible/drupal.development.yml -i <inventory_path>
  ```
  have following roles -
  `{git-pull, env, restart, composer, drupal}`

2. **drupal.docker-install.yml** is configured to install docker and docker-compose -

  ```shell
    ansible-playbook ansible/drupal.docker-install.yml -i <inventory_path>
  ```
  have following roles -
  `{docker-install}`

3. **drupal.production.yml** is configured to setup site on production server -

  ```shell
    ansible-playbook ansible/drupal.production.yml -i <inventory_path>
  ```
  have following roles -
  `{backup, docker-install, git-clone, git-hooks, env, docker-build, composer-prod, drupal}`

4. **drupal.restore-backup.yml** is configured to restore backup on your server -

  ```shell
    ansible-playbook ansible/drupal.restore-backup.yml -i <inventory_path>
  ```
  have following roles -
  `{restore, docker-build, composer-prod, drupal}`

5. **drupal.staging.yml** is configured to setup site on staging server -

  ```shell
    ansible-playbook ansible/drupal.staging.yml -i <inventory_path>
  ```
  have following roles -
  `{backup, docker-install, git-stage, git-hooks, env, restart, composer, drupal}`

6. **drupal.backup.yml** is configured to backup your site on server -

  ```shell
    ansible-playbook ansible/drupal.backup.yml -i <inventory_path>
  ```
  have following roles -
  `{backup}`

7. **drupal.local.yml** is configured to configure development environment on your local system -

  ```shell
    ansible-playbook ansible/drupal.local.yml -i <inventory_path>
  ```
  have following roles -
  `{docker-install, git-hooks, docker-build, composer, drupal}`

8. **drupal.travis.prod.yml** is configured to integrate Continuous Integration and Continuous Deployment -

  ```shell
    ansible-playbook ansible/drupal.travis.prod.yml -i <inventory_path>
  ```
  have following roles -
  `{docker-build, composer, drupal}`

### Roles

1. **backup** - It will rename `html` folder to `backup` folder and create empty `html` folder.

2. **composer** - Install Composer Dependencies with dev dependencies.

3. **composer-prod** - Install Composer Dependencies without dev dependencies.

4. **docker-build** - Delete previous container and rebuild image if there is any change and re-create `drupal` and `drupaldb` containers.

5. **docker-install** - Install Docker and docker-compose on the server.

6. **drupal** - Import Configuration and Rebuild Cache.

7. **env** - Move `.env.example` to `.env`.

8. **git-clone** - Clone the git repo.

9. **git-pull** - Pull the changes from the git repo after stashing any local changes.

10. **git-stage** - Clone the selective branch from git repo.

11. **git-hooks** - Configure git hooks on pre-commit

12. **restart** - Restart Docker containers.

13. **restore** - Restore previously generated `backup` folder to `html` and `html` to `backup`.
