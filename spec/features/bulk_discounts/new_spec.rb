require 'rails_helper'

RSpec.describe 'new bulk discount page' do
  before :each do
    @merchant = create(:random_merchant)
  end

  context 'you are on the bulk discounts index page' do
    it 'the link to create new discount takes you to a new page' do
      visit merchant_bulk_discounts_path(@merchant)
      
      click_on 'New Bulk Discount'

      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant))
    end
  end

  context 'you are on the new bulk discount page' do
    before :each do
      visit new_merchant_bulk_discount_path(@merchant)
    end

    it 'filling out the form creates a new form' do
      fill_in 'Name', with: 'FakeName'
      fill_in 'Percent discount', with: 17
      fill_in 'Quantity threshold', with: 3
      click_on 'Create Bulk discount'

      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant))
      expect(page).to have_content('FakeName')
      expect(page).to have_content('17% off')
      expect(page).to have_content('Need: 3 items')
    end

    it 'submitting a blank form returns errors' do
      click_on 'Create Bulk discount'

      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant))
      expect(page).to have_content("Error: Name can't be blank, Percent discount can't be blank, Percent discount is not a number, Quantity threshold can't be blank, Quantity threshold is not a number")
    end
  end
end