require "spec_helper.rb"

class TestRedisKeyring
  include RedisKeyManager::Manager

  key :example_nullary, "example:nullary"
  key :example_unary, "example:unary:[user_id]"
  key :example_binary, "example:binary:[user_id]:[tag]"
end

describe RedisKeyManager::Manager do

  describe ".included" do
    it "creates a class method on the including class for each key declared with .key", :aggregate_failures do
      expect(TestRedisKeyring).to respond_to(:example_nullary)
      expect(TestRedisKeyring).to respond_to(:example_unary)
      expect(TestRedisKeyring).to respond_to(:example_binary)
    end

    it "does not permit arbitrary class methods on the including class", :aggregate_failures do
      expect(TestRedisKeyring).not_to respond_to(:example_nullaryx)
      expect(TestRedisKeyring).not_to respond_to(:example_unaryx)
      expect(TestRedisKeyring).not_to respond_to(:example_binaryx)
    end

    it "does not create class methods on RedisKeyManager::Manager itself", :aggregate_failures do
      expect(RedisKeyManager::Manager).not_to respond_to(:example_nullary)
      expect(RedisKeyManager::Manager).not_to respond_to(:example_unary)
      expect(RedisKeyManager::Manager).not_to respond_to(:example_binary)
    end

    it "does not create class methods on RedisKeyManager itself", :aggregate_failures do
      expect(RedisKeyManager).not_to respond_to(:example_nullary)
      expect(RedisKeyManager).not_to respond_to(:example_unary)
      expect(RedisKeyManager).not_to respond_to(:example_binary)
    end
  end

  describe "each synthesized class method" do
    context "when passed all and only the option parameters implied by bracketed segments of the declared key pattern" do
      it "returns a string with the passed option values interpolated into the bracketed placeholders in the pattern",
        :aggregate_failures do
        expect(TestRedisKeyring.example_nullary).to eq("example:nullary")
        expect(TestRedisKeyring.example_unary(user_id: 15)).to eq("example:unary:15")
        expect(TestRedisKeyring.example_binary(user_id: 15, tag: "cool")).to eq("example:binary:15:cool")
      end
    end

    context "when passed option parameters that are not specified by bracketed segments of the declared key pattern" do
      it "raises ArgumentError" do
        expect { TestRedisKeyring.example_nullary(user_id: 3) }.to raise_error(ArgumentError)
        expect { TestRedisKeyring.example_unary(user_id: 3, tag: 15) }.to raise_error(ArgumentError)
        expect { TestRedisKeyring.example_binary(user_id: 15, tag: "cool", tagx: "warm") }.to raise_error(ArgumentError)
      end
    end

    context "when some of the implied option paramaters are not passed" do
      it "raises ArgumentError", :aggregate_failures do
        expect { TestRedisKeyring.example_unary }.to raise_error(ArgumentError)
        expect { TestRedisKeyring.example_binary(tag: "cool") }.to raise_error(ArgumentError)
      end
    end

    context "when some of the implied option parameters are passed nil" do
      it "raises RedisKeyManager::InvalidKeyComponentError", :aggregate_failures do
        expect { TestRedisKeyring.example_unary(user_id: nil) }.to raise_error(RedisKeyManager::InvalidKeyComponentError)
        expect { TestRedisKeyring.example_binary(user_id: 15, tag: nil) }.to \
          raise_error(RedisKeyManager::InvalidKeyComponentError)
      end
    end
  end
end
