module.exports = (robot) ->
  robot.hear /(app|agg)\/\#(\d+)/i, (msg) ->
    repo = if msg.match[1] == "agg" then "aggregation" else "outright"
    id = msg.match[2]

    msg.send("Looks like #{msg.message.user.name} was talking about https://github.com/outright/#{repo}/issues/#{id}")
