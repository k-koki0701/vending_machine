class Drink
  attr_accessor :name
  attr_accessor :price
  attr_accessor :stock

  def initialize(name:, pricpricee:, stock:)
    @name = name
    @price = price
    @stock = stock
  end

  def add_stock
    @stock += 1
  end
end
