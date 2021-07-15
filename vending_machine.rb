# require '/Users/kanasakakoki/workspace/vending_machine_test/vending_machine.rb'
# machine = VendingMachine.new
# machine.main
# machine.admin_machine

require './inventory_control'
require './money_management'


class VendingMachine

  def initialize
    @money_management = MoneyManagement.new
    @inventory_control = InventoryControl.new
  end

  # 一般のお客様用
  def main
    puts "＜メニュー＞"
    puts "1.お金を入れる，2.商品を買う，3.お金払い戻し"
    puts "0.自販機から離れる"
    puts "【投入金額：#{@money_management.current_slot_money}円】"
    number = gets.tr('０-９','0-9').to_i
    case number
    when 1 then
      puts "1.お金を入れる"
      puts "お金を入れてください(10,50,100,500,1000)"
      @money_management.money_entry
      main
    when 2 then
      puts "2.商品を買う"
      puts "【投入金額：#{@money_management.current_slot_money}円】"
      purchase if buyable? == true
      main
    when 3 then
      @money_management.return_money
    when 0 then
      puts "またのご利用お待ちしております"
    else
      puts "そんな番号ない"
      main
    end
  end

  # 購入
  def purchase
    puts "当たりでもう一本プレゼント！"
    VendingMachine.sleep_time(1)
    puts "購入したいドリンク名を入力してください"
    drink_name = gets.chomp
    if @inventory_control.drink.has_key?(:"#{drink_name}") == false
      puts "#{drink_name}はありません"
    elsif @money_management.slot_money < @inventory_control.drink[:"#{drink_name}"][:price] || @inventory_control.drink[:"#{drink_name}"][:stock] == 0
      puts "購入できません"
    else
      @inventory_control.drink[:"#{drink_name}"][:stock] -= 1
      @money_management.slot_money -= @inventory_control.drink[:"#{drink_name}"][:price]
      @money_management.sales_total_amount += @inventory_control.drink[:"#{drink_name}"][:price]
      puts 'ガタンッ'
      puts '抽選中...'
      VendingMachine.sleep_time(2)
      hit_or_miss(drink_name)
    end
    VendingMachine.sleep_time(1)
  end

  def  hit_or_miss(drink_name)
    roulette = ['ハズレ','ハズレ','ハズレ','ハズレ','当たり'].shuffle
    if roulette[0] == '当たり' && @inventory_control.drink[:"#{drink_name}"][:stock] > 0
      @inventory_control.drink[:"#{drink_name}"][:stock] -= 1
      puts "当たり"
      puts "#{drink_name}をもう一本プレゼント！！"
    else
      puts "ハズレ"
    end
    VendingMachine.sleep_time(1)
  end

  def buyable?
    drink_buyable = []
    @inventory_control.drink.each do |item|
      drink_name = item[0]
      if @money_management.slot_money >= @inventory_control.drink[:"#{drink_name}"][:price] && @inventory_control.drink[:"#{drink_name}"][:stock] > 0
      drink_buyable << drink_name
      end
    end
    unless drink_buyable.empty?
      puts "#{drink_buyable.join(',')}が購入可能です"
      VendingMachine.sleep_time(1)
      return true
    else
      puts "購入可能なドリンクはありません"
      VendingMachine.sleep_time(1)
      return false
    end
  end

  def admin_machine
    puts "合言葉は？"
    keyword = gets.chomp
    if keyword == "admin"
      admin
    else
      puts "合言葉が間違っています"
    end
  end


  def admin
    puts "＜メニュー＞"
    puts "1.在庫確認，2.商品追加，3.新規商品登録, 4.売上金確認"
    puts "0.自販機から離れる"
    number = gets.tr('０-９','0-9').to_i
    case number
    when 1 then
      @inventory_control.stock_information
      admin
    when 2 then
      @inventory_control.existing_stock_addition
      admin
    when 3 then
      @inventory_control.new_stock_addition
      admin
    when 4 then
      @money_management.current_sales
      admin
    when 0 then
      puts "お疲れ様でした"
    else
      puts "そんな番号ない"
      admin
    end
  end

  def self.sleep_time(seconds)
    sleep "#{seconds}".to_i
  end


end
