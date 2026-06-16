# infrastructure

Infrastructure as Code for your environment

## prerequisites

This repo uses the following dependencies :

- direnv for load env vars in `.envrc` files
- asdf for managing binary versions  of the needed tools
- aws-vault (optional) to manage all aws accounts securely
- pyenv for managing python version and virtualenv

You can find more details about each tool on their official websites :

- [direnv](https://direnv.net/)
- [asdf](https://asdf-vm.com)
- [aws-vault](https://github.com/99designs/aws-vault)
- [pyenv](https://github.com/pyenv/pyenv)

### asdf-vm

- install asdf
- run these commands :

```sh
asdf plugin add checkov
asdf plugin add infracost
asdf plugin add terraform
asdf plugin add terraform-docs
asdf plugin add terragrunt
asdf plugin add tflint
asdf plugin add tfsec
asdf plugin add tfupdate
asdf install
```

### pyenv

- install pyenv
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
aws-vault exec <acme-env-aws-account> -- terragrunt run-all apply
```

NOTE: you can add the following arguments in order to fully automate the deployment

- `--terragrunt-non-interactive`
- `--terragrunt-ignore-external-dependencies`

## depploy apps to an env

- take the outputs you need from the step above
- see [argo-app-of-apps](../argo-app-of-apps) repository

## limitations
