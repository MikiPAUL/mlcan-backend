class Container < ApplicationRecord
  has_many :container_attachments
  has_many :activity
  has_many :comments
  has_many :logs
  belongs_to :customer
end
