#!/usr/bin/env coffee

# turn on debug statements
process.env.DEBUG = 'advizor*'

optimist    = require 'optimist'
declare     = require '../lib/declare'
photo       = require '../lib/photo'
new_student = require '../lib/new_student'
board       = require '../lib/board'

debug = require('debug')('advizor/bin/advizor')

argv = optimist
  .usage('Usage: advizor [options] command')
  .demand(1)
  .argv

command = argv._[0] # will be there

callback = (err) ->
  return debug 'error', err if err
  debug 'Great Success'

debug "command: #{command}"

switch command
  when 'declare' then declare(argv, callback)
  when 'photo'   then photo()
  when 'new'     then new_student()
  when 'board'   then board()
