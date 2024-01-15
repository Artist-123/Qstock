require 'stripe'
Stripe.api_key = "sk_test_51OW2HVSDvSSLi51N8y5VeMxVWQeKETxWFGHndP1ml3XGS7l3Sk8gXTt9WakiuUSo1RH0e55hdtzEjeB5CjE14aVp00tg3UfkVS"
class StripeService
  def self.find_or_create_customer(customer)

    if customer.stripe_id.present?
      stripe_customer = Stripe::Customer.retrieve(customer.stripe_id)
    else
      stripe_customer = Stripe::Customer.create({
        name: customer.name,
        email: customer.email
      })
      customer.update(stripe_id: stripe_customer.id)
    end
    stripe_customer
  end

  def self.create_stripe_customer_card(stripe_customer)
    token = "tok_visa"
    Stripe::Customer.create_source(
      stripe_customer,
      {source: token})
  end

  def self.create_on_stripe_charge(amount, stripe_customer_id, card_id)
    Stripe::Charge.create(
      amount: amount*100,
      currency: 'inr',
      source: card_id,
      customer: stripe_customer_id,
      description: "Account $ #{amount} Charge"
      )
  end
  
end
