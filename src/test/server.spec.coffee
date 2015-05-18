lib = require '../'
config = require 'config'

describe 'Server test suite', ()  ->
  svr = new lib.Server lib.Data, config

  it 'should construct an instance', () ->
    expect(svr).not.toBeNull()
