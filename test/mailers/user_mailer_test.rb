require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  test "account_activation" do
    # userにmichaelを代入
    user = users(:michael)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    # "Share App アカウント認証メール"とmail.subjectが等しい
    assert_equal "Share App アカウント認証メール", mail.subject
    # user.emailとmail.toが等しい
    assert_equal [user.email], mail.to
    # "noreply@example.org"とmail.fromが等しい    
    assert_equal ["noreply@example.com"], mail.from
    # user.nameが本文に含まれる
    assert_match user.name,                     mail.body.encoded
    # user.activationが本文に含まれる
    assert_match user.activation_token,     mail.body.encoded
    # 特殊文字をescapeしたuser.mailが本文に含まれる
    assert_match CGI.escape(user.email),  mail.body.encoded
  end

  test "password_reset" do
    # userにmichaelを代入
    user = users(:michael)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    # "Share App パスワードリセットメール"とmail.subjectが等しい
    assert_equal "Share App パスワードリセットメール", mail.subject
    # user.emailとmail.toが等しい
    assert_equal [user.email], mail.to
    # "noreply@example.org"とmail.fromが等しい    
    assert_equal ["noreply@example.com"], mail.from
    # user.resetが本文に含まれる
    assert_match user.reset_token,           mail.body.encoded
    # 特殊文字をescapeしたuser.mailが本文に含まれる
    assert_match CGI.escape(user.email),  mail.body.encoded
  end
end
