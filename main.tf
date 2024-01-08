module "repos" {
  source       = "./modules/repos"
  repositories = var.repositories
}
