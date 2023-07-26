class Activity < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :customer, optional: true
  belongs_to :container
  has_many :activity_repair_lists
  has_many :logs

  enum activity_type: { quote_form: 0, inspection_form: 1, repair_form: 2 }
  enum status: {quote_draft: 0, quote_pending: 1, quote_accepted: 2,  quote_approved: 3, repair_done: 4, inspection_done: 5,
    repair_approved: 6, ready_for_billing: 7, billed: 8, invoice_generated: 9, repair_draft: 10, inspection_draft: 11, 
    quote_issued: 12}
end
