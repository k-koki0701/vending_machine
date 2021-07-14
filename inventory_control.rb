class InventoryControl
  attr_accessor :drink

  def initialize
    @drink = {coke:{price:120, stock:5}, redbull:{price:200, stock:5}, water:{price:100, stock:5}}
  end

  def stock_information
    puts "在庫：#{@drink}"
  end

  def existing_stock_addition
    puts "2.商品名を入力してください"
    drink = gets.chomp
    if @drink.has_key?(:"#{drink}") == true
       @drink[:"#{drink}"][:stock]+= 1
      puts "ガチャン"
    else
      puts "登録にない商品です。"
    end
    sleep 1
  end

  def new_stock_addition
    puts "商品名を入力してください"
    drink = gets.chomp
    puts "値段を入力してください"
    price = gets.to_i
    puts "本数を入力してください"
    stock = gets.to_i

    if @drink.has_key?(:"#{drink}") == false
      @drink[:"#{drink}"] = {price:price,stock:stock}
    else
      puts "すでに登録してある商品です"
    end
  end

end
