# codicng: utf-8

require 'yaml'

def input_loop(label = '')
  loop do
    print "#{label}: "
    i = $stdin.gets.chomp
    return i unless i.empty?
  end
end

def write_file(path, append = false)
  if block_given?
    File.open(path, append ? 'w+' : 'w') do |f|
      yield f
    end
    puts "[write] #{path}"
  end
end

CONFIG_DIR_NAME = 'config'
CONTRIBUTER_CONFIG_FILE_NAME = 'config.yaml'
WHENEVER_CONFIG_FILE_NAME = 'schedule.rb'

CONFIG_YAML_TEMPLATE = <<-EOS
@@CONFIG@@
# channel: "@your_name"
# post_user_name: 'Contributer'
# post_icon_emoji: ':warning:'
# post_text: 'WARNING!! Nothing contributing today!!'
EOS

WHENEVER_CONFIG_TEMPLATE = <<-EOS
# Powered by Whenever.
# Learn more: http://github.com/javan/whenever

# Contributer example.

#every '0 18,21,23 * * *' do
#  rake 'run_contributer'
#end
EOS

Config = Struct.new(:github_user_name, :slack_web_hook_url)

desc 'Setup Contributer.'
task :setup do
  sh 'bundle install --without development'
  puts ''

  config = Config.new(*Config.members.reduce([]) { |ary, m| ary << input_loop(m.to_s) })

  Dir.mkdir(CONFIG_DIR_NAME) unless FileTest.directory?(CONFIG_DIR_NAME)

  write_file(CONFIG_DIR_NAME + '/' + CONTRIBUTER_CONFIG_FILE_NAME) do |f|
    yaml = CONFIG_YAML_TEMPLATE.gsub(/@@CONFIG@@/, config.to_h.to_yaml)
    f.write(yaml)
  end

  write_file(CONFIG_DIR_NAME + '/' + WHENEVER_CONFIG_FILE_NAME) do |f|
    f.write(WHENEVER_CONFIG_TEMPLATE)    
  end

  puts "\nSetup finished!"
end

desc 'Execute Contributer.'
task :run_contributer do
  sh 'bundle exec bin/contributer'
end

desc 'Set crontab by Whenever.'
task :set_schedule do
  sh 'bundle exec whenever --update-crontab'
end
