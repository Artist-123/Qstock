class Course < ApplicationRecord
  belongs_to :expert
  attr_accessor :credit_card_number, :credit_card_exp_month, :credit_card_exp_year, :credit_card_cvv
  enum payment_method: %i[credit_card]
  attr_accessor :customer_id
end
