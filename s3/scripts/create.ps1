[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $BUCKET_NAME,

    [Parameter()]
    [string]
    $AWS_REGION
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

$lazyS3CreateUrl = "$env:LAZY_API_HOST/profiles/custom/s3?role_arn=$env:AWS_ROLE_TO_ASSUME"
$headers = @{
  'x-api-key'    = $env:LAZY_API_KEY
  'Content-Type' = 'application/json'
}

if ($AWS_REGION -ieq "us-east-1")
{
  $body = @{
    options = @{
      Bucket = $BUCKET_NAME
    }
  } | ConvertTo-Json
}
else
{
  $body = @{
    options = @{
      Bucket                    = $BUCKET_NAME
      CreateBucketConfiguration = @{
        LocationConstraint = $AWS_REGION
      }
    }
  } | ConvertTo-Json
}

$body

Write-Output "Lazy API Create URL $lazyS3CreateUrl"
$Response = Invoke-RestMethod -Uri $lazyS3CreateUrl `
  -Headers $headers -Method POST -Body $body

$Response | ConvertTo-Json
