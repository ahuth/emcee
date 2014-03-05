require 'test_Helper'

class CompressorsTest < ActiveSupport::TestCase
  setup do
    @compressor = Emcee::Compressors::HtmlCompressor.new
  end

  test "compressor should remove html comments" do
    content = "<!--\nHere\nAre\nSome Comments\n-->\n<span>test</span>\n"
    assert_equal "<span>test</span>\n", @compressor.compress(content)
  end

  test "compressor should remove multi-line javascript comments" do
    content = "<script>\n/*\nHere\nAre\nA Bunch\nOf Comments\n*/\n</script>\n"
    assert_equal "<script>\n</script>\n", @compressor.compress(content)
  end

  test "compressor should remove single-line javascript comments" do
    content = "<script>\n// Here\n// Are Yet\n// Some More\n// Of The\n// Comments\n</script>\n"
    assert_equal "<script>\n</script>\n", @compressor.compress(content)
  end

  test "compressor should remove css comments" do
    content = %q{
<style>
  h1 {
    /*
    Make it pink
    */
    color: pink;
  }
</style>
}
  assert_equal "<style>\n  h1 {\n    color: pink;\n  }\n</style>\n", @compressor.compress(content)
  end

  test "compressor should remove blank lines" do
    content = "<p>test</p>\n\n\n\n\n\n<p>oh yeah</p>"
    assert_equal "<p>test</p>\n<p>oh yeah</p>", @compressor.compress(content)
  end
end
