# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_rdcc_session_secure',
  :secret      => 'cf0c08516edce2d10a6c9f90bd604aa7488e0a2910aa627f3596d999def37012af30a6e8606466227690b087d8886e4a7f46b5ebfaf2a7d61980faadfd836881'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
