require 'rubygems'
require 'bundler'
Bundler.setup

require 'sequel'
require 'sequel/extensions/migration'
require_relative '../lib/sequel_auth'


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
        end
      end
    end.apply(Sequel::Model.db, :up)
    
    class User < Sequel::Model
      plugin :sequel_auth
    end
   
  end
  
end
