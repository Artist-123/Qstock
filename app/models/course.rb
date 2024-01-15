class Course < ApplicationRecord
  belongs_to :expert
  has_many :purchases
  validates :title, presence: true
  validates :category, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  attr_accessor :credit_card_number, :credit_card_exp_month, :credit_card_exp_year, :credit_card_cvv
  enum payment_method: %i[credit_card]
  attr_accessor :customer_id
  def price_in_cents
    
    (price * 100).to_i
  end
end
