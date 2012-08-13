# Based on github-issue-link.coffee, in hubot-scripts.
module.exports = (robot) ->
  github = require("githubot")(robot)

  describe_issue = (msg, issue_number) ->
    if isNaN(issue_number)
      return

    bot_github_repo = github.qualified_repo process.env.HUBOT_GITHUB_REPO
    issue_title = ""
    github.get "https://api.github.com/repos/#{bot_github_repo}/issues/" + issue_number, (issue_obj) ->
      issue_title = issue_obj.title
      msg.send "Issue " + issue_number + ": " + issue_title  + "  http://github.com/" + bot_github_repo + '/issues/' + issue_number

  robot.hear /#\d+/g, (msg) ->
    for match in msg.match
      describe_issue msg, match.replace '#', ''
