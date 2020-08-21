provider "tfe" {}

resource "tfe_organization" "default" {
  name  = "Org"
  email = "org@tfe.com"
}

resource "tfe_team" "default" {
  name         = "Team"
  organization = tfe_organization.default.name
  visibility   = "organization"
  organization_access {
    manage_policies   = true
    manage_workspaces = true
  }
}

# For each workspace, add a module call (requires a code change)
module "team1" {
  source = "./modules/workspaces"

  organization_name = tfe_organization.default.name
  names = [
    "team1-poc-core",
    "team1-sdlc-core",
    "team1-cust-core",
  ]
  teams_access = [
    {
      id     = tfe_team.default.id
      access = "admin"
    }
  ]
}

module "team2" {
  source = "./modules/workspaces"

  organization_name = tfe_organization.default.name
  names = [
    "team2-poc-core",
    "team2-sdlc-core",
    "team2-cust-core",
  ]
  teams_access = [
    {
      id     = tfe_team.default.id
      access = "admin"
    }
  ]
}

# Uncomment to add Workspace C
# module "workspace_c" {
#   source = "./modules/workspaces"

#   organization_name = var.organization_name
#   names             = ["workspace_c_tf12-1"]
#   teams_access = [
#     {
#       id     = var.team_dev
#       access = "plan"
#     }
#   ]
# }
