#!/bin/bash
#docker-compose down
#docker-compose rm $(docker ps -q -f status=exited)
echo "Running tests in a fully containerized environment ====>"
# docker-compose run post bundle exec rake ts:configure
# docker-compose run post bundle exec rake ts:start
# docker-compose run post bundle exec rake ts:index
docker-compose up -d mysql post
sleep 15
docker-compose run post bundle exec rails db:create db:migrate
echo "Databse created..."
docker-compose run post bundle exec rails test