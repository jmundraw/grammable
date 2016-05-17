FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "dummyEmail#{n}@gmail.com"
    end
    password "password"
    password_confirmation "password"
  end

    factory :gram do
      message "hello"
      association :user
    end
end