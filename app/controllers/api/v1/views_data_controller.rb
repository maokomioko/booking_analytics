class Api::V1::ViewsDataController < Api::V1Controller
  require 'uri'
  require 'net/http'

  def get_views
    external_post(@api_prefix)
  end

  def get_rejections
    external_post(@api_prefix)
  end

  def get_destinations
    external_post(@api_prefix)
  end

  def get_sources
    external_post(@api_prefix)
  end

  private

  def base_scope(target_date, view_window, region)
    "date=#{target_date}&date_gap=#{view_window}&region=#{region}"
  end

  def select_sitename
    case name
    when 'booking'
      'booking_com'
    when 'expedia'
      'expedia_com'
    end
  end

  def select_provider(provider)
    case 'provider'
    when 'alexa'
      api_provider = 'alexa'
    when 'similar_web'
      api_provider = 'similar_web'
    end

    "&provider=#{api_provider}"
  end

  def external_post(params)
    uri = URI.parse('http://google.com')
    response = Net::HTTP.get(uri.host, params)
    raise response
  end
end

# API
# /v1/site_name

# Переменная base_scope
# date=2014-12-25
# date_gap=10
# region=cs

# date=2014-12-25&date_gap=30&region=cs

# Провайдер
# provider=alexa
# provider=similar_web

# Доп. параметры
# country_code=cs

# Просмотры страницы
# /get_views/
# /get_views/date=2014-12-25&date_gap=30&region=cs&provider=alexa

# Ответ:
# get_views
#  -> date, date_gap, views_count
#  -> timestamp (дата-время отправки ответа)

# Отказы, уход с сайта
# /get_rejections
# /get_rejections/date=2014-12-25&date_gap=30&region=cs&provider=alexa

# Ответ:
# get_rejections
#  -> date, date_gap, views_count,
#  -> rate (процент от 100%)
#  -> timestamp (дата-время отправки ответа)

# Популярные направления
# /get_destinations
# /get_destinations/date=2014-12-25&date_gap=30&region=cs&provider=alexa

# Ответ:
# get_destinations
#  -> date, date_gap, views_count
#  -> city (lowercase)
#  -> country_code (cs/en/uk…)
#  -> timestamp (дата-время отправки ответа)

# Источники просмотров
# /get_sources
# /get_sources/date=2014-12-25&date_gap=30&region=cs&provider=alexa

# Ответ:
# get_sources
#  -> date, date_gap, views_count
#  -> city (lowercase)
#  -> country_code (cs/en/uk…)
#  -> timestamp (дата-время отправки ответа)
