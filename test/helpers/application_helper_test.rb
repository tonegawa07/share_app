require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title,              "Share App"
    assert_equal full_title("Help"),   "Help" + " | " + "Share App"
  end
end