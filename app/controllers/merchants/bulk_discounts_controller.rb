class Merchants::BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
  end

  def new
    @discount = BulkDiscount.new
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    discount = merchant.bulk_discounts.new(bulk_discount_params)

    if discount.save
      redirect_to merchant_bulk_discounts_path
    else
      redirect_to new_merchant_bulk_discount_path
      flash[:error] = "Error: #{error_message(discount.errors)}"
    end
  end

  def destroy
    BulkDiscount.destroy(params[:id])

    redirect_to merchant_bulk_discounts_path
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
  end

  def update
    discount = BulkDiscount.find(params[:id])
    if discount.update(bulk_discount_params)
      redirect_to merchant_bulk_discount_path
      flash[:success] = 'Bulk discount successfully updated!'
    else
      redirect_to edit_merchant_bulk_discount_path
      flash[:error] = "Error: #{error_message(discount.errors)}"
    end
  end

  private
  def bulk_discount_params
    params.require(:bulk_discount).permit(:name, :percent_discount, :quantity_threshold)
  end
end