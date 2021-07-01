ce tfswitch
ce terraform init

$tests = @("test1", "test2")

$env:TF_VAR_aws_role_to_assume = $AWS_ROLE_TO_ASSUME

$tests | ForEach-Object {
  $TF_VARIABLES | ConvertTo-Json -Depth 100
  ce terraform plan -no-color -input=false `
    -var-file "vars/${_}.json"

  if ($TF_APPLY -ieq "true")
  {
    try
    {
      SetAWSCredentials
      ce terraform apply -auto-approve -no-color -input=false `
        -var-file "vars/${_}.json"
    }
    finally
    {
      SetAWSCredentials
      ce terraform destroy -auto-approve -no-color -input=false `
        -var-file "vars/${_}.json"
    }
  }
}


