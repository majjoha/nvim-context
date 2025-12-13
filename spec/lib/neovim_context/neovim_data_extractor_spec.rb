# frozen_string_literal: true

require_relative "../../spec_helper"

RSpec.describe NeovimContext::NeovimDataExtractor do
  let(:client) { instance_double(Neovim::Client) }

  describe ".cursor_info" do
    let(:current) { instance_double(Neovim::Current) }
    let(:window) { instance_double(Neovim::Window) }

    before do
      allow(client).to receive(:current).and_return(current)
      allow(current).to receive(:window).and_return(window)
      allow(window).to receive(:cursor).and_return([1, 0])
    end

    it "returns the cursor position as a hash" do
      expect(described_class.cursor_info(client: client)).to eq({ line: 1,
                                                                  col: 0 })
    end
  end

  describe ".file_info" do
    let(:current) { instance_double(Neovim::Current) }
    let(:buffer) { instance_double(Neovim::Buffer) }

    before do
      allow(client).to receive(:current).and_return(current)
      allow(current).to receive(:buffer).and_return(buffer)
      allow(buffer).to receive(:name).and_return("/path/to/file.rb")
    end

    it "returns the current file name" do
      expect(described_class.file_info(client: client)).to eq(
        "/path/to/file.rb"
      )
    end
  end

  describe ".visual_selection" do
    let(:client) { double("client") }

    context "when in visual mode" do
      before do
        allow(client).to receive(:eval).with("mode()").and_return("v")
        allow(client).to receive(:eval).with("getpos(\"'<\")")
          .and_return([0, 1, 0, 0])
        allow(client).to receive(:eval).with("getpos(\"'>\")")
          .and_return([0, 1, 5, 0])
        allow(client).to receive(:eval).with("getline(1, 1)")
          .and_return(["selected text"])
      end

      it "returns selection info" do
        expect(described_class.visual_selection(client: client)).to eq(
          {
            start: { line: 1, col: 0 },
            end: { line: 1, col: 5 },
            text: "selected text"
          }
        )
      end
    end

    context "when not in visual mode" do
      it "returns nil" do
        allow(client).to receive(:eval).with("mode()").and_return("n")
        expect(described_class.visual_selection(client: client)).to be_nil
      end
    end
  end
end
