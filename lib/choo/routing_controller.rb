

# Every command inherits from BaseCommand. Might
# be expanded with CommandThatInitiatesMultipleEvents
# Bij wijze van spreken.
require 'sinatra/base'
require 'yaml'
module Choo
  class RoutingController < Sinatra::Base
    get '/' do
      "Hello world"
    end
    routes = Yaml
    
    Choo::Application.routes.each do |route|
      if routes[:method] == 'get'

      elsif routes[:method] == 'post'

      end
    end

  end
end