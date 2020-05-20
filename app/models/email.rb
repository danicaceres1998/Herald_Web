class Email < ApplicationRecord
  validates :contacts, presence: true
  validates :message, presence: true
end