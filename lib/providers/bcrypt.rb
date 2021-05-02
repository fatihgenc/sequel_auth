require "bcrypt"

module SequelAuth
  module Providers
    class Bcrypt
      class << self
        
        def cost
          @cost ||= ::BCrypt::Engine.cost
        end
        
        def cost=(val)
          raise ArgumentError,"cost < #{min_cost} not allowed!" if val < min_cost
          @cost = val
        end
        
        def encrypt(password)
          raise ArgumentError, "password not a valid string" if !password.is_a?(String) || password.strip.empty?
          ::BCrypt::Password.create(password, cost: cost)
        end
        
        def matches?(hash,password)
          ::BCrypt::Password.new(hash)==password
        rescue ::BCrypt::Errors::InvalidHash
          false
        end
        
        private
        def min_cost
          ::BCrypt::Engine::MIN_COST
        end
      end
    end
  end
end
