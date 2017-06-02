class Racer
  def self.mongo_client
    #mdb = 'mongodb://localhost:27017'
    @@client = Mongoid::Clients.default
  end
  def self.collection
    @@client['racers']
  end
end
