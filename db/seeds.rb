# メインのサンプルユーザーを1人作成する
User.create!(name:  "Example User",
  email: "example@railstutorial.org",
  password:              "foobar",
  password_confirmation: "foobar",
  admin: true,
  activated: true,
  activated_at: Time.zone.now)

# 追加のユーザーをまとめて生成する
99.times do |n|
name  = Faker::Name.name
email = "example-#{n+1}@railstutorial.org"
password = "password"
User.create!(name:  name,
    email: email,
    password:              password,
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now)
end

# ユーザーの一部を対象にマイクロポストを生成する
users = User.order(:created_at).take(6)
50.times do
  # contetに　Faker::Loremで作ったサンプルを代入（Faker::Loremから文章を5個取り出す）
  content = Faker::Lorem.sentence(word_count: 5)
  # 取り出した要素をuserに代入　userに紐づいたmicropostを作成（content属性に変数contentの値）
  users.each { |user| user.microposts.create!(content: content) }
end