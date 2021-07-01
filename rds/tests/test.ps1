tfswitch
terraform init

$tests = @("test2")

$tests | ForEach-Object {
  # SetAWSCredentials
  $TF_VARIABLES | ConvertTo-Json -Depth 100
  # terraform plan -no-color -input=false `
  #   -var-file "vars/${_}.json"

    terraform destroy -auto-approve -no-color -input=false `
      -var-file "vars/${_}.json"
  if ($TF_APPLY -ieq "true")
  {
    try
    {
    }
    finally
    {
      # SetAWSCredentials
      # ce terraform destroy -auto-approve -no-color -input=false `
      #   -var-file "vars/${_}.json"
    }
  }
}


