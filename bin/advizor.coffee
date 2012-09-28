#!/usr/bin/env coffee

declare     = require '../lib/declare'
photo       = require '../lib/photo'
new_student = require '../lib/new_student'

argv = require('optimist')
  .usage('Usage: advizor [options] command')
  .boolean('no-fb')
  .demand(1)
  .argv

command = argv._[0] # will be there

switch command
  when 'declare' then declare argv['no-fb']
  when 'photo'   then photo()
  when 'new'     then new_student()
