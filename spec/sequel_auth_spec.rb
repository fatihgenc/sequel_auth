require 'spec_helper'
describe "using Sequel::Plugins::SequelAuth" do
  describe "Using default settings" do
    subject(:user) { User.new }
    context "with empty password" do
      it "should raise Argument Error" do
        expect {user.password = user.password_confirmation = ""}.to raise_error ArgumentError
      end
    end
    context "with whitespace password" do
      it "should raise Argument Error" do
        expect {user.password = user.password_confirmation = "    ";}.to raise_error ArgumentError
      end
    end
    context "with nil password" do
      it "should raise Argument Error" do
        expect {user.password = user.password_confirmation = nil}.to raise_error ArgumentError
      end
    end
    context "without setting a password" do
      it "should raise Argument Error" do
        expect {user.save}.to raise_error Sequel::ValidationFailed
      end
    end
    context "without confirmation" do
      it "should raise Argument Error" do
        expect {user.password = "test";user.save}.to raise_error Sequel::ValidationFailed
      end
    end
  end 
  
  describe "Access token column" do
    context "Access token column defined" do
      subject(:user) { 
        User.plugin :sequel_auth,access_token_column: :access_token
        User.create(password: "test",password_confirmation: "test") }
      it "should respond to reset_access_token" do
        expect(user.respond_to?(:reset_access_token)).to eq(true)
      end
      it "should not raise error" do
        expect{user.reset_access_token}.not_to raise_error
      end
      it "should give 16 char string" do
        user.reset_access_token
        expect(user.values[User.access_token_column].length).to eq(22) 
      end
    end
  end
  
  describe "Using bcrypt provider" do
    context "Min cost" do
      subject(:user) {
        User.plugin :sequel_auth, provider: :bcrypt, provider_opts: {cost: BCrypt::Engine::MIN_COST-1};
        User.new(password: "test",password_confirmation: "test")
      }
      it "should not be less then min cost" do
        expect {user.save}.to raise_error ArgumentError
      end
    end
    context "Default cost" do
      subject(:user) {
        User.plugin :sequel_auth, provider: :bcrypt;
        User.new(password: "test",password_confirmation: "test")
      }
      it "should be equal to default cost" do
        expect(user.class.provider.cost).to eq(BCrypt::Engine.cost)
      end
    end
  end
  
  describe "Using scrypt provider" do
    context "Default options" do
      subject(:user) {
        User.plugin :sequel_auth, provider: :scrypt;
        User.new(password: "test",password_confirmation: "test")
      }
      it "should be equal to default key_len" do
        expect(user.class.provider.key_len).to eq(SequelAuth::Providers::Scrypt.defaults[:key_len])
      end
      it "should be equal to default salt_size" do
        expect(user.class.provider.salt_size).to eq(SequelAuth::Providers::Scrypt.defaults[:salt_size])
      end
      it "should be equal to default max_time" do
        expect(user.class.provider.max_time).to eq(SequelAuth::Providers::Scrypt.defaults[:max_time])
      end
      it "should be equal to default max_mem" do
        expect(user.class.provider.max_mem).to eq(SequelAuth::Providers::Scrypt.defaults[:max_mem])
      end
      it "should be equal to default max_memfrac" do
        expect(user.class.provider.max_memfrac).to eq(SequelAuth::Providers::Scrypt.defaults[:max_memfrac])
      end
    end
  end
  
  describe "Using crypt provider" do
    context "Default options" do
      subject(:user) {
        User.plugin :sequel_auth, provider: :crypt;
        User.new(password: "test",password_confirmation: "test")}
      it "should be equal to default salt_prefix" do
        expect(user.class.provider.salt_prefix).to eq(SequelAuth::Providers::Crypt.defaults[:salt_prefix])
      end
      it "should be equal to default salt_size" do
        expect(user.class.provider.salt_size).to eq(SequelAuth::Providers::Crypt.defaults[:salt_size])
      end
    end
    context "With incorrect prefix" do
      subject(:user) {
        User.plugin :sequel_auth, provider: :crypt, provider_opts: {salt_prefix: "***"}
        User.new(password: "test",password_confirmation: "test")}
      it "should raise Argument Error" do
        expect {user.save}.to raise_error Errno::EINVAL
      end
    end
  end
  
  
end
