module Emcee
  # ScriptProcessor scans a document for external script references and inlines
  # them into the current document.
  class ScriptProcessor
    # Match a script tag.
    #
    #   <script src="assets/example.js"></script>
    #
    SCRIPT_PATTERN = /^\s*<script .*src=["'].+\.js["']><\/script>$/

    # Match the source path from a script tag. Captures the actual path.
    #
    #   src="/assets/example.js"
    #
    SRC_PATH_PATTERN = /src=["'](?<path>[\w\.\/-]+)["']/

    # Match the indentation whitespace of a line
    #
    INDENT_PATTERN = /^(?<indent>\s*)/

    def process(context, data, directory)
      to_inline = find_script_tags(data, directory)
      inline_scripts(data, to_inline)
    end

    private

    def read_file(path)
      File.read(path)
    end

    def find_script_tags(data, directory)
      data.scan(SCRIPT_PATTERN).reduce([]) do |output, script_tag|
        path = script_tag[SRC_PATH_PATTERN, :path]
        return output unless path

        indent = script_tag[INDENT_PATTERN, :indent] || ""
        absolute_path = File.absolute_path(path, directory)
        script_contents = read_file(absolute_path)

        output << [script_tag, "#{indent}<script>#{script_contents}\n#{indent}</script>"]
      end
    end

    def inline_scripts(data, scripts)
      scripts.reduce(data) do |output, (tag, contents)|
        output.gsub(tag, contents)
      end
    end
  end
end
