Gem::Specification.new do |s|
  s.name          = 'jsonoid'
  s.version       = '0.0.1'
  s.date          = '2014-01-26'
  s.summary       = "A simple serverless NoSQL (JSON) document storage system"
  s.description   = s.summary
  s.authors       = ["Mihail Szabolcs"]
  s.email         = 'szaby@szabster.net'
  s.files         = Dir['lib/**/*.rb']
  s.require_paths = ['lib']
  s.homepage      = 'http://szabster.net/jsonoid'
  s.licenses      = ['MIT']
  s.add_dependency 'json'
end
