require 'yaml'
module Choo
  class Application





    @@resources = {}


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
      
      @@resources[resource_name.to_sym] = {events: [], commands: []}
      
      # Load the commands associated with this resource

      Dir.glob("./resources/#{resource_name}/commands/*.rb") do |command_file|
        @@resources[resource_name.to_sym][:commands] << command_file[0...-3].split("/").last
        require command_file
      end
      
      # Load the events associated with this resource
      
      Dir.glob("./resources/#{resource_name}/events/*.rb") do |event_file|
        @@resources[resource_name.to_sym][:events] << event_file[0...-3].split("/").last
        require event_file
      end

    end

    def self.routes
      routes = YAML.load(File.open("./config/routes.yml"))['routes']
      returnvalue = []

      routes.each do |k,r|
        if r['get'].present?
          returnvalue << {method: 'get', response: r['response'], route: "/"}
        end
        if r['post'].present?
          returnvalue << {method: 'get', response: r['response'], route: "/"}
        end
      end

    end

    def self.resources
      @@resources
    end


    def self.render_template(view, locals = {}, layout= nil)
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
