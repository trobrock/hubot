# Outright people are awesome

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
