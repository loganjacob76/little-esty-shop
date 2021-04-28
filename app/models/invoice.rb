class Invoice < ApplicationRecord
  belongs_to :customer

  has_many :transactions, dependent: :destroy

  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items

  enum status: [:"in progress", :cancelled, :completed]

  def self.where_not_successful
    self.joins(:invoice_items)
        .where.not("invoice_items.status=2")
        .order(:created_at)
        .distinct
  end

  def total_revenue
    invoice_items.sum("invoice_items.unit_price * invoice_items.quantity")
  end

  def current_discounts
    invoice_items.joins(item: [merchant: :bulk_discounts])
    .where('bulk_discounts.quantity_threshold <= invoice_items.quantity')
    .select('invoice_items.id, max(invoice_items.unit_price * invoice_items.quantity * (bulk_discounts.percent_discount / 100.0)) as amount_saved')
    .group(:id)
    .map do |iv_item|
      iv_item.amount_saved.to_i
    end.sum
  end

  def net_profits
    total_revenue - current_discounts
  end
end
