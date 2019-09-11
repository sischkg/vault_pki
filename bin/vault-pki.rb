#!/usr/bin/ruby

require 'vault_pki'
require 'optparse'
require 'net/http'
require 'uri'
require 'pp'
require 'json'

# Default Variables.
common_name       = nil
ttl               = 30 * 24 * 60 * 60
role              = nil
vault_address     = 'http://127.0.0.1:8200'
mount_pki_path    = 'pki'
certificate_path  = 'certificate.pem'
intermediate_path = 'intermediate.pem'
private_key_path  = 'private_key.pem'
token             = VaultPKI::get_token()

opt = OptionParser.new
opt.on( '-n common_name',  '--name',         'common name' )                                    {|v| common_name = v }
opt.on( '-l ttl',          '--ttl',          'ttl' )                                            {|v| ttl = v }
opt.on( '-a address',      '--address',      'Vault address(https://example.com:8200)' )        {|v| vault_address = v }
opt.on( '-r role',         '--role',         'the name of the role to create the certificate' ) {|v| role = v }
opt.on( '-m path',         '--mount',        'mount path for PKI secret engine' )               {|v| mount_pki_path = v }
opt.on( '-t token',        '--token',        'vault token' )                                    {|v| token = v }
opt.on( '-c certificate',  '--certificate',  'new certificate file path' )                      {|v| certificate_path = v }
opt.on( '-i intermediate', '--intermediate', 'new intermediate certificate file path' )         {|v| intermediate_path = v }
opt.on( '-p private_key',  '--private',      'new private key file path' )                      {|v| private_key_path = v }
argv = opt.parse(ARGV)

if token.nil?
  $stderr.puts( "provide token via VAULT_TOKEN environment value or --token or $HOME/.vault-token(vault login)" )
  exit 1
end

url = URI.parse( sprintf( '%s/v1/%s/issue/%s', vault_address, mount_pki_path, role ) )
req = Net::HTTP::Post.new(url.path, { 'X-Vault-Token' => token, 'Content-Type' => 'application/json' } )
req['X-Vault-Token'] = token
req['Content-Type']  = 'application/json'
req.body = {
  "common_name" => common_name,
  "ttl"         => ttl,
}.to_json
res = Net::HTTP.start(url.host, url.port) {|http|
  http.request(req)
}

begin
  res.value
rescue => e
  $stderr.printf( "cannot generate the certificate for %s by %s(%s)\n",
                  common_name,
                  url.path,
                  e.message )
  exit 1
end

result = JSON.parse( res.body )
error = result['error']
if error
  $stderr.puts( error )
  exit 1
end

data = result['data]
File.open( certificate_path, File::WRONLY | File::CREAT | File::TRUNC ) { |out|
  out.print( data['certificate'] )
}
File.open( intermediate_path, File::WRONLY | File::CREAT | File::TRUNC ) { |out|
  out.print( data['ca_chain'] )
}
File.open( private_key_path, File::WRONLY | File::CREAT | File::TRUNC ) { |out|
  out.print( data['private_key'] )
}

