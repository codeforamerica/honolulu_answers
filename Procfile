web: bundle exec thin start -p $PORT
worker: bundle exec rake jobs:work
log: tail -f log/development.log