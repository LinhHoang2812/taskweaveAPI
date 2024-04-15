#!/usr/bin/env bash
# exit on error
set -o errexit

bundle lock --add-platform x86_64-linux
bundle install
bundle exec rails db:migrate