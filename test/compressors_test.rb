require 'test_helper'

class CompressorsTest < ActiveSupport::TestCase
  setup do
    @compressor = Emcee::Compressors::HtmlCompressor.new
  end

  test "compressor should remove html comments" do
    content = %q{
      <!--
        What will we do with all
        of these html comments?
      -->
      <span>The span to end all spans</span>
    }
    assert_equal "\n" + @compressor.compress(content), %q{
      <span>The span to end all spans</span>
    }
  end

  test "compressor should remove multi-line javascript comments" do
    content = %q{
      <script>
        /*
        Here are some comments that
        go over many, many lines.
        */
      </script>
    }
    assert_equal "\n" + @compressor.compress(content), %q{
      <script>
      </script>
    }
  end

  test "compressor should remove single-line javascript comments" do
    content = %q{
      <script>
        // Here is a comment.
        // Here is another coment.
      </script>
    }
    assert_equal "\n" + @compressor.compress(content), %q{
      <script>
      </script>
    }
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
    assert_equal "\n" + @compressor.compress(content), %q{
      <style>
        h1 {
          color: pink;
        }
      </style>
    }
  end

  test "compressor should remove blank lines" do
    content = %q{
      <p>test</p>



      <p>oh yeah</p>

      <p>test</p>
    }
    assert_equal "\n" + @compressor.compress(content), %q{
      <p>test</p>
      <p>oh yeah</p>
      <p>test</p>
    }
  end

  test "compressor should not remove javascript comments within a string" do
    content = %q{
      <script>
        var url = 'http://www.w3.org/2000/svg';
      </script>
    }
    assert_equal "\n" + @compressor.compress(content), %q{
      <script>
        var url = 'http://www.w3.org/2000/svg';
      </script>
    }
  end
end
