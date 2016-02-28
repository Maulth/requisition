module Api
  class OrdersController < Api::BaseApiController
    def create
      unless current_user.can_place_order?
        flash[:danger] = 'You are not allowed to place orders'
        return render_nothing :unauthorized
      end

      @order = current_user.orders.new permitted_params
      authorize @order
      if @order.save
        flash[:success] = 'Order placed'
        return render status: :created
      end

      render status: :unprocessable_entity
    end

  private

    def permitted_params
      params.require(:order).permit(order_items_attributes: [:item_id, :quantity])
    end
  end
end
