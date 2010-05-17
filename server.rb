require 'sinatra'
require 'twitter'

set :title, 'Morning, Christchurch'

helpers do
  def fetch_pics
    tweets = Twitter::Search.new('morning OR christchurch from:danrandow').fetch.results
    tweets.map do |t|
      photo_urls = t.text.match(/http:\/\/yfrog\.com\/[a-z0-9]+/).to_a
      next if photo_urls.empty?
      {
        :urls => photo_urls.map { |url| url << ':iphone' }, # to retreive yFrog iPhone-sized photos
        :date => DateTime.parse(t.created_at),
        :tweet => t.text
      }
    end.compact
  end
  
  def site_url
    "#{request.scheme}://#{request.host}/"
  end
  
  def xmlschema_time(time)
    time.strftime('%Y-%m-%dT%H:%M:%S%z')
  end
end

get '/' do
  @pics = fetch_pics
  haml :gallery
end

get '/feed.xml' do
  @pics = fetch_pics
  erb :feed
end

get '/stylesheet.css' do
  content_type :css
  sass :stylesheet
end
