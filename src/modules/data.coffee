Core = require 'sublime-core'
Data = require 'sublime-data'
mongo = require 'sails-mongo'

models = [
  new Data.Model(
    { identity: 'token', connection: 'primary', autoPK: false },
    {
      userId: { type: 'string', required: true }
      clientId: { type: 'string', required: true }
      value: { type: 'string', required: true }
    }
  ),
  new Data.Model(
    { identity: 'code', connection: 'primary' },
    {
      userId: { type: 'string', required: true }
      clientId: { type: 'string', required: true }
      redirectUri: { type: 'string', required: true }
      value: { type: 'string', required: true }
    }
  ),
  new Data.Model(
    { identity: 'client', connection: 'primary' },
    {
      name: { type: 'string', unique: true, required: true }
      userId: { type: 'string', required: true }
      secret: { type: 'string', required: true }
    }
  ),
  new Data.Model(
    { identity: 'user', connection: 'primary' },
    {
      username: { type: 'string', unique: true, required: true }
      password: { type: 'string', required: true }
      email: { type: 'email', required: true }
      thumbnail: { type: 'string', required: true }
      gender: { type: 'string', required: true }
    }
  )
]

cfg =
  adapters:
    'default': mongo
    mongo: mongo

  connections:
    primary:
      adapter: 'mongo'
      host: 'localhost'
      port: 27017
      database: 'sublime-db'

  defaults:
    migrate: 'drop'

ctx = new Data.DataContext cfg
ctx.init models
  .then () ->
    ctx.models.user
      .create
        username: 'admin'
        password: 'admin'
        email: 'shaunfarrell@g.harvard.edu'
        thumbnail: 'https://lh3.googleusercontent.com/-i2djnmHtrWw/AAAAAAAAAAI/AAAAAAAAAF8/NGlm7wio9L4/photo.jpg?sz=50'
        gender: 'male'
      .exec (err, user) ->
        ctx.models.client
          .create
            userId: user.id
            name: 'sublime'
            secret: 'keyboard cat'
          .exec () -> return

module.exports = ctx
