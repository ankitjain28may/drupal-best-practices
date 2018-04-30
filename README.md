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

1. **drupal.development.yml** is configured for your development environment -

  ```shell
    ansible-playbook ansible/drupal.development.yml
  ```
  will have following roles -
  `{git-pull, env, restart, composer, drupal}`

2. **drupal.docker-install.yml** is configured to install docker and docker-compose -

  ```shell
    ansible-playbook ansible/drupal.docker-install.yml
  ```
  will have following roles -
  `{docker-install}`

3. **drupal.production.yml** is configured to setup site on production server -

  ```shell
    ansible-playbook ansible/drupal.production.yml
  ```
  will have following roles -
  `{backup, docker-install, git-clone, env, docker-build, composer-prod, drupal}`

4. **drupal.restore-backup.yml** is configured to restore backup on your server -

  ```shell
    ansible-playbook ansible/drupal.restore-backup.yml
  ```
  will have following roles -
  `{restore, docker-build, composer-prod, drupal}`

5. **drupal.staging.yml** is configured to setup site on staging server -

  ```shell
    ansible-playbook ansible/drupal.staging.yml
  ```
  will have following roles -
  `{backup, docker-install, git-stage, env, restart, composer, drupal}`

6. **drupal.backup.yml** is configured to backup your site on server -

  ```shell
    ansible-playbook ansible/drupal.backup.yml
  ```
  will have following roles -
  `{backup}`

### Roles

1. **backup** - It will rename `html` folder to `backup` folder and create empty `html` folder under `/var/www` directory.

2. **composer** - Install Composer Dependencies with dev dependencies.

3. **composer-prod** - Install Composer Dependencies without dev dependencies.

4. **docker-build** - Delete previous container and rebuild image if there is any change and re-create `drupal` and `drupaldb` containers.

5. **docker-install** - Install Docker and docker-compose on the server.

6. **drupal** - Import Configuration and Rebuild Cache.

7. **env** - Move `.env.ansible` to `.env`.

8. **git-clone** - Clone the git repo.

9. **git-pull** - Pull the changes from the git repo after stashing any local changes.

10. **git-stage** - Clone the selective branch from git repo.

11. **restart** - Restart Docker containers.

12. **restore** - Restore previously generated `backup` folder to `html` and `html` to `backup` under `/var/www` directory.

## Docker

Docker is a tool designed to make it easier to create, deploy, and run applications by using containers. Containers allow a developer to package up an application with all of the parts it needs, such as libraries and other dependencies, and ship it all out as one package

> This project will have three images from which we create two containers.

1. [mariadb](https://hub.docker.com/_/mariadb/) image from [Docker hub](https://hub.docker.com) for creating database container.

2. [Ubuntu](https://hub.docker.com/_/ubuntu/) V16.04 image from [Docker hub](https://hub.docker.com) for generating image using Dockerfile.

3. [php-nginx-composer](https://hub.docker.com/r/ankitjain28/php-nginx-composer/) install nginx, php7.2 with its extensions and composer. This image is maintained by me under Github Repo [php-nginx-composer](https://github.com/ankitjain28may/php-nginx-composer)

### Docker Compose

Compose is a tool for defining and running multi-container Docker applications.

We have defined `docker-compose.yml` file to create Containers from `php-nginx-composer` and `mariadb` images.

**docker-compose.yml** contains two services -

1. **drupaldb** : It will create container name `drupaldb` using `mariadb` image and import the dump in the `db-dump` to the database. Set env variable in `.env` file.

2. **drupal** : It will create container name `drupal` using `php-nginx-composer` image and mount `/var/www/html` directory to `/var/www/html` in container and application runs on port `80`.

It depends on **drupaldb** container.


