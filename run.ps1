$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"
$currentPath = $(Get-Location).Path

Write-Information "Region is $ENV:AWS_DEFAULT_REGION"

aws sts get-caller-identity

ce pip3 install -U -q --no-color --user policy_sentry

$ModulePath = Get-Item $currentPath/$TEST_MODULE
$TestsPath = "$currentPath/tests"
$ADMIN_ROLE_ARN = $AWS_ROLE_TO_ASSUME

$name = $TEST_MODULE

$policies = @()

New-Item -ItemType Directory -Force -Path $TestsPath/terraform/policies
Get-ChildItem $ModulePath/policies/*.yml | ForEach-Object {
  $filePath = "$TestsPath/terraform/policies/$($_.BaseName).json"
  $policies += @{
    name      = $_.BaseName
    file_path = $filePath
  }

  if ($_.FullName -imatch "skip" )
  {
    $policy = ce /home/octopus/.local/bin/policy_sentry write-policy `
      -i $_.FullName | ConvertFrom-Json
  }
  else
  {
    $policy = ce /home/octopus/.local/bin/policy_sentry write-policy `
      -i $_.FullName -m | ConvertFrom-Json
  }

  $policy.Statement | ForEach-Object {
    if ($_.Sid -ieq "MultMultNone")
    {
      $_.Action = $_.Action `
        -replace '(.*:.{1,7}).*', '$1*' `
        -replace '\*\*', '*' | Select-Object -Unique
    }
    elseif ($_.Sid -ieq "SkipResourceConstraints")
    {
      $_.Action = $_.Action | Select-Object -Unique
    }
    else
    {
      $_.Action = $_.Action `
        -replace '(.*:.).*', '$1*' `
        -replace '\*\*', '*' | Select-Object -Unique
    }
  }

  $policy | ConvertTo-Json -Depth 100 -Compress | Out-File `
    -FilePath $filePath

}

$variables = @{
  name                 = "tf-$name"
  policies             = $policies
  attachReadOnlyPolicy = $true
}

$variables | ConvertTo-Json

$tfvarsFile = "$TestsPath/terraform/terraform.tfvars.json"
New-Item $tfvarsFile -Force
Set-Content $tfvarsFile ($variables | ConvertTo-Json)

Set-Location $TestsPath/terraform
ce terraform init

$variables | ConvertTo-Json

try
{
  ce terraform apply -auto-approve -no-color -input=false
  ce aws sts get-caller-identity

  Start-Sleep -Seconds 10

  $AWS_ROLE_TO_ASSUME = (ce terraform output -json -no-color role | ConvertFrom-Json).arn
  SetAWSCredentials
  if (![string]::IsNullOrEmpty($TEST_MODULE))
  {
    Set-Location $currentPath/$TEST_MODULE/tests
    & $currentPath/$TEST_MODULE/tests/tests.ps1
  }
}
finally
{
  $AWS_ROLE_TO_ASSUME = $ADMIN_ROLE_ARN
  Set-Location $TestsPath/terraform
  SetAWSCredentials
  ce terraform destroy -auto-approve -no-color -input=false
}$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"
$currentPath = $(Get-Location).Path

Write-Information "Region is $ENV:AWS_DEFAULT_REGION"

aws sts get-caller-identity

ce pip3 install -U -q --no-color --user policy_sentry

$ModulePath = Get-Item $currentPath/$TEST_MODULE
$TestsPath = "$currentPath/tests"
$ADMIN_ROLE_ARN = $AWS_ROLE_TO_ASSUME

$name = $TEST_MODULE

$policies = @()

New-Item -ItemType Directory -Force -Path $TestsPath/terraform/policies
Get-ChildItem $ModulePath/policies/*.yml | ForEach-Object {
  $filePath = "$TestsPath/terraform/policies/$($_.BaseName).json"
  $policies += @{
    name      = $_.BaseName
    file_path = $filePath
  }

  if ($_.FullName -imatch "skip" )
  {
    $policy = ce /home/octopus/.local/bin/policy_sentry write-policy `
      -i $_.FullName | ConvertFrom-Json
  }
  else
  {
    $policy = ce /home/octopus/.local/bin/policy_sentry write-policy `
      -i $_.FullName -m | ConvertFrom-Json
  }

  $policy.Statement | ForEach-Object {
    if ($_.Sid -ieq "MultMultNone")
    {
      $_.Action = $_.Action `
        -replace '(.*:.{1,7}).*', '$1*' `
        -replace '\*\*', '*' | Select-Object -Unique
    }
    elseif ($_.Sid -ieq "SkipResourceConstraints")
    {
      $_.Action = $_.Action | Select-Object -Unique
    }
    else
    {
      $_.Action = $_.Action `
        -replace '(.*:.).*', '$1*' `
        -replace '\*\*', '*' | Select-Object -Unique
    }
  }

  $policy | ConvertTo-Json -Depth 100 -Compress | Out-File `
    -FilePath $filePath

}

$variables = @{
  name                 = "tf-$name"
  policies             = $policies
  attachReadOnlyPolicy = $true
}

$variables | ConvertTo-Json

$tfvarsFile = "$TestsPath/terraform/terraform.tfvars.json"
New-Item $tfvarsFile -Force
Set-Content $tfvarsFile ($variables | ConvertTo-Json)

Set-Location $TestsPath/terraform
ce terraform init

$variables | ConvertTo-Json

try
{
  ce terraform apply -auto-approve -no-color -input=false
  ce aws sts get-caller-identity

  Start-Sleep -Seconds 10

  $AWS_ROLE_TO_ASSUME = (ce terraform output -json -no-color role | ConvertFrom-Json).arn
  SetAWSCredentials
  if (![string]::IsNullOrEmpty($TEST_MODULE))
  {
    Set-Location $currentPath/$TEST_MODULE/tests
    & $currentPath/$TEST_MODULE/tests/tests.ps1
  }
}
finally
{
  $AWS_ROLE_TO_ASSUME = $ADMIN_ROLE_ARN
  Set-Location $TestsPath/terraform
  SetAWSCredentials
  ce terraform destroy -auto-approve -no-color -input=false
}
