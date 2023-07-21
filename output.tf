#creating an output file

output "vpc" {
  value = aws_vpc.website.main_route_table_id

}

output "aws_subnet" {
  value = aws_subnet.web-public-subnet1.id
}

output "aws_private_subnet" {
  value = aws_subnet.app-private-subnet1.arn
}

output "aws_route" {
  value = aws_route_table.website-private-route.owner_id
}

output "aws_route_association" {
  value = aws_route_table_association.website-public-RTA.id

}

output "IGW" {
  value = aws_internet_gateway.website-IGW
}

output "eip" {
  value = aws_eip.website-eip.id
}

output "NAT" {
  value = aws_nat_gateway.website-Nat-gateway.id
}