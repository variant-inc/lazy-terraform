ce tfswitch
ce terraform init

$tests = @("test1", "test2")

$tests | ForEach-Object {
  $TF_VARIABLES | ConvertTo-Json -Depth 100
  ce terraform plan -no-color -input=false `
    -var-file "vars/${_}.json"
  ce terraform apply -auto-approve -no-color -input=false `
    -var-file "vars/${_}.json"
  ce terraform destroy -auto-approve -no-color -input=false `
    -var-file "vars/${_}.json"
}


