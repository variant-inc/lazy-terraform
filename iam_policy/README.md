# IAM Policy Module

Module to create IAM Policy in a lazy fasion

## Input Variables

- profile
  - string
- region
  - string
  - default = us-east-1
- policy_description
  - string
- policy_name
  - string
  - default = policy-name-not-provided
- policy_json
  - Variable Definition
    ```bash
        object({
        Version     = string
        Statement   = list(object({
            Sid     = string
            Effect  = string
            Action  = string
            Resource= string
        }))
    })
    ```
  - Example
    ```bash
    {
        "Version"   : "2012-10-17",
        "Statement" : [
            {
                "Sid"       : "VisualEditor0",
                "Effect"    : "Allow",
                "Action"    : "sts:AssumeRole",
                "Resource"  : "*"
            }
        ]
    }
    ```

## Example .tfvars

```bash
profile = "devops"
region  = "us-west-2"
policy_description  = "This is a test policy"
policy_name         = "Test_Policy_Lee_TF"
policy_json         = {
                        "Version"   : "2012-10-17",
                        "Statement" : [
                            {
                                "Sid"       : "VisualEditor0",
                                "Effect"    : "Allow",
                                "Action"    : "sts:AssumeRole",
                                "Resource"  : "*"
                            }
                        ]
                    }
```


You may have to provide credentials/s3 information when you init the root module
