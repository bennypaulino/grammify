FactoryGirl.define do
  factory :comment do
    message "Whatevah"
    association :gram
    association :user
  end
  
  factory :user do
  	sequence :username do |n|
      "dummyUserName#{n}"
    end
    sequence :email do |n|
      "dummyEmail#{n}@gmail.com"
    end
    password "secretPassword"
    password_confirmation "secretPassword"

  end

  factory :gram do
    message "hello"
    picture { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'picture.png'), 'image/png') }

    association :user
  end
end