#It_Will_Give_Public_IP
output "public_ip_of_demo_server" {
    description = "this is the public IP"
    value = aws_instance.demo-server.public_ip
}

#It_Will_Give_Private_IP
output "private_ip_of_demo_server" {
    description = "this is the public IP"
    value = aws_instance.demo-server.private_ip
}

#Security_Group_ID
output "security_group_public" {
   value = "${aws_security_group.worker_node_sg.id}"
}

#Endpoint_Cluster
output "endpoint" {
  value = aws_eks_cluster.eks.endpoint
}
