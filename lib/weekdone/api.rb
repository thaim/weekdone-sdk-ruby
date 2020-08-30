# frozen_string_literal: true

require 'logger'
require 'time'

require 'oauth2'
require 'faraday'

class Weekdone::Api
  API_URL = 'https://api.weekdone.com'
  attr_reader :client
  attr_accessor :token_code, :loglevel

  def initialize(client_id, client_secret, loglevel: Logger::DEBUG)
    @logger = Logger.new(STDERR)
    @logger.level = loglevel

    @client = OAuth2::Client.new(
      client_id, client_secret,
      {
        site: 'https://weekdone.com',
        authorize_url: 'oauth_authorize',
        token_url: 'oauth_token',
        redirect_uri: 'http://localhost:8080/oauth2/callback'
      }
    )
  end

  def authenticate
    puts "open URL to authorize:"
    puts authorization_request

    print "\ninput authorization code: "
    auth_code = gets.chomp
    authorization_grant(auth_code)
  end

  def authorization_request
    @client.auth_code.authorize_url
  end

  def authorization_grant(auth_code)
    @token = client.auth_code.get_token(
      auth_code,
      redirect_uri: 'http://localhost:8080/oauth2/authorized'
    )

    @token_code = @token.token
  end

  def refresh
    @logger.debug("tokencode=#{@token_code} clientid=#{@client.id}")

    if @token.expired?
      @token = @token.refresh!
      @logger.info("refreshed token due to expire (new token expires at #{Time.at(@token.expires_at)}).")
    elsif
      @logger.debug("token is still valid (token expires at #{Time.at(@token.expires_at)}).")
    end

    @token_code = @token.token
  end

  def token_hash
    @token.to_hash
  end

  def token_hash=(hash)
    @logger.debug("update oauth token from hash=#{hash}")

    @token = OAuth2::AccessToken.from_hash(@client, hash)
    @token_code = @token.token
  end


  def searchForItems(user_id: nil, team_id: nil, period: nil)
    refresh

    params = { token: @token_code }
    params[:user_id] = user_id if not user_id.nil?
    params[:team_id] = team_id if not team_id.nil?
    params[:period] = period if not period.nil?

    response = Faraday.get(API_URL + '/1/items', params)
    JSON.parse(response.body)
  end

  def createItem
    raise NotImplementedError
  end

  def updateItem
    raise NotImplementedError
  end

  def assignItemToAnotherUser
    raise NotImplementedError
  end

  def deleteItem
    raise NotImplementedError
  end

  def getItemLikes(item_id)
    refresh

    params = { token: @token_code }

    response = Faraday.get(API_URL + "/1/item/#{item_id}/likes", params)
    JSON.parse(response.body)
  end

  def addItemLike
    raise NotImplementedError
  end

  def deleteItemLike
    raise NotImplementedError
  end

  def sortItems
    raise NotImplementedError
  end

  def getItemComments(item_id)
    refresh

    params = { token: @token_code }

    response = Faraday.get(API_URL + "/1/item/#{item_id}/comments", params)
    JSON.parse(response.body)
  end

  def addItemComment
    raise NotImplementedError
  end

  def deleteItemComment
    raise NotImplementedError
  end


  def getReport
    refresh

    params = { token: @token_code }

    response = Faraday.get(API_URL + '/1/report', params)
    JSON.parse(response.body)
  end


  def getAllTeams
    refresh

    params = { token: @token_code }

    response = Faraday.get(API_URL + '/1/teams', params)
    JSON.parse(response.body)
  end


  def getAllUsers
    refresh

    params = { token: @token_code }

    response = Faraday.get(API_URL + '/1/users', params)
    JSON.parse(response.body)
  end


  def getAllTypes
    refresh

    params = { token: @token_code }

    response = Faraday.get(API_URL + '/1/types', params)
    JSON.parse(response.body)
  end


  def getAllTags
    refresh

    params = { token: @token_code }

    response = Faraday.get(API_URL + '/1/tag', params)
    JSON.parse(response.body)
  end

  def getSingleTag(tag_id)
    refresh

    params = { token: @token_code }

    response = Faraday.get(API_URL + "/1/tag/#{tag_id}", params)
    JSON.parse(response.body)
  end

  def updateTagPriority
    raise NotImplementedError
  end

  def updateTagStatus
    raise NotImplementedError
  end


  def getAllObjectives(type: nil, departmentid: nil, teamid: nil, userid: nil, period: nil)
    refresh

    params = { token: @token_code }
    params[:type] = type if not type.nil?
    params[:department_id] = departmentid if not departmentid.nil?
    params[:team_id] = teamid if not teamid.nil?
    params[:user_id] = userid if not userid.nil?
    params[:period] = period if not period.nil?

    @logger.debug("params: #{params}")
    response = Faraday.get(API_URL + '/1/objective', params)
    JSON.parse(response.body)
  end

  def createNewObjective
    raise NotImplementedError
  end

  def updateObjective
    raise NotImplementedError
  end

  def deleteObjective
    raise NotImplementedError
  end

  def listObjectiveComments(objective_id)
    refresh

    params = { token: @token_code }

    response = Faraday.get(API_URL + "/1/objective/#{objective_id}/comments", params)
    JSON.parse(response.body)
  end

  def addObjectiveComment
    raise NotImplementedError
  end

  def updateObjectiveComment
    raise NotImplementedError
  end

  def deleteObjectiveComment
    raise NotImplementedError
  end

  def addObjectiveResult
    raise NotImplementedError
  end

  def updateObjectiveResult
    raise NotImplementedError
  end

  def deleteObjectiveResult
    raise NotImplementedError
  end


  def getCompanyInfo
    refresh

    params = { token: @token_code }

    response = Faraday.get(API_URL + '/1/company', params)
    JSON.parse(response.body)
  end
end
