resource "aws_appautoscaling_target" "example_target" {
  max_capacity = 10
  min_capacity = 1
  resource_id = "service/${aws_ecs_cluster.example_cluster.name}/${aws_ecs_service.example_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"
}

resource "aws_appautoscaling_policy" "scale_up_policy" {
  name               = "scale-up"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.example_target.resource_id
  scalable_dimension = aws_appautoscaling_target.example_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.example_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type = "PercentChangeInCapacity"  # Use PercentChangeInCapacity
    cooldown        = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 10  
    }
  }
}


resource "aws_appautoscaling_policy" "scale_down_policy" {
  name               = "scale-down"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.example_target.resource_id
  scalable_dimension = aws_appautoscaling_target.example_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.example_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"
    min_adjustment_magnitude = -1

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}