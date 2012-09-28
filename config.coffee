email = require 'emailjs'

config = {}

# PASSWORDS
config.pwd  = process.env.PWD_STANFORD
config.user = process.env.USR_STANFORD

# email
config.smtp = server = email.server.connect
   name     : config.user
   password : config.pwd
   host     : "smtp.stanford.edu"
   ssl      : true

module.exports = config
