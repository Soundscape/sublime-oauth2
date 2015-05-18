module.exports = (ctx) ->
  return {
    post: (req, res) ->
      client =
        name: req.body.name
        secret: req.body.secret
        userId: req.user.id

      ctx.models.client
        .create client
        .exec (err, client) ->
          if err then res.send err
          else res.json client

    get: (req, res) ->
      ctx.models.client
        .find()
        .where userId: req.user.id
        .exec (err, clients) ->
          if err then res.send err
          else res.json clients
  }
