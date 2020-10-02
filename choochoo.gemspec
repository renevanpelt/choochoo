Gem::Specification.new do |s|
  s.name = %q{choochoo}
  s.author = "Rene van pelt"
  s.version = "0.0.0"
  s.date = %q{2020-09-30}
  s.summary = %q{choochoo - web application framework using CQRS and event sourcing}
  s.files = [
    "views/admin/layout.html.haml",
    "views/admin/home.html.haml",
    "views/admin/resource.html.haml",
    "lib/choo.rb",
    "lib/choo/aggregate.rb",
    "lib/choo/application.rb",
    "lib/choo/base_command.rb",
    "lib/choo/routing_controller.rb",
    "lib/choo/base_event.rb",
    "lib/choo/socket_manager.rb",
    "lib/choo/event.rb",
    "lib/choo/repository.rb",
    "lib/choo/resource.rb",
  ]
  s.executables   = ["choo"]

  s.add_dependency "activerecord"
  s.add_dependency "colorize"
  s.add_dependency "fileutils"
  s.add_dependency "rack"
  s.add_dependency "rerun"


end