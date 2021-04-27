require 'rails_helper'

RSpec.describe 'bulk discounts show page' do
  before :each do
    @merchant = create(:random_merchant)
    
    visit merchant_dashboard_index_path(@merchant)
  end

  context 'you are on a merchant dashboard page' do
    it 'a link will take you to their discounts' do
      expect(current_path).to eq(merchant_dashboard_index_path(@merchant))
      click_on 'My Discounts'
      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant))
    end
  end
end