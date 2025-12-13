# frozen_string_literal: true

require "json"

module NeovimContext
  class ContextOutputter
    def self.output(context)
      puts JSON.generate(context)
    rescue StandardError => e
      puts JSON.generate({
                           error: "No Neovim context available",
                           details: e.message
                         })
    end
  end
end
