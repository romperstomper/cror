class Racer
  attr_accessor :id, :number, :first_name, :last_name, :gender, :group, :secs
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
  def initialize(params={})
    @id=params[:_id].nil? ? params[:id] : params[:_id].to_s
    @number=params[:number].to_i
    @first_name=params[:first_name]
    @last_name=params[:last_name]
    @gender=params[:gender]
    @group=params[:group]
    @secs=params[:secs].to_i
  end
  def self.find(id)
    id = BSON::ObjectId(id) unless id.class == BSON::ObjectId
    result = all({:_id => id}).map {|r| r}.pop
    return result.nil? ? nil : Racer.new(result)
  end
  def save
    result=self.class.collection.insert_one(self.instance_values)
    @id=result.inserted_ids.first.to_s
  end
end
