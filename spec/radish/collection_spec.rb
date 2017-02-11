require_relative '../../lib/radish/collection'

describe 'Radish::Collection' do
  describe 'each' do
    it 'should return the passed collection' do
      arr = [1, 2, 3, 4];
      o = { a: 1, b: 2, c: 3, d: 4 }

      expect(Radish::Collection.each(arr)).to eql(arr)
      expect(Radish::Collection.each(o)).to eql(o)
      expect(Radish::Collection.each(nil)).to be_nil
   end

   it 'should iterate an array yielding [k, i, c]' do
      arr = [1, 2, 3, 4];

      expected = arr.each_with_index.map { |v, i| [v, i, arr] }

      results = []
      Radish::Collection.each(arr) do |v, k, o|
        results << [v, k, o]
      end

      expect(results).to eql(expected)

   end

   it 'should iterate a hash yielding [k, v, c]' do
      o = { a: 1, b: 2, c: 3, d: 4 }

      expected = o.map { |k, v| [v, k, o] }

      results = []
      Radish::Collection.each(o) do |v, k, o|
        results << [v, k, o]
      end

      expect(results).to eql(expected)
   end
 end

 describe 'map' do
    it 'should return values if there is no iteree' do
      arr = [1, 2, 3, 4];
      o = { a: 1, b: 2, c: 3, d: 4 }

      expect(Radish::Collection.map(arr)).to eql(arr)
      expect(Radish::Collection.map(o)).to eql(o.values)
      expect(Radish::Collection.map(nil)).to eql([])
   end

   it 'should iterate an array yielding transform of (k, i, c)' do
      arr = [1, 2, 3, 4];

      expected = arr.each_with_index.map { |v, i| { v: v, k: i, c: arr } }

      results = Radish::Collection.map(arr) do |v, k, c|
        { v: v, k: k, c: c}
      end

      expect(results).to eql(expected)
   end

   it 'should iterate a hash transform of [k, v, c]' do
      o = { a: 1, b: 2, c: 3, d: 4 }

      expected = o.map { |k, v| { v: v, k: k, c: o} }

      results = Radish::Collection.map(o) do |v, k, c|
        { v: v, k: k, c: c }
      end

      expect(results).to eql(expected)
   end
 end
end
