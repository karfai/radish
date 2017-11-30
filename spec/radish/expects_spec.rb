require 'multi_json'
require_relative '../../lib/radish/randomness'

require_relative '../../lib/radish/expects'

describe 'Radish::Expects' do
  include Radish::Expects
  include Radish::Randomness
  
  it 'should read expectations from JSON files and call a function' do
    exs = rand_seq.inject({}) do |o, i|
      fn = "/tmp/#{i}.json"
      vals = rand_seq.map do
        { args: (0...3).map { Faker::StarWars.planet }, expects: rand_document }
      end

      IO.write(fn, MultiJson.encode(vals))

      o.merge(fn => vals)
    end

    func = lambda do |a, b, c|
      [a, b, c]
    end

    exs.keys.each do |fn|
      actuals = []
      load_expects([fn], func) do |ex, ac|
        actuals << { args: ac, expects: ex }
        # expect(ex).to eql(exs[fn][:expects])
        # expect(ac).to eql(exs[fn][:args])
      end

      expect(actuals.length).to eql(exs[fn].length)
      actuals.each_with_index do |ac, i|
        expect(ac).to eql(exs[fn][i])
      end
    end
  end
end
