# Generates help commands for Hubot.
#
# These commands are grabbed from comment blocks at the top of each file.
#
# help - Displays all of the help commands that Hubot knows about.
# help <query> - Displays all help commands that match <query>.

module.exports = (robot) ->
  robot.respond /build my (.+) branch$/i, (msg) ->
    msg.send "Changing your Jenkins job to build #{msg}"

