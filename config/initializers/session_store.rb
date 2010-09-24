# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_wb-shipping_session',
  :secret      => '70160cf8dfe88244418a62f58330095bb8628b286091c629bb15ca215ced2e85aa0dfb039250fbcfc2fa78e14d1445dbe47853c0886fa3b5cb0251fb839b7d45'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
