[CmdletBinding()]
param (
  [Parameter()]
  [string]
  $BUCKET_NAME
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

$lazyS3DeleteUrl = "$env:LAZY_API_HOST/tenants/custom/profiles/custom/s3/${BUCKET_NAME}?role_arn=$env:AWS_ROLE_TO_ASSUME"
$headers = @{
  'x-api-key'    = $env:LAZY_API_KEY
  'Content-Type' = 'application/json'
}

Write-Output "Lazy API Delete URL $lazyS3DeleteUrl"
Write-Output "Deleting Bucket $BUCKET_NAME"

try
{
  $Response = Invoke-RestMethod -Uri $lazyS3DeleteUrl `
    -Headers $headers -Method Delete

  $Response | ConvertTo-Json
}
catch
{
  Write-Information $_.Exception
  $StatusCode = $_.Exception.Response.StatusCode.value__

  if ($StatusCode -ne 404)
  {
    throw
  }
}
