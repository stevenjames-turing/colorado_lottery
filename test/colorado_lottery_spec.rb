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
  let (:grace) {Contestant.new({
    first_name: 'Grace',
    last_name: 'Hopper',
    age: 20,
    state_of_residence: 'CO',
    spending_money: 20})}

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

  it 'tracks whether players are eligible to register, while also being interested in game' do
    alexander.add_game_interest('Pick 4')
    alexander.add_game_interest('Mega Millions')
    frederick.add_game_interest('Mega Millions')
    winston.add_game_interest('Cash 5')
    winston.add_game_interest('Mega Millions')
    benjamin.add_game_interest('Mega Millions')

    expect(lottery.can_register?(alexander, pick_4)).to be true
    expect(lottery.can_register?(alexander, cash_5)).to be false
    expect(lottery.can_register?(frederick, mega_millions)).to be true
    expect(lottery.can_register?(benjamin, mega_millions)).to be false
    expect(lottery.can_register?(frederick, cash_5)).to be false
  end

  it 'can register eligible contestants' do
    alexander.add_game_interest('Pick 4')

    lottery.register_contestant(alexander, pick_4)

    expected_registered = {"Pick 4"=> [alexander]}
    expect(lottery.registered_contestants).to eq(expected_registered)
  end

  it 'can register contestants to multiple games' do
    alexander.add_game_interest('Pick 4')
    alexander.add_game_interest('Mega Millions')

    lottery.register_contestant(alexander, pick_4)
    lottery.register_contestant(alexander, mega_millions)

    expected_registered = {"Pick 4"=> [alexander], "Mega Millions"=> [alexander]}
    expect(lottery.registered_contestants).to eq(expected_registered)
  end

  it 'can register multiple contestants to multiple games' do
    alexander.add_game_interest('Pick 4')
    alexander.add_game_interest('Mega Millions')
    frederick.add_game_interest('Mega Millions')
    winston.add_game_interest('Cash 5')
    winston.add_game_interest('Mega Millions')

    lottery.register_contestant(alexander, pick_4)
    lottery.register_contestant(alexander, mega_millions)
    lottery.register_contestant(frederick, mega_millions)
    lottery.register_contestant(winston, cash_5)
    lottery.register_contestant(winston, mega_millions)

    expected_registered = {
      "Pick 4"=> [alexander],
      "Mega Millions"=> [alexander, frederick, winston],
      "Cash 5"=> [winston]}

    expect(lottery.registered_contestants).to eq(expected_registered)
  end

  it 'knows contestants are eligible once registered and spending_money >= game cost' do
    alexander.add_game_interest('Pick 4')
    alexander.add_game_interest('Mega Millions')
    frederick.add_game_interest('Mega Millions')
    winston.add_game_interest('Cash 5')
    winston.add_game_interest('Mega Millions')
    grace.add_game_interest('Mega Millions')
    grace.add_game_interest('Cash 5')
    grace.add_game_interest('Pick 4')

    lottery.register_contestant(alexander, pick_4)
    lottery.register_contestant(alexander, mega_millions)
    lottery.register_contestant(frederick, mega_millions)
    lottery.register_contestant(winston, cash_5)
    lottery.register_contestant(winston, mega_millions)
    lottery.register_contestant(grace, mega_millions)
    lottery.register_contestant(grace, cash_5)
    lottery.register_contestant(grace, pick_4)

      expected_registered = {
        "Pick 4"=> [alexander, grace],
        "Mega Millions"=> [alexander, frederick, winston, grace],
        "Cash 5"=> [winston, grace]}

      expected_eligible_pick_4 = [alexander, grace]
      expected_eligible_cash_5 = [winston, grace]
      expected_eligible_mega = [alexander, frederick, winston, grace]

      expect(lottery.registered_contestants).to eq(expected_registered)
      expect(lottery.eligible_contestants(pick_4)).to eq(expected_eligible_pick_4)
      expect(lottery.eligible_contestants(cash_5)).to eq(expected_eligible_cash_5)
      expect(lottery.eligible_contestants(mega_millions)).to eq(expected_eligible_mega)
  end

  it 'charges elibible contestants for game if registered' do
    alexander.add_game_interest('Pick 4')
    alexander.add_game_interest('Mega Millions')
    frederick.add_game_interest('Mega Millions')
    winston.add_game_interest('Cash 5')
    winston.add_game_interest('Mega Millions')
    grace.add_game_interest('Mega Millions')
    grace.add_game_interest('Cash 5')
    grace.add_game_interest('Pick 4')

    lottery.register_contestant(alexander, pick_4)
    lottery.register_contestant(alexander, mega_millions)
    lottery.register_contestant(frederick, mega_millions)
    lottery.register_contestant(winston, cash_5)
    lottery.register_contestant(winston, mega_millions)
    lottery.register_contestant(grace, mega_millions)
    lottery.register_contestant(grace, cash_5)
    lottery.register_contestant(grace, pick_4)

    lottery.charge_contestants(cash_5)

    expect(winston.spending_money).to eq(4)
    expect(grace.spending_money).to eq(19)
  end

  it 'contestants are considered "current_contestants" after being charged' do
  end

end
