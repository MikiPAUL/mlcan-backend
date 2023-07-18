class Container < ApplicationRecord
  has_many :container_attachments
  has_many :activity
  has_many :comments
  has_many :log
  belongs_to :customer
end
