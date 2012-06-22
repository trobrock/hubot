# Helps with handling communication during times of application outage
#
# hubot what's the problem with the app? - Shows the current status message, or all good
# hubot the app's down because "REASON" - Sets the current status message
# hubot the app's back up - Resets the current status message to good
# hubot is there an update to the app down? - Asks for an update about the app being down
# hubot downtime update "MESSAGE" - Adds a new update to the status message stack

class ItsDown
  owner: null
  startedAt: null
  _requests: []

  constructor: (storage) ->
    storage.its_down = {} unless storage.its_down
    @_storage         = storage.its_down
    @_storage.updates = []

  currentStatus: (msg, owner) ->
    if msg == null
      @_storage.status  = null
      @_storage.updates = []
      @_requests        = []
      @owner            = null
      @startedAt        = null
    else if msg != undefined
      @_storage.status  = msg
      @_storage.updates = []
      @_requests        = []
      @owner            = owner
      @startedAt        = Date()

    @_storage.status || "Looks like things are good"

  requestUpdate: (user) ->
    @_requests.push user

  requesters: (persist=false) ->
    requesters = @_requests
    @_requests = []
    requesters

  update: (msg) ->
    @_storage.updates.push "[#{Date()}] #{msg}"

  updates: (msg) ->
    @_storage.updates

module.exports = (robot) ->
  itsDown = new ItsDown(robot.brain.data)
  askForUpdate = (msg) ->
    msg.send "#{itsDown.owner}: is there an update to the downtime?"

  robot.respond /what('?s| is) the problem with the app\??/i, (msg) ->
    msg.send itsDown.currentStatus()

  robot.respond /is there an update to the app down\??/i, (msg) ->
    asker = msg.message.user.name
    owner = itsDown.owner

    itsDown.requestUpdate(asker)

    msg.send "#{owner}, #{asker} is wondering is there is an update to the down time."

  robot.respond /fill me in on the down ?time/i, (msg) ->
    msg.send "OK #{msg.message.user.name}..."
    msg.send "The downtime started at #{itsDown.startedAt} with #{itsDown.currentStatus()}"
    msg.send "Updates to this downtime were:"
    msg.send itsDown.updates().join("\n")

  robot.respond /downtime update "(.+)"/i, (msg) ->
    itsDown.update(msg.match[1])
    requesters = itsDown.requesters()
    setTimeout(askForUpdate.bind(this, msg), 5 * 60 * 1000)
    if requesters.length
      message = "#{requesters.join(", ")}: #{msg.message.user.name} sent an update about the downtime."
      msg.send message
      msg.send msg.match[1]
    else
      msg.send "Downtime update saved"

  robot.respond /the app'?s down because "(.+)"/i, (msg) ->
    status = itsDown.currentStatus(msg.match[1], msg.message.user.name)
    msg.send "OK it's set to: '#{status}'"
    setTimeout(askForUpdate.bind(this, msg), 5 * 60 * 1000)

  robot.respond /the app'?s back up/i, (msg) ->
    itsDown.currentStatus(null)
    msg.send "OK the site is back up. Well done."
