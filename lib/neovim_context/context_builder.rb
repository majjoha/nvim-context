# frozen_string_literal: true

module NeovimContext
  class ContextBuilder
    def self.build(client:)
      {
        cursor: NeovimDataExtractor.cursor(client: client),
        file: NeovimDataExtractor.file(client: client),
        selection: NeovimDataExtractor.visual_selection(client: client),
        diagnostics: NeovimDataExtractor.diagnostics(client: client)
      }
    end
  end
end
