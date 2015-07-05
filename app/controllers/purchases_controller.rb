class PurchasesController < ApplicationController
  def index
    for_sale = Item.joins(:category).for_sale.order :name
    @items = {}
    Category.names.each do |name|
      @items[name.to_sym] = for_sale.where categories: { name: name }
    end
  end
end
