# frozen_string_literal: true

require_relative "../../spec_helper"

RSpec.describe NeovimContext::NeovimContextFetcher do
  let(:client) { instance_double(Neovim::Client) }
  let(:context) { { cursor: { line: 1, col: 0 }, file: "/path/to/file.rb" } }

  describe ".fetch" do
    before do
      connector = double
      allow(connector).to receive(:connect).and_yield(client)
      allow(NeovimContext::NeovimConnector).to receive(:new)
        .and_return(connector)
      allow(NeovimContext::ContextBuilder).to receive(:build)
        .and_return(context)
      allow(NeovimContext::ContextOutputter).to receive(:output)
        .and_call_original
    end

    it "orchestrates connection, building, and output" do
      described_class.fetch

      expect(NeovimContext::ContextOutputter)
        .to have_received(:output).with(context)
    end

    context "when connection fails" do
      before do
        allow(NeovimContext::NeovimConnector).to receive(:new).and_raise(
          NeovimContext::NeovimConnectionError.new("Socket error")
        )
      end

      it "outputs connection error" do
        described_class.fetch

        expect(NeovimContext::ContextOutputter).to have_received(:output).with(
          { error: "Connection failed", details: "Socket error" }
        )
      end
    end

    context "when context extraction fails" do
      before do
        allow(NeovimContext::ContextBuilder).to receive(:build).and_raise(
          NeovimContext::NeovimContextError.new("Build error")
        )
      end

      it "outputs extraction error" do
        described_class.fetch

        expect(NeovimContext::ContextOutputter).to have_received(:output).with(
          { error: "Context extraction failed", details: "Build error" }
        )
      end
    end
  end
end
