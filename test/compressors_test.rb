require 'test_helper'

class CompressorsTest < ActiveSupport::TestCase
  setup do
    @compressor = Emcee::Compressors::HtmlCompressor.new
  end

  test "compressor should remove html comments" do
    content = <<-EOS.strip_heredoc
      <!--
        What will we do with all
        of these html comments?
      -->
      <span>The span to end all spans</span>
    EOS
    assert_equal @compressor.compress(content), <<-EOS.strip_heredoc
      <span>The span to end all spans</span>
    EOS
  end

  test "compressor should remove multi-line javascript comments" do
    content = <<-EOS.strip_heredoc
      <script>
        /*
        Here are some comments that
        go over many, many lines.
        */
      </script>
    EOS
    assert_equal @compressor.compress(content), <<-EOS.strip_heredoc
      <script>
      </script>
    EOS
  end

  test "compressor should remove single-line javascript comments" do
    content = <<-EOS.strip_heredoc
      <script>
        // Here is a comment.
        // Here is another coment.
      </script>
    EOS
    assert_equal @compressor.compress(content), <<-EOS.strip_heredoc
      <script>
      </script>
    EOS
  end

  test "compressor should remove css comments" do
    content = <<-EOS.strip_heredoc
      <style>
        h1 {
          /*
          Make it pink
          */
          color: pink;
        }
      </style>
    EOS
    assert_equal @compressor.compress(content), <<-EOS.strip_heredoc
      <style>
        h1 {
          color: pink;
        }
      </style>
    EOS
  end

  test "compressor should remove blank lines" do
    content = <<-EOS.strip_heredoc
      <p>test</p>



      <p>oh yeah</p>

      <p>test</p>
    EOS
    assert_equal @compressor.compress(content), <<-EOS.strip_heredoc
      <p>test</p>
      <p>oh yeah</p>
      <p>test</p>
    EOS
  end

  test "compressor should not attempt to remove javascript comments within a string" do
    content = <<-EOS.strip_heredoc
      <script>
        var url = 'http://www.w3.org/2000/svg';
      </script>
    EOS
    assert_equal @compressor.compress(content), content
  end
end
