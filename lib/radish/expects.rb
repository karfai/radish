require 'multi_json'

module Radish
  module Expects
    def load_expects(files, func)
      files.each do |fn|
        o = MultiJson.decode(IO.read(fn))
        yield(o['expects'], func.call(*o['args']))
      end
    end
  end
end
