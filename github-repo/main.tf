
resource "github_repository" "this" {
  name        = var.name
  description = var.description
  private     = var.private

  visibility  = var.private ? "private" : "public"

  has_issues    = true
  has_wiki      = false
  auto_init     = true
  delete_branch_on_merge = true
}
