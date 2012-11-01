# Description
#   Outright people are awesome
#
# Dependencies:
#   none
#
# Configuration:
#   TRACKER_TOKEN
#
# Commands:
#   hubot what's best in life - cool video of, well, what's best in life
#   hubot what's going on with the importers? - an attempt at guessing what's up with the importers. Don't take it seriously though
#   hubot automate <this idea I have> - Add an idea for something you would like to see automated with hubot
#
# Notes:
#   no notes
#
# Author:
#   trobrock
#   julio

xml2js = require('xml2js')

module.exports = (robot) ->
  robot.respond /what'?s best in life\??/i, (msg) ->
    msg.send "To crush your enemies, see them driven before you, and to hear the lamentation of their women"
    msg.send "http://www.youtube.com/watch?v=kkSFIWzi7aA"

  robot.respond /what'?s going on with the importers\??/i, (msg) ->
    answers = [
      "Ask Steven",
      "A thrift server died",
      "We're under DDoS attack",
      "Ebay is down, or is it Paypal?",
      "Someone messed up a deploy",
      "There was an Amazon power outage",
      "Nothing is going on, mkay!?",
      "Someone must have tripped on the chord",
      "Hmmm..."
    ]

    answer = answers[Math.floor(Math.random()*answers.length)]

    msg.send answer

  robot.respond /(what'?s )?mau/i, (msg) ->
    msg.http("http://outright:salarium17@analytics.outright.com/widgets/mau")
      .query(key: "9fa76110375e94f647121c9e0f3f04fd6140e0e7")
      .get() (err, res, body) ->
        parser = new xml2js.Parser()
        parser.parseString body, (err, result) ->
          mau = result.root.item.pop()
          msg.send "#{msg.message.user.name}, current MAU is #{mau}"

  # Tell hubot to tell tracker to automate this new idea one day
  # The automations project ID on tracker is 679315
  # post to
  # http://www.pivotaltracker.com/services/v3/projects/679315/stories
  # TODO: make it so it's generic to any project
  robot.respond /(automate|tracker|pt) (.*)/i, (msg) ->
    msg.http('http://www.pivotaltracker.com/services/v3/projects/679315/stories')
      .header("X-TrackerToken", process.env.TRACKER_TOKEN)
      .query("story[name]": msg.match[2])
      .post(msg.match[2]) (err, res, body) ->
        if res.statusCode != 200 || err
          msg.send("Could not add this idea to the automations project.")
        else
          msg.send("Ok, someone will consider implementing that fine idea.")
