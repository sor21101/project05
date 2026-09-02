# CPU 사용률 80% 이상
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name        = "${var.project_name}-high-cpu"
  alarm_description = "CPU usage is over 80%"
  namespace         = "AWS/EC2"
  metric_name       = "CPUUtilization"
  statistic         = "Average"

  period              = 300
  evaluation_periods  = 1
  threshold           = 80
  comparison_operator = "GreaterThanOrEqualToThreshold"

  dimensions = {
    InstanceId = aws_instance.app.id
  }

  treat_missing_data = "notBreaching"
}


# Memory 사용률 80% 이상
resource "aws_cloudwatch_metric_alarm" "high_memory" {
  alarm_name        = "${var.project_name}-high-memory"
  alarm_description = "Memory usage is over 80%"
  namespace         = "CWAgent"
  metric_name       = "mem_used_percent"
  statistic         = "Average"

  period              = 60
  evaluation_periods  = 2
  threshold           = 80
  comparison_operator = "GreaterThanOrEqualToThreshold"

  dimensions = {
    InstanceId = aws_instance.app.id
  }

  treat_missing_data = "notBreaching"
}


# Root Disk 사용률 80% 이상
resource "aws_cloudwatch_metric_alarm" "high_disk" {
  alarm_name        = "${var.project_name}-high-disk"
  alarm_description = "Root disk usage is over 80%"
  namespace         = "CWAgent"
  metric_name       = "disk_used_percent"
  statistic         = "Average"

  period              = 60
  evaluation_periods  = 2
  threshold           = 80
  comparison_operator = "GreaterThanOrEqualToThreshold"

  dimensions = {
    InstanceId = aws_instance.app.id
    path       = "/"
    device     = "nvme0n1p1"
    fstype     = "ext4"
  }

  treat_missing_data = "notBreaching"
}