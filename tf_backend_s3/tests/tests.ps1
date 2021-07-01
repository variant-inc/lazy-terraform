ce tfswitch
ce terraform init

$TF_VARIABLES | ConvertTo-Json -Depth 100
ce terraform plan -no-color -input=false

if ($TF_APPLY -ieq "true")
{
  try
  {
    SetAWSCredentials
    ce terraform apply -auto-approve -no-color -input=false
  }
  finally
  {
    SetAWSCredentials
    ce terraform destroy -auto-approve -no-color -input=false
  }
}


