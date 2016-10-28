# coding: utf-8

desc 'Setup Contributer.'
task :setup do
  sh 'bundle install --without development'
end

desc 'Execute Contributer.'
task :run_contributer do
  sh 'bundle exec bin/contributer'
end

desc 'Set crontab by Whenever.'
task :set_schedule do
  sh 'bundle exec whenever --update-crontab'
end
