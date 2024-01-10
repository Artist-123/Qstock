class Order < ApplicationRecord

   attr_accessor :credit_card_number, :credit_card_exp_month, :credit_card_exp_year, :credit_card_cvv
  belongs_to :customer
  has_one :payment
  after_create :create_payment

  # Add as much as you need
  # Example: enum payment_method: %i[credit_card ach boleto]
  enum payment_method: %i[credit_card]
  def create_payment
    params = {
      order_id: id,
      credit_card_number: "4242424242424242",
      credit_card_exp_month: "11",
      credit_card_exp_year: "2026",
      credit_card_cvv: "1234"
    }
    Payment.create!(params)
  end
end
