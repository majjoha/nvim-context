# frozen_string_literal: true

require_relative "../../spec_helper"

RSpec.describe NeovimContext::ContextBuilder do
  let(:client) { instance_double(Neovim::Client) }

  describe ".build" do
    let(:expected_context) do
      {
        cursor: { line: 1, col: 0 },
        file: "/path/to/file.rb",
        selection: {
          start: { line: 1, col: 0 },
          end: { line: 1, col: 5 },
          text: "selected"
        },
        diagnostics: [
          { line: 1, col: 1, message: "Error", severity: 1 }
        ]
      }
    end

    before do
      allow(NeovimContext::NeovimDataExtractor).to receive_messages(
        cursor: { line: 1, col: 0 },
        file: "/path/to/file.rb",
        visual_selection: {
          start: { line: 1, col: 0 },
          end: { line: 1, col: 5 },
          text: "selected"
        },
        diagnostics: [
          { line: 1, col: 1, message: "Error", severity: 1 }
        ]
      )
    end

    it "builds the context hash from the extractor data" do
      expect(described_class.build(client: client)).to eq(expected_context)
    end
  end
end
