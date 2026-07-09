# S3 backend for Terraform state
#
# INITIAL SETUP INSTRUCTIONS:
# 1. First run: `terraform init` (without this backend config commented out)
# 2. Apply: `terraform apply` to create initial resources including the state bucket
# 3. Then uncomment the backend block below
# 4. Run: `terraform init -migrate-state` to migrate state from local to S3
# 5. Confirm the migration when prompted
#
# After setup, state will be stored in S3 with DynamoDB locking enabled.

# terraform {
#   backend "s3" {
#     bucket         = "bunmiolowo-dmisite-terraform-state"
#     key            = "terraform.tfstate"
#     region         = "us-east-1"
#     encrypt        = true
#     dynamodb_table = "terraform-locks"
#   }
# }
