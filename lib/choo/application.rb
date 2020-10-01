module Choo
  class Application

    attr_accessor :resources


    def initialize

      self.resources = []


      # We load the user defined helper classes 
      # from ./lib in the application folder

      Dir.glob("./lib/*/") do |f|
        require f
      end



      # The folders in ./resources/ let the framework know 
      # about user defined resources (models)

      Dir.glob("./resources/*/") do |f|
        resource_name = f.split("/").last

        # Load the model file (AggregateRecord)

        require "./resources/#{resource_name}/#{resource_name.singularize}.rb"
        
        self.resources << resource_name.to_sym
        
        # Load the commands associated with this resource

        Dir.glob("./resources/#{resource_name}/commands/*.rb") do |command_file|
          require command_file
        end
        
        # Load the events associated with this resource
        
        Dir.glob("./resources/#{resource_name}/events/*.rb") do |event_file|
          require event_file
        end

      end




    end


    def render_template(view, locals = {}, layout= nil)
      locals = {application: self}.merge(locals)
      view =  Haml::Engine.new(open("#{view}.html.haml").read).render(Object.new,locals)
      if layout
        return Haml::Engine.new(open("#{layout}.html.haml").read).render(Object.new,{content: view}.merge(locals))
      else
        return view
      end
    end

  end
end
