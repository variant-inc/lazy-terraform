data "aws_route53_zone" "zone" {
  name = "drivevariant.com"
}

resource "aws_route53_record" "route" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "${var.sub_domain}.${data.aws_route53_zone.zone.name}"
  type    = var.type
  ttl     = "300"
  records = var.records
}
