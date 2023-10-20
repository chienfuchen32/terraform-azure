# Purpose
Build, change, and destroy infrastructure with Terraform
This repository to implement Azure resource management including `virtual machine`, `Azure PostgreSQL flexible server`, `Azure Cache for Redis`, `Azure Managed Instance for Apache Cassandra`, `Azure Kubernetes service`, `Application Gateway` establishing, updating and destroy with limited scoped service priciple.
## create Azure service principle
```bash
$ az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>/resourceGroups/<RESOURCE_GROUP>"
# export all environment variable to .env file
$ source .env
```
## provision infrastructure
```bash
$ terraform --version
Terraform v1.5.7
# Let's see what we can do.
$ terraform --help
Usage: terraform [global options] <subcommand> [args]

The available commands for execution are listed below.
The primary workflow commands are given first, followed by
less common or more advanced commands.

Main commands:
  init          Prepare your working directory for other commands
  validate      Check whether the configuration is valid
  plan          Show changes required by the current configuration
  apply         Create or update infrastructure
  destroy       Destroy previously-created infrastructure

All other commands:
  console       Try Terraform expressions at an interactive command prompt
  fmt           Reformat your configuration in the standard style
  force-unlock  Release a stuck lock on the current workspace
  get           Install or upgrade remote Terraform modules
  graph         Generate a Graphviz graph of the steps in an operation
  import        Associate existing infrastructure with a Terraform resource
  login         Obtain and save credentials for a remote host
  logout        Remove locally-stored credentials for a remote host
  metadata      Metadata related commands
  output        Show output values from your root module
  providers     Show the providers required for this configuration
  refresh       Update the state to match remote systems
  show          Show the current state or a saved plan
  state         Advanced state management
  taint         Mark a resource instance as not fully functional
  test          Experimental support for module integration testing
  untaint       Remove the 'tainted' state from a resource instance
  version       Show the current Terraform version
  workspace     Workspace management

Global options (use these before the subcommand, if any):
  -chdir=DIR    Switch to a different working directory before executing the
                given subcommand.
  -help         Show this help output, or the help for a specified subcommand.
  -version      An alias for the "version" subcommand. 
# go to the resource working folder like `application-gateway`
$ pushd <folder>
# init a terraform configuration working directory
$ terraform init -upgrade
# preview changes for you infrastructure
$ terraform plan -out main.tfplan
# execute create or update the resources
$ terraform apply main.tfplan
# delete resources
$ terraform destroy
```
