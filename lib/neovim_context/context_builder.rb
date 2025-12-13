# frozen_string_literal: true

require "neovim"

module NeovimContext
  class ContextBuilder
    def self.build(client:)
      {
        cursor: NeovimDataExtractor.cursor_info(client: client),
        file: NeovimDataExtractor.file_info(client: client),
        selection: NeovimDataExtractor.visual_selection(client: client),
        diagnostics: NeovimDataExtractor.diagnostics(client: client)
      }
    end
  end
end
