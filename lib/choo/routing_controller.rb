

# Every command inherits from BaseCommand. Might
# be expanded with CommandThatInitiatesMultipleEvents
# Bij wijze van spreken.
require 'sinatra/base'

module Choo
  class RoutingController < Sinatra::Base
    Choo::Application.routes.each do |route|

      if route[:method] == "GET"
        get route[:path] do
          route[:value]
        end
      elsif route[:method] == "POST"
      end
    end

  end
end