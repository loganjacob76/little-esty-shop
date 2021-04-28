require 'rails_helper'

RSpec.describe "Merchant Invoice Show Page" do
  before :each do
    @merchant = create(:random_merchant)
    @merchant2 = create(:random_merchant)
    @item_1 = create(:random_item, merchant: @merchant)
    @invoice_1 = create(:random_invoice)
    @invoice_item_1 = create(:random_invoice_item, quantity: 75, unit_price: 17600, status: 'pending', item: @item_1, invoice: @invoice_1)
    @invoice_item_2 = create(:random_invoice_item, quantity: 1, unit_price: 0, status: 'pending', item: @item_1, invoice: @invoice_1) # no discount

    @discount1 = create(:bulk_discount, merchant: @merchant, quantity_threshold: 76, percent_discount: 90) #too high of a threshold
    @discount2 = create(:bulk_discount, merchant: @merchant, quantity_threshold: 10, percent_discount: 1) #percent discount too low
    @discount3 = create(:bulk_discount, merchant: @merchant, quantity_threshold: 15, percent_discount: 15)
    @discount4 = create(:bulk_discount, merchant: @merchant2, quantity_threshold: 1, percent_discount: 99) #wrong merchant

    visit merchant_invoice_path(@merchant, @invoice_1)
  end

  describe "As a visitor (/merchants/merchant_id/invoices/invoice_id)" do
    it "I see information related to that invoice index" do
      expect(page).to have_content(@invoice_1.id)
      expect(page).to have_content(@invoice_1.status)
      expect(page).to have_content(@invoice_1.created_at.strftime("%A, %B %d, %Y"))

      within ".customer" do
        expect(page).to have_content(@invoice_1.customer.name)
      end
    end

    it "I see information of the items on the invoice" do

      within ".show-items" do
        expect(page).to have_content(@item_1.name)
        expect(page).to have_content(75)
        expect(page).to have_content('$17,600.00')
        expect(page).to have_content('pending')
        expect(page).to have_content('No discount')
        expect(page).to have_link(@discount3.name)

        expect(page).to_not have_link(@discount1.name)
        expect(page).to_not have_link(@discount2.name)
        expect(page).to_not have_link(@discount4.name)
      end
    end

    it "I see total revenue that will be generated from items on invoice" do
      within ".total-revenue" do
        expect(page).to have_content('$1,122,000.00')
      end
    end

    it "I see a dropdown to update the invoice status" do
      expect(page).to have_button('Update Invoice')

      select "completed", from: 'Status'
      click_on 'Update Invoice'
    
      expect(current_path).to eq(merchant_invoice_path(@merchant, @invoice_1))
      expect(page).to have_content("completed")
    end
  end
end
