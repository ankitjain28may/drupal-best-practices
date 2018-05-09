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



## One Click deployment

  ```shell
    ansible-playbook ansible/drupal.production.yml -i ansible/inventories/develop
  ```

  will deploy your drupal site on all the hosts from the inventory file.

> Default inventory file is loaded from `ansible.cfg`.

## Install Drupal on Localhost (Locally)

1. Set group_vars for the localhost host in `localhost.yml` file in `ansible/group_vars` directory.

2. Run this command -

  ```shell
    ansible-playbook ansible/drupal.local.yml --connection=local --extra-vars "ansible_sudo_pass=<local-system-password>"
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


