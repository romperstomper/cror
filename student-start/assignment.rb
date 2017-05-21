require 'mongo'
require 'json'
require 'pp'
require 'byebug'
Mongo::Logger.logger.level = ::Logger::INFO
#Mongo::Logger.logger.level = ::Logger::DEBUG

class Solution
  MONGO_URL='mongodb://localhost:27017'
  MONGO_DATABASE='test'
  RACE_COLLECTION='race1'

  # helper function to obtain connection to server and set connection to use specific DB
  # set environment variables MONGO_URL and MONGO_DATABASE to alternate values if not
  # using the default.
  def self.mongo_client
    url=ENV['MONGO_URL'] ||= MONGO_URL
    database=ENV['MONGO_DATABASE'] ||= MONGO_DATABASE 
    db = Mongo::Client.new(url)
    @@db=db.use(database)
  end

  # helper method to obtain collection used to make race results. set environment
  # variable RACE_COLLECTION to alternate value if not using the default.
  def self.collection
    collection=ENV['RACE_COLLECTION'] ||= RACE_COLLECTION
    return mongo_client[collection]
  end
  
  # helper method that will load a file and return a parsed JSON document as a hash
  def self.load_hash(file_path) 
    file=File.read(file_path)
    JSON.parse(file)
  end

  # initialization method to get reference to the collection for instance methods to use
  def initialize
    @coll=self.class.collection
  end

  def clear_collection
    @coll.delete_many
  end

  def load_collection(file_path) 
    @coll.insert_many(self.class.load_hash(file_path))
  end

  def insert(race_result)
    @coll.insert_one(race_result)
  end

  def all(prototype={})
    @coll.find(prototype)
  end

  def find_by_name(fname, lname)
    @coll.find({first_name: fname, last_name: lname}).projection({:last_name => 1,:_id => 0, :first_name => 1, :number => 1})
    #place solution here
  end

  def find_group_results(group, offset, limit)
    @coll.find({"group" => group}).skip(offset).limit(limit).sort({:secs => 1}).projection({:group => 0, :_id => 0})

    #result = self.class.all(group).projection({:group => 0, :_id => 0})
    #place solution here
  end

  #
  # Lecture 4: Find By Criteria
  #

  def find_between(min, max) 
    @coll.find({:secs => {:$lt => max, :$gt => min}})
    #place solution here
  end

  def find_by_letter(letter, offset, limit) 
    letter = letter.upcase
    @coll.find({:last_name => {:$regex => "^#{letter}.+"}}).sort({:last_name => 1}).skip(offset).limit(limit)
  end

  #
  # Lecture 5: Updates
  #
  
  def update_racer(racer)
    all({:_id => racer[:_id]}).replace_one(racer)
    #place solution here
  end

  def add_time(number, secs)
    all({:number => number}).replace_one(:$inc => {:secs => secs})
    #place solution here
  end

end

s=Solution.new
race1=Solution.collection
