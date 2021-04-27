require 'rails_helper'

RSpec.describe 'bulk discounts show page' do
  before :each do
    @merchant = create(:random_merchant)
    @discount1 = create(:bulk_discount, merchant: @merchant)
    @discount2 = create(:bulk_discount, merchant: @merchant)
  end
  
  context 'you are on a merchant dashboard page' do
    it 'a link will take you to their discounts' do
      visit merchant_dashboard_index_path(@merchant)

      click_on 'My Discounts'

      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant))
    end
  end

  context 'you are on the bulk discounts show page' do
    before :each do
      visit merchant_bulk_discounts_path(@merchant)
    end

    it 'has the name of the merchant' do
      expect(page).to have_content(@merchant.name)
    end

    it "has a list of the merchant's discounts and all their percentages and thresholds" do
      expect(page).to have_link(@discount1.name)
      expect(page).to have_link(@discount2.name)

      expect(page).to have_content(@discount1.percent_discount)
      expect(page).to have_content(@discount2.percent_discount)

      expect(page).to have_content(@discount1.quantity_threshold)
      expect(page).to have_content(@discount2.quantity_threshold)
    end

    it 'has a button to create a new bulk discount' do
      expect(page).to have_link('New Bulk Discount')
    end

    context 'you want to delete a bulk discount' do
      before :each do
        visit merchant_bulk_discounts_path(@merchant)
      end

      it 'has a button to delete bulk discounts' do
        expect(page).to have_button('Delete')
      end

      it 'clicking the button deletes the specific discount' do
        first(:button, 'Delete').click

        expect(current_path).to eq(merchant_bulk_discounts_path(@merchant))
        expect(page).to_not have_content(@discount1.name)
        expect(page).to have_content(@discount2.name)
      end
    end
  end
end