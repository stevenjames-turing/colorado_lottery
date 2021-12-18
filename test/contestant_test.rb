require './lib/contestant'


RSpec.describe Contestant do
  let (:alexander) {Contestant.new({
    first_name: 'Alexander',
    last_name: 'Aigiades',
    age: 28,
    state_of_residence: 'CO',
    spending_money: 10})}

  it 'exists' do
    expect(alexander).to be_instance_of Contestant
  end

  it 'initializes with a hash of data containing name, age, residency, and spending money' do
    expect(alexander.full_name).to eq("Alexander Aigiades")
    expect(alexander.age).to eq(28)
    expect(alexander.state_of_residence).to eq("CO")
    expect(alexander.spending_money).to eq(10)
  end

  it 'knows whether the Contestant is out of state' do
    expect(alexander.out_of_state?).to be false
  end

  it 'initializes without any game interests' do
    expect(alexander.game_interests).to eq([])
  end

  it 'can add interested games' do
    alexander.add_game_interest('Mega Millions')
    alexander.add_game_interest('Pick 4')

    expect(alexander.game_interests).to eq(["Mega Millions", "Pick 4"])
  end
end
