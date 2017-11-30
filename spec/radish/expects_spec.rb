require 'multi_json'
require_relative '../../lib/radish/randomness'

require_relative '../../lib/radish/expects'

describe 'Radish::Expects' do
  include Radish::Expects
  include Radish::Randomness
  
  it 'should read expectations from JSON files and call a function' do
    exs = rand_seq.inject({}) do |o, i|
      fn = "/tmp/#{i}.json"
      a = (0...3).map { Faker::StarWars.planet }
      ex = rand_document

      IO.write(fn, MultiJson.encode({ args: a, expects: ex }))

      o.merge(fn => { args: a, expects: ex })
    end

    func = lambda do |a, b, c|
      [a, b, c]
    end

    exs.keys.each do |fn|
      called = false
      load_expects([fn], func) do |ex, ac|
        expect(ex).to eql(exs[fn][:expects])
        expect(ac).to eql(exs[fn][:args])

        called = true
      end

      expect(called).to eql(true)
    end
  end
end
