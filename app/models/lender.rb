class Lender < ActiveRecord::Base
  email_regex = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i
  validates :first_name, :last_name, presence: :true
  validates :email, :format =>{ :with => email_regex }, :uniqueness => { :case_sensitive => false}
  validates :password, presence: :true, on: :create, confirmation: true
  validates :money, presence: :true
  has_many :histories, dependent: :destroy
  has_many :lending_history, through: :histories, source: :borrower
end
