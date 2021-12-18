require './lib/contestant'
require './lib/game'
require './lib/colorado_lottery'


RSpec.describe ColoradoLottery do
  let (:lottery) {ColoradoLottery.new}
  let (:pick_4) {Game.new('Pick 4', 2)}
  let (:mega_millions) {Game.new('Mega Millions', 5, true)}
  let (:cash_5) {Game.new('Cash 5', 1)}
  let (:alexander) {Contestant.new({
    first_name: 'Alexander',
    last_name: 'Aigiades',
    age: 28,
    state_of_residence: 'CO',
    spending_money: 10})}
  let (:benjamin) {Contestant.new({
    first_name: 'Benjamin',
    last_name: 'Franklin',
    age: 17,
    state_of_residence: 'PA',
    spending_money: 100})}
  let (:frederick) {Contestant.new({
    first_name:  'Frederick',
    last_name: 'Douglas',
    age: 55,
    state_of_residence: 'NY',
    spending_money: 20})}
  let (:winston) {Contestant.new({
    first_name: 'Winston',
    last_name: 'Churchill',
    age: 18,
    state_of_residence: 'CO',
    spending_money: 5})}

  it 'exists' do
    expect(lottery).to be_instance_of ColoradoLottery
  end

  it 'initializes with no registered contestants, winners, or current contestants' do
    expect(lottery.registered_contestants).to eq({})
    expect(lottery.current_contestants).to eq({})
    expect(lottery.winners).to eq([])
  end

  it 'tracks contestants that are interested and old enough to play ' do
    alexander.add_game_interest('Pick 4')
    alexander.add_game_interest('Mega Millions')
    frederick.add_game_interest('Mega Millions')
    winston.add_game_interest('Cash 5')
    winston.add_game_interest('Mega Millions')
    benjamin.add_game_interest('Mega Millions')

    expect(lottery.interested_and_18?(alexander, pick_4)).to be true
    expect(lottery.interested_and_18?(benjamin, mega_millions)).to be false
    expect(lottery.interested_and_18?(alexander, cash_5)).to be false
  end
end
