require 'rails_helper'

RSpec.describe 'bulk discount edit page' do
  before :each do
    @merchant = create(:random_merchant)
    @discount = create(:bulk_discount, merchant: @merchant)
  end

  describe 'there is a link to edit on the show page' do
    it 'clicking the link takes you to the edit page' do
      visit merchant_bulk_discount_path(@merchant, @discount)
  
      click_on 'Edit Bulk Discount'
  
      expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant, @discount))
    end
  end

  context 'you are on the bulk discount edit page' do
    before :each do
      visit edit_merchant_bulk_discount_path(@merchant, @discount)
    end

    it 'the page is pre-filled' do
      expect(find_field('Name').value).to eq(@discount.name)
      expect(find_field('Percent discount').value).to eq(@discount.percent_discount.to_s)
      expect(find_field('Quantity threshold').value).to eq(@discount.quantity_threshold.to_s)
    end

    it 'submitting changed values updates them' do
      fill_in 'Name', with: 'NewName'
      fill_in 'Percent discount', with: 19
      fill_in 'Quantity threshold', with: 45
      click_on 'Update Bulk discount'

      expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @discount))
      expect(page).to have_content('Bulk discount successfully updated!')
      expect(page).to have_content('NewName')
      expect(page).to have_content('19%')
      expect(page).to have_content('45 items')
    end

    it 'submitting an empty form returns errors' do
      fill_in 'Name', with: ''
      fill_in 'Percent discount', with: ''
      fill_in 'Quantity threshold', with: ''
      click_on 'Update Bulk discount'

      expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant, @discount))
      expect(page).to have_content("Error: Name can't be blank, Percent discount can't be blank, Percent discount is not a number, Quantity threshold can't be blank, Quantity threshold is not a number")
    end
  end
end