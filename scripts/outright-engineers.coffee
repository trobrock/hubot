# Outright people are awesome

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

    answer = answers.shuffle().pop()

    msg.send answer
