oauth2orize = require 'oauth2orize'

module.exports = (ctx) ->
  server = oauth2orize.createServer()

  server.serializeClient (client, callback) ->
    callback null, client.name

  server.deserializeClient (name, callback) ->
    ctx.models.client
      .findOne()
      .where name: name
      .exec (err, client) ->
        if err then callback err
        else callback null, client

  server.grant oauth2orize.grant.token((client, user, ares, callback) ->
    expiration = new Date(new Date().getTime() + (3600 * 1000)).toISOString()
    token =
      value: uid 256
      clientId: client.name
      userId: user.id

    ctx.models.token
      .create token
      .exec (err, token) ->
        if err then callback err
        else callback null, token.value, expires_in: expiration
  )

  server.grant oauth2orize.grant.code((client, redirectUri, user, ares, callback) ->
    code =
      value: uid 16
      clientId: client.name
      redirectUri: redirectUri
      userId: user.id

    ctx.models.code
      .create code
      .exec (err) ->
        if err then callback err
        else callback null, code.value
  )

  server.exchange oauth2orize.exchange.code((client, code, redirectUri, callback) ->
    ctx.models.code
      .findOne()
      .where value: code
      .exec (err, authCode) ->
        if err then return callback err
        if authCode == undefined then return callback null, false
        if client.name.toString() != authCode.clientId then return callback null, false
        if redirectUri != authCode.redirectUri then return callback null, false

        ctx.models.code
          .destroy authCode
          .exec (err) ->
            if err then return callback err

          token =
            value: uid 256
            clientId: authCode.clientId
            userId: authCode.userId

          ctx.models.token
            .create token
            .exec (err, token) ->
              if err then callback err
              else callback null, token
  )

  return {
    authorization: [
      server.authorization(
        (name, redirectUri, callback) ->
          ctx.models.client
            .findOne()
            .where name: name
            .exec (err, client) ->
              if err then callback err
              else callback null, client, redirectUri
      ),
      (req, res) ->
        res.render 'dialog',
          transactionId: req.oauth2.transactionID
          user: req.user
          client: req.oauth2.client
    ]
    decision: [server.decision()]
    token: [server.token(), server.errorHandler()]
  }

uid = (len) ->
  buf = []
  chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
  charlen = chars.length

  for i in [0..len]
    buf.push chars[getRandomInt 0, charlen - 1]

  buf.join ''

getRandomInt = (min, max) ->
  Math.floor(Math.random() * (max - min + 1)) + min
