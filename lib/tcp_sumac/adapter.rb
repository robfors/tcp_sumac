module TCPSumac
  class Adapter
  
    def initialize(messenger)
      @messenger = messenger
    end
    
    def send(message)
      begin
        @messenger.send(message)
      rescue TCPMessenger::ClosedError
        raise Sumac::Adapter::ClosedError
      end
      nil
    end
    
    def receive
      begin
        message = @messenger.receive
      rescue TCPMessenger::ClosedError
        raise Sumac::Adapter::ClosedError
      end
      message
    end
    
    def close
      begin
        @messenger.close
      rescue TCPMessenger::ClosedError
        raise Sumac::Adapter::ClosedError
      end
      nil
    end
    
    def closed?
      @messenger.closed?
    end
    
  end
end
