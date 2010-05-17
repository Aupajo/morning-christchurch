require 'sinatra'
require 'twitter'

set :title, 'Morning, Christchurch'

get '/' do
  tweets = Twitter::Search.new('morning from:danrandow').fetch.results
  @pics = tweets.map do |t|
    photo_urls = t.text.match(/http:\/\/yfrog\.com\/[a-z0-9]+/).to_a
    next if photo_urls.empty?
    {
      :urls => photo_urls.map { |url| url << ':iphone' }, # to retreive yFrog iPhone-sized photos
      :date => DateTime.parse(t.created_at),
      :tweet => t.text
    }
  end.compact
  haml :gallery
end

get '/stylesheet.css' do
  content_type :css
  sass :stylesheet
end
