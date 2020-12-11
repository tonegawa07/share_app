require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end

  test "micropost interface" do
    # @userでログイン
    log_in_as(@user)
    # root_pathにgetのリクエスト
    get root_path
    # 特定のHTMLタグが存在する→ class = "pagination"を持つdiv
    assert_select 'div.pagination'
    ## 無効な送信
    # ブロックで渡されたものを呼び出す前後でMicropost.countに違いがない
    assert_no_difference 'Micropost.count' do
      # microposts_pathにpostのリクエスト　→　micropost: { content: "" }（無効なデータ）
      post microposts_path, params: { micropost: { content: "" } }
    end
    # 特定のHTMLタグが存在する→　id = "error_explanation"を持つdiv
    assert_select 'div#error_explanation'
    # 有効な送信
    # contentに代入　→　"This micropost really ties the room together"
    content = "This micropost really ties the room together"
    # ブロックで渡されたものを呼び出す前後でMicropost.countが+1
    assert_difference 'Micropost.count', 1 do
      # microposts_pathにpostのリクエスト　→　micropost: { content: content }（有効なデータ）
      post microposts_path, params: { micropost: { content: content } }
    end
    # root_urlにリダイレクト
    assert_redirected_to root_url
    #　指定されたリダイレクト先に移動
    follow_redirect!
    # 表示されたページのHTML本文すべての中にcontentが含まれている
    assert_match content, response.body
    # 投稿を削除する
    # 特定のHTMLタグが存在する→　text: '削除'を持つa
    assert_select 'a', text: 'delete'
    # first_micropostに代入　@user.micropostsの1ページ目の1番目のマイクロポスト
    first_micropost = @user.microposts.paginate(page: 1).first
    # ブロックで渡されたものを呼び出す前後でMicropost.countが-1
    assert_difference 'Micropost.count', -1 do
      # micropost_path(first_micropost)にdeleteのリクエスト
      delete micropost_path(first_micropost)
    end
    # 違うユーザーのプロフィールにアクセス (削除リンクがないことを確認)
    # user_path(users(:archer))にgetのリクエスト
    get user_path(users(:archer))
    # 特定のHTMLタグが存在する→　text: '削除'を持つaが0個
    assert_select 'a', text: 'delete', count: 0
  end
end
