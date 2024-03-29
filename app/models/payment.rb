class Payment < ApplicationRecord
  attr_accessor :credit_card_number, :credit_card_exp_month, :credit_card_exp_year, :credit_card_cvv
  belongs_to :order
  before_validation :create_on_stripe
  def create_on_stripe
    token = get_token
    params = { amount: order.amount_cents, currency: 'usd', source: token}
    response = Stripe::Charge.create(params)
    self.stripe_id = response.id
  end
  def get_token
    Stripe::Token.create({
      card: {
        number: "4242424242424242",
        exp_month: "11",
        exp_year: "2026",
        cvc: "1234"
      }
    })
  end
end
