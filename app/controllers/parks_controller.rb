class ParksController < ApplicationController
  Park = Struct.new(:picture_url, :name, :id, :latitude, :longitude, :photo_references)
  PLACES_API_KEY = 'AIzaSyC5Qklw5Cwn2LGmoyzbhRFUA2gX7WZHMHo'
  WEATHER_API_KEY = 'c9cf5712b2bc1e8c386dc830a39522b1'

  def nearby
    lat = params[:latitude]
    lon = params[:longitude]
    if (!lat || !lon)
      render :json => {error: "Invalid coordinates"}, :status => :bad_request
    else
      result = get_parkList(lat, lon)
      render json: result
    end
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
    return (800..804).member?(condition) || (951..953).member?(condition)
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
    parks = unformatted_parks
    photo_ref = parks.map do |park|
      park.photos.map do |photo|
        photo.photo_reference
      end
    end

    formatted = unformatted_parks.map do |unformatted_park|

      Park.new(
          unformatted_park.icon,
          unformatted_park.name,
          unformatted_park.id,
          unformatted_park.lat,
          unformatted_park.lng,
          getImageURL(photo_ref[0])
      )
    end

    puts formatted
    return formatted

  end

  def get_parks(latitude, longitude)
    @client = GooglePlaces::Client.new(PLACES_API_KEY)
    parks = @client.spots(latitude, longitude, :types => 'park')
    puts(parks.length.to_s + " parks nearby")
    return parks
  end

  def get_weather(latitude, longitude)
    require 'open_weather'
    options = {units: "metric", APPID: WEATHER_API_KEY}
    # binding.pry
    weather = OpenWeather::Current.geocode(latitude, longitude, options)
    puts("Weather is " + weather["weather"].to_s)
    return weather
  end

  def getImageURL(photoref)
    BLANKPHOTOREQUEST = 'https://maps.googleapis.com/maps/api/place/photo?'
    dimensions= 'maxwidth=1280&maxheight=1920'
    url = BLANKPHOTOREQUEST + dimensions + photoref + PLACES_API_KEY

    return url
  end
end

# make a parkListItem struct
#includes picture, name, lat, long
#json representation