# Define a CloudWatch Alarm
resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = 20
  metric_name        = "CPUUtilization"
  namespace          = "AWS/ECS"
  period             = 300
  statistic          = "Average"
  threshold          = 60
  alarm_description  = "CPU utilization is high for more than 20 minutes"
  alarm_actions      = [aws_sns_topic.example_sns_topic.arn]

  dimensions = {
    ServiceName = aws_ecs_service.example_service.name
    ClusterName = aws_ecs_cluster.example_cluster.name
  }
}