
---
output: html_document
editor_options: 
  chunk_output_type: console
---
# Github APIv3 (REST)





```r
library(jsonlite)
library(httpuv)
library(httr)
library(gh)

token <- Sys.getenv("GH_CLIENT_SECRET")
if (token == '') {
  stop('You need a github token', call. = FALSE)
}
```

The Github REST API v3 lists everything as `curl` commands,
so when they say something like:


```bash
curl https://api.github.com/zen
##   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
##                                  Dload  Upload   Total   Spent    Left  Speed
##   0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0100    31  100    31    0     0    196      0 --:--:-- --:--:-- --:--:--   196
## Responsive is better than fast.
```

You can make the equlivalent call from the `gh` package:


```r
gh::gh("https://api.github.com/zen")
## {
##   "message": "Anything added dilutes everything else."
## }
```

You can pass in the raw GET command


```r
gh("https://api.github.com/users/chendaniely")
## {
##   "login": "chendaniely",
##   "id": 5782147,
##   "node_id": "MDQ6VXNlcjU3ODIxNDc=",
##   "avatar_url": "https://avatars3.githubusercontent.com/u/5782147?v=4",
##   "gravatar_id": "",
##   "url": "https://api.github.com/users/chendaniely",
##   "html_url": "https://github.com/chendaniely",
##   "followers_url": "https://api.github.com/users/chendaniely/followers",
##   "following_url": "https://api.github.com/users/chendaniely/following{/other_user}",
##   "gists_url": "https://api.github.com/users/chendaniely/gists{/gist_id}",
##   "starred_url": "https://api.github.com/users/chendaniely/starred{/owner}{/repo}",
##   "subscriptions_url": "https://api.github.com/users/chendaniely/subscriptions",
##   "organizations_url": "https://api.github.com/users/chendaniely/orgs",
##   "repos_url": "https://api.github.com/users/chendaniely/repos",
##   "events_url": "https://api.github.com/users/chendaniely/events{/privacy}",
##   "received_events_url": "https://api.github.com/users/chendaniely/received_events",
##   "type": "User",
##   "site_admin": false,
##   "name": "Daniel Chen",
....
```

Or create "variables" that you can pass in using the `:` in the GET command,
this comes in handy when you start working wiht the various endpoints.


```r
gh("https://api.github.com/users/:user", user = 'chendaniely')
## {
##   "login": "chendaniely",
##   "id": 5782147,
##   "node_id": "MDQ6VXNlcjU3ODIxNDc=",
##   "avatar_url": "https://avatars3.githubusercontent.com/u/5782147?v=4",
##   "gravatar_id": "",
##   "url": "https://api.github.com/users/chendaniely",
##   "html_url": "https://github.com/chendaniely",
##   "followers_url": "https://api.github.com/users/chendaniely/followers",
##   "following_url": "https://api.github.com/users/chendaniely/following{/other_user}",
##   "gists_url": "https://api.github.com/users/chendaniely/gists{/gist_id}",
##   "starred_url": "https://api.github.com/users/chendaniely/starred{/owner}{/repo}",
##   "subscriptions_url": "https://api.github.com/users/chendaniely/subscriptions",
##   "organizations_url": "https://api.github.com/users/chendaniely/orgs",
##   "repos_url": "https://api.github.com/users/chendaniely/repos",
##   "events_url": "https://api.github.com/users/chendaniely/events{/privacy}",
##   "received_events_url": "https://api.github.com/users/chendaniely/received_events",
##   "type": "User",
##   "site_admin": false,
##   "name": "Daniel Chen",
....
```

For example, the endpoint for listing organization repositories

```
GET /orgs/:org/repos
```

Can be passed into the `gh` function as well


```r
gh("/orgs/:org/repos", org = 'numpy')
## [
##   {
##     "id": 754238,
##     "node_id": "MDEwOlJlcG9zaXRvcnk3NTQyMzg=",
##     "name": "datetime",
##     "full_name": "numpy/datetime",
##     "private": false,
##     "owner": {
##       "login": "numpy",
##       "id": 288276,
##       "node_id": "MDEyOk9yZ2FuaXphdGlvbjI4ODI3Ng==",
##       "avatar_url": "https://avatars2.githubusercontent.com/u/288276?v=4",
##       "gravatar_id": "",
##       "url": "https://api.github.com/users/numpy",
##       "html_url": "https://github.com/numpy",
##       "followers_url": "https://api.github.com/users/numpy/followers",
##       "following_url": "https://api.github.com/users/numpy/following{/other_user}",
##       "gists_url": "https://api.github.com/users/numpy/gists{/gist_id}",
##       "starred_url": "https://api.github.com/users/numpy/starred{/owner}{/repo}",
##       "subscriptions_url": "https://api.github.com/users/numpy/subscriptions",
....
```


