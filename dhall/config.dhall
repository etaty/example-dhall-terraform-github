--
let g = ./github.dhall
in let d = ./defaults.dhall
in let T = ./types.dhall

-- Config
in let config = {
    teams = [
          {name = "a-team", description = "The A-Team", privacy = "closed"}
        , {name = "admins", description = "Admins", privacy = "closed"}
    ] : List T.Team,

    users = [
        d.defaultGithubUser // {login = "admin_of_org", role = d.admin, teams = ["admins"]}
        , d.defaultGithubUser // {login = "Smith", role = d.member, teams = [ "a-team"]}
        , d.defaultGithubUser // {login = "Peck", role = d.member, teams = ["a-team"]}
        , d.defaultGithubUser // {login = "Baracus", role = d.member, teams = ["a-team"]}
        , d.defaultGithubUser // {login = "Schultz", teams = ["a-team"]}
    ] : List T.GithubUser
} : T.Config


in {
    resource = g.build config
}