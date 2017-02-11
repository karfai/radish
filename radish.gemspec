# coding: utf-8
Gem::Specification.new do |s|
  s.name        = 'radish'
  s.version     = '0.0.1'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Don Kelly"]
  s.email       = ["karfai@gmail.com"]
  s.summary     = "Radish"
  s.description = "Library emulating lodash"

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'faker'
  s.add_development_dependency 'fuubar'

  s.files        = Dir.glob("{bin,lib}/**/*")
  s.require_path = 'lib'
end
