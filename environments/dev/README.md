# How to build up Azure Infrastructure with Terraform
## Prerequisite

### terraform cli
```bash
$ terraform --version
Terraform v1.6.0
```
https://developer.hashicorp.com/terraform/tutorials/azure-get-started/install-cli
### create Azure service principle and role assignment
```bash
$ az ad sp create-for-rbac --name <SP_NAME> --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>/resourceGroups/<RESOURCE_GROUP_NAME>"
# check the service principal information and fill in .env file
```
```
$ vi .env
$ bash ./gen_provider.sh

# initializes a working directory and downloads the necessary provider plugins and modules and setting up the backend for storing your infrastructure's state
$ source .env
$ terraform init
```
## Create Infrastructure with local module
```bash
# edit varable for your infrastructure. note that module has the default variable value, please check every module you use to ensure everything work like a charm.
$ vi variable.tf
```
### check if the IaC plan meet your expectation
```bash
$ terraform plan -out main.tfplan
```
### apply the plan
```bash
$ terraform apply main.tfplan
```
## Others
### destroy resources
```bash
$ terraform destroy
```
### modify part resource
```bash
$ terraform plan -target='resource.name' -out main.tfplan
$ terraform apply -target='resource.name'
$ terraform plan -target="module.vm" -out main.tfplan
$ terraform apply main.tfplan
$ terraform destroy -target='resource.name'
```
