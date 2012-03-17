# Generates help commands for Hubot.
#
# These commands are grabbed from comment blocks at the top of each file.
#
# help - Displays all of the help commands that Hubot knows about.
# help <query> - Displays all help commands that match <query>.

module.exports = (robot) ->
  robot.respond /build my (.+) branch$/i, (msg) ->
    branch = msg.match[1]

    msg.http("http://admin.outright.com:8080/api/jenkins/job/config")
      .query(user: msg.message.user.githubLogin, branch: branch)
      .post() (err, res, body) ->
        if res.statusCode != 200 || err
          msg.send("There was a problem setting CI to your #{branch} branch")
        else
          msg.send("Ok... it's set up to build your #{branch} branch")

  robot.respond /whats my ci building/i, (msg) ->
    msg.http("http://admin.outright.com:8080/api/jenkins/job/config")
      .query(user: msg.message.user.githubLogin)
      .get() (err, res, body) ->
        if res.statusCode != 200 || err
          msg.send("There was a problem finding out what branch is building")
        else
          msg.send("CI is building your #{body} branch")
