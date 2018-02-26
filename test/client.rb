require 'pry'
require 'tcp_sumac'

Thread.abort_on_exception = true

class Entry
  include Sumac::ExposedObject
  
  attr_accessor :value
  
  expose :test, :value, :value=
  
  def test
    raise
    sleep 5
    55
  end
  
end

entry = Entry.new

sumac = TCPSumac.connect(host: '127.0.0.1', port: 2000, entry: entry, workers: 10)
#sumac.on(:network_error) { puts "***NETWORK_ERROR***" }
sumac.on(:shutdown) { puts "***SHUTDOWN***" }
sumac.on(:close) { puts "***CLOSE***" }

#u = sumac.entry.new_user('rob')
#u.sleep
#sumac.close
#begin
#  u.sleep
#rescue StandardError => e
#  puts e.message
#end

binding.pry
#sumac.entry.find('a').text
#sumac.join

threads = []
100.times do
  threads << Thread.new do
    1000.times do
      #print 'a'
      #name = (0...8).map { (65 + rand(26)).chr }.join
      #g = sumac.entry.new_game
      u = sumac.entry.new_user('name')
      #begin
      #rname = u.username
      u.sleep
      #rescue
      #puts u.__remote_reference__.exposed_id
      #binding.pry
      #end
      #raise unless rname == name
      #print 'b'
      #g.name
      #g.forget
      u.forget
      #print 'c'
      print '.'
    end
  end
end

#binding.pry
threads.each(&:join)
puts 'done'
#sumac.join
sumac.close

exit

c = []

1_000.times do
  messenger = TCPMessenger.connect('127.0.0.1', 2001)
  connection = Sumac.start(messenger, nil)
  
  connection.on(:network_error) { puts "***NETWORK_ERROR***" }
  connection.on(:shutdown) { puts "***SHUTDOWN***" }
  connection.on(:close) { messenger.close; puts "***CLOSE***" }
  
  entry = connection.entry
  
  u = entry.new_user('rob')
  u.username
  u.forget
  c << connection
end

binding.pry

#t = Thread.new do
#  begin
#    sleep 1
#    puts entry.test
#  rescue Sumac::StaleObject
#    puts 'good'
#  end
#end

#mutex = Mutex.new
#$count = 0

#threads = 5.times.map do
#  Thread.new do
#    100.times do
#      entry.test
#      mutex.synchronize { $count += 1; puts $count }
#    end
#  end
#end
#
#threads.each(&:join)

#sleep 2

connection.close

#binding.pry

#puts entry.new_user('rob').tt({},[44.44])

#puts connection.entry.new_user.username

#binding.pry



#t.join
