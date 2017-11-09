require_relative '../../../lib/radish/documents/reduce'

require 'faker'

describe Radish::Documents::Reduce do
  include Radish::Documents::Reduce

  it 'should omit and pick keys from a hash' do
    doc = {
      'a' => {
        'aa' => 1,
        'ab' => 2,
      },
      'b' => 2,
      'c' => [0, 1, 2],
    }
    
    exs = [
      {
        keys: ['a', 'c'],
        omit: {
          'b' => 2,
        },
        pick: {
          'a' => {
            'aa' => 1,
            'ab' => 2,
          },
          'c' => [0, 1, 2],
        },
      },
      {
        keys: ['a.aa'],
        omit: {
          'a' => {
            'ab' => 2,
          },
          'b' => 2,
          'c' => [0, 1, 2],
        },
        pick: {
          'a' => {
            'aa' => 1,
          },
        },
      },
      {
        keys: ['a.aa', 'c'],
        omit: {
          'a' => {
            'ab' => 2,
          },
          'b' => 2,
        },
        pick: {
          'a' => {
            'aa' => 1,
          },
          'c' => [0, 1, 2],
        },
      },
    ]

    exs.each do |ex|
      expect(omit(doc, ex[:keys])).to eql(ex[:omit])
      expect(pick(doc, ex[:keys])).to eql(ex[:pick])
    end
  end
  
  it 'should recursively reduce a document to a single-level document' do
    expectations = [
      {
        doc: {
          'a' => {
            'aa' => {
              'aaa' => 100,
              'aab' => 101,
            },
            'ab' => {
              'aba' => 110,
              'abb' => 111,
            }
          },
          'b' => {
            'bb' => 20,
          },
          'c' => 3,
        },
        ex: {
          'a.aa.aaa' => 100,
          'a.aa.aab' => 101,
          'a.ab.aba' => 110,
          'a.ab.abb' => 111,
          'b.bb' => 20,
          'c' => 3,
        },
      },
      {
        doc: {
          'a' => 1,
          'b' => 2,
          'c' => 3,
        },
        ex: {
          'a' => 1,
          'b' => 2,
          'c' => 3,
        },
      },
      {
        doc: [1, 2, 3],
        ex: [1, 2, 3],
      },
      {
        doc: 1,
        ex: 1,
      },
    ]

    expectations.each do |ex|
      expect(flatten_broadly(ex[:doc])).to eql(ex[:ex])
    end
  end
end
