class ParksController < ApplicationController
  Park = Struct.new(:picture_url, :name, :latitude, :longitude)
  PLACES_API_KEY = 'AIzaSyC5Qklw5Cwn2LGmoyzbhRFUA2gX7WZHMHo'
  WEATHER_API_KEY = 'c9cf5712b2bc1e8c386dc830a39522b1'

  def nearby
    lat = params[:latitude]
    lon = params[:longitude]

    result = get_parkList(lat, lon)

    render json: result
  end

  def get_parkList(lat, lon)
    parksOptions = get_parks(lat, lon)
    weatherResult = get_weather(lat, lon)

    return filter_parks_by_weather(parksOptions, weatherResult) #weather not good, so return nothing
  end

  def filter_parks_by_weather(parksOptions, weatherResult)
    if isWeatherGood?(weatherResult["weather"])
      # binding.pry
      return format_parkListItems(parksOptions)
    end

    return []
  end

  def isWeatherGood?(weatherConditions)
    # http://openweathermap.org/weather-conditions
    weatherConditions.each do |weatherStatus|
      if isGoodCondition?(weatherStatus['id'])
        return true
      end
    end
    return false
  end

  def isGoodCondition?(condition)
    return (800..802).member?(condition) || (951..953).member?(condition)
  end

  def format_parkListItems(unformatted_parks)
    # render array of rendered parkListItems
    # [
    # {
    #     picture_url: "http://something.com/image.jpg",
    #     name: "park name",
    #     latitude: 49.1,
    #     longitude: 120.1
    # }
    # ]

    formatted = unformatted_parks.map do |unformatted_park|
      Park.new(
          unformatted_park.icon,
          unformatted_park.name,
          unformatted_park.lat,
          unformatted_park.lng
      )
    end

    # Park.new(
    #     picture_url: unformatted_park.icon,
    #     name: unformatted_park.name,
    #     latitude: unformatted_park.lat,
    #     longitude: unformatted_park.lng
    # )

    return formatted

  end

  def get_parks(latitude, longitude)
    @client = GooglePlaces::Client.new(PLACES_API_KEY)
    @client.spots(latitude, longitude, :types => 'park')

  end

  def get_weather(latitude, longitude)
    require 'open_weather'
    options = {units: "metric", APPID: WEATHER_API_KEY}
    # binding.pry
    OpenWeather::Current.geocode(latitude, longitude, options)

  end
end

# make a parkListItem struct
#includes picture, name, lat, long
#json representation