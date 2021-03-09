[CmdletBinding()]
param (
  [Parameter(Mandatory = $true)]
  [string]
  $Path
)

$tfS3Key = "efs/server"
$env = "ops"
$profile = "1234567890"

$currentPath = $(Get-Location).Path

Trap
{
  Set-Location $currentPath
  Write-Error $_ -ErrorAction Continue
  exit 1
}

. $currentPath/SetVars.ps1 -YamlVarsFile "$currentPath/.terraform.$env.yaml"

$tfS3Bucket

Set-Location ./$Path

ce terraform init `
  -backend-config="bucket=$tfS3Bucket" `
  -backend-config="key=$tfS3Key" `
  -backend-config="region=$region" `
  -backend-config="dynamodb_table=$tfDynamodbTable" `
  -backend-config="encrypt=true" `
  -backend-config="kms_key_id=$tfKmsKeyId" `
  -backend-config="profile=$profile"


ce terraform plan
ce terraform apply

Set-Location $currentPath
