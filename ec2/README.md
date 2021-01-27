# Lazy EC-2 Module
Module to deploy EC2 instance and required resources in a lazy fashion

## Resources
- Elastic IP
- EBS Volume
- Security Group 
- Security Group Rules
- IAM EC2 Instance Profile
- EC2 Instance
- EBS Volume Attachement
- Elastic IP Instance Association

## Input Variables
- zone
    - string
- profile
    - string
- ec2_instance_name
    - string
- instance_purpose
    - string
- instance_owner
    - string
- ami_id
    - string
- associate_public_ip_address
    - boolean
    - default = false
- ec2_instance_type
    - string
    - default = t2.small
- ebs_optimized
    - boolean
    - default = true
- vpc_id
    - string
- subnet_type
    - string
    - on of: public or private
- security_group_rules_data
    - map (object({
        type = string (ingress/egress)
        from_port = number
        to_port = number
        protocol = string
        description = string
        cidr = list(string)
    }))
    - example 
    '''
        - "ssh" : {
            "type" : "ingress",
            "from_port" : "0",
            "to_port" : "22",
            "protocol" : "TCP",
            "description" : "ssh access to instance",
            "cidr_blocks" : ["0.0.0.0/8"]
        }
    '''
- ebs_volume_size
    - number
- kms_key_id
    - string
- ebs_vol_type
    - string
    - default gp2
    - one of standard, gp2, gp3, io1, io2, sc1 or st1
- ebs_device_name
    - string
    - default = /dev/sdh

## Example .tfvars
```
profile = "dev"
region = "us-west-2"
ami_id = "ami-0000000000000000"
instance_purpose = "Test"
instance_owner= "Dev Ops"
ec2_instance_name = "ec2-module-test"
associate_public_ip_address = false
ec2_instance_type = "c5.metal"
ebs_optimized = true
vpc_id = "vpc-000000000000"
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
kms_key_id = "arn:aws:kms:us-west-2:-000000000:key/00000000-0000-0000-0000-000000000000"
ebs_volume_size = 40
ebs_vol_type="standard"
```
