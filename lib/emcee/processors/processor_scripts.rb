module Emcee
  module Processors
    module Includes
      # Match a script tag.
      #
      #   <script src="assets/example.js"></script>
      #
      SCRIPT_PATTERN = /^ *<script .*src=["'].+\.js["']><\/script>$/

      # Scan the body for external script references. If any are found, inline
      # the files in place of the references and return the new body.
      def process_scripts(body, directory)
        to_inline = []

        body.scan(SCRIPT_PATTERN) do |script_tag|
          if path = script_tag[SRC_PATH_PATTERN, :path]
            absolute_path = File.absolute_path(path, directory)
            script_contents = read_file(absolute_path)
            to_inline << [script_tag, "<script>" + script_contents + "</script>"]
          end
        end

        to_inline.reduce(body) do |output, (tag, contents)|
          output.gsub(tag, contents)
        end
      end
    end
  end
end
