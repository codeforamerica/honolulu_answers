pushd infrastructure
ruby bin/create_database.rb
cd ..
mv infrastructure/database.yml config/database.yml
rake -T db:setup
ruby bin/create_honolulu_answers_stack.rb