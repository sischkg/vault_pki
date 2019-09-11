# VaultPki

## Installation

    $ gem install vault_pki-0.1.0.gem

## Usage

```console
$ vault login
$ vault-pki \
   --name www.example.com \
   --address https://vault.example.com:8200 \
   --role example-com \
   --ttl 86400 \
   --certificate www.example.com.cert.pem \
   --intermediate chain.pem \
   --private www.example.com.priv.pem
```

The abeve command is equivalent to following.

```
$ vault login
$ vault write pki/issue/example-com common_name=www.example.com ttl=86400
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the VaultPKI project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/sischkg/vault_pki/blob/master/CODE_OF_CONDUCT.md).
