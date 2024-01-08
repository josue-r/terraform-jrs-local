terraform {
  required_providers {
    github = {
      source  = "integrations/github"
    }
  }
}

# #repositories creation
# resource "github_repository" "repositories" {
#   for_each = {for repo in var.repositories: repo.name => repo}
#   # Configuration options
#   name        = each.value.name
#   description = "Repository managed by Terraform"
#   visibility  = "public"  
# }


#repositories branch creation and autoinit
resource "github_repository" "repository_branch_autoninit" {
  for_each = {for repo in var.repositories: repo.name => repo}
  # Configuration options
  name        = each.value.name
  description = "Repository managed by Terraform"
  visibility  = "public"
#   default_branch = each.value.default_branch
  auto_init = true
  
}

#rename current branch to master
resource "github_branch_default" "default"{
  for_each = {for repo in var.repositories: repo.name => repo}
  repository = each.value.name
  branch     = each.value.default_branch
  rename     = true
}

#branch protection
# Protect the main branch of the foo repository. Additionally, require that
# the "ci/check" check ran by the Github Actions app is passing and only allow
# the engineers team merge to the branch.

resource "github_branch_protection_v3" "branch_policy" {
  for_each = {for repo in var.repositories: repo.name => repo}
  repository     = each.value.name
  branch         = each.value.default_branch
  enforce_admins = true

  required_status_checks {
    strict   = false
    checks = []
  }

  required_pull_request_reviews {
    dismiss_stale_reviews = true
    # dismissal_users       = ["josue-r"]
    required_approving_review_count = 2
    # dismissal_teams       = [github_team.example.slug]
    # dismissal_app         = ["foo-app"]

    bypass_pull_request_allowances {
    #   users = ["josue-r"]
    #   teams = [github_team.example.slug]
    #   apps  = ["foo-app"]
    }
  }

  restrictions {
    # users = ["josue-r"]
    # teams = [github_team.example.slug]
    # apps  = ["foo-app"]
  }
}


# resource "github_repository_file" "default_pipeline" {
#   count               = terraform.workspace != "dev" ? 0 : length(var.repositories)
#   repository          = var.repositories[count.index].name
#   branch              = "refs/heads/${var.repositories[count.index].branch_pipeline}"
#   file                = ".github/workflows/github-pipelines.yml"
#   content             = file("${path.cwd}/assets/github-pipelines.yml" ) #,{ type = var.repositories[count.index].type })
#   commit_message      = "Añade o actualiza azure-pipelines.yml via terraform ***NO_CI***"
#   overwrite_on_create = false

#   lifecycle {
#     ignore_changes = [
#       file,
#       commit_message
#     ]
#   }
# }


# resource "github_repository_file" "pr_template" {
#   count               = terraform.workspace != "dev" ? 0 : length(data.github_repository.repositories)
#   repository          = data.github_repository.repositories[count.index].id
#   branch              = "refs/heads/${var.repositories[count.index].branch_pipeline}"
#   file                = ".github/pull-request-template.md"
#   content             = templatefile("${path.module}/assets/pull-request-template.md", { type = var.repositories[count.index].type })
#   commit_message      = "Añade o actualiza azure-pipelines.yml via terraform ***NO_CI***"
#   overwrite_on_create = false

#   lifecycle {
#     ignore_changes = [
#       file,
#       commit_message
#     ]
#   }
# }
