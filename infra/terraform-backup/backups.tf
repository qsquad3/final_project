locals {
  bkpdia = {
    schedule  = "cron(30 13 ? * MON-SUN *)"
    retention = 1 // days
  }
  bkpsem = {
    schedule  = "cron(30 1 ? * SAT *)"
    retention = 180 // days
  }
  bkpmen = {
    schedule  = "cron(30 1 ? * SUN *)" 
    retention = 730 // days
  }
}

resource "aws_backup_vault" "quodeproj-backup-vault-diario" {
  name = "quodeproj-backup-vault-diario"
  tags = {
    Project = var.project
    Role    = "backup-vault"
  }
}
resource "aws_backup_vault" "quodeproj-backup-vault-semanal" {
  name = "quodeproj-backup-vault-semanal"
  tags = {
    Project = var.project
    Role    = "backup-vault"
  }
}
resource "aws_backup_vault" "quodeproj-backup-vault-mensal" {
  name = "quodeproj-backup-vault-mensal"
  tags = {
    Project = var.project
    Role    = "backup-vault"
  }
}

resource "aws_backup_plan" "quodeproj-backup-plan" {
  name = "quodeproj-backup-plan"

  rule {
    rule_name         = "quodeproj-backup-diario"
    target_vault_name = aws_backup_vault.quodeproj-backup-vault-diario.name
    schedule          = local.bkpdia.schedule
    start_window      = 60
    completion_window = 120

    lifecycle {
      delete_after = local.bkpdia.retention
    }
    recovery_point_tags = {
      Project = var.project
      Role    = "Backuprole"
      Creator = "AWS Backup"
    }
   }

  rule {
    rule_name         = "quodeproj-backup-semanal"
    target_vault_name = aws_backup_vault.quodeproj-backup-vault-semanal.name
    schedule          = local.bkpsem.schedule
    start_window      = 60
    completion_window = 120

    lifecycle {
      delete_after = local.bkpsem.retention
    }
    recovery_point_tags = {
      Project = var.project
      Role    = "Backuprole"
      Creator = "AWS Backup"
    }
  }
  rule {
    rule_name         = "quodeproj-backup-mensal"
    target_vault_name = aws_backup_vault.quodeproj-backup-vault-mensal.name
    schedule          = local.bkpmen.schedule
    start_window      = 60
    completion_window = 120

    lifecycle {
      delete_after = local.bkpmen.retention
    }
    recovery_point_tags = {
      Project = var.project
      Role    = "Backuprole"
      Creator = "AWS Backup"
    }
  }

  tags = {
    Project = var.project
    Role    = "Backuprole"
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
