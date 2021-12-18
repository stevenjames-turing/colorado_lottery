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

  def register_contestant(contestant, game)
    if can_register?(contestant, game) && registered_contestants.has_key?(game.name)
      registered_contestants[game.name] << contestant
    elsif can_register?(contestant, game) == true && !registered_contestants.has_key?(game.name)
      registered_contestants[game.name] = [] << contestant
    end
  end
end
