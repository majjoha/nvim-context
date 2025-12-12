# frozen_string_literal: true

require "neovim"

module NeovimContext
  class NeovimContextError < StandardError; end

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
  end
end
