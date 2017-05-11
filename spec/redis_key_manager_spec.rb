require "spec_helper"

describe RedisKeyManager do
  it "has a version number" do
    expect(RedisKeyManager::VERSION).not_to be_nil
  end
end
