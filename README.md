# fluent-plugin-magento2, a plugin for [Fluentd](http://fluentd.org)

## Overview

***Magento2*** input plugin.

Get data from Magento2 to fluentd.

* Get metrics from Magento2 REST API.
* Interval is 300(default. config=interval) seconds

## Configuration

```config
<source>
    @type magento2
    interval 300
    host magento2.bluefactory.nl
    protocol https
    port 443
    api_method orders
    consumer_key dvi9jfsdsdxstg4oyx6qgt0p6l8dsfsdsj556
    consumer_secret c37d24cgrjw1mhw357knrt98ikcskhhy
    token qnibi3fc34dc8vp3xn3fwv5dxyyn6d7t
    token_secret vbs7urh2ct2s1n8ake5fqh1573w9kvmv
</source>
```

## config: interval

Set how frequently data should be retrieved. The default, `1`, means send a message every second.

## config: host

The host where the Magento2 REST API is running.

## config: protocol

The protocol on which the Magento2 REST API is listening. If you are going to use HTTPS make sure you use a signed certificate.

## config: port

The port on which the Magento2 API is listening.

## config: api_method

The API method to call. For more info check [Magento2 API docs] (http://devdocs.magento.com/swagger/index_20.html).

## config: consumer_key

The key that needs to created for each consumer of the API.

## config: consumer_secret

The secret key that is coupled with the key for the consumer.

## config: token

The access token for the Magento2 REST API.

## config: token_secret

The secret that is coupled with the token.

## ChangeLog

See [CHANGELOG](CHANGELOG.md) for details.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

Copyright (c) 2016 Coen Meerbeek. See [LICENSE](LICENSE) for details.
