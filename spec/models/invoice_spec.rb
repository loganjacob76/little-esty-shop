require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "relationships" do
    it {should belong_to :customer}
    it {should have_many :transactions}
    it {should have_many :invoice_items}
    it {should have_many :items}
  end

  describe 'class methods' do
    describe '.where_not_successful' do
      it 'returns all the invoices where the items have not been shipped' do
        invoice = create(:random_invoice)
        invoice_2 = create(:random_invoice)
        invoice_3 = create(:random_invoice)

        invoice_item_1 = create(:random_invoice_item, status: 2, invoice: invoice)
        invoice_item_2 = create(:random_invoice_item, status: 1, invoice: invoice_2)
        invoice_item_3 = create(:random_invoice_item, status: 0, invoice: invoice_3)

        expect(Invoice.where_not_successful).to eq([invoice_2, invoice_3])

        invoice_item_4 = create(:random_invoice_item, status: 0, invoice: invoice)

        expect(Invoice.where_not_successful).to eq([invoice, invoice_2, invoice_3])
      end
    end
  end

  describe 'instance methods' do
    before :each do
      @merchant = create(:random_merchant)
      @merchant2 = create(:random_merchant)
      @item_1 = create(:random_item, merchant: @merchant)
      @invoice = create(:random_invoice)
      @invoice_item_1 = create(:random_invoice_item, quantity: 15, unit_price: 160, status: 'pending', item: @item_1, invoice: @invoice) # 2040 after discount 4
      @invoice_item_2 = create(:random_invoice_item, quantity: 10, unit_price: 100, status: 'pending', item: @item_1, invoice: @invoice) # 900 after discount 3
      @invoice_item_3 = create(:random_invoice_item, quantity: 1, unit_price: 10, status: 'pending', item: @item_1, invoice: @invoice) # no discount
  
      @discount1 = create(:bulk_discount, merchant: @merchant, quantity_threshold: 76, percent_discount: 90) #threshold too high
      @discount2 = create(:bulk_discount, merchant: @merchant, quantity_threshold: 10, percent_discount: 1) # discount too low
      @discount3 = create(:bulk_discount, merchant: @merchant, quantity_threshold: 5, percent_discount: 10)
      @discount4 = create(:bulk_discount, merchant: @merchant, quantity_threshold: 15, percent_discount: 15)
      @discount5 = create(:bulk_discount, merchant: @merchant2, quantity_threshold: 1, percent_discount: 99) #different merchant
    end

    describe '#total_revenue' do
      it 'calculates the total revenue of an invoice' do
        expect(@invoice.total_revenue).to eq(3410)
      end
    end

    describe '#current_discounts' do
      it 'returns the total amount saved with the bulk discounts' do
        expect(@invoice.current_discounts).to eq(460)
      end
    end

    describe '#net_profits' do
      it 'returns the total revenue after the savings have been deducted' do
        expect(@invoice.net_profits).to eq(2950)
      end
    end
  end
end
