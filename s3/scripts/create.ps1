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

$lazyS3CreateUrl = "$LAZY_API_HOST/profiles/custom/s3?role_arn=$AWS_ROLE_TO_ASSUME"
$headers = @{
  'x-api-key'    = $LAZY_API_KEY
  'Content-Type' = 'application/json'
}

if ($AWS_REGION -ieq "us-east-1")
{
  $body = @{
    options = @{
      Bucket = $BUCKET_NAME
    }
  }
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
  }
}

$body | ConvertTo-Json

Write-Output "Lazy API URL $lazyS3CreateUrl"
$Response = Invoke-RestMethod -Uri $lazyS3CreateUrl `
  -Headers $headers -Method POST -Body ($body | ConvertTo-Json)

$Response | ConvertTo-Json
