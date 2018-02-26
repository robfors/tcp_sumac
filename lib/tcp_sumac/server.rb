module TCPSumac
  class Server
  
    def initialize(tcp_messenger_server, duck_types: , entry: , entry_class: , max_message_length: , workers: )
      @tcp_messenger_server = tcp_messenger_server
      @duck_types = duck_types
      @entry = entry
      @entry_class = entry_class
      @max_message_length = max_message_length
      @workers = workers
      @close_mutex = QuackConcurrency::ReentrantMutex.new(duck_types: duck_types)
      @accept_mutex = QuackConcurrency::ReentrantMutex.new(duck_types: duck_types)
      @closed = false
    end
    
    def accept
      @accept_mutex.synchronize do
        raise ClosedError if closed?
        begin
          tcp_messenger = @tcp_messenger_server.accept
        rescue
          @close_mutex.synchronize do
            raise ClosedError if closed?
            close
            raise ConnectionError
          end
        end
        adapter = Adapter.new(tcp_messenger)
        
        return Sumac.new(duck_types: @duck_types, entry: new_entry, messenger: adapter, workers: @workers)
      end
    end
    
    def close
      @close_mutex.synchronize do
        raise ClosedError if closed?
        begin
          @tcp_messenger_server.close
        rescue
          raise ConnectionError
        ensure
          @closed = true
        end
      end
      nil
    end
    
    def closed?
      @closed
    end
    
    private
    
    def new_entry
      case
      when @entry && !@entry_class
        entry = @entry
      when !@entry && @entry_class
        entry = @entry_class.new
      else
        raise
      end
      entry
    end
    
  end
end
