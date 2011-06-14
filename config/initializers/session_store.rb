# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_earthaudit_session',
  :secret      => 'a794ca1c7806b1c0fa8a1c5e1949964c4e9af5e98bb8bcd5cc89fd884e924cd94148bc25b8f5cb3fbca0a498fe66a9a73d0a57fcddf8cbc9c6232f108ddbbb52'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
