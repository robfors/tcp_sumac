Gem::Specification.new do |s|
  s.name        = 'tcp_sumac'
  s.version     = '0.0.0'
  s.date        = '2018-02-25'
  s.summary     = "Wraps Sumac and TCPMessenger for an easy to implement library."
  s.authors     = ["Rob Fors"]
  s.email       = 'mail@robfors.com'  
  s.files       = Dir.glob("{lib,test}/**/*") + %w(LICENSE README.md)
  s.homepage    = 'https://github.com/robfors/tcp_sumac'
  s.license     = 'MIT'
  s.add_runtime_dependency 'quack_concurrency', '=0.0.1'
  s.add_runtime_dependency 'tcp_messenger', '=0.0.0'
  s.add_runtime_dependency 'sumac', '=0.0.0'
end
