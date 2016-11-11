require "fluent/input"
require "rest-client"
require "json"
require "oauth"

class Fluent::Magento2Input < Fluent::Input
  Fluent::Plugin.register_input("magento2", self)

  # To support log_level option implemented by Fluentd v0.10.43
  unless method_defined?(:log)
    define_method("log") { $log }
  end

  # Define `router` method of v0.12 to support v0.10 or earlier
  unless method_defined?(:router)
    define_method("router") { Fluent::Engine }
  end

  # Primary Magento2 parameters
  config_param :host,             :string, :default => 'localhost', :required => true
  config_param :protocol,         :string, :default => 'http'
  config_param :port,             :string, :default => '80'
  config_param :api_method,       :string, :default => 'orders'
  config_param :consumer_key,     :string, :default => nil, :required => true
  config_param :consumer_secret,  :string, :default => nil, :required => true
  config_param :token,            :string, :default => nil, :required => true
  config_param :token_secret,     :string, :default => nil, :required => true

  # Set how frequently messages should be sent.
  #
  # The default, `1`, means send a message every second.
  config_param :interval, :validate => :number, :default => 60

  def initialize
    super
  end

  def configure(conf)
    super

    @base_url = conf['protocol'] + '://' + conf['host'] + ':' + conf['port']
    @magento2_url = @base_url + '/rest/V1/' + conf['api_method'] + '?searchCriteria=*'
    log.debug 'magento2: sent data to ' + @magento2_url
    if conf['consumer_key'] != nil and conf['consumer_secret'] != nil and conf['token'] != nil and conf['token_secret'] != nil
      @consumer_key = conf['consumer_key']
      @consumer_secret = conf['consumer_secret']
      @token = conf['token']
      @token_secret = conf['token_secret']
    else
      raise 'magento2: please provide all required authentication parameters for this plugin to work'
    end

  end

  def start
    super

    @running = true
    @updated = Time.now
    @watcher = Thread.new(&method(:watch))
    @monitor = Thread.new(&method(:monitor))
    @mutex   = Mutex.new
  end

  def shutdown
    super
    @running = false
    @watcher.terminate
    @monitor.terminate
    @watcher.join
    @monitor.join
  end

  private

  # if watcher thread was not update timestamp in recent @interval * 2 sec., restarting it.
  def monitor
    log.debug "magento2: monitor thread starting"
    while @running
      sleep @interval / 2
      @mutex.synchronize do
        now = Time.now
        number = @updated < now - @interval * 2
        log.debug "magento2: last updated at #{@updated} with number #{number}"
        if @updated < now - @interval * 2
          log.warn "magento2: watcher thread is not working after #{@updated}. Restarting..."
          @watcher.kill
          @updated = now
          @watcher = Thread.new(&method(:watch))
        end
      end
    end
  end

  def watch
    if @delayed_start
      delay = rand() * @interval
      log.debug "magento2: delay at start #{delay} sec"
      sleep delay
    end

    output

    started = Time.now
    while @running
      now = Time.now
      sleep 1
      if now - started >= @interval
        output
        started = now
        @mutex.synchronize do
          @updated = Time.now
        end
      end
    end
  end

  def output
    begin
      log.debug "magento2: try to get the data"

      @consumer = OAuth::Consumer.new(@consumer_key, @consumer_secret, {:site=>@base_url})
      accesstoken = OAuth::AccessToken.new(@consumer, @token, @token_secret)

      RestClient.add_before_execution_proc do |req, params|
        accesstoken.sign! req
      end

      # Create POST request
      response = RestClient.get @magento2_url
      log.debug "\nmagento2: response code is " + response.code.to_s + "\n"
      log.debug "\nmagento2: response headers are " + response.headers.to_s + "\n"

      report = JSON.parse(response.body.to_s)
      log.debug "magento2: #{report.length} items."

      report["items"].each do |item|
        timestamp = DateTime.parse(item["updated_at"]).to_time.to_i
        item["store_name"] = item["store_name"].gsub!("/\\n/", " ")

        router.emit("magento2", timestamp, item)
      end

    rescue => err
      log.fatal("magento2: caught exception; exiting")
      log.fatal(err)
    end
  end
  
end
