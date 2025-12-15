# frozen_string_literal: true

require "json"

module NeovimContext
  class NeovimContextFetcher
    class << self
      def fetch
        NeovimConnector.new.connect do |client|
          context = ContextBuilder.build(client: client)
          ContextOutputter.output(context)
        end
      rescue NeovimConnectionError => e
        handle_error(:connection, e)
      rescue NeovimContextError,
        NeovimOperationError => e
        handle_error(:extraction, e)
      end

      private

      def handle_error(type, error)
        message = case type
                  when :connection then "Connection failed"
                  when :extraction then "Context extraction failed"
                  end
        ContextOutputter.output({ error: message,
                                  details: error.message })
      end
    end
  end
end
