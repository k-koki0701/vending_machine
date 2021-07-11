# require '/Users/kanasakakoki/workspace/vending_machine_test/vending_machine.rb'
# machine = VendingMachine.new
# machine.slot_money(1000)
# machine.purchase("coke")
# machine.purchase("redbull")
# machine.purchase("water")
# machine.stock_information
# machine.current_slot_money
# machine.return_money
# machine.current_sales
# machine.hit_or_miss
# machine.buyable
# machine.existing_stock_addition("redbull")
# machine.new_stock_addition("ayataka",120,5)


class VendingMachine

  # 10円玉、50円玉、100円玉、500円玉、1000円札を１つずつ投入できる。
  MONEY = [10, 50, 100, 500, 1000].freeze

  # キーにドリンク名、バリューにハッシュを作りドリンクの値段とストック数を入れる。二次元ハッシュ。
  @@drink = {coke:{price:120, stock:5}, redbull:{price:200, stock:5}, water:{price:100, stock:5}}

  # （自動販売機に投入された金額をインスタンス変数の @slot_money に代入する）
  def initialize
    # 最初の自動販売機に入っている金額は0円
    @slot_money = 0
    #最初の売り上げ金額は0円
    @sales_total_amount = 0
  end
  # 投入金額の総計を取得できる。
  def current_slot_money
    # 自動販売機に入っているお金を表示する
    @slot_money
  end
  # 10円玉、50円玉、100円玉、500円玉、1000円札を１つずつ投入できる。
  # 投入は複数回できる。
  def slot_money(money)
    MONEY.include?(money)?
     "チャリン".tap { @slot_money += money } :"#{money}円"
  end
  # 払い戻し操作を行うと、投入金額の総計を釣り銭として出力する。
  def return_money
    "釣り銭#{@slot_money}円".tap {@slot_money = 0}
  end

  def stock_information
    "在庫:#{@@drink}"
  end

  # 売り上げ総額を出力する。
  def current_sales
    "売り上げ総額:#{@sales_total_amount}円"
  end

  # 購入できるかを判定する。購入した場合当たり判定を行うメソッドを呼び出す。
  def purchase(drink_name)
    unless @slot_money >= @@drink[:"#{drink_name}"][:price] && @@drink[:"#{drink_name}"][:stock] > 0
      return false
    else
      @@drink[:"#{drink_name}"][:stock] -= 1
      @slot_money -= @@drink[:"#{drink_name}"][:price]
      @sales_total_amount += @@drink[:"#{drink_name}"][:price]

      if hit_or_miss == true && @@drink[:"#{drink_name}"][:stock] > 0
        @@drink[:"#{drink_name}"][:stock] -= 1
        puts "7777"
        puts "#{drink_name}をもう一本プレゼント！！"
        puts "#{drink_name}は残り#{@@drink[:"#{drink_name}"][:stock]}個"
      else
        puts "7776"
      end
    end
  end

    # 当たり判定を行うメソッド
    def  hit_or_miss
      roulette = ['7776','7776','7776','7776','7777']
      roulette.shuffle!
      roulette_result = roulette[0]

      if roulette_result == '7777'
        true
      else
        false
      end
    end

    # 投入金額とストックの数で購入可能な飲み物を出力できるメソッド
    def buyable
      drink_buyable = []
      @@drink.each do |item|
        drink_name = item[0]
        if @slot_money >= @@drink[:"#{drink_name}"][:price] && @@drink[:"#{drink_name}"][:stock] > 0
        drink_buyable << drink_name
        end
      end
      unless drink_buyable.empty?
        puts "#{drink_buyable.join(',')}が購入可能です"
      else
        puts "おめえに飲ませるジュースはねぇ！！by坂本先生"
      end
    end

    # 既存のドリンクを追加（１本ずつ）
    def existing_stock_addition(drink)
      if exists_drink(drink) == true
        @@drink[:"#{drink}"][:stock]+= 1
        return "ガチャン"
      else
       "登録にない商品です。"
      end
    end

    # 新しいドリンクを登録する（ドリンク名、値段、本数）
    def new_stock_addition(drink,price,stock)
      if exists_drink(drink) == false
        @@drink[:"#{drink}"] = {price:price,stock:stock}
      else
        "すでに登録してある商品です"
      end
    end

    # 引数のドリンク名が自販機内にあるかどうか　
    def exists_drink(drink)
      @@drink.has_key?(:"#{drink}")
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
