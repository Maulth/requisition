module NotificationHelper

  def send_notification(order)
    PurchaseMailer.purchase_order(order).deliver
  end
end
