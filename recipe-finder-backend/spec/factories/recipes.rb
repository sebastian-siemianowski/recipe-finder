FactoryBot.define do
  factory :recipe do
    title { "Golden Sweet Cornbread" }
    cook_time { 25 }
    prep_time { 10 }
    ratings { 4.74 }
    cuisine { "" }
    category { "Cornbread" }
    author { "bluegirl" }
    image { "https://example.com/image.jpg" }
  end
end
