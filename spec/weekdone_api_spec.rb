RSpec.describe Weekdone do
  it 'initialize api client successfully' do
    client_id = ENV['WEEKDONE_CLIENT_ID']
    client_secret = ENV['WEEKDONE_CLIENT_SECRET']

    sut = Weekdone::Api.new(client_id, client_secret)

    expect(sut).not_to be nil
    expect(sut.token_code).to be nil
  end


  describe '#authenticate' do
  end


  context 'with valid auth code' do
    before(:all) do
      client_id = ENV['WEEKDONE_CLIENT_ID']
      client_secret = ENV['WEEKDONE_CLIENT_SECRET']

      @sut = Weekdone::Api.new(client_id, client_secret)
      @sut.authenticate
    end

    describe '#searchForItems' do
      it 'search without any parameter' do
        res = @sut.searchForItems

        expect(res['status']).to eq('ok')
        expect(res['items'].length).to be >= 0
        res['items'].each do |item|
          expect(item['id']).to be >= 0
          expect(item['inserted']).to match(/\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z\z/)
          expect(item['description']).to be_a_kind_of(String)
          expect(item['likecount']).to be >= 0
          expect(item['commentcount']).to be >= 0
          expect(item['type_id']).to be >= 0
          expect(item['team_id']).to be >= 0
          expect(item['user_id']).to be >= 0
          expect(item['priority']).to be >= 0
          if not item['from_id'].nil?
            expect(item['from_id']).to be >= 0
          end
          expect(item['source']).to be >= 0
          expect(item['due_on']).to match(/\A\d{4}-\d{2}-\d{2}\z/).or be nil
        end
      end

      it 'search with user_id' do
        res = @sut.searchForItems(user_id: 'me')

        expect(res['status']).to eq('ok')
        expect(res['items'].length).to be >= 0
        res['items'].each do |item|
          if @me.nil?
            @me = res['user_id']
          end

          expect(res['user_id']).to eq @me
        end
      end

      it 'search with team_id' do
        my_team_id = ENV['WEEKDONE_TEAM_ID']
        res = @sut.searchForItems(team_id: my_team_id)

        expect(res['status']).to eq('ok')
        expect(res['items'].length).to be >= 0
        res['items'].each do |item|
          if @us.nil?
            @us = item['team_id']
          end

          expect(item['team_id']).to eq @us
        end
      end

      it 'search with period' do
        period = 10
        res = @sut.searchForItems(period: period)

        expect(res['status']).to eq('ok')
        expect(res['items'].length).to be >= 0
        res['items'].each do |item|
          if @us.nil?
            @us = item['team_id']
          end

          expect(item['team_id']).to eq @us
        end
      end
    end

    describe '#getItemLikes' do
      it 'get likes with item_id' do
        item_id = ENV['WEEKDONE_ITEM_ID']
        res = @sut.getItemLikes(item_id)

        expect(res['status']).to eq('ok')
        expect(res['likes'].length).to be >= 0
      end
    end

    describe '#getItemComments' do
      it 'get comments', skip: true do
        item_id = ENV['WEEKDONE_ITEM_ID_WITH_COMMENT']
        res = @sut.getItemComments(item_id)

        expect(res['status']).to eq('ok')
        # fail to get comment
        # expect(res['comments'].length).to be >= 0
      end

      it 'get comments from item without comment' do
        item_id = ENV['WEEKDONE_ITEM_ID_WITHOUT_COMMENT']
        res = @sut.getItemComments(item_id)

        expect(res['status']).to eq('ok')
        expect(res['comments']).to be_nil
      end
    end

    describe '#getReport' do
      it 'get report' do
        res = @sut.getReport

        expect(res['status']).to eq('ok')
        expect(res['period']).not_to be nil
        expect(res['report'].length).to be >= 0
      end
    end

    describe '#getAllTeams' do
      it 'get all teams' do
        res = @sut.getAllTeams

        expect(res['status']).to eq('ok')
        expect(res['teams'].length).to be >= 0
      end
    end

    describe '#getAllUsers' do
      it 'get all users' do
        res = @sut.getAllUsers

        expect(res['status']).to eq('ok')
        expect(res['users'].length).to be >= 0
      end
    end

    describe '#getAllTypes' do
      it 'get all types' do
        res = @sut.getAllTypes

        expect(res['status']).to eq('ok')
        expect(res['same_template']).to be_truthy | be_falsey
        expect(res['types'].length).to be >= 0
      end
    end

    describe '#getAllTags' do
      it 'get all tags', skip: true do
        res = @sut.getAllTags

        expect(res['status']).to eq('ok')
        expect(res['tags'].length).to be >= 0
      end
    end

    describe '#getSingleTag' do
      it 'get single tag', skip: true do
        res = @sut.getSingleTag(0)

        expect(res['status']).to eq('ok')
        expect(res['tag']['id']).to be 0
        expect(res['tag']['tag']).to be_a_kind_of(String)
        expect(res['tag']['status']['status']).to be_a_kind_of(String)
        expect(res['tag']['status']['updated']).to be_a_kind_of(String)
        expect(res['tag']['status']['user_id']).to be > 0
      end
    end

    describe '#getAllObjectives' do
      it 'get all objectives without params' do
        res = @sut.getAllObjectives

        expect(res['status']).to eq('ok')
        expect(res['data'].length).to be >= 0
      end
    end

    describe '#listObjectiveComments' do
      it 'list objective comments' do
        res = @sut.listObjectiveComments(0)

        expect(res['status']).to eq('ok')
      end
    end

    describe '#getCompanyInfo' do
      it 'get company info' do
        res = @sut.getCompanyInfo

        expect(res['status']).to eq('ok')
        expect(res['data']['same_schedule']).to be_truthy | be_falsey
        expect(res['data']['same_template']).to be_truthy | be_falsey
        if not res['data']['external_emails'].nil?
          expect(res['data']['external_emails']).to be_a_kind_of(String)
        end
        expect(res['data']['company_objectives']).to be_truthy | be_falsey
        expect(res['data']['team_objectives']).to be_truthy | be_falsey
        expect(res['data']['user_objectives']).to be_truthy | be_falsey
        expect(res['data']['reportsdue_day']).to  be_between(0, 6)
        expect(res['data']['reportsdue_hour']).to be_between(0, 23)
        expect(res['data']['reportreminder_day']).to  be_between(1, 31)
        expect(res['data']['reportreminder_hour']).to be_between(0, 23)
        expect(res['data']['timezone']).to be_a_kind_of(String)
      end
    end
  end
end
