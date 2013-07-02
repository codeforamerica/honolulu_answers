# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
Honoluluanswers::Application.config.secret_token = ENV['SECRET_TOKEN'] || 'e7e15c757fd054f59075806437a73db06f24afed6203af2cd15dead1fcd3612560e51aeb5477e772d06c2e3f1387edef13ed6885a8292461564a9df9815c2005'
