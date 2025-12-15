# frozen_string_literal: true

require "neovim"

module NeovimContext
  class NeovimConnector
    def initialize(client: nil)
      @socket_path = ENV["NVIM_CONTEXT_SOCKET"] || DEFAULT_SOCKET_PATH
      @client = client || begin
        Neovim.attach_unix(socket_path)
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

    attr_reader :client, :socket_path

    DEFAULT_SOCKET_PATH = File.expand_path("neovim-context.sock")
    private_constant :DEFAULT_SOCKET_PATH
  end
end
