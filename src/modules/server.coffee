_ = require 'lodash'
Core = require 'sublime-core'
Application = require 'sublime-application'
express = require 'express'
passport = require 'passport'
bodyParser = require 'body-parser'
session = require 'express-session'
cons = require 'consolidate'
userController = require('./controllers/user.controller')
profileController = require('./controllers/profile.controller')
authController = require('./controllers/auth.controller')
oauth2Controller = require('./controllers/oauth2.controller')
clientController = require('./controllers/client.controller')

class Server extends Core.CoreObject
  constructor: (ctx, options) ->
    super options

    @ctx = ctx
    @ctrl =
      user: userController(@ctx)
      profile: profileController(@ctx)
      auth: authController(@ctx)
      oauth2: oauth2Controller(@ctx)
      client: clientController(@ctx)

    @app = new Application.Application @options.server

    @app.use (app) =>
      app.engine 'html', cons.handlebars
      app.set 'view engine', 'html'
      app.set 'views', 'views'

      app.use bodyParser.urlencoded(extended: true)

      app.use session(
        secret: @options.session.secret
        saveUninitialized: true
        resave: true
      )

      app.use passport.initialize()

      app.use (req, res, next) ->
        res.header 'Access-Control-Allow-Origin', '*'
        next()

      router = express.Router()

      router.route '/users'
        .post @ctrl.user.post
        .get @ctrl.auth.isAuthenticated, @ctrl.user.get

      router.route '/profile'
        .get @ctrl.auth.isAuthenticated, @ctrl.profile.get

      router.route '/clients'
        .post @ctrl.auth.isAuthenticated, @ctrl.client.post
        .get @ctrl.auth.isAuthenticated, @ctrl.client.get

      router.route '/oauth2/authorize'
        .get @ctrl.auth.isAuthenticated, @ctrl.oauth2.authorization
        .post @ctrl.auth.isAuthenticated, @ctrl.oauth2.decision

      router.route '/oauth2/token'
        .post @ctrl.auth.isClientAuthenticated, @ctrl.oauth2.token

      app.use '/api', router

  use: (fn) ->
    @app.use fn

  start: (port) ->
    @app.start port

module.exports = Server
