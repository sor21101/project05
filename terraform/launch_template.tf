resource "aws_launch_template" "app" {
  name_prefix   = "${var.project_name}-app-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [
    aws_security_group.asg.id
  ]

  iam_instance_profile {
    name = aws_iam_instance_profile.cloudwatch_agent.name
  }

  user_data = base64encode(
    templatefile("${path.module}/user_data.sh", {
      aws_region                  = var.aws_region
      ecr_repository_url          = aws_ecr_repository.app.repository_url
      cloudwatch_config_parameter = aws_ssm_parameter.cloudwatch_agent_config.name
    })
  )

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.project_name}-asg-app"
    }
  }

  tags = {
    Name = "${var.project_name}-launch-template"
  }
}