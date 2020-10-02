

# Every command inherits from BaseCommand. Might
# be expanded with CommandThatInitiatesMultipleEvents
# Bij wijze van spreken.
require 'sinatra/base'

module Choo
  class RoutingController < Sinatra::Base
    
    Choo::Application.routes.each do |route|
      if routes[:method] == 'get'

        get routes[:route] do
          "Hello world"
        end
        
      elsif routes[:method] == 'post'

      end
    end

  end
end