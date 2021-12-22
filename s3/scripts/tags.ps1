[CmdletBinding()]
param (
  [Parameter()]
  [string]
  $BUCKET_NAME,

  [Parameter()]
  [string]
  $AWS_REGION,

  [Parameter()]
  [string]
  $TAGS
)

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"
$WarningPreference = "SilentlyContinue"

Trap
{
  Write-Error $_.InvocationInfo.ScriptName -ErrorAction Continue
  $line = "$($_.InvocationInfo.ScriptLineNumber): $($_.InvocationInfo.Line)"
  Write-Error $line -ErrorAction Continue
  Write-Error $_
}

$lazyS3UpdateUrl = "$env:LAZY_API_HOST/tenants/custom/profiles/custom/s3/$BUCKET_NAME/tags?role_arn=$env:AWS_ROLE_TO_ASSUME"
$headers = @{
  'x-api-key'    = $env:LAZY_API_KEY
  'Content-Type' = 'application/json'
}

try
{
  & $PSScriptRoot/create.ps1 -BUCKET_NAME $BUCKET_NAME -AWS_REGION $AWS_REGION
}
catch
{
  Write-Information "Bucket $BUCKET_NAME already exists"
}


$TAGS

$hashtable = @{}

(ConvertFrom-Json $TAGS).psobject.properties | Foreach { $hashtable[$_.Name] = $_.Value }


$body +=@{}
$body["tags"] = $hashtable
$body | ConvertTo-Json -Depth 100 -Compress


Write-Output "Lazy API Update URL $lazyS3UpdateUrl"
$Response = Invoke-RestMethod -Uri $lazyS3UpdateUrl `
  -Headers $headers -Method PUT -Body $body | ConvertTo-Json -Depth 100 -Compress

$Response | ConvertTo-Json