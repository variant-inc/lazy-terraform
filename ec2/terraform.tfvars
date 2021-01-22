profile = "108141096600_AWSAdministratorAccess"
region = "us-west-2"
ami_id = "ami-0a36eb8fadc976275"
instance_purpose = "Test"
instance_owner= "Dev Ops"
ec2_instance_name = "ec2-module-test"
associate_public_ip_address = false
ec2_instance_type = "c5.metal"
ebs_optimized = true
vpc_id = "vpc-0d20dafc2165640e0"
subnet_type = "public"
security_group_rules_data = {
    "ssh" : {
        "type" :"ingress",
        "from_port":"22",
        "to_port":"22",
        "protocol":"TCP",
        "description":"ssh",
        "cidr_blocks": ["0.0.0.0/8"]
    }
}
kms_key_id = "arn:aws:kms:us-west-2:108141096600:key/fc9bb6d7-4f0d-4b99-a830-85951933c030"
ebs_volume_size = 40
ebs_vol_type="standard"
