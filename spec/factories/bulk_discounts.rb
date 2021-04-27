FactoryBot.define do
  factory :bulk_discount do
    percent_discount { 1 }
    quantity_threshold { 1 }

    association :merchant, factory: :random_merchant
  end
end
