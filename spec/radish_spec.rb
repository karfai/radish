describe Radish do
  it 'defines a global alias' do
    require_relative '../lib/radish'
    expect(R).to_not be_nil
    expect{ R.method(:each) }.to_not raise_error
    expect{ R.method(:rand_one) }.to_not raise_error
  end
end
