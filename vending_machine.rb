# require '/Users/kanasakakoki/workspace/vending_machine_test/vending_machine.rb'
# machine = VendingMachine.new
# machine.main
# machine.admin_machine
# Ryo Maruyama

require './inventory_control'
require './money_management'


class VendingMachine

  def initialize
    @mm = MoneyManagement.new
    @ic = InventoryControl.new
  end

  def main
    puts "いらっしゃいませ"
    puts "1.お金を入れる，2.商品を買う，3.お金払い戻し"
    puts "0.立ち去る"
    puts "【投入金額：#{@mm.current_slot_money}円】"
    number = gets.chomp
    case number
    when "1","１" then
      @mm.money_entry
      main
    when "2","２" then
      purchase
      main
    when "3","３" then
      @mm.return_money
      main
    when "0","０" then
      puts "さようなら"
    else
      puts "そんな番号ない"
    end
  end

  def purchase
    puts "2.商品を買う"
    puts "【投入金額：#{@mm.current_slot_money}円】"
    # buyable
    return puts "お金が足りません。"  if buyable == false
    puts "当たりでもう一本"
    puts "購入したいドリンク名を入力してください"
    drink_name = gets.chomp
    if @ic.drink.has_key?(:"#{drink_name}") == false
      puts "#{drink_name}はありません。"
    elsif @mm.slot_money < @ic.drink[:"#{drink_name}"][:price] || @ic.drink[:"#{drink_name}"][:stock] == 0
      puts "購入できません。"
    else
      @ic.drink[:"#{drink_name}"][:stock] -= 1
      @mm.slot_money -= @ic.drink[:"#{drink_name}"][:price]
      @mm.sales_total_amount += @ic.drink[:"#{drink_name}"][:price]
      puts 'ガタンッ'
      puts '抽選中...'
      sleep 2
      if hit_or_miss == true && @ic.drink[:"#{drink_name}"][:stock] > 0
        @ic.drink[:"#{drink_name}"][:stock] -= 1
        puts "当たり"
        puts "#{drink_name}をもう一本プレゼント！！"
      else
        puts "ハズレ"
      end
    end
    sleep 1
  end

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

  def buyable
    drink_buyable = []
    @ic.drink.each do |item|
      drink_name = item[0]
      if @mm.slot_money >= @ic.drink[:"#{drink_name}"][:price].to_i && @ic.drink[:"#{drink_name}"][:stock].to_i > 0
      drink_buyable << drink_name
      end
    end
    unless drink_buyable.empty?
      puts "#{drink_buyable.join(',')}が購入可能です"
    else
      puts "おめえに飲ませるジュースはねぇ！！by坂本先生"
      sleep 1
      return false
    end
  end

  def admin_machine
    puts "合言葉は？"
    keyword = gets.chomp
    if keyword == "Ryo Maruyama"
      admin
    else
      puts "Ryo Maruyamaではありませんね。"
    end
  end


  def admin
    puts "丸山様、お帰りなさい。"
    puts "1.在庫確認，2.商品追加，3.新規商品登録"
    puts "0.立ち去る"
    number = gets.chomp
    case number
    when "1","１" then
      @ic.stock_information
      admin
    when "2","２" then
      @ic.existing_stock_addition
      admin
    when "3","３" then
      @ic.new_stock_addition
      admin
    when "0","０" then
      puts "さようなら"
    else
      puts "タイプミスでございます"
    end
  end



end
