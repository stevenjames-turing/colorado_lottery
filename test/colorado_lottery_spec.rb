require './lib/contestant'
require './lib/game'
require './lib/colorado_lottery'


RSpec.describe ColoradoLottery do
  it 'exists' do
    lottery = ColoradoLottery.new

    expect(lottery).to be_instance_of ColoradoLottery
  end
end
