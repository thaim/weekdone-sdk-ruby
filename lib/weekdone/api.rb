# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'

class Weekdone::Api
  def initialize()
    @connection =
      Faraday.new(url: "https://api.weekdone.com") do |builder|
        builder.request :url_encoded
        builder.request :multipart
        builder.adapter :net_http
      end

    yield(@connection) if block_given?
  end
end
