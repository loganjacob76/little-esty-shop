FactoryBot.define do
  factory :bulk_discount do
    sequence(:name) { |n| "#{Faker::Beer.name}#{n}" }
    percent_discount { 1 }
    quantity_threshold { 1 }

    association :merchant, factory: :random_merchant
  end
end
