# frozen_string_literal: true

require_relative "../../spec_helper"

RSpec.describe NeovimContext::NeovimDataExtractor do
  let(:client) { instance_double(Neovim::Client) }

  describe ".cursor_info" do
    let(:current) { instance_double(Neovim::Current) }
    let(:window) { instance_double(Neovim::Window) }

    it "returns the cursor position as a hash" do
      allow(client).to receive(:current).and_return(current)
      allow(current).to receive(:window).and_return(window)
      allow(window).to receive(:cursor).and_return([1, 0])
      expect(described_class.cursor_info(client: client)).to eq({ line: 1,
                                                                  col: 0 })
    end
  end

  describe ".file_info" do
    let(:current) { instance_double(Neovim::Current) }
    let(:buffer) { instance_double(Neovim::Buffer) }

    it "returns the current file name" do
      allow(client).to receive(:current).and_return(current)
      allow(current).to receive(:buffer).and_return(buffer)
      allow(buffer).to receive(:name).and_return("/path/to/file.rb")
      expect(described_class.file_info(client: client)).to eq(
        "/path/to/file.rb"
      )
    end
  end
end
