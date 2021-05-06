# frozen_string_literal: true

module SequelAuth
  module Providers
    class Crypt
      class << self
        
        attr_writer :method,:salt_size,:salt
        # Salt prefix - prefix for random salt
        def method
          @method ||= defaults[:method]
        end
        
        # Salt size - size as number
        def salt_size
          @salt_size ||= defaults[:salt_size]
        end
        
        # Salt size
        def salt
          @salt ||= defaults[:salt]
        end
        
        def random_salt
          schemes.fetch(method) + (salt_size-schemes.fetch(method).length).times.map { 
            (('a'..'z').to_a + (1..9).to_a + ('A'..'Z').to_a).sample 
          }.join
        end
        
        def encrypt(password)
          if salt
            password.crypt(salt)
          else
            password.crypt(random_salt)
          end
        end
        
        def matches?(hash, password)
          password.crypt(hash) == hash
        end   
        
        def defaults
          {
            salt: nil,
            method: :sha512,
            salt_size: 16,
          }.freeze
        end
        private 
        def schemes
          {
            md5: '$1$',
            nthash: '$3$$',
            sha256: '$5$',
            sha512: '$6$',
            sha1: '$sha1$'
          }.freeze
        end
      end
    end
  end
end
