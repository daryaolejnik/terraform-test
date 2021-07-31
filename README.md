Create secret.tfvars file with content:
db_password = {{db_password}}

Change main.tf file:
change the project_id and creadentials in providers.

======================================================
To run terraform:
terraform init
terraform plan
terraform apply -var-file="/path/to/secret.tfvars"

To destroy all infractructure:
terraform destroy