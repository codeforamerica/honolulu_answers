
When(/^I pull up the Honolulu Answers application$/) do
  @error = nil
  begin
    url = ENV["HONOURL"]
    @response = Net::HTTP.get_response(URI.parse(url).host, URI.parse(url).path)
  rescue Exception => e
    @error = e
  end
end

Then(/^I should get data back$/) do
    expect(@failure).to eq(nil), "An error occured when trying to open the application: #{@failure}"
    expect(@response.code).to eql("200"), "Non 200 code returned"
    expect(@response.body.length).to be > 0, "No data receieved"
end