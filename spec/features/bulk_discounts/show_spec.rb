require 'rails_helper'

RSpec.describe 'bulk discount show page' do
  before :each do
    @merchant = create(:random_merchant)
    @discount = create(:bulk_discount, merchant: @merchant)
  end

  context 'you are on the discounts index page' do
    it 'has a link to take you to the specific discount show page' do
      visit merchant_bulk_discounts_path(@merchant)

      click_on @discount.name

      expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @discount))
    end
  end

  context 'you are on the discount show page' do
    it 'has the quantity threshold and percent discount' do
      visit merchant_bulk_discount_path(@merchant, @discount)
      
      expect(page).to have_content(@discount.quantity_threshold)
      expect(page).to have_content(@discount.percent_discount)
    end
  end
end