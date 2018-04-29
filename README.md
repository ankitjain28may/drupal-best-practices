# Drupal Best Practices

This project template provides a starter kit for managing Drupal Workflow using [Ansible](https://www.ansible.com/), [Docker](https://docker.com/), [Git](https://git-scm.com/) and [Composer](https://getcomposer.org/)

You can manage multiple sites like production/development and staging servers through this project, All your environment will setup, install dependencies and Sync Configuration in a single click.

## Requirements

You should have python2.7 installed on your server so that Ansible can use its magic ward to help you in managing Drupal Projects.

# Usage

  Let's see how to use and implement this project kit.

## Ansible

Ansible is the most powerful automation tool that can configure the hosts at ease. Define your own hosts under `ansible/inventories` and configure your inventory in `ansible.cfg` in root directory

Add hosts under groups and configure groups in `ansible.*.yml` under `ansible` folder.

Add and Set Variables under group_vars variable for your defined groups.

1. `drupal.development.yml` is configured for your development environment, On running -

  ```shell
    ansible-playbook ansible/drupal.development.yml
  ```
  will have following roles -
  `{git-pull, env, restart, composer, drupal}`

2. `drupal.docker-install.yml` is configured to install docker and docker-compose, On running -

  ```shell
    ansible-playbook ansible/drupal.docker-install.yml
  ```
  will have following roles -
  `{docker-install}`

3. `drupal.production.yml` is configured to setup site on production server, On running -

  ```shell
    ansible-playbook ansible/drupal.production.yml
  ```
  will have following roles -
  `{backup, docker-install, git-clone, env, docker-build, composer-prod, drupal}`

4. `drupal.restore-backup.yml` is configured to restore backup on your server, On running -

  ```shell
    ansible-playbook ansible/drupal.restore-backup.yml
  ```
  will have following roles -
  `{restore, docker-build, composer-prod, drupal}`

5. `drupal.staging.yml` is configured to setup site on staging server, On running -

  ```shell
    ansible-playbook ansible/drupal.staging.yml
  ```
  will have following roles -
  `{backup, docker-install, git-stage, env, restart, composer, drupal}`

### Roles

1. backup - It will create `backup` folder of `html` folder under `/var/www` directory.

2. composer - Install Composer Dependencies with dev dependencies.

3. composer-prod - Install Composer Dependencies without dev dependencies.

4. docker-build - Delete previous container and rebuild image if there is any change and re-create `drupal` and `drupaldb` containers.

5. docker-install - Install Docker and docker-compose on the server.

6. drupal - Import Configuration and Rebuild Cache.

7. env - Move `.env.ansible` to `.env`.

8. git-clone - Clone the git repo.

9. git-pull - Pull the changes from the git repo after stashing any local changes.

10. git-stage - Clone the selective branch from git repo.

11. restart - Restart Docker containers.

12. restore - Restore previously generated `backup` folder to `html` and `html` to `backup` under `/var/www` directory.

## Docker
