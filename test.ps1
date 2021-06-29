Write-Information "Region is $ENV:AWS_DEFAULT_REGION"

aws sts get-caller-identity


if (![string]::IsNullOrEmpty($TEST_MODULE))
{
  $currentPath = $(Get-Location).Path
  Set-Location $currentPath/$TEST_MODULE/tests
  & $currentPath/$TEST_MODULE/tests/test.ps1
}
