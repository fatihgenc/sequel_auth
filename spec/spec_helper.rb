require 'rubygems'
require 'bundler'
Bundler.setup
require 'simplecov'
require "simplecov_json_formatter"
# Generate HTML and JSON reports
SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::JSONFormatter
])

require 'sequel'
require 'sequel/extensions/migration'
require 'net/http'

RSpec.configure do |c|
  c.before :suite do
    Sequel::Model.db = Sequel.connect('sqlite:/')
    
    Sequel.migration do
      up do
        create_table(:users) do
          primary_key :id
          varchar     :password_digest
          varchar     :access_token
          integer     :login_count, default: 0
          integer     :failed_login_count, default: 0
          datetime    :last_login_at
        end
      end
    end.apply(Sequel::Model.db, :up)
    
    class User < Sequel::Model
      plugin :sequel_auth
    end
    
    class User2 < Sequel::Model(:users)
    end
  end
  
end


SimpleCov.minimum_coverage 90 
SimpleCov.start
SimpleCov.at_exit do
  op = SimpleCov.result.coverage_statistics[:line].percent
  color = case op
  when 0..20 then :red
  when 21..40 then :orange
  when 41..60 then :yellow
  when 61..80 then :yellowgreen
  when 81..90 then :green
  else :brightgreen
  end
  File.write("coverage.svg", Net::HTTP.get(URI.parse("https://img.shields.io/badge/coverage-#{op.round(2)}-#{color}.svg")))
  SimpleCov.result.format!
end
require_relative '../lib/sequel_auth'
