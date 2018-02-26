require 'thread'
require 'quack_concurrency'
require 'tcp_messenger'
require 'sumac'

require 'tcp_sumac/adapter'
require 'tcp_sumac/closed_error'
require 'tcp_sumac/connection_error'
require 'tcp_sumac/server'


module TCPSumac

  def self.connect(duck_types: {}, entry: nil, host: , max_message_length: Float::INFINITY, port: , workers: 1)
    messenger = TCPMessenger.connect(duck_types: duck_types, host: host, max_message_length: max_message_length, port: port)
    adapter = Adapter.new(messenger)
    Sumac.new(duck_types: duck_types, entry: entry, messenger: adapter, workers: workers)
  end
  
  def self.listen(duck_types: {}, entry: nil, entry_class: nil, max_message_length: Float::INFINITY, port: , workers: 1)
    tcp_messenger_server = TCPMessenger.listen(duck_types: duck_types, max_message_length: max_message_length, port: port)
    Server.new(tcp_messenger_server, duck_types: duck_types, entry: entry, entry_class: entry_class, max_message_length: max_message_length, workers: workers)
  end
  
  def self.accept(duck_types: {}, entry: nil, entry_class: nil, max_message_length: Float::INFINITY, port: , workers: 1)
    server = listen(duck_types: duck_types, entry: entry, entry_class: entry_class, max_message_length: max_message_length, port: port, workers: workers)
    sumac = server.accept
    server.close
    sumac
  end
  
end
