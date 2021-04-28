class BulkDiscount < ApplicationRecord
  belongs_to :merchant

  validates :name, presence: true
  validates :percent_discount, presence: true, numericality: true
  validates :quantity_threshold, presence: true, numericality: true

  def self.which_discount(invoice_item)
    where('bulk_discounts.quantity_threshold <= ?', invoice_item.quantity)
    .where('bulk_discounts.merchant_id = ?', invoice_item.item.merchant_id)
    .order(percent_discount: :desc)
    .limit(1)
  end
end
