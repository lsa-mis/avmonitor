class ConnectSocketJob
  include Sidekiq::Job
  require 'typhoeus'

  def perform(facility_id, tport)
    p "Connect to socket for #{facility_id} - [#{tport}]"
    Typhoeus.get("http://localhost:#{tport}/")
  end

end
