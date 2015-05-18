module.exports = (ctx) ->
  return {
    post: (req, res) ->
      user =
        username: req.body.username
        password: req.body.password

      ctx.models.user
        .create user
        .exec (err, user) ->
          if err then res.send err
          else res.json user

    get: (req, res) ->
      ctx.models.user
        .find()
        .exec (err, users) ->
          if err then res.send err
          else res.json users
  }
