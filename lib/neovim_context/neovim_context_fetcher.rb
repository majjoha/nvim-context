# frozen_string_literal: true

require "json"

class NeovimContextFetcher
  class << self
    def fetch
      NeovimContext::NeovimConnector.new.connect do |client|
        context = NeovimContext::ContextBuilder.build(client: client)
        NeovimContext::ContextOutputter.output(context)
      end
    rescue NeovimContext::NeovimConnectionError => e
      handle_error(:connection, e)
    rescue NeovimContext::NeovimContextError,
      NeovimContext::NeovimOperationError => e
      handle_error(:extraction, e)
    end

    private

    def handle_error(type, error)
      message = case type
                when :connection then "Connection failed"
                when :extraction then "Context extraction failed"
                end
      NeovimContext::ContextOutputter.output({ error: message,
                                               details: error.message })
    end
  end
end
