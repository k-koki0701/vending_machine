require './vending_machine'

class MoneyManagement
  attr_accessor :slot_money, :sales_total_amount

  MONEY = [10, 50, 100, 500, 1000].freeze
  def initialize
    # 最初の自動販売機に入っている金額は0円
    @slot_money = 0
    #最初の売り上げ金額は0円
    @sales_total_amount = 0
  end

  def current_slot_money
    # 自動販売機に入っているお金を表示する
    @slot_money
  end

  def money_entry
    puts "1.お金を入れる"
    puts "お金を入れてください(10,50,100,500,1000)"
    money = gets
    if MONEY.include?(money.to_i)?
      "チャリン".tap { @slot_money += money.to_i } :"#{money}円"
    else
      puts "はいんない"
    end
  end

  def return_money
    puts "釣り銭#{@slot_money}円".tap {@slot_money = 0}
    sleep 2
  end

  def current_sales
    puts "売り上げ総額:#{@sales_total_amount}円"
  end

end
