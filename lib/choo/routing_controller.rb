

# Every command inherits from BaseCommand. Might
# be expanded with CommandThatInitiatesMultipleEvents
# Bij wijze van spreken.
require 'sinatra/base'

module Choo
  class RoutingController < Sinatra::Base
         get "/a" do
          "Hello adsworld"
        end
    puts "!!!!!!!!!!!!!!"
    puts "!!!!!!!!!!!!!!"
    puts "!!!!!!!!!!!!!!"
    puts "!!!!!!!!!!!!!!"
    puts "!!!!!!!!!!!!!!"
    puts "!!!!!!!!!!!!!!"
    puts "!!!!!!!!!!!!!!"
    puts Choo::Application.routes.inspect
    puts Choo::Application.routes.inspect
    puts Choo::Application.routes.inspect
    puts Choo::Application.routes.inspect
    Choo::Application.routes.each do |path, route|

      if route['get'].present?
        puts "asdfasdfasfd"
        get "/" do
          route["response"]
        end
        
      elsif route["post"].present?

      end
    end

  end
end