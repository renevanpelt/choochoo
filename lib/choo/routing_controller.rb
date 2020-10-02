

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
    Choo::Application.routes.each do |route|

      if route['get'].present?
        puts "asdfasdfasfd"
        get "/" do
          "Hello world"
        end
        
      elsif route["post"].present?

      end
    end

  end
end