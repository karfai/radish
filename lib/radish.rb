require_relative './radish/collection'

R = Class.new do |cl|
  cl.include(Radish::Collection)
end.new
