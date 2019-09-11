require "spec_helper"

RSpec.describe VaultPKI do
  it "has a version number" do
    expect(VaultPki::VERSION).not_to be nil
  end
end
