require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  subject { order }
  let(:user) { users(:user1) }
  let(:valid_order) do
    Order.new character_name: 'Gandhi', user: user, order_items_attributes: [{
      item_id: items(:naglfar).id,
      quantity: 1
    }]
  end

  describe 'Sanity' do
    it 'must start with valid fixtures' do
      Order.all.each do |ability|
        ability.valid?.must_equal true, ability.errors.messages
      end
    end
  end

  describe 'Validations' do
    let(:order) { valid_order }

    it 'must create an order' do
      assert_difference 'Order.all.count', 1 do
        order.valid?.must_equal true, order.errors.messages
        order.save.must_equal true, 'Could not save order'
      end
    end

    it 'must contain order items' do
      order.order_items.clear
      order.valid?.must_equal false, 'Order must require items'
    end

    it 'must specify character name' do
      order.character_name = nil
      order.valid?.must_equal false, 'Order must have a character name'
    end

    it 'must specify the user who created the order' do
      order.user = nil
      order.valid?.must_equal false, 'Order must have a user'
    end
  end
end
