# Drupal Best Practices

[![Build Status](https://travis-ci.org/ankitjain28may/drupal-best-practices.svg?branch=master)](https://travis-ci.org/ankitjain28may/drupal-best-practices)

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

7. **drupal.travis.prod.yml** is configured to integrate Continuous Integration and Continuous Deployment -

  ```shell
    ansible-playbook ansible/drupal.travis.prod.yml
  ```
  will have following roles -
  `{docker-build, composer, drupal}`

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

> This project will have two images from which we create two containers.

1. [mariadb](https://hub.docker.com/_/mariadb/) image from [Docker hub](https://hub.docker.com) for creating database container.

2. [ankitjain28/php-nginx-composer](https://hub.docker.com/r/ankitjain28/php-nginx-composer/) install nginx, php7.2 with its extensions and composer. This image is maintained by me under Github Repo [php-nginx-composer](https://github.com/ankitjain28may/php-nginx-composer)

### Docker Compose

Compose is a tool for defining and running multi-container Docker applications.

We have defined `docker-compose.yml` file to create Containers from `ankitjain28/php-nginx-composer` and `mariadb` images.

**docker-compose.yml** contains two services -

1. **drupaldb** : It will create container name `drupaldb` using `mariadb` image and import the dump in the `db-dump` to the database. Set env variable in `.env` file.

2. **drupal** : It will create container name `drupal` using `ankitjain28/php-nginx-composer` image and mount `/var/www/html` directory to `/var/www/html` in container and application runs on port `80`.

It depends on **drupaldb** container for database.

  ```
    docker-compose up -d
  ```
 will create two containers and you can anytime start and stop your container using-

  ```
    docker-compose stop <container-name>
  ```

  ```
    docker-compose start <container-name>
  ```

> Add your configuration under group_vars directory for your defined groups to manage multiple sites on multiple servers.

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
## One Click Installation

  ```shell
    ansible-playbook ansible/drupal.production.yml -i ansible/inventories/develop
  ```

  will deploy your drupal site on all the hosts from the inventory file.
> Default inventory file is loaded from `ansible.cfg`.

## Install Drupal on Localhost (Locally)

1. Add localhost group to hosts in `drupal.*.yml` under `ansible` dir and set group_vars for the localhost in `localhost.yml` file.

2. Run this command -

  ```shell
    ansible-playbook ansible/drupal.production.yml --connection=local --extra-vars "ansible_sudo_pass=<local-system-password>"
  ```

> All the dependencies are managed using Composer.

For more information about managing dependencies and sync configuration, Read here -

 - [The best way to manage your Drupal workflow](http://ankitjain28.me/best-way-managing-drupal-workflow)

## Continous Integration

For Continuous Integration, We are using Travic-Ci.
Each time we pushes through Git, Travis is triggred and checks for Code Quality (Using CodeSniffer) and Unit Tests (Using PHPunit).

You can skip these in `.travis.yml` file by setting `env` variables value.

```
  env:
    BUILD_CHECK_PHPCS: false
    BUILD_CHECK_PHPUNIT: false
    DEPLOY: true
```

## Continous Deployment

On Successful Build, Travis will deploy the changes to the server using Ansible. Ansible will connect to server through SSH username and Password. Password will be saved in Travis-CI env variable in a secure mode so it wont be visible during build.
Password Key should be - `ssh_pass`

It will automatically deploy the changes to your deploying server.

**Note** : Travis configuration will be set in `.env.travis` and `travis.yml` under group_vars dir and You can add your own custom roles under `roles` and called them from `drupal.travis.prod.yml` for travis configuration.

## Contribute :

  If you are interested in contributing to this project, Open Issues, send PR and Don't forget to star the repo.

    Feel free to code and contribute

**Note** :  Make new branch for each PR.


