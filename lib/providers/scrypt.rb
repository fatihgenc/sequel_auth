# frozen_string_literal: true

require "scrypt"

module SequelAuth
  module Providers
    class Scrypt
      class << self
        
        attr_writer :key_len, :salt_size, :max_time, :max_mem, :max_memfrac
        # Key length - length in bytes of generated key, from 16 to 512.
        def key_len
          @key_len ||= defaults[:key_len]
        end
        
        # Salt size - size in bytes of random salt, from 8 to 32
        def salt_size
          @salt_size ||= defaults[:salt_size]
        end
        
        # Max time - maximum time spent in computation
        def max_time
          @max_time ||= defaults[:max_time]
        end
        
        # Max memory - maximum memory usage. The minimum is always 1MB
        def max_mem
          @max_mem ||= defaults[:max_mem]
        end
        
        # Max memory fraction - maximum memory out of all available. Always
        # greater than zero and <= 0.5.
        def max_memfrac
          @max_memfrac ||= defaults[:max_memfrac]
        end
        
        def encrypt(password)
          ::SCrypt::Password.create(
            password,
            key_len: key_len,
            salt_size: salt_size,
            max_mem: max_mem,
            max_memfrac: max_memfrac,
            max_time: max_time
          )
        end

        def matches?(hash, password)
          ::SCrypt::Password.new(hash)==password
        rescue ::SCrypt::Errors::InvalidHash
          false
        end   
        
        def defaults
          {
            key_len: 32,
            salt_size: 8,
            max_time: 0.2,
            max_mem: 1024 * 1024,
            max_memfrac: 0.5
          }.freeze
        end
      end
    end
  end
end
