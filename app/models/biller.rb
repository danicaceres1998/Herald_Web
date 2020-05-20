class Biller < ApplicationRecord
  has_many :brands
  validates :error, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :from, presence: true, format: { with: VALID_EMAIL_REGEX }
  validate :check_email_addresses
  def check_email_addresses
    contacts.split('; ').each do |email|
      unless email =~ VALID_EMAIL_REGEX
        errors.add(:contacts, ": this email address -> '#{email}' is invalid")
      end
    end
  end
end