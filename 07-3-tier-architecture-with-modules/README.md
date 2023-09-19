Building a highly available 3-tier application on aws using terraform end-to-end 

procedures
- create a new repo/existing repository
- create s3 bucket and dynanodb table for the backend 
- configure the backend (terraform.tf)
- creating workspace

'''
terraform init
terraform workspace new sbx (sandbox)
terraform workspace list 
'''

## Run terraform plan/apply/destroy
'''
terraform plan -var-file sbx.tfvars