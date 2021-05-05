output "elk_master_password" {
    # value =  contains(keys(var.master_user_options),"master_user_password")? "Password provided by user": random_password.password.result
    value = lookup( var.master_user_options, "master_user_password", random_password.password.result)
    sensitive = true
}