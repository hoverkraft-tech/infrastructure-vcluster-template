# infrastructure

Infrastructure as Code for your environment: **vcluster version**

This repository is a template to help you start with the creation of an **Hoverkraft environment based on vcluster**.

## prerequisites

This repo uses the following dependencies :

- **mise-en-place** for heving a good development experience
- **pyenv** for managing python version and virtualenv (used mainly by pre-commit hooks)

You can find more details about each tool on their official websites :

- [mise-en-place](https://mise.jdx.dev)
- [pyenv](https://github.com/pyenv/pyenv)

### mise-en-place

- Please refer to the [mise-en-place](https://mise.jdx.dev) website for installation instructions
- run these commands :

```sh
mise trust
mise install
```

### pyenv

- Please refer to the [pyenv](https://github.com/pyenv/pyenv) website for installation instructions
- run these commands :

```shell
pyenv virtualenv 3.13.0 hk-ovh
```

## setup a new env

- copy one of the prod env and rename the top level folder
- remove terraform states files (`find . -type f -name '.terraform.lock.hcl' -exec rm {} \; && find . -type d -name '.terragrunt-cache' -exec rm -rf {} \;`)
- search and replace `/old/new/` in the just created folder
- create an SSH ED25519 key `ssh-keygen -t ed25519 -C '<env>@acme.net' -f <env>` and store it in password store repository
- customize the `env.yaml` file to suits your needs

## deploy an env (or partial subfolder)

```shell
cd envs/xxxxxxxxx
cd <part you want to apply> # if you want to deploy full env just skip this step
terragrunt apply --all
```

## depploy apps to an env

- take the outputs you need from the step above
- see [argo-app-of-apps](../argo-app-of-apps) repository
