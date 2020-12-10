require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    # このコードは慣習的に正しくない
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  test "should be valid" do
    # @micropostが有効である
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id = nil
    # @micropostが有効でない
    assert_not @micropost.valid?
  end

  test "content should be present" do
    @micropost.content = " "
    # @micropostが有効でない
    assert_not @micropost.valid?
  end
  
    
  test "content shoule be at most 140 characters"do
    @micropost.content = "a"*141
    # @micropostが有効でない
    assert_not @micropost.valid?
  end

  test "order should be most recent first" do
    # 第一引数と第二引数が等しい　microposts（fixture）の:most_recent　と　Micropostオブジェクトの1つ目
    assert_equal microposts(:most_recent), Micropost.first
  end

end
