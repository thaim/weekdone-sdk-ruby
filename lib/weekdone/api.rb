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
    puts @client.auth_code.authorize_url

    print "\ninput authorization code: "
    auth_code = gets.chomp

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

  def getItemLikes
    raise NotImplementedError
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

  def getItemComments
    raise NotImplementedError
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
    raise NotImplementedError
  end


  def getAllUsers
    raise NotImplementedError
  end


  def getAllTypes
    raise NotImplementedError
  end


  def getAllTags
    raise NotImplementedError
  end

  def getSingleTag
    raise NotImplementedError
  end

  def updateTagPriority
    raise NotImplementedError
  end

  def updateTagStatus
    raise NotImplementedError
  end


  def getAllObjectives
    raise NotImplementedError
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

  def listObjectiveComments
    raise NotImplementedError
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
    raise NotImplementedError
  end
end
