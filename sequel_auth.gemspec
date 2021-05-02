# frozen_string_literal: true

require_relative 'lib/sequel_auth/version'

Gem::Specification.new do |s| 
  s.name        = 'sequel_auth'
  s.version     = Sequel::Plugins::SequelAuth::VERSION
  s.date        = Time.now.strftime('%Y-%m-%d')
  s.summary     = <<EOF
Plugin to add authentication methods to Sequel Model
Select one of crypt, bcrypt, scrypt
EOF
  s.authors     = ["Fatih GENÇ"]
  s.files       = Dir['lib/**/*.rb']
  s.homepage    = 'https://gitlab.com/fatihgenc/sequel_auth'
  s.license     = 'MIT' 
  s.description = "Plugin to add authentication methods to Sequel Model" 
  s.email       = 'fatihgnc@gmail.com'
  
  s.add_dependency 'sequel',      '~> 5.0','>= 5.0.0'
  s.add_dependency 'bcrypt',      '~> 3.1'
  s.add_dependency 'scrypt',      '~> 3.0'
  
  s.add_development_dependency 'rspec',          '~> 3.0'
  s.add_development_dependency 'sqlite3',        '~> 1.4'
end
