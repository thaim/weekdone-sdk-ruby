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
        items = @sut.searchForItems

        expect(items['status']).to eq('ok')
        expect(items['items'].length).to be >= 0
        items['items'].each do |item|
          expect(item['id']).to be >= 0
          expect(item['inserted']).to match(/\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z\z/)
          expect(item['description']).to be_a_kind_of(String)
          expect(item['likecount']).to be >= 0
          expect(item['commentcount']).to be >= 0
          expect(item['type_id']).to be >= 0
          expect(item['team_id']).to be >= 0
          expect(item['user_id']).to be >= 0
          expect(item['priority']).to be >= 0
          # expect(item['from_id']).to be >= 0 | nil
          expect(item['source']).to be >= 0
          expect(item['due_on']).to match(/\A\d{4}-\d{2}-\d{2}\z/).or be nil
        end
      end

      it 'search with user_id' do
        items = @sut.searchForItems(user_id: 'me')

        expect(items['status']).to eq('ok')
        expect(items['items'].length).to be >= 0
        items['items'].each do |item|
          if @me.nil?
            @me = item['user_id']
          end

          expect(item['user_id']).to eq @me
        end
      end

      it 'search with team_id' do
        my_team_id = ENV['WEEKDONE_TEAM_ID']
        items = @sut.searchForItems(team_id: my_team_id)

        expect(items['status']).to eq('ok')
        expect(items['items'].length).to be >= 0
        items['items'].each do |item|
          if @us.nil?
            @us = item['team_id']
          end

          expect(item['team_id']).to eq @us
        end
      end

      it 'search with period' do
        period = 10
        items = @sut.searchForItems(period: period)

        expect(items['status']).to eq('ok')
        expect(items['items'].length).to be >= 0
        items['items'].each do |item|
          if @us.nil?
            @us = item['team_id']
          end

          expect(item['team_id']).to eq @us
        end
      end
    end

    describe '#getReport' do
      it 'get report' do
        report = @sut.getReport

        expect(report['status']).to eq('ok')
        expect(report['period']).not_to be nil
        expect(report['report'].length).to be >= 0
      end
    end
  end
end
