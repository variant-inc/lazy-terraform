# How to test a PR

Testing Steps

Sample terraform.tfvars

```bash
profile = "devops"
region = "us-west-2"
bucket_name = "naveen-ops-2132385"
lazy_api_host = "https://lazy.apps.ops-drivevariant.com"
# lazy_api_host = "https://lazyapi-test.apps.ops-drivevariant.com"
lazy_api_key = "#################"
user_tags = {
team = "devops4"
purpose = "s3-test3"
owner = "naveen3"
}
octopus_tags = {
  project = "actions-test3"
  space   = "Default3"
}
replication=false
```

**prerequisites:**
Run export AWS_DEFAULT_REGION="us-east-1" to set the region

**Positive scenario:**

Add above tfvars and run terraform commands. If the bucket creation is successful, this will give below success logs and verify it in aws console.

null_resource.lazy_s3_api: Creation complete after 2s [id=7797626284577043951]
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Running terraform destroy will delete bucket created in above process.

**Negative Scenario:**

In above tfvars change bucket name by adding some special characters. It should fail bucket creation and show the reason for failures.
In tfvars
bucket_name = "naveen-ops-8%%"

Connecting to lazy.apps.ops-drivevariant.com (lazy.apps.ops-drivevariant.com)|54.245.149.241|:443... connected.
HTTP request sent, awaiting response... 500 Internal Server Error
Saving to: ‘STDOUT’
"Parameter validation failed:\nInvalid bucket name \"naveen-ops-8%%\": Bucket name must match the regex \"^[a-zA-Z0-9.\\-_]{1,255}$\" or be an ARN matching the regex \"^arn:(aws).*:(s3|s3-object-lambda):[a-z\\-0-9]+:[0-9]{12}:accesspoint[/:][a-zA-Z0-9\\-]{1,63}$|^arn:(aws).*:s3-outposts:[a-z\\-0-9]+:[0-9]{12}:outpost[/:][a-zA-Z0-9\\-]{1,63}[/:]accesspoint[/:][a-zA-Z0-9\\-]{1,63}$\""
     0K                                                       100% 91.8M=0s

To test as source module

```bash
variable "octopus_tags" {
  description = "Octopus Tags"
  type = map(string)
}
variable "lazy_api_host" {
  type = string
}

variable "lazy_api_key" {
  type = string
  sensitive = true
}


module "test_s3_module" {
    source = "git::https://github.com/variant-inc/lazy-terraform.git//s3?ref=v1"
    profile = "devops"
    region = "us-west-2"
    bucket_name = "navin-ops-39"
    lazy_api_key = var.lazy_api_key # If run from octopus, this will be auto set
    lazy_api_host = var.lazy_api_host # If run from octopus, this will be auto set
    user_tags = {
            team = "devops2"
            purpose = "s3-test3"
            owner = "naveen3"
            }
    octopus_tags = var.octopus_tags # If run from octopus, this will be auto set
    replication=true
}

```

To delete the bucket, run below terraform destroy command

```bash
terraform destroy
```
