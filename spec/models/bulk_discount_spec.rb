require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :percent_discount }
    it { should validate_presence_of :quantity_threshold }

    it { should validate_numericality_of :percent_discount }
    it { should validate_numericality_of :quantity_threshold }
  end

  describe 'class_methods' do
    describe '.which_discount' do
      before :each do
        @merchant = create(:random_merchant)
        @merchant2 = create(:random_merchant)
        @item_1 = create(:random_item, merchant: @merchant)
        @invoice_1 = create(:random_invoice)
        @invoice_item_1 = create(:random_invoice_item, quantity: 75, unit_price: 17600, status: 'pending', item: @item_1, invoice: @invoice_1)
    
        @discount1 = create(:bulk_discount, merchant: @merchant, quantity_threshold: 76, percent_discount: 90) #too high of a threshold
        @discount2 = create(:bulk_discount, merchant: @merchant, quantity_threshold: 10, percent_discount: 1) #percent discount too low
        @discount3 = create(:bulk_discount, merchant: @merchant, quantity_threshold: 15, percent_discount: 15)
        @discount4 = create(:bulk_discount, merchant: @merchant2, quantity_threshold: 1, percent_discount: 99) #wrong merchant
      end

      it 'returns the max discount the merchant is offering' do
        expect(BulkDiscount.which_discount(@invoice_item_1).first).to eq(@discount3)
      end
    end
  end
end
