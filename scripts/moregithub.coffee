# Based on github-issue-link.coffee, in hubot-scripts.
module.exports = (robot) ->
  github = require("githubot")(robot)

  bot_github_repo = github.qualified_repo process.env.HUBOT_GITHUB_REPO

  hey_github = (frag, callback) ->
    console.log frag
    github.get "https://api.github.com/repos/#{bot_github_repo}#{frag}", callback

  describe_issue = (msg, issue_number) ->
    return if isNaN(issue_number)
    hey_github "/issues/" + issue_number, (issue_obj) ->
      issue_title = issue_obj.title
      msg.send "Issue " + issue_number + ": " + issue_title  + "  http://github.com/" + bot_github_repo + '/issues/' + issue_number

  robot.hear /#\d+/g, (msg) ->
    for match in msg.match
      describe_issue msg, match.replace '#', ''

  describe_commit = (msg, sha) ->
    hey_github "/commits/" + sha, (commit_obj) ->
      commit_message = commit_obj.commit.message
      msg.send "Commit " + sha + ": " + commit_message + "  http://github.com/" + bot_github_repo + "/commit/" + sha

  robot.hear /[0-9a-f]{4,40}/g, (msg) ->
    for match in msg.match
      describe_commit msg, match
