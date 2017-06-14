require_relative '../../../lib/radish/documents/reduce'

require 'faker'

describe Radish::Documents::Reduce do
  include Radish::Documents::Reduce

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

  it 'should omit keys by path-like keys' do
    doc0 = {
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
    }
    expectations = [
      {
        doc: {
          'a' => 1,
          'b' => 2,
          'c' => 3,
          'd' => 4,
        },
        keys: ['a', 'c'],
        ex: {
          'b' => 2,
          'd' => 4,
        },
      },
      {
        doc: doc0,
        keys: ['a.aa.aaa', 'a.ab'],
        ex: {
          'a' => {
            'aa' => {
              'aab' => 101,
            },
          },
          'b' => {
            'bb' => 20,
          },
          'c' => 3,
        },
      },
      {
        doc: doc0,
        keys: ['a', 'c'],
        ex: {
          'b' => {
            'bb' => 20,
          },
        },
      },
    ]

    expectations.each do |ex|
      expect(omit(ex[:doc], ex[:keys])).to eql(ex[:ex])
    end
  end
end
