require_relative '../../lib/radish/randomness'

describe 'Radish::Expects' do
  include Radish::Randomness

  it 'should yield a random sequence' do
    expect(rand_seq.to_a).to_not be_empty
    expect(rand_seq.to_a).to_not be_empty
    expect(rand_seq.to_a).to_not be_empty
  end
  
  it 'should yield a random number of times' do
    o = 0
    c = rand_times do
      o += 1
    end

    expect(c).to_not eql(0)
    expect(o).to eql(c)

    expect(rand_times).to_not eql(0)
  end
  
  it 'should generate random documents' do
    rand_times do
      o = rand_document
      expect(o).to respond_to(:keys)
      expect(o.keys.length).to_not eql(0)
    end
  end
end
