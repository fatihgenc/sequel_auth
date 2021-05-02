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
        end
      end
    end.apply(Sequel::Model.db, :up)
    
    class User < Sequel::Model
      plugin :sequel_auth
    end
    
   # class BcryptUser < Sequel::Model
   #   plugin :sequel_auth, provider: :bcrypt
   # end
   # 
   # class ScryptUser < Sequel::Model
   #   plugin :sequel_auth, provider: :scrypt
   # end
   # 
   # class CryptUser < Sequel::Model
   #   plugin :sequel_auth, provider: :crypt
   # end
   # 
   # class DifferentDigestUser < Sequel::Model
   #   plugin :sequel_auth, digest_column: :password_hash
   # end
    
  end
  
end
