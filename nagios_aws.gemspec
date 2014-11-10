Gem::Specification.new do |s|
  s.name        = 'nagios_aws'
  s.version     = '0.1.0'
  s.licenses    = ['MIT']
  s.summary     = "Monitor all aws services without pain"
  s.description = "This gem allow to server admins to monitor all Amazon ws via Nagios"
  s.authors     = ["Tarik ihadjadene"]
  s.email       = 'tarik.ihadjadene@gmail.com'
  s.files       = Dir["lib/**/*"]
  s.require_paths = ["lib"]
  s.homepage    = ''
  s.add_runtime_dependency 'aws-sdk', "~> 1.58"
  s.add_runtime_dependency 'rspec', "~>3.0"
  s.add_runtime_dependency 'vcr', '~> 2.9', '>= 2.9.3'
  s.add_runtime_dependency 'webmock', '~> 1.20'
end
