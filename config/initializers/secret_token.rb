# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Scheduler::Application.config.secret_key_base = '385d10056b498f20612056d9f838f088a1542d98cb7f96adfdb7a23153a7b081ab92118ee85061dabd4c3b95f12440225500c72f2cc6fab6751a79faefad576b'
