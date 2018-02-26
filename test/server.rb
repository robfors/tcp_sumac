require 'pry'
require 'tcp_sumac'

class Entry
  include Sumac::ExposedObject
  
  attr_accessor :value
  
  expose :test, :value, :value=, :new_user, :games, :new_game
  expose :messages
  
  def test
    #sleep 5
    #sleep(rand)
    55
  end
  
  def new_user(username)
    User.new(username)
  end
  
  def parent
    Parent.new
  end
  
  def new_game
    Game.new
  end
  
  def games
    Game.new
    #@games ||= [Game.new, Game.new]
  end
  
  def messages
    TextMessage
  end
  
end


class User
  include Sumac::ExposedObject
  
  attr_accessor :username
  
  expose :username, :tt, :sleep
  
  def initialize(username)
    @username = username
  end
  
  def sleep
    #binding.pry
    #Kernel.sleep(0.1)
    #raise 'test'
    nil
  end
  
  def tt(a, b)
    {'a' => a, 'b' => b}
  end
  
end


class Game
  include Sumac::ExposedObject
  
  expose :name
  
  def name
    'cool_game'
  end
  
end


class Parent
  include Sumac::ExposedObject
  
  child_accessor :new_child
  
  def initialize
    @children = [Child.new(0, 'a'), Child.new(1, 'b')]
  end
  
  def child(key)
    @children.find { |child| child.key == key }
  end
  
  def get_child(name)
    @children.find { |child| child.name == name }
  end
  
end


class Child
  include Sumac::ExposedObjectChild
  
  expose :name
  
  def initialize(id, name)
    @id = id
    @name = name
  end
  
  def key
    @id
  end
  
  def name
    @name
  end
  
end

class DB
  class TextMessage
    
    def self.messages
      @text_messages ||= [new(0, 'a'), new(1, 'b')]
    end
    
    def self.find(uid)
      messages.find { |text_message| text_message.uid == uid }
    end
    
    def self.search(text)
      messages.find { |text_message| text_message.text == text }
    end
    
    attr_reader :uid, :text
    
    def initialize(uid, text)
      @uid = uid
      @text = text
    end
    
  end
end

class TextMessage
  extend Sumac::ExposedObject
  include Sumac::ExposedObjectChild
  
  child_accessor :get
  parent_accessor :parent
  key_accessor :key
  
  expose :test, :find, :text
  
  def self.get(key)
    record = DB::TextMessage.find(key)
    raise unless record
    new(record)
  end
  
  def self.find(text)
    record = DB::TextMessage.search(text)
    raise unless record
    new(record)
  end
  
  def initialize(record)
    @record = record
  end
  
  def parent
    TextMessage
  end
  
  def key
    @record.uid
  end
  
  def text
    @record.text
  end
  
end
  
Thread.abort_on_exception = true

entry = Entry.new

sumac = TCPSumac.accept(port: 2000, entry: entry, workers: 10)
sumac.on(:shutdown) { puts "***SHUTDOWN***" }
sumac.on(:close) { puts "***CLOSE***" }

#binding.pry

sumac.join
