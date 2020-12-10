require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
  end

  test "profile display" do
    # user_path(@user)にgetのリクエスト
    get user_path(@user)
    # テンプレートが描画される　'users/show
    assert_template 'users/show'
    # 特定のHTMLタグが存在する (title)
    assert_select "title", full_title(@user.name)
    # 特定のHTMLタグが存在する (h1)
    assert_select "h1", text: @user.name
    # 特定のHTMLタグが存在する (h1タグに含まれるimg.gravatar)
    assert_select "h1>img.gravatar"
    # 描画されたページに@userのマイクロポストのcountを文字列にしたものが含まれる
    assert_match @user.microposts.count.to_s, response.body
    # 特定のHTMLタグが存在する (class=paginationのdiv)
    assert_select "div.pagination"
    # @user.micropostsのページネーションの1ページ目の配列を1個ずつ取り出してmicropostに代入
    @user.microposts.paginate(page: 1).each do |micropost|
      # このページにmicropost.contentが含まれる
      assert_match micropost.content, response.body
    end
  end

end
