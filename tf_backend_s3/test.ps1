$ErrorActionPreference = "Continue"
$InformationPreference = "Continue"
$WarningPreference = "SilentlyContinue"

# $MODULE_NAME = "tf_backend_s3" 
# $STATE_KEY_ID = "test/runbook"
# $VARIABLES = '{"region":"us-west-2","table_name":"test_runbook","user_tags":{"team":"devops","purpose":"Test runbook","owner":"devops"},"octopus_tags":{"space":"DevOps","project":"lazy-api"},"create_vars_bucket":false}' 
# $REGION  = "us-west-2"
# $DESTROY = "false" 
# $OUTPUT_LOCATION = "lazy_terraform_executions"

Trap
{
  Write-Error $_ -ErrorAction Continue
  exit 1
}


function CommandAliasFunction
{
  Write-Information ""
  Write-Information "$args"
  $cmd, $args = $args
  $params = $args -split " "
  $output = "  "
  Invoke-Expression "$cmd $args" 2>&1 | Tee-Object -Variable badoutput
  Write-Host "hello: $badoutput, error"
  if ($LASTEXITCODE)
  {
    throw "Exception"
  }
  Write-Information ""
}
Set-Alias -Name ce -Value CommandAliasFunction -Scope script

# $env:TF_LOG="TRACE"
# $env:TF_LOG_PATH="terraform.txt"
$env:TF_CLI_ARGS_plan="-no-color -input=false -out=tfplan"
$env:TF_CLI_ARGS_apply="-no-color -auto-approve=true"

try {
    $step = "Plan"
    $output = ce terraform plan
}
catch {
    $_.Exception
    $_.ErrorDetails
}
# Finally {


#     $dbTableEntry = `
#     @{
#       'terraform_output' = @{
#         'S' = "$output";
#       }
#       'step' = @{
#         'S' = "$step";
#       }
#     } | ConvertTo-Json -Compress -Depth 5

#     Write-Output $dbTableEntry
# }

