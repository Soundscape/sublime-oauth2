passport = require 'passport'
BasicStrategy = require('passport-http').BasicStrategy
BearerStrategy = require('passport-http-bearer').Strategy

module.exports = (ctx) ->
  passport.use new BasicStrategy (username, password, callback) ->
    ctx.models.user
      .findOne()
      .where username: username
      .exec (err, user) ->
        if err then return callback err
        if !user then return callback null, false
        if password != user.password then callback null, false
        else callback null, user

  passport.use 'client-basic', new BasicStrategy (name, secret, callback) ->
    ctx.models.client
      .findOne()
      .where name: name
      .exec (err, client) ->
        if err then return callback err
        if !client || client.secret != secret then callback null, false
        else callback null, client

  passport.use new BearerStrategy (accessToken, callback) ->
    ctx.models.token
      .findOne()
      .where value: accessToken
      .exec (err, token) ->
        if err then return callback err
        if !token then return callback null, false

        ctx.models.user
          .findOne()
          .where id: token.userId
          .exec (err, user) ->
            if err then return callback err
            if !user then callback null, false
            else callback null, user, scope: '*'

  return {
    isAuthenticated: passport.authenticate ['basic', 'bearer'], session: false
    isClientAuthenticated: passport.authenticate 'client-basic', session: false
    isBearerAuthenticated: passport.authenticate 'bearer', session: false
  }
