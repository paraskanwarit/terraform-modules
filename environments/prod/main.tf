module "repo_1" {
  source      = "../../modules/github-repo"
  name        = "terraform-repo-1"
  description = "Created using Terraform module"
  private     = true
}

module "repo_3" {
  source      = "../../modules/github-repo"
  name        = "terraform-repo-2"
  description = "Another repo created via Terraform"
  private     = false
}
