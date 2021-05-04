require 'json'

namespace :sonar do
  desc 'Convert rspec report to sonarqube format'
  task :convert do
    sqube = JSON.load(File.read('coverage/.resultset.json'))['RSpec']['coverage'].transform_values {|lines| lines['lines']}
    total = { 'RSpec' => { 'coverage' => sqube, 'timestamp' => Time.now.to_i }}
    File.write('coverage/.resultset.sonarqube.json', JSON.dump(total)) 
  end
end
