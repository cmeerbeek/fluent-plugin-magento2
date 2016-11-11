require 'helper'

class Magento2InputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  ### for GA
  CONFIG_GA = %[
    tag magento2
    interval 300
    host magento2.bluefactory.nl
    protocol https
    port 443
    consumer_key dvi9jfsdsdxstg4oyx6qgt0p6l8dsfsdsj556
    consumer_secret c37d24cgrjw1mhw357knrt98ikcskhhy
    token qnibi3fc34dc8vp3xn3fwv5dxyyn6d7t
    token_secret vbs7urh2ct2s1n8ake5fqh1573w9kvmv
  ]

  def create_driver_magento2(conf = CONFIG_GA)
    Fluent::Test::InputTestDriver.new(Fluent::Magento2Input).configure(conf)
  end

  def test_configure_magento2
    d = create_driver_magento2
    assert_equal 'magento2', d.instance.tag
    assert_equal '300', d.instance.interval
    assert_equal 'magento2.bluefactory.nl', d.instance.host
    assert_equal 'https', d.instance.protocol
    assert_equal '443', d.instance.port
  end

end
