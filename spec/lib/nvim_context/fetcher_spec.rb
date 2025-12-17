# frozen_string_literal: true

require "json"
require_relative "../../spec_helper"

RSpec.describe NvimContext::Fetcher do
  let(:client) { instance_double(Neovim::Client) }
  let(:connector) { instance_double(NvimContext::Connector) }
  let(:context) do
    {
      cursor: { line: 1, col: 0 },
      file: "/path/to/file.rb",
      selection: nil,
      diagnostics: []
    }
  end

  describe ".fetch" do
    before do
      allow(NvimContext::Connector).to receive(:new)
        .and_return(connector)
      allow(connector).to receive(:connect).and_yield(client)
      allow(NvimContext::DataExtractor).to receive_messages(
        cursor: { line: 1, col: 0 },
        file: "/path/to/file.rb",
        visual_selection: nil,
        diagnostics: []
      )
    end

    it "returns the context as JSON" do
      expect(described_class.fetch).to eq(JSON.generate(context))
      expect(NvimContext::DataExtractor).to have_received(:cursor)
        .with(client: client)
      expect(NvimContext::DataExtractor).to have_received(:file)
        .with(client: client)
      expect(NvimContext::DataExtractor).to have_received(:visual_selection)
        .with(client: client)
      expect(NvimContext::DataExtractor).to have_received(:diagnostics)
        .with(client: client)
    end

    context "when connection fails" do
      before do
        allow(NvimContext::Connector).to receive(:new).and_raise(
          NvimContext::ConnectionError.new("Socket error")
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
        allow(NvimContext::DataExtractor).to receive(:cursor).and_raise(
          NvimContext::ContextError.new("Build error")
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
