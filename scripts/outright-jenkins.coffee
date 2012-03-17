# Manage the Outright Jenkins CI
#
# build my <branch> branch - Set's up Jenkins to point your CI at a specified branch
# whats my ci building - Tells you what branch your CI is currently building
# kick off my build - Kicks off a new build of your CI on Jenkins

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

  robot.respond /kick off my build/i, (msg) ->
    msg.http("http://admin.outright.com:8080/api/jenkins/job/build")
      .query(user: msg.message.user.githubLogin)
      .post() (err, res, body) ->
        if res.statusCode != 200 || err
          msg.send("There was a problem building your CI")
        else
          msg.send("Ok... just kicked off a build of your CI")
