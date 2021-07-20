$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"
$WarningPreference = "SilentlyContinue"

. ./env/env.ps1

Trap
{
  Write-Error $_.InvocationInfo.ScriptName -ErrorAction Continue
  $line = "$($_.InvocationInfo.ScriptLineNumber): $($_.InvocationInfo.Line)"
  Write-Error $line -ErrorAction Continue
  Write-Error $_
}

$lazyS3UpdateUrl = "$LAZY_API_HOST/profiles/custom/s3/$BUCKET_NAME/tags?role_arn=$AWS_ROLE_TO_ASSUME"
$headers = @{
  'x-api-key'    = $LAZY_API_KEY
  'Content-Type' = 'application/json'
}

$TAGS

Write-Output "Lazy API URL $lazyS3UpdateUrl"
try
{
  & $PSScriptRoot/create.ps1
}
catch
{
}

$Response = Invoke-RestMethod -Uri $lazyS3UpdateUrl `
  -Headers $headers -Method PUT -Body $TAGS

$Response | ConvertTo-Json
