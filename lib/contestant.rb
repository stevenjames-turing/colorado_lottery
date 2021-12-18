class Contestant
  attr_reader :full_name, :age, :state_of_residence, :spending_money

  def initialize(data)
    @full_name = "#{data[:first_name]} #{data[:last_name]}"
    @age = data[:age]
    @state_of_residence = data[:state_of_residence]
    @spending_money = data[:spending_money]
  end

end
