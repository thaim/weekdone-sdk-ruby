# frozen_string_literal: true

require 'oauth2'
require 'faraday'

class Weekdone::Api
  API_URL = 'https://api.weekdone.com'
  attr_reader :client
  attr_accessor :token_code

  def initialize(client_id, client_secret)
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
    token_client = client.auth_code.get_token(
      auth_code,
      redirect_uri: 'http://localhost:8080/oauth2/authorized'
    )

    @token_code = token_client.token
  end

  def searchForItems(user_id: nil, team_id: nil, period: nil)
    params = { token: @token_code }
    if not user_id.nil?
      params[:user_id] = user_id
    end
    if not team_id.nil?
      params[:team_id] = team_id
    end
    if not period.nil?
      params[:period] = period
    end

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
    params = { token: @token_code }

    response = Faraday.get(API_URL + '/1/report', params)
    JSON.parse(response.body)
  end


  def getAllTeams
    params = { token: @token_code }

    response = Faraday.get(API_URL + '/1/teams', params)
    JSON.parse(response.body)
  end


  def getAllUsers
    params = { token: @token_code }

    response = Faraday.get(API_URL + '/1/users', params)
    JSON.parse(response.body)
  end


  def getAllTypes
    params = { token: @token_code }

    response = Faraday.get(API_URL + '/1/types', params)
    JSON.parse(response.body)
  end


  def getAllTags
    params = { token: @token_code }

    response = Faraday.get(API_URL + '/1/tag', params)
    # FIXME: fail to parse
    JSON.parse(response.body)
  end

  def getSingleTag(tag_id)
    params = { token: @token_code }

    response = Faraday.get(API_URL + "/1/tag/#{tag_id}", params)
    # FIXME: fail to parse
    JSON.parse(response.body)
  end

  def updateTagPriority
    raise NotImplementedError
  end

  def updateTagStatus
    raise NotImplementedError
  end


  def getAllObjectives(type: nil, department_id: nil, team_id: nil, user_id: nil, period: nil)
    params = { token: @token_code }
    if not type.nil?
      params[:type] = type
    end
    if not department_id.nil?
      params[:department_id] = department_id
    end
    if not team_id.nil?
      params[:team_id] = team_id
    end
    if not user_id.nil?
      params[:user_id] = user_id
    end
    if not period.nil?
      params[:period] = period
    end

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
    params = { token: @token_code }

    response = Faraday.get(API_URL + '/1/company', params)
    JSON.parse(response.body)
  end
end
