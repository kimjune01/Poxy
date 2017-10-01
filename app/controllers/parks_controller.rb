class ParksController < ApplicationController
  Park = Struct.new(:picture_url, :name, :id, :latitude, :longitude, :wind, :temp, :cloud)
  PLACES_API_KEY = 'AIzaSyC5Qklw5Cwn2LGmoyzbhRFUA2gX7WZHMHo'
  WEATHER_API_KEY = 'c9cf5712b2bc1e8c386dc830a39522b1'
  BLANK_PHOTO_REQUEST = 'https://maps.googleapis.com/maps/api/place/photo?'

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

    return filter_parks_by_weather(parksOptions, weatherResult)
  end

  def filter_parks_by_weather(parksOptions, weatherResult)
    if isWeatherGood?(weatherResult)
      return format_park_list(parksOptions, weatherResult)
    end
    return []  #weather not good, so return nothing
  end

  def isWeatherGood?(weatherResult)
      return isGoodCondition?(weatherConditions["weather"][0]['id'])
  end

  # http://openweathermap.org/weather-conditions
  def isGoodCondition?(condition)
    return (800..804).member?(condition) || (951..953).member?(condition)
  end

  def format_park_list(raw_parks, weather_result)

    # photo ref needs to call Google to get its url.
    photo_references = raw_parks.map do |each_park|
      each_park.photos.map do |each_photo|
        each_photo.photo_reference
      end
    end

    park_photo_zip = raw_parks.zip(photo_references)

    # render array of rendered parkListItems
    puts "weather result: " + weather_result.to_s
    return park_photo_zip.map do |each_raw_park, each_photo_ref|
      Park.new(
        # each photo ref may have many URLs associated with it
          getImageURL(each_photo_ref[0]),
          each_raw_park.name,
          each_raw_park.id,
          each_raw_park.lat,
          each_raw_park.lng,
          interpret_wind(weather_result['wind']),
          interpret_temp(weather_result['main']),
          interpret_cloud(weather_result['clouds']),
          )
    end
  end

  def interpret_wind(raw_wind)
    speed = raw_wind['speed'] # metric. m/s
    if speed < 1
      'Calm'
    elsif speed < 5
      'Light Air'
    elsif speed < 11
      'Light Breeze'
    elsif speed < 19
      'Gentle Breeze'
    elsif speed < 28
      'Moderate Breeze'
    elsif speed < 38
      'Fresh Breeze'
    elsif speed < 49
      'Strong Breeze'
    elsif speed < 61
      'High wind'
    elsif speed < 74
      'Fresh gale'
    elsif speed < 88
      'Strong gale'
    elsif speed < 102
      'Storm'
    elsif speed < 117
      'Violent storm'
    else
      'Hurricane'
    end
  end
  def interpret_temp(raw_main)
    return raw_main['temp']
  end
  def interpret_cloud(raw_clouds)
    cloud = raw_clouds['all']
    if cloud < 10
      'Clear'
    elsif cloud < 30
      'Scattered'
    elsif cloud < 50
      'Scattered'
    elsif cloud < 90
      'Broken'
    elsif cloud < 100      
      'Overcast'
    end
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
    weather = OpenWeather::Current.geocode(latitude, longitude, options)
    return weather
  end

  def getImageURL(photoref)
    dimensions= 'maxwidth=1280&maxheight=1920'
    url = ""
    if !photoref.nil?
      url = BLANK_PHOTO_REQUEST + dimensions + "&photoreference="+ photoref + "&key=" + PLACES_API_KEY
    end

    return url
  end
end

# make a parkListItem struct
#includes picture, name, lat, long
#json representation