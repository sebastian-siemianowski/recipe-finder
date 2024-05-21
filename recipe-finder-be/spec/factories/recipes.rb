FactoryBot.define do
  factory :recipe do
    sequence(:title) { |n| "Golden Sweet Cornbread Recipe #{n}" }
    cook_time { 25 }
    prep_time { 10 }
    ratings { 4.74 }
    cuisine { "" }
    category { "Cornbread" }
    author { "bluegirl" }
    image { "https://example.com/image.jpg" }
  end
end
