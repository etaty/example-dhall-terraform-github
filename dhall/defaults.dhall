let T = ./types.dhall


in let githubUserRole = T.TF/GithubUserRole

in let member = githubUserRole.member {=}
in let admin = githubUserRole.admin {=}

in let defaultGithubUser = {role = member, teams = [] : List Text}

in {
    member = member,
    admin = admin,
    defaultGithubUser = defaultGithubUser
}