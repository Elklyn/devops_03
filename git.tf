provider "github" {
  token        = "4edc417aef18c08e0f27f235238a08032821acdc"
}
resource "github_repository" "devops_terraform" {
  name        = "devops_terraform"
  description = "devops_task_by_Dmytro_Yevenko"
  auto_init   = true
}

resource "github_branch" "development" {
  repository = "devops_terraform"
  branch     = "development"
  depends_on = [github_repository.devops_terraform]
}
resource "github_branch_protection" "foo" {
  repository_id     = github_repository.devops_terraform.node_id
  pattern         = "master"
  enforce_admins = true
  required_pull_request_reviews {
    dismiss_stale_reviews = true
  }
}
resource "github_user_ssh_key" "id-rsa" {
  title = "id-rsa"
  key   = file("~/.ssh/k.pub")
}
