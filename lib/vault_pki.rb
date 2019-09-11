require "vault_pki/version"
require "etc"

module VaultPKI
  def get_token()
    env_token = ENV['VAULT_TOKEN']
    if env_token
      return env_token
    end

    return get_token_from_file()
  end

  def get_token_from_file()
    token = nil
    begin
      passwd = Etc.getpwuid()
      token = File.open( "#{ passwd.dir }/.vault-token" ) { |input|
        input.gets( nil )
      }
    rescue => e
      # ignore error
    end
    return token
  end

  module_function :get_token, :get_token_from_file
end
