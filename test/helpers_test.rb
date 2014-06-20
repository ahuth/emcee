require 'test_helper'

class Helpers < ActionView::TestCase
  test "html_import should work" do
    assert_equal "<link href=\"/components/test.html\" rel=\"import\" />", html_import_tag("test")
  end
end
