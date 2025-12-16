# frozen_string_literal: true

require "json"

module NeovimContext
  class NeovimContextFetcher
    class << self
      def fetch
        context = build_context
        JSON.generate(context)
      rescue NeovimConnectionError => e
        output_error("Connection failed", e.message)
      rescue NeovimContextError => e
        output_error("Context extraction failed", e.message)
      rescue StandardError => e
        output_error("Unexpected error", e.message)
      end

      private

      def build_context
        NeovimConnector.new.connect do |client|
          {
            cursor: NeovimDataExtractor.cursor(client: client),
            file: NeovimDataExtractor.file(client: client),
            selection: NeovimDataExtractor.visual_selection(client: client),
            diagnostics: NeovimDataExtractor.diagnostics(client: client)
          }
        end
      end

      def output_error(error, details)
        JSON.generate({ error: error, details: details })
      end
    end
  end
end
