# frozen_string_literal: true

require "neovim"

module NeovimContext
  class NeovimConnector
    def initialize(client: nil)
      @client = client || begin
        Neovim.attach_unix(SOCKET_PATH)
      rescue StandardError => e
        raise NeovimConnectionError,
              "Failed to connect to Neovim socket: #{e.message}"
      end
    end

    def connect
      yield client if block_given?
    rescue StandardError => e
      raise NeovimOperationError, "Failed during Neovim operation: #{e.message}"
    end

    private

    SOCKET_PATH = ".opencode/nvim.sock"

    attr_reader :client
  end
end
