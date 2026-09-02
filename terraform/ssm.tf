resource "aws_ssm_parameter" "cloudwatch_agent_config" {
  name = "AmazonCloudWatch-project05-config"
  type = "String"
  tier = "Standard"

  value = file("${path.module}/cloudwatch-agent-config.json")

  tags = {
    Name = "${var.project_name}-cloudwatch-agent-config"
  }
}