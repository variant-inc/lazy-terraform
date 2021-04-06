[CmdletBinding()]
param (
  [Parameter(Mandatory = $true)]
  [string]
  $Path,

  [Parameter(Mandatory = $false)]
  [string]
  $Backend = "s3"
)

$tfS3Key = "s3/terraform"
$env = "data"
$awsProfile = "648462982672_AWSAdministratorAccess"
$awsRegion = "us-east-1"

$env:TF_VAR_region = $awsRegion
$env:TF_VAR_profile = $awsProfile

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
if ($Backend -ieq "s3")
{
  ce terraform init `
    -backend-config="bucket=$tfS3Bucket" `
    -backend-config="key=$tfS3Key" `
    -backend-config="region=$region" `
    -backend-config="dynamodb_table=$tfDynamodbTable" `
    -backend-config="encrypt=true" `
    -backend-config="kms_key_id=$tfKmsKeyId" `
    -backend-config="profile=$awsProfile"
}
else
{
  ce terraform init
}

ce terraform plan -out=tfplan
ce terraform apply tfplan

$vars_path = [System.IO.Path]::GetFullPath((Join-Path -Path "$currentPath" -ChildPath "${Path}terraform.tfvars"))
if ($Backend -ieq "s3")
{
  ce aws s3 cp $vars_path s3://$tfS3Bucket/tfvars/$tfS3Key --profile $awsProfile
}

Set-Location $currentPath
