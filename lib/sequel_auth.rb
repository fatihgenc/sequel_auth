require "sequel"
require "securerandom"
require_relative "providers/bcrypt"
require_relative "providers/scrypt"
require_relative "providers/crypt"

module Sequel
  module Plugins
    module SequelAuth
      def self.provider(provider,opts={})
        provider = Kernel.const_get("SequelAuth::Providers::#{provider.to_s.capitalize}")
        opts.each { |k,v| provider.public_send("#{k}=", v) }
        provider
      end
      
      def self.configure(model, opts = {})
        model.instance_eval do
          @digest_column       = opts.fetch(:digest_column, :password_digest)
          @include_validations = opts.fetch(:include_validations, true)
          @provider  = SequelAuth.provider opts.fetch(:provider, :bcrypt),
              opts.fetch(:provider_opts, {})
          #Optional columns
          @access_token_column        = opts.fetch(:access_token_column, nil)
          @login_count_column         = opts.fetch(:login_count_column, nil)
          @failed_login_count_column  = opts.fetch(:failed_login_count_column, nil)
          @last_login_at_column       = opts.fetch(:last_login_at_column,nil)
        end
      end
      
      module ClassMethods
        attr_reader :provider, 
            :digest_column, 
            :access_token_column, 
            :login_count_column,
            :failed_login_count_column,
            :last_login_at_column,
            :include_validations
        
        # NOTE: nil as a value means that the value of the instance variable
        # will be assigned as is in the subclass.
        Plugins.inherited_instance_variables(self, :@provider => nil,
                                             :@include_validations => nil,
                                             :@digest_column  => nil)
        
      end
      
      module InstanceMethods
        attr_accessor :password_confirmation
        attr_reader   :password
        def password=(unencrypted)
          @password = unencrypted
          self.send "#{model.digest_column}=",model.provider.encrypt(unencrypted)
        end
        
        def authenticate(unencrypted)
          if model.provider.matches?(self.send(model.digest_column),unencrypted)
            if model.login_count_column || model.last_login_at_column
              #Update login count
              self.send("#{model.login_count_column}=",self.send(model.login_count_column)+1 ) if model.login_count_column
              self.send("#{model.last_login_at_column}=",Time.now ) if model.last_login_at_column
              self.save
            end
            self
          else
            if model.failed_login_count_column
              #Update failed login count
              self.send("#{model.failed_login_count_column}=",self.send(model.failed_login_count_column)+1 )
              self.save            
            end
          end
        end
        
        def reset_access_token
          if model.access_token_column
            self.update(model.access_token_column=>SecureRandom.urlsafe_base64(16))
          end
        end
        
        def validate
          super
          
          if model.include_validations
            errors.add :password, 'is not present'              if password.nil? && new?
            errors.add :password, 'doesn\'t match confirmation' if password != password_confirmation
          end
        end
        
      end
      
    end
  end
end
