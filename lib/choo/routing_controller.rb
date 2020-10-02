

# Every command inherits from BaseCommand. Might
# be expanded with CommandThatInitiatesMultipleEvents
# Bij wijze van spreken.
require 'sinatra/base'
module Choo
  class RoutingController < Sinatra::Base
    get '/' do
      "Hello world"
    end
     
  end
end