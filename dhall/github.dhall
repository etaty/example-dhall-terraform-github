-- Prelude imports
   let map              = https://raw.githubusercontent.com/dhall-lang/Prelude/v3.0.0/List/map
in let concat           = https://raw.githubusercontent.com/dhall-lang/Prelude/v3.0.0/List/concat
in let concatMap        = https://raw.githubusercontent.com/dhall-lang/Prelude/v3.0.0/List/concatMap
in let null             = https://raw.githubusercontent.com/dhall-lang/Prelude/v3.0.0/List/null

-- Types
in let T = ./types.dhall

in let TF/ref3 = \(scope : Text) -> \(k2 : Text) -> \(k3 : Text) -> "\${${scope}.${k2}.${k3}}"

in let TF/toText = \(role: T.TF/GithubUserRole) ->
    merge {
        admin = \(_ :{}) -> "admin"
        , member = \(_ :{}) -> "member"
    } role

in let makeGithubMembership = \(username: Text) -> \(role: T.TF/GithubUserRole) ->
    {
        mapKey = "membership_" ++ username,
        mapValue = {
            username = username,
            role = TF/toText role
        }
    }
    : T.TF/GithubMembership

in let makeGithubMembership = \(u: T.GithubUser) ->
    makeGithubMembership u.login u.role : T.TF/GithubMembership

in let makeGithubTeam = \(name: Text) -> \(description: Text) -> \(privacy: Text) ->
    {
        mapKey = "team_" ++ name,
        mapValue =
            {
                name = name,
                description = description,
                privacy = privacy
            }
    }
    : T.TF/GithubTeam

in let makeGithubTeam = \(t: T.Team) ->
    makeGithubTeam t.name t.description t.privacy : T.TF/GithubTeam

in let makeGithubTeamMembership = \(username: Text) -> \(team: Text) ->
    {
        mapKey = "team_${team}_member_${username}",
        mapValue =
            {
                team_id = TF/ref3 "github_team" ("team_" ++ team) "id",
                username = username,
                role = "maintainer"
            }
    }
    : T.TF/GithubTeamMembership

in let makeGithubTeamMembership = \(u: T.GithubUser) ->
    (map Text T.TF/GithubTeamMembership (makeGithubTeamMembership u.login) u.teams)
    : List T.TF/GithubTeamMembership

in let emptyListToOptional = \(a: Type) -> \(l: List a) ->
    if (null a l) then [] : Optional (List a)
    else [l]: Optional (List a)

in let build = \(config: T.Config) ->
        let github_membership = map T.GithubUser T.TF/GithubMembership makeGithubMembership config.users
    in let github_team = map T.Team T.TF/GithubTeam makeGithubTeam config.teams
    in let github_team_membership = concat T.TF/GithubTeamMembership (map T.GithubUser (List T.TF/GithubTeamMembership) makeGithubTeamMembership config.users)
    in {
        github_membership = emptyListToOptional T.TF/GithubMembership github_membership
        , github_team = emptyListToOptional T.TF/GithubTeam github_team
        , github_team_membership = emptyListToOptional T.TF/GithubTeamMembership github_team_membership
    }

in {
    build = build
}