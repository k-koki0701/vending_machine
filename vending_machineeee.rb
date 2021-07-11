class VendingMachine
  # 10円玉、50円玉、100円玉、500円玉、1000円札を１つずつ投入できる。
  MONEY = [10, 50, 100, 500, 1000].freeze
  # （自動販売機に投入された金額をインスタンス変数の @slot_money に代入する）
  def initialize
    # 最初の自動販売機に入っている金額は0円
    @slot_money = 0
    #最初の売り上げ金額は0円
    @sales_total_amount = 0

    @vm = InventoryControl.new

  end
  # 投入金額の総計を取得できる。
  def current_slot_money
    # 自動販売機に入っているお金を表示する
    @slot_money
  end
  # 10円玉、50円玉、100円玉、500円玉、1000円札を１つずつ投入できる。
  # 投入は複数回できる。
  def slot_money(money)
    return false unless MONEY.include?(money)
    @slot_money += money
  end
  # 払い戻し操作を行うと、投入金額の総計を釣り銭として出力する。
  def return_money
    puts "釣り銭#{@slot_money}円"
    @slot_money = 0
  end
  def stock_information
    puts @drink
  end
  # 売り上げ総額を出力する。
  def current_sales
    puts "売り上げ総額:#{@sales_total_amount}円"
  end
  # 購入できるかを判定する。購入した場合当たり判定を行うメソッドを呼び出す。
  def purchase(drink_name)
    unless @slot_money >= @drink[:"#{drink_name}"][:price] && @drink[:"#{drink_name}"][:stock] > 0
      return false
    else
      @drink[:"#{drink_name}"][:stock] -= 1
      @slot_money -= @drink[:"#{drink_name}"][:price]
      @sales_total_amount += @drink[:"#{drink_name}"][:price]
      puts "#{drink_name}は残り#{@drink[:"#{drink_name}"][:stock]}個"
      puts "釣り銭#{@slot_money}円"
      puts "売り上げ総額#{@sales_total_amount}円"
      if hit_or_miss == true && @drink[:"#{drink_name}"][:stock] > 0
        @drink[:"#{drink_name}"][:stock] -= 1
        puts '当たりです！！'
        puts "#{drink_name}をもう一本プレゼント！！"
        puts "#{drink_name}は残り#{@drink[:"#{drink_name}"][:stock]}個"
      else
        puts 'ハズレですねwwww'
      end
    end
  end
    # 当たり判定を行うメソッド
    def  hit_or_miss
      roulette = ['ハズレ','ハズレ','ハズレ','ハズレ','当たり']
      roulette.shuffle!
      roulette_result = roulette[0]
      if roulette_result == '当たり'
        true
      else
        false
      end
    end
    # 投入金額とストックの数で購入可能な飲み物を出力できるメソッド
    def buyable
      drink_buyable = []
      @drink.each do |item|
        drink_name = item[0]
        if @slot_money >= @drink[:"#{drink_name}"][:price] && @drink[:"#{drink_name}"][:stock] > 0
        drink_buyable << drink_name
        end
      end
      unless drink_buyable.empty?
        puts "#{drink_buyable.join(',')}が購入可能です"
      else
        puts "おめえに飲ませるジュースはねぇ！！by坂本先生"
      end
    end

    def stock_addition(drink,price,stock)
      drink_add = {price:price,stock:stock}
      @drink[:"#{drink}"] = drink_add
    end
end

class PurchaseDrink
  def initialize
    @vm=VendingMachine.new
  end
  # お金を入れてください
  def purchase_drink
    puts "硬貨を投入します"
    puts "10円なら\"10\"と入力してください"
    @slot_money = gets.chomp
    puts "現在の投入金額は#{@slot_money}円です"
    @vm.buyable
  end
end

class InventoryControl
  # attr_reader :drink
  # def initialize(drink)
    @drink = {coke:{price:120, stock:5}, redbull:{price:200, stock:5}, water:{price:100, stock:5}}
    # @drink = drink
  # end

end
