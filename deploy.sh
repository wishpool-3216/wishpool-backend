#!/bin/bash
cd /var/www/wishpool-backend
kill $(lsof -ti :3000)
export GIT_MERGE_AUTOEDIT=no
git fetch
git merge origin/master
bundle install
bundle exec rake db:migrate
bundle exec rails s -d
