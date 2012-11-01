module.exports = (robot) ->
  robot.router.post "/elo/rank", (req, res) ->
    player = req.body.player
    rank   = req.body.rank

    start_rank = parseInt(rank[0])
    end_rank   = parseInt(rank[1])

    diff   = start_rank - end_rank
    motion = if diff > 0 then "down" else "up"

    robot.messageRoom 538892, "#{player} just moved #{motion} in rank by #{Math.abs(diff)}"
    res.end()
