email = require 'emailjs'

config = {}

# PASSWORDS
Object.defineProperty config, 'pwd',
  get: () ->
    pwd = process.env.PWD_STANFORD
    return pwd if pwd?
    console.error('You must export PWD_STANFORD environment variable')
    console.error('i.e. `export PWD_STANFORD=abc123`')
    console.error('The best way to do this is in ~/.zshenv')
    process.exit(-1)

Object.defineProperty config, 'user',
  get: () ->
    user = process.env.USR_STANFORD
    return user if user?
    console.error('You must export USR_STANFORD environment variable')
    console.error('i.e. `export USR_STANFORD=aeckert`')
    console.error('The best way to do this is in ~/.zshenv')
    process.exit(-1)

#config.pwd  = process.env.PWD_STANFORD
#config.user = process.env.USR_STANFORD

# email
config.smtp = server = email.server.connect
   name     : config.user
   password : config.pwd
   host     : "smtp.stanford.edu"
   ssl      : true

module.exports = config
