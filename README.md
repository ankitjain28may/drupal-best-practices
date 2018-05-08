# Drupal Best Practices

[![Build Status](https://travis-ci.org/ankitjain28may/drupal-best-practices.svg?branch=master)](https://travis-ci.org/ankitjain28may/drupal-best-practices)

This project template provides a starter kit for managing Drupal Workflow using [Ansible](https://www.ansible.com/), [Docker](https://docker.com/), [Git](https://git-scm.com/) and [Composer](https://getcomposer.org/)

You can manage multiple sites like production/development and staging servers through this project, All your environment will setup, install dependencies and Sync Configuration in a single click.

## Requirements

You should have python2.7 installed on your server so that Ansible can use its magic ward to help you in managing Drupal Projects.

# Usage

  Let's see how to use and implement this project kit.

### Configure .env file

You need to create `.env` file for each deploying server. It will also be managed by ansible automatically. You need to create `.env.<hostname>` file and add `<hostname>` name in `env_file` variable in host group_var file.

`cp .env.example .env.<hostname>`

```
  APP_ENV=
  HASH_SALT=

  MYSQL_DATABASE=drupal
  MYSQL_HOSTNAME=mysql
  MYSQL_PASSWORD=<password>
  MYSQL_PORT=3306
  MYSQL_USER=root

  APP_PORT=
  DB_PATH=./db-dump/drupal.sql
  SAVE_PREVIOUS_DB_DUMP=true
  EXPORT_CONFIG_ON_COMMIT=true
  EXPORT_DB_DUMP_ON_COMMIT=true
```

**Note** : For configuring on Local system, create .env file and set configs.

Copy .env.example file to .env
```shell
  cp .env.example .env
```

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
Add your hosts name in existing playbooks defined in subdirectory called `playbooks` or create your own custom playbooks.

### Playbooks

In this project, Total 8 playbooks are defined to help you, Detailed description of these playbooks-

1. **drupal.development.yml** is configured for your development environment -

  ```shell
    ansible-playbook ansible/playbooks/drupal.development.yml -i <inventory_path>
  ```
  have following roles -
  `{git-pull, env, restart, composer, drupal}`

2. **drupal.docker-install.yml** is configured to install docker and docker-compose -

  ```shell
    ansible-playbook ansible/playbooks/drupal.docker-install.yml -i <inventory_path>
  ```
  have following roles -
  `{docker-install}`

3. **drupal.production.yml** is configured to setup site on production server -

  ```shell
    ansible-playbook ansible/playbooks/drupal.production.yml -i <inventory_path>
  ```
  have following roles -
  `{backup, docker-install, git-clone, git-hooks, env, docker-build, composer-prod, drupal}`

4. **drupal.restore-backup.yml** is configured to restore backup on your server -

  ```shell
    ansible-playbook ansible/playbooks/drupal.restore-backup.yml -i <inventory_path>
  ```
  have following roles -
  `{restore, docker-build, composer-prod, drupal}`

5. **drupal.staging.yml** is configured to setup site on staging server -

  ```shell
    ansible-playbook ansible/playbooks/drupal.staging.yml -i <inventory_path>
  ```
  have following roles -
  `{backup, docker-install, git-stage, git-hooks, env, restart, composer, drupal}`

6. **drupal.backup.yml** is configured to backup your site on server -

  ```shell
    ansible-playbook ansible/playbooks/drupal.backup.yml -i <inventory_path>
  ```
  have following roles -
  `{backup}`

7. **drupal.local.yml** is configured to configure development environment on your local system -

  ```shell
    ansible-playbook ansible/playbooks/drupal.local.yml -i <inventory_path>
  ```
  have following roles -
  `{docker-install, git-hooks, docker-build, composer, drupal}`

8. **drupal.travis.prod.yml** is configured to integrate Continuous Integration and Continuous Deployment -

  ```shell
    ansible-playbook ansible/playbooks/drupal.travis.prod.yml -i <inventory_path>
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

**Note** : You can configure your docker-compose file, Read more about it under [docker directory](https://github.com/ankitjain28may/drupal-best-practices/tree/master/docker)

## One Click deployment

  ```shell
    ansible-playbook ansible/playbooks/drupal.production.yml -i ansible/inventories/develop
  ```

  will deploy your drupal site on all the hosts from the inventory file.

> Default inventory file is loaded from `ansible.cfg`.

## Install Drupal on Localhost (Locally)

1. Set group_vars for the localhost host in `localhost.yml` file in `ansible/group_vars` directory.

2. Run this command -

  ```shell
    ansible-playbook ansible/playbooks/drupal.local.yml --connection=local --extra-vars "ansible_sudo_pass=<local-system-password>"
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
**Note** : You can also add your custom testsuites by making changes in `.travis.yml` file.

## Continous Deployment

On Successful Build, Travis will deploy the changes to the server using Ansible. Ansible will connect to server through SSH username and Password. Password will be saved in Travis-CI env variable in a secure mode through Web Interface so that it won't be visible during build.
Password Key should be - `ssh_pass`

It will automatically deploy the changes to your deploying server.

**Note** : Travis configuration will be set in `.env.travis` and `travis.yml` under group_vars dir and You can add your own custom roles under `roles` and called them from `drupal.travis.prod.yml` playbook for travis configuration.

## Future Implementation

* [ ] Maintaining log file for each deployment using ansible on host server.

* [ ] Opting .env.<hostname> file from setting up through Ansible.


## Contribute :

  If you are interested in contributing to this project, Open Issues, send PR and Don't forget to star the repo.

    Feel free to code and contribute

**Note** :  Make new branch for each PR.


