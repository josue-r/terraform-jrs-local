variable "repositories" {
  type = list(object({
    name            = string
    type            = string
    path            = string
    branch_pipeline = string
    default_branch  = string
  }))
  default = []
}

variable "token" {
  description = "GitHub token for authentication"
  type        = string
}