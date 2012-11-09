TENSAI_URL = "http://localhost:9292"
module.exports = (robot) ->
  robot.router.post "/tensai", (req, res) ->
    robot.messageRoom 123, req.body.message
    res.end()

  robot.respond /deploy apps\?$/i, (msg) ->
    msg.http("#{TENSAI_URL}/applications")
      .get() (err, res, body) ->
        data = JSON.parse(body)
        msg.send("I can deploy to #{data.join(", ")}")

  robot.respond /deploy add (.+)$/i, (msg) ->
    msg.http("#{TENSAI_URL}/applications")
      .query(repo: msg.match[1])
      .post() (err, res, body) ->
        data = JSON.parse(body)
        msg.send("Adding application: #{msg.match[1]}")

  robot.respond /deploy (\w+) ?(\w+)$/i, (msg) ->
    options = {
      application: msg.match[1]
      user: msg.message.user.name
    }
    options["environment"] = msg.match[2] if msg.match[2]
    msg.http("#{TENSAI_URL}/deploys")
      .query(options)
      .post() (err, res, body) ->
        data = JSON.parse(body)
        msg.send("Queued deploy for #{msg.match[1]} #{msg.match[2]} :: #{TENSAI_URL}/deploy/#{data.id}")
