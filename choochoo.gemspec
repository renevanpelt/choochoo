Gem::Specification.new do |s|
  s.name = %q{choochoo}
  s.author = "Rene van pelt"
  s.version = "0.0.0"
  s.date = %q{2020-09-30}
  s.summary = %q{choochoo - web application framework using CQRS and event sourcing}
  s.files = [
    "lib/choochoo.rb"
  ]
  s.executables   = ["choo"]

  s.add_dependency "activerecord"
  s.add_dependency "colorize"
  s.add_dependency "fileutils"


end