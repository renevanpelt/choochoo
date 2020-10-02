

# Every command inherits from BaseCommand. Might
# be expanded with CommandThatInitiatesMultipleEvents
# Bij wijze van spreken.
require 'sinatra/base'

module Choo
  class RoutingController < Sinatra::Base
    get '/' do
      "Hello world"
    end
    
    
    Choo::Application.routes.each do |route|
      if routes[:method] == 'get'
        
      elsif routes[:method] == 'post'

      end
    end

  end
end