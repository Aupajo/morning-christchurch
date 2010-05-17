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

__END__

@@gallery
%html
  %head
    %meta{ :charset => 'utf-8' }
    %title=options.title
    %link{ :href => '/stylesheet.css', :rel => 'stylesheet', :type => 'text/css', :charset => 'utf-8' }
  %body
    %h1=options.title
    -@pics.each do |pic|
      .pic
        .date=pic[:date].strftime('%a, %d %b %Y')
        -pic[:urls].each do |url|
          %img{ :src => url, :alt => pic[:tweet] }
        %p=pic[:tweet]
    #footer
      &mdash; Powered by <a href="http://twitter.com/danrandow">@danrandow</a>.

@@stylesheet
body
  font: 11pt/1.6em "Helvetica Neue", Helvetica, sans-serif
  color: #666
  margin: 2em auto
  width: 480px

h1
  font-size: 2em
  color: black

img
  margin: 1em 0

.pic, #footer
  border-top: 1px solid #ccc
  margin: 2em 0
  padding-top: 2em

#footer
  font-size: 0.8em
  text-align: right