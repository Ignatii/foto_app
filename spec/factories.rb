
FactoryBot.define do
  
  factory :user do
    id 1
    insta_token '4088921481.a999fd0.64eec4699b2946d1882946ec2d8762e1'
    api_token "5FB23t5kK8g1RfSMkyzua3YA624="
    name "RspecUser"
    email "rspec@test.com"
  end

  factory :image do
    id 1
    user_id 1
    image File.open("/home/ignatiy/Загрузки/index.jpeg",'r')
    created_at "2018-03-28 10:55:18"
    updated_at "2018-03-28 13:10:33"
    aasm_state "verified"
    title_img "Тверской бомонд на выезде 😁 "
    tags "friends saintpetersburg bomondtver"
    likes_img 1
  end
  
  factory :comment do
    id 1
    user_id 1
    body 'test comment to test'
    commentable_id 1
    commentable_type 'Image'
  end
  
  factory :identity do
    id 1
    user_id 1
    provider 'vkontakte'
    uid 11685678
    token 'FJjnjdfjn545njbebfnm4k5=45knfdHHB'
  end

  factory :like do
    user_id 1
    image_id 1
  end

end