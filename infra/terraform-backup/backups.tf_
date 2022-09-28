locals {
  backups = {
    schedule  = "cron(40 4 ? * SUN *)" /* UTC Time */
    retention = 1 // days
  }
}

resource "aws_backup_vault" "quodeproj-backup-vault" {
  name = "quodeproj-backup-vault"
  tags = {
    Project = var.project
    Role    = "backup-vault"
  }
}

resource "aws_backup_plan" "quodeproj-backup-plan" {
  name = "quodeproj-backup-plan"

  rule {
    rule_name         = "quodeproj-backup-semanal"
    target_vault_name = aws_backup_vault.quodeproj-backup-vault.name
    schedule          = local.backups.schedule
    start_window      = 60
    completion_window = 300

    lifecycle {
      delete_after = local.backups.retention
    }

    recovery_point_tags = {
      Project = var.project
      Role    = "backup"
      Creator = "aws-backups"
    }
  }

  tags = {
    Project = var.project
    Role    = "backup"
  }
}

resource "aws_backup_selection" "quodeproj-server-backup-selection" {
  iam_role_arn = aws_iam_role.quodeproj-aws-backup-service-role.arn
  name         = "quodeproj-server-resources"
  plan_id      = aws_backup_plan.quodeproj-backup-plan.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "Backup"
    value = "true"
  }
}


