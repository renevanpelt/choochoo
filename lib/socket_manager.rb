# As long as the use of the framework is still dev-only we
# will only support pusher. We will spin up a free alternative
# that compares to the free tier of pusher.

class SocketManager

  attr_accessor :pusher

  def self.make
    if File.exist?("./config/pusher.yml")
      puts YAML.load(File.read('./config/pusher.yml')).inspect
      return Pusher::Client.new(YAML.load(File.read('./config/pusher.yml')).transform_keys(&:to_sym))
    else
      puts "Please configure your Pusher credentials in config/pusher.yml"
      return false
    end
  end

end

