require 'test_helper'

class Helpers < ActionView::TestCase
  test "html_import should work" do
    assert_equal "<link rel=\"import\" href=\"/components/test.html\" />", html_import_tag("test")
  end
end
