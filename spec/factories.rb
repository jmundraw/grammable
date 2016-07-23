FactoryGirl.define do
  factory :comment do
    
  end
  factory :user do
    sequence :email do |n|
      "dummyEmail#{n}@gmail.com"
    end
    password "password"
    password_confirmation "password"
  end

    factory :gram do
      message "hello"
      picture { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'picture.png'), 'image/png') }
      association :user
    end
end