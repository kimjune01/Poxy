require 'rails_helper'

RSpec.describe ParksController, type: :controller do

  describe "GET #nearby" do
    it "returns http success" do
      get :nearby
      expect(response).to have_http_status(:success)
    end
  end

  describe ParksController do
    it "weather should be good if sunny" do
      weatherConditions = [{"id" => 800, "main" => "Clear", "description" => "clear sky", "icon" => "01d"}]
      expect(controller.isWeatherGood?(weatherConditions)).to be true
    end

    it 'gets some parks with good weather in a list' do
      parkOptions = [OpenStruct.new(
          icon: "https://maps.gstatic.com/mapfiles/place_api/icons/generic_recreational-71.png",
          lat: 49.2735645,
          lng: -122.9091102,
          name: "Burnaby Mountain Biking and Hiking Trails")]

      weatherConditions = {"weather" => [{"id" => 800, "main" => "Clear", "description" => "clear sky", "icon" => "01d"}]}
      parksList = controller.filter_parks_by_weather(parkOptions, weatherConditions)

      expect(parksList.size).to be > 0

    end

    it 'gets no parks with bad weather in a list' do
      parkOptions = [OpenStruct.new(
          icon: "https://maps.gstatic.com/mapfiles/place_api/icons/generic_recreational-71.png",
          lat: 49.2735645,
          lng: -122.9091102,
          name: "Burnaby Mountain Biking and Hiking Trails")]

      # weatherConditions = {"weather"=>[{"id"=>803, "main"=>"Clear", "description"=>"clear sky", "icon"=>"01d"}]}
      weatherConditions = {"weather" => [{"id" => 803, "main" => "Clouds", "description" => "broken clouds", "icon" => "04n"}]}
      parksList = controller.filter_parks_by_weather(parkOptions, weatherConditions)

      # expect(parksList.size).to be > 0
      expect(parksList.size).to be 0
    end
  end

end
