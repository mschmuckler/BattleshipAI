class Ship
  attr_accessor :size, :life
  attr_reader :name
  def initialize(size)
    @size = size
    @life = size
    case size
    when 5 then @name = "Aircraft Carrier"
    when 4 then @name = "Battleship"
    when 3 then @name = "Submarine"
    when 2 then @name = "Destroyer"
    else
      @name = "Water Vessel \##{size}"
    end
  end

  def self.create_all_ships
    carrier = Ship.new(5)
    battleship = Ship.new(4)
    submarine = Ship.new(3)
    destroyer = Ship.new(2)
    return carrier, battleship, submarine, destroyer
  end

  def sunk?
    @life <= 0
  end
end
