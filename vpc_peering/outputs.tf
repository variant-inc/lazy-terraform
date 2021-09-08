output "acceptor_vpc_id" {
  value = module.vpc_peering.peer_vpc_id
}
output "requester_vpc_id" {
  value = module.vpc_peering.this_vpc_id
}
output "vpc_peering_id" {
  value = module.vpc_peering.vpc_peering_id
}
output "vpc_peering_accept_status" {
  value = module.vpc_peering.vpc_peering_accept_status
}

