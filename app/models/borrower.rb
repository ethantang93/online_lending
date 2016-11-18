class Borrower < ActiveRecord::Base
  email_regex = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i
  validates :first_name, :last_name, presence: :true
  validates :email, :format =>{ :with => email_regex }, :uniqueness => { :case_sensitive => false}
  validates :password, presence: :true, on: :create, confirmation: true
  validates :money, :purpose, :description, :raised, presence: :true
  has_many :histories
  has_many :borrowing_histories, through: :histories, source: :lender
end
