require 'sinatra'

set :environment, :production
disable :run

enable :inline_templates

require 'haml'
require 'server'

run Sinatra::Application