-- Terraform
   let TF/GithubUserRole : Type = < admin: {} | member: {} >

in let TF/GithubMembership : Type =
    { mapKey : Text
    , mapValue :
       { role : Text, username : Text }
    }

in let TF/GithubTeam : Type =
    { mapKey : Text
    , mapValue : { name: Text, description: Text, privacy: Text}
    }

in let TF/GithubTeamMembership : Type =
    { mapKey : Text
    , mapValue :
       { team_id : Text, username : Text, role: Text }
    }

-- Config
in let GithubUser : Type = {login: Text, role: TF/GithubUserRole, teams: List Text}

in let Team : Type = {name: Text, description: Text, privacy: Text}

in let Config : Type = {teams: List Team, users : List GithubUser}

in {
    TF/GithubUserRole = TF/GithubUserRole,
    TF/GithubMembership = TF/GithubMembership,
    TF/GithubTeam = TF/GithubTeam,
    TF/GithubTeamMembership = TF/GithubTeamMembership,
    GithubUser = GithubUser,
    Team = Team,
    Config = Config
}