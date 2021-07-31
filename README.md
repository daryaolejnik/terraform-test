Create secret.tfvars file with content:<br>
db_password = {{db_password}}<br>

Change main.tf file:<br>
change the project_id and creadentials in providers.<br>

======================================================
To run terraform:<br>
terraform init<br>
terraform plan<br>
terraform apply -var-file="/path/to/secret.tfvars"<br>

To destroy all infractructure:<br>
terraform destroy<br>