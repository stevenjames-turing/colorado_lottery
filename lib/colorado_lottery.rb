class ColoradoLottery
  attr_reader :registered_contestants, :winners, :current_contestants

  def initialize
    @registered_contestants = {}
    @winners = []
    @current_contestants = {}
  end

  def interested_and_18?(contestant, game)
    contestant.age >= 18 && contestant.game_interests.include?(game.name)
  end

  def can_register?(contestant, game)
    interested_and_18?(contestant, game) &&
    (game.national_drawing? || !contestant.out_of_state?)
  end


end
