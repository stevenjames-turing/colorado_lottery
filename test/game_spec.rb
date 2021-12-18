require './lib/contestant'
require './lib/game'


RSpec.describe Game do
  it 'exists' do
    mega_millions = Game.new('Mega Millions', 5, true)

    expect(mega_millions).to be_instance_of Game
  end

  it 'initializes with a name, cost to play, and whether the drawing is national' do
    mega_millions = Game.new('Mega Millions', 5, true)

    expect(mega_millions.name).to eq("Mega Millions")
    expect(mega_millions.cost).to eq(5)
    expect(mega_millions.national_drawing?).to be true
  end

  it 'has an optional argument for national_drawing. Default is false' do
    mega_millions = Game.new('Mega Millions', 5, true)
    pick_4 = Game.new('Pick 4', 2)

    expect(mega_millions.national_drawing?).to be true
    expect(pick_4.national_drawing?).to be false 
  end
end
