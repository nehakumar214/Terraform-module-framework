output "asg_id" {
  value = aws_autoscaling_group.this.id
}
output "asg_arn" {
  value = aws_autoscaling_group.this.arn
}
output "asg_availabilityZones" {
  value = aws_autoscaling_group.this.availability_zones
}
output "asg_name" {
  value = aws_autoscaling_group.this.name
}
output "asg_vpcZoneIdentifier" {
  value = aws_autoscaling_group.this.vpc_zone_identifier
}
output "asg_maxSize" {
  value = aws_autoscaling_group.this.max_size
}
output "asg_minSize" {
  value = aws_autoscaling_group.this.min_size
}