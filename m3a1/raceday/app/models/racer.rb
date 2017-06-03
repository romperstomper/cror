class Racer
  def self.mongo_client
    #mdb = 'mongodb://localhost:27017'
    @@client = Mongoid::Clients.default
  end
  def self.collection
    mongo_client['racers']
  end
  def self.all(prototype={},sort={:number => 1},offset=0,limit=nil)
    limit = 0 unless limit
    collection.find(prototype).sort(sort).skip(offset).limit(limit)
  end
end
