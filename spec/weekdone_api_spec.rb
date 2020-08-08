RSpec.describe Weekdone do
  it 'initialize api client successfully' do
    client_id = ENV['WEEKDONE_CLIENT_ID']
    client_secret = ENV['WEEKDONE_CLIENT_SECRET']

    sut = Weekdone::Api.new(client_id, client_secret)

    expect(sut.token_client).to_not be nil
    expect(sut.token_code).to_not   be nil
  end
end
