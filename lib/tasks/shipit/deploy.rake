# frozen_string_literal: true
require 'rake'
require 'heroku_helper'
require 'colorize'

namespace :shipit do
  task :deploy do
    Rake::Task["shipit:deploy:#{ENV['ENVIRONMENT']}"].invoke
  end
  namespace :deploy do
    desc 'Deploys production'
    task :production do
      app_name = 'space-dolphins'
      key = ENV['HEROKU_API_KEY']
      abort 'HEROKU_API_KEY is required'.red if key.blank?

      app = HerokuHelper::App.new(key, app_name)
      branch = if ENV['SHIPIT'] == '1'
                 'HEAD'
               else
                 'master'
               end
      app.deploy branch: branch
    end

    desc 'Deploys staging'
    task :staging do
      app_name = 'space-dolphins-staging'
      key = ENV['HEROKU_API_KEY']
      abort 'HEROKU_API_KEY is required'.red if key.blank?

      app = HerokuHelper::App.new(key, app_name)
      branch = if ENV['SHIPIT'] == '1'
                 'HEAD'
               else
                 'develop'
               end
      app.deploy branch: branch
    end
  end
end
