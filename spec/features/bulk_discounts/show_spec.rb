require 'rails_helper'

RSpec.describe 'bulk discount show page' do
  before :each do
    @merchant = create(:random_merchant)
    @discount = create(:bulk_discount, merchant: @merchant)
  end

  describe 'you are on the discounts index page' do
    it 'has a link to take you to the specific discount show page' do
      visit merchant_bulk_discounts_path(@merchant)

      click_on @discount.name

      expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @discount))
    end
  end
end