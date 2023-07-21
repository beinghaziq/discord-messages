# frozen_string_literal: true

require 'httparty'
require_relative 'response_formatter'

module Discord
  # Base class for API Wrapper for Discord APIs.
  class Base
    attr_reader :url, :body

    def initialize(url: nil, body: {}, args: {})
      # convert all passed arguments into instance variables
      args.each { |name, value| instance_variable_set("@#{name}", value) }
      @url = url || request_url
      @body = body || payload
    end

    protected

    def request(method: :get, headers: default_headers, timeout: 7, query: {})
      response = HTTParty.send(method, url, body: body, headers: headers, query: query,
                                            timeout: timeout)
      ResponseFormatter.new(response: response)
    end

    # to substitiute arguments in url e.g. :channel_id with excat value
    def substitute_url_args(url, args)
      result_url = url.dup
      args.each do |key, value|
        raise ArgumentError, 'cannot use blank key' if key.nil?
        raise ArgumentError, "#{key} is blank" if value.nil?

        result_url.sub!(%r{:#{key}(?=/|$)}, value)
      end

      result_url
    end

    def path
      self.class::PATH
    end

    def payload
      {}
    end

    def default_headers
      {
        'accept-language' => 'en-US,en;q=0.9,it;q=0.8,de;q=0.7,es;q=0.6,pt;q=0.5',
        'authorization' => @user_authentication_token,
        'sec-ch-ua-platform' => 'macOS',
        'user-agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko)'\
        ' Chrome/103.0.0.0 Safari/537.36',
        'x-discord-locale' => 'en-US',
        'Cookie' => '__dcfduid=49abb8400f0015eda5e6a635b2344b6a; '\
        '__sdcfduid=494bb8400f0011eda5e6a635b2344b6a298b870d23dc4dc4dc2ed47448ff82791438eca9542b8ddd0aec833c93404851'
      }
    end

    def request_url
      "#{ENV['DISCORD_BASE_DOMAIN']}/api/v9/#{path}"
    end
  end
end
