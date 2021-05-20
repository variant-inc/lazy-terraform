# How to test a PR

```text
Testing Steps

Sample terraform.tfvars

profile = "devops"
region = "us-west-2"
bucket_name = "naveen-ops-1"
purpose = "devops"
team = "devops"
owner = "devops"
lazy_api_host = "https://lazy.apps.ops-drivevariant.com"
lazy_api_key = "add_lazy_api_key_here"
bucket = "lazy-tf-state20210107203535113800000001"
key = "s3/default"
dynamodb_table = "lazy_tf_state"
s3_backend_region = "us-west-2"
octopus_project_space = "test-space"
octopus_project_name = "test-project"

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

module "test_s3_module" {
    source = "git::https://github.com/variant-inc/lazy-terraform.git//s3?ref=feature/CLOUD-199-TF-module-for-s3"
    profile = "devops"
    region = "us-west-2"
    bucket_name = "navin-ops-11"
    purpose = "devops"
    team = "devops"
    owner = "devops"
    lazy_api_host = "https://lazy.apps.ops-drivevariant.com"
    lazy_api_key = "00o2TvfA8DjInc-RuQ1tC6nwqOnsqZ-3bsVyTuBHGK"
    octopus_project_space = "test-space"
    octopus_project_name = "test-project"

}

```
