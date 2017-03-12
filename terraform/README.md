# Terraform

We use terraform to spawn our VMs.


## Secrets
Create a `variables.tf` file containing the exoscale keys.
```
variable "exoscale_api_key" {
    type = "string"
    default = "INSERT"
}

variable "exoscale_secret_key" {
    type = "string"
    default = "INSERT"
}
```


## Usage
Change or add a `.tf` script how you like it. Then
```
terraform plan   # to see what would happen
terraform apply  # to execute the changes
```
