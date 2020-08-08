RSpec.describe Weekdone do
  it 'initialize api client successfully' do
    client_id = ENV['WEEKDONE_CLIENT_ID']
    client_secret = ENV['WEEKDONE_CLIENT_SECRET']

    sut = Weekdone::Api.new(client_id, client_secret)

    expect(sut).not_to be nil
    expect(sut.token_client).to be nil
    expect(sut.token_code).to   be nil
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
      it 'search for items without search parameter' do
        items = @sut.searchForItems

        expect(items['status']).to eq('ok')
        expect(items['items'].length).to be >= 0
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
