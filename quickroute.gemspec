Gem::Specification.new do |s|
  s.name        = 'quickroute'
  s.version     = '0.1.1'
  s.date        = '2012-01-02'
  s.summary     = "Parser library for QuickRoute JPG files with embedded route data"
  s.description = "Library for parsing the GPS data embedded to JPG files by QuickRoute (http://www.matstroeng.se/quickroute/en/)."
  s.authors     = ["Jarkko Laine"]
  s.email       = 'jarkko@jlaine.net'
  s.files       = Dir.glob("{lib,spec}/**/*") + %w(README.md)
  s.homepage    =
    'https://github.com/jarkko/quickroute-ruby'
  s.add_development_dependency 'rspec', '~>2.7.0'
  s.add_runtime_dependency 'bindata', '~>1.4.3'
  s.add_runtime_dependency 'binary_search', '~>0.2.0'
  s.required_ruby_version = '>= 1.9.2'
end
