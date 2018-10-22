provider "github" {
  token        = "${var.github_token}"
  organization = "your_organization"
  version      = "~> 1.3.0"
}

// todo add management for terraform state file