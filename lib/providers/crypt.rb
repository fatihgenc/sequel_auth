# frozen_string_literal: true

module SequelAuth
  module Providers
    class Crypt
      class << self
        
        attr_writer :salt_prefix,:salt_size
        # Salt prefix - prefix for random salt
        def salt_prefix
          @salt_prefix ||= defaults[:salt_prefix]
        end
        
        # Salt size - size as number
        def salt_size
          @salt_size ||= defaults[:salt_size]
        end
        
        def salt
          salt_prefix + (salt_size-salt_prefix.length).times.map { 
            (('a'..'z').to_a + (1..9).to_a + ('A'..'Z').to_a).sample 
          }.join
        end
        
        def encrypt(password)
          password.crypt(salt)
        end
        
        def matches?(hash, password)
          password.crypt(hash) == hash
        end   
        
        private
        def defaults
          {
            salt_prefix: "$6$",
            salt_size: 16,
          }.freeze
        end
      end
    end
  end
end
