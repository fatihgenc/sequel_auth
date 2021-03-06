# Sequel_auth

[![Gem Version](https://badge.fury.io/rb/sequel_auth.svg)](https://badge.fury.io/rb/sequel_auth) [![Coverage](/coverage.svg)]()

Plugin adds model level authentication with BCrypt, Scrypt, Crypt algotihms for Sequel models.

This plugin inspired from [sequel_secure_password](https://github.com/mlen/sequel_secure_password) and [authlogic](https://github.com/binarylogic/authlogic) (rails) plugins.

If you're looking for a full stack authentication framework then check [rodauth](https://github.com/jeremyevans/rodauth)

## Installation

Add this line to your application's Gemfile:

    gem 'sequel_auth'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sequel_auth

## Usage

Plugin should be used in subclasses of `Sequel::Model`.


### Basic Exapmle

    class User < Sequel::Model
      plugin :sequel_auth
    end

### Specific Provider

    # Bcrypt is the default provider and you can chose bcrypt, scrypt or string crypt 
    class ScryptUser < Sequel::Model
      plugin :sequel_auth, provider: :scrypt
    end
    
### Specific Provider with options
    
    class ScryptUser < Sequel::Model
      plugin :sequel_auth, provider: :scrypt, provider_opts: {salt_size: 9}
    end

#### Default Opitions

*Bcrypt*
* cost : 8

*Scrypt*
* key_len: 32
* salt_size: 8
* max_time: 0.2
* max_mem: 1024 * 1024
* max_memfrac: 0.5

*Crypt*
* salt_size: 16
* method: on of (:sha512, :md5,:nthash,:sha256,:sha512,:sha1)

### Access Token Column
access_token_column option adds a method for resetting the colum. This method generates 22 character length url safe string
 
    class UserWithAccessToken
        plugin :sequel_auth,access_token_column: :access_token
    end
    user.reset_access_token
    user.access_token # => "knOSWH5l5JI87p1AVEq6Xg"
### include_validations option
include_validations option can be used to disable default password presence and confirmation validation. 
> Please note that, precence check only works for new records.

    class UserWithoutValidations < Sequel::Model
      plugin :sequel_auth, include_validations: false
    end
### digest_validations option
digest_column option can be used to use an alternate database column. the default column is "password_digest"

    class UserWithSpecificDigestColumn < Sequel::Model
      plugin :sequel_auth, digest_column: :crypted_password
    end
    
### Login columns    
Implemented columns (integer)login_count, (integer)failed_login_count, (datetime)last_login_at

    class UserWithLoginColumns
        plugin :sequel_auth, 
            login_count_column: :login_count, 
            failed_login_count_column: :failed_login_count,
            last_login_at_column: :last_login_at
    end
    
    user = User.new
    user.password = "foo"
    user.password_confirmation = "bar"
    user.valid? # => false

    user.password_confirmation = "foo"
    user.valid? # => true

    user.authenticate("foo") # => user
    user.login_count # => 1
    user.last_login_at # => Just now
    user.authenticate("bar") # => nil
    user.failed_login_count # => 1

## Contributing
1. Fork it ( http://github.com/planas/sequel_enum/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request
