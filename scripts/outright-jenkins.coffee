# Manage the Outright Jenkins CI
#
# build my <branch> branch - Set's up Jenkins to point your CI at a specified branch
# whats my ci building - Tells you what branch your CI is currently building
# kick off my build - Kicks off a new build of your CI on Jenkins

ADMIN_URL = "http://admin.outright.com:8080"
# ADMIN_URL = "http://localhost:9292"

module.exports = (robot) ->
  robot.respond /build my (.+) branch$/i, (msg) ->
    branch = msg.match[1]

    msg.http("#{ADMIN_URL}/api/jenkins/job/config")
      .query(user: msg.message.user.githubLogin, branch: branch)
      .post() (err, res, body) ->
        if res.statusCode != 200 || err
          msg.send("There was a problem setting CI to your #{branch} branch")
        else
          msg.send("Ok... it's set up to build your #{branch} branch")

  robot.respond /whats my ci building/i, (msg) ->
    msg.http("#{ADMIN_URL}/api/jenkins/job/config")
      .query(user: msg.message.user.githubLogin)
      .get() (err, res, body) ->
        if res.statusCode != 200 || err
          msg.send("There was a problem finding out what branch is building")
        else
          branch = JSON.parse(body)['branch']
          msg.send("CI is building your #{branch} branch")

  robot.respond /kick off my build/i, (msg) ->
    msg.http("#{ADMIN_URL}/api/jenkins/job/build")
      .query(user: msg.message.user.githubLogin)
      .post() (err, res, body) ->
        if res.statusCode != 200 || err
          msg.send("There was a problem building your CI")
        else
          msg.send("Ok... just kicked off a build of your CI")

  robot.respond /how'?s my build/i, (msg) ->
    msg.http("#{ADMIN_URL}/api/jenkins/job/status")
      .query(user: msg.message.user.githubLogin)
      .get() (err, res, body) ->
        if res.statusCode != 200 || err
          msg.send("There was a problem checking the status of your CI")
        else
          json = JSON.parse(body)

          successful = []
          failed     = []
          building   = []
          for branch, success of json
            successful.push branch if success == true
            failed.push branch     if success == false
            building.push branch   if success == null

          message = "#{msg.message.user.name}: "
          if failed.length
            message += "You have your #{failed.join(", ")} builds failing"
          else
            message += "All green"

          msg.send("#{message} with #{building.length} other jobs building")

  robot.respond /create my ci/i, (msg) ->
    msg.http("#{ADMIN_URL}/api/jenkins/create")
      .query(user: msg.message.user.githubLogin)
      .post() (err, res, body) ->
        if res.statusCode != 200 || err
          msg.send("There was a problem creating your CI")
        else
          json = JSON.parse(body)

          if json.success == true
            msg.send("Ok your CI is setup to build your master branch.")
          else
            msg.send("You already have a CI set up")

  robot.respond /update my ci build/i, (msg) ->
    msg.http("#{ADMIN_URL}/api/jenkins/update")
      .query(user: msg.message.user.githubLogin)
      .post() (err, res, body) ->
        if res.statusCode != 200 || err
          msg.send("There was a problem updating your CI")
        else
          json = JSON.parse(body)

          if json.success == true
            msg.send("Ok your CI is updated to the latest templates")
          else
            msg.send("You don't have a CI setup yet")
