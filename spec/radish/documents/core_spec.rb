require_relative '../../../lib/radish/documents/core'

require 'faker'

describe Radish::Documents::Core do
  include Radish::Documents::Core

  let(:doc) do
    {
      'a' => 0,
      'b' => '1',
      'c' => {
        'ca' => {
          'caa' => '200',
          'cab' => '201',
        },
        'cb' => {
          'cba' => '210',
        }
      },
      'd' => ['d0', 'd1', 'd2'],
      'e' => [
        {
          'ea' => '400',
          'eb' => {
            'eba' =>'410',
            'ebb' => '411',
          }
        },
        {
          'ea' => '500',
          'eb' => {
            'eba' => '510',
            'ebb' => '511',
          }
        },
      ]
    }
  end

  def verify_get(expectations)
    expectations.each do |ex|
      expect(has(doc, ex[:path])).to be_truthy, "expected doc to have #{ex[:path]}"
      ac = get(doc, ex[:path])
      expect(ac).to eql(ex[:ex]), "expected #{ex[:ex]} for #{ex[:path]}, but got #{ac}"
    end
  end

  it 'should get paths by array' do
    expectations = [
      { path: ['a'], ex: doc['a'] },
      { path: ['b'], ex: doc['b'] },
      { path: ['c', 'ca'], ex: doc['c']['ca'] },
      { path: ['c', 'ca', 'caa'], ex: doc['c']['ca']['caa'] },
      { path: ['d', 0], ex: doc['d'][0] },
      { path: ['d', 2], ex: doc['d'][2] },
      { path: ['e', 0, 'ea'], ex: doc['e'][0]['ea'] },
      { path: ['e', 1, 'eb', 'eba'], ex: doc['e'][1]['eb']['eba'] },
    ]
    verify_get(expectations)
  end

  def verify_set(expectations)
    expectations.each do |ex|
      odoc = ex[:doc].clone
      ndoc = set(ex[:doc], ex[:path], ex[:val])

      expect(ex[:doc]).to eql(odoc), 'expected documents to not be modified'
      expect(ndoc).to eql(ex[:ex])
    end
  end

  it 'should set paths by array' do
    expectations = [
      { path: ['a'], doc: {}, val: '1', ex: { 'a' => '1' } },
      { path: ['a'], doc: { 'a' => 1 }, val: 11, ex: { 'a' => 11 } },
      { path: ['a', 'b'], doc: { 'a' => {} }, val: '1', ex: { 'a' => { 'b' => '1' } } },
      { path: ['a', 'b'], doc: { 'a' => {} }, val: { 'c' => 'ccc' }, ex: { 'a' => { 'b' => { 'c' => 'ccc' } } } },
      { path: ['a', 'b'], doc: { 'a' => { 'c' => 'ccc' } }, val: '1', ex: { 'a' => { 'b' => '1', 'c' => 'ccc' } } },
      { path: ['a', 0], doc: { 'a' => {} }, val: '1', ex: { 'a' => { 0 => '1' } } },
      { path: ['a', '0'], doc: { 'a' => {} }, val: '1', ex: { 'a' => { '0' => '1' } } },
      { path: ['a', 0], doc: { 'a' => { 'b' => '11' } }, val: '1', ex: { 'a' => { 'b' => '11', 0 => '1' } } },
      { path: ['a', 0], doc: { }, val: '1', ex: { 'a' => ['1'] } },
      { path: ['a', '0'], doc: {}, val: '1', ex: { 'a' => ['1'] } },
      { path: ['a', 0], doc: { 'a' => [0, 1, 2] }, val: '1', ex: { 'a' => ['1', 1, 2] } },
      { path: ['a', 0, 'a'], doc: { }, val: '1', ex: { 'a' => [{ 'a' => '1' }] } },
      { path: ['a', 3], doc: {}, val: '1', ex: { 'a' => [nil, nil, nil, '1'] } },
      { path: ['a', 3], doc: { 'a' => [0, 1, 2, 3, 4]}, val: '1', ex: { 'a' => [0, 1, 2, '1', 4] } },
      { path: [3], doc: {}, val: '1', ex: { 3 => '1' } },
      { path: [3], doc: [0, 1, 2, 3, 4], val: '1', ex: [0, 1, 2, '1', 4] },
      { path: ['a', 'b', 1, 'c'], doc: {}, val: '1', ex: { 'a' => {'b' => [nil, { 'c' => '1' }] } } },
    ]

    verify_set(expectations)
  end

  it 'should get paths by string' do
    expectations = [
      { path: 'a', ex: doc['a'] },
      { path: 'b', ex: doc['b'] },
      { path: 'c.ca', ex: doc['c']['ca'] },
      { path: 'c.ca.caa', ex: doc['c']['ca']['caa'] },
      { path: 'd[0]', ex: doc['d'][0] },
      { path: 'd[2]', ex: doc['d'][2] },
      { path: 'e[0].ea', ex: doc['e'][0]['ea'] },
      { path: 'e[1].eb.eba', ex: doc['e'][1]['eb']['eba'] },
    ]
    verify_get(expectations)
  end

  it 'should yield default if path is non existant' do
    expectations = [
      ['z', 'z'],
      'zz[0].zz',
      '[0]',
      'y.z.e',
      [0, 0, 2],
      ['q', 2, 'q'],
    ]

    expectations.each do |path|
      expect(has(doc, path)).to be_falsey
      ex = Faker::Hipster.word
      expect(get(doc, path, ex)).to eql(ex)
    end
  end
end
