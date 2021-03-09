# Lazy Terraform Modules

Terraform scripts for lazy folks

## How to run

Create a filename called `.terraform.<env>.yaml` which will contain the following vars

```yaml
tfS3Bucket: lazy-tf-state
tfDynamodbTable: lazy_tf_state
tfKmsKeyId: arn:aws:kms:us-east-1:1234567890:key/1234567890-b3cd-447c-9cd2-7a9d095a143a
region: us-east-1
```

where

| Name            | Description                                     |
| --------------- | ----------------------------------------------- |
| tfS3Bucket      | Name of S3 bucket to store the state            |
| tfDynamodbTable | Name of the dynamodb which stores the lock file |
| tfKmsKeyId      | KMS Key ARN for encrypting S3 bucket            |
| region          | Region where bucket & dynamodb are located      |

Modify lines 8-10 in [terraform.ps1](./terraform.ps1)

```powershell
$tfS3Key = "efs/octopus-server" ## Name of the state key
$env = "ops" ## env name which is same as `.terraform.<env>.yaml`
$profile = "108141096600_AWSAdministratorAccess" ## Profile name in `/.aws/credentials
```
