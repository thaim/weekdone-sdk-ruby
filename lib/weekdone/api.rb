# frozen_string_literal: true

require 'oauth2'

class Weekdone::Api
  attr_reader :token_client, :token_code

  def initialize(client_id, client_secret)
    client = OAuth2::Client.new(
      client_id, client_secret,
      {
        site: 'https://weekdone.com',
        authorize_url: 'oauth_authorize',
        token_url: 'oauth_token',
        redirect_uri: 'http://localhost:8080/oauth2/callback'
      }
    )
    puts "open URL to authorize:"
    puts client.auth_code.authorize_url

    print "\ninput authorization code: "
    auth_code = gets.chomp

    token_client = client.auth_code.get_token(
      auth_code,
      redirect_uri: 'http://localhost:8080/oauth2/authorized'
    )

    token_code = token_client.token
  end

  def listItems
    response = token_client.get(
      '/1/items'
    )

    response.body
  end
end
