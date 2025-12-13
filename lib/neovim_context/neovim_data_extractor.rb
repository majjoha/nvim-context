# frozen_string_literal: true

module NeovimContext
  class NeovimDataExtractor
    def self.cursor_info(client:)
      cursor = client.current.window.cursor
      { line: cursor[0], col: cursor[1] }
    rescue StandardError => e
      raise NeovimContextError,
            "Failed to get cursor info: #{e.message}"
    end

    def self.file_info(client:)
      client.current.buffer.name
    rescue StandardError => e
      raise NeovimContextError,
            "Failed to get file info: #{e.message}"
    end

    def self.visual_selection(client:)
      return nil unless visual_mode?(client)

      marks = visual_marks(client)
      text = selected_text(client, marks)
      build_selection_info(marks, text)
    rescue StandardError
      nil
    end

    def self.diagnostics(client:)
      client.eval("vim.diagnostic.get(0)").map do |diagnostic|
        {
          line: diagnostic["lnum"] + 1,
          col: diagnostic["col"] + 1,
          message: diagnostic["message"],
          severity: diagnostic["severity"]
        }
      end
    rescue StandardError
      []
    end

    class << self
      private

      def visual_mode?(client)
        ["v", "V", "\x16"].include?(client.eval("mode()"))
      end

      def visual_marks(client)
        {
          start: client.eval("getpos(\"'<\")"),
          end: client.eval("getpos(\"'>\")")
        }
      end

      def selected_text(client, marks)
        start_line = marks[:start][1]
        end_line = marks[:end][1]
        client.eval("getline(#{start_line}, #{end_line})")
      end

      def build_selection_info(marks, text)
        {
          start: { line: marks[:start][1], col: marks[:start][2] },
          end: { line: marks[:end][1], col: marks[:end][2] },
          text: text.join("\n")
        }
      end
    end
  end
end
