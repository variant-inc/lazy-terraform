$currentPath = $(Get-Location).Path

Set-Location $currentPath/$TEST_MODULE/tests
& test.ps1
