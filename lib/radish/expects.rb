require 'multi_json'

module Radish
  module Expects
    def load_expects(files, func)
      files.each do |fn|
        o = MultiJson.decode(IO.read(fn))
        o.each do |ex|
          yield(ex['expects'], func.call(*ex['args']))
        end
      end
    end
  end
end
