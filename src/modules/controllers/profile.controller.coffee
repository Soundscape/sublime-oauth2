module.exports = (ctx) ->
  return {
    get: (req, res) ->
      ctx.models.user
        .findOne()
        .where username: req.user.username
        .exec (err, user) ->
          if err then res.send err
          else res.json user
  }
