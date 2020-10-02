

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

      if routes['method'] == 'get'
        puts "asdfasdfasfd"
        get "/" do
          "Hello world"
        end
        
      elsif routes[:method] == 'post'

      end
    end

  end
end