# frozen_string_literal: true

require "json"
require_relative "../../spec_helper"

RSpec.describe NeovimContext::NeovimContextFetcher do
  let(:client) { instance_double(Neovim::Client) }
  let(:connector) { instance_double(NeovimContext::NeovimConnector) }
  let(:context) { { cursor: { line: 1, col: 0 }, file: "/path/to/file.rb" } }

  describe ".fetch" do
    before do
      allow(NeovimContext::NeovimConnector).to receive(:new)
        .and_return(connector)
      allow(connector).to receive(:connect).and_yield(client)
      allow(NeovimContext::ContextBuilder).to receive(:build)
        .and_return(context)
    end

    it "returns the context as JSON" do
      expect(described_class.fetch).to eq(JSON.generate(context))
    end

    context "when connection fails" do
      before do
        allow(NeovimContext::NeovimConnector).to receive(:new).and_raise(
          NeovimContext::NeovimConnectionError.new("Socket error")
        )
      end

      it "returns connection error as JSON" do
        expect(described_class.fetch).to eq(JSON.generate({
          error: "Connection failed", details: "Socket error"
        }))
      end
    end

    context "when context extraction fails" do
      before do
        allow(NeovimContext::ContextBuilder).to receive(:build).and_raise(
          NeovimContext::NeovimContextError.new("Build error")
        )
      end

      it "returns extraction error as JSON" do
        expect(described_class.fetch).to eq(JSON.generate({
          error: "Context extraction failed", details: "Build error"
        }))
      end
    end
  end
end
