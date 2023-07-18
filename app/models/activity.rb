class Activity < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :customer, optional: true
  belongs_to :container
  has_many :activity_repair_lists
  has_many :logs

  enum activity_type: { quote_form: 0, inspection_form: 1, repair_form: 2 }
  enum status: {draft: 0, quote_pending: 1, quote_accepted: 2,  quote_approved: 3, repair_done: 4, 
                repair_approved: 5, ready_for_billing: 6, billed: 7, invoice_generated: 8}
end
