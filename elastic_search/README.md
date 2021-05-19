# Lazy EC-2 Module

Module to deploy EC2 instance and required resources in a lazy fashion

## Resources

- Security Group
- Security Group Rules
- Random Password (If nonotne provided)
- ES Service Domain
- Log Groups for ES Cluster
- Log Resource Policy for Log Groups

## Input Variables

- region
  - string
  - default = us-east-1
- profile
  - string
- domain_name
  - string
- es_version
  - string
  - default = 7.10
- vpc_id
  - string
- inbound_cidr
  - string
  - default = "0.0.0.0/0"
- [cluster_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticsearch_domain#kibana_endpoint)
  - map(string)
  - example

    ```bash
    dedicated_master_enabled = false
    instance_count= 4
    ```

    or

    ```bash
    dedicated_master_enabled = true
    dedicated_master_count = 2
    instance_count= 4
    ```

- [master_user_options](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticsearch_domain#master_user_options)
  - map(string)
  - example

    ```bash
    master_user_name= "devops-test-user"
    master_user_password= "jbb12377(!#%TORkf2ef"
    ```

- user_tags
  - map(string)
  - Following tags are required
  
    ```bash
    octopus-project_name= "actions-test"
    octopus-space_name = "Default"
    Team= "devops"
    Purpose= "elk module test"
    Owner= "Samir"
    ```

## Example .tf file module reference

```bash
module "module-test" {
        source = "./elastic_search" # See below for github repo reference
        region="us-east-1"
        profile ="0601924719241_AWSAdministratorAccess"
        domain_name= "module-test"
        vpc_id= "vpc-26r9f023fh2f3"
        inbound_cidr = "0.0.0.0/0"
        cluster_config= {
            dedicated_master_enabled = false
            instance_count= 1
        }
        master_user_options= {
            master_user_name= "devops-test-user"
        }
        user_tags= {
            octopus-project_name= "actions-test"
            octopus-space_name = "Default"
            team= "devops"
            purpose= "elk module test"
            owner= "Samir"
        }
}
```

or example.tf.json

```json
{
    "module": {
        "module-test": {
            "source" : "git@github.com:variant-inc/lazy-terraform//elastic_search",
            "profile": "06098029709172_AWSAdministratorAccess",
            "region": "us-east-1",
            "domain_name": "module-test",
            "vpc_id": "vpc-26r9f023fh2f3",
            "inbound_cidr": "0.0.0.0/0",
            "cluster_config": {
                "dedicated_master_enabled" : false,
                "instance_count": "1"
        
            },
            "master_user_options": {
                "master_user_name": "devops-test-user"
            },
            "user_tags": {
                "octopus-project_name": "actions-test",
                "octopus-space_name" : "Default",
                "team": "devops",
                "purpose": "elk module",
                "owner": "YourNameHere"
            }
        }
    }
}
```