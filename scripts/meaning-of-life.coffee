# Find out what the meaning of life is
#
# what's the meaning of life - Do you have to ask?

module.exports = (robot) ->
  robot.respond /what'?s?(is )? the meaning of life\??/i, (msg) ->
    msg.send "42"
