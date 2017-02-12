require_relative './radish/collection'
require_relative './radish/randomness'

R = Class.new do |cl|
  cl.include(Radish::Collection)
  cl.include(Radish::Randomness)
end.new
