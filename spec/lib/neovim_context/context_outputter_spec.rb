# frozen_string_literal: true

require_relative "../../spec_helper"

RSpec.describe NeovimContext::ContextOutputter do
  describe ".output" do
    let(:json) do
      <<~JSON.chomp
        {"cursor":{"line":1,"col":0},"file":"/path/to/file.rb","selection":{"start":{"line":1,"col":0},"end":{"line":1,"col":5},"text":"selected"},"diagnostics":[{"line":1,"col":1,"message":"Error","severity":1}]}
      JSON
    end
    let(:context) do
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

    it "outputs the context as JSON" do
      expect do
        described_class.output(context)
      end.to output("#{json}\n").to_stdout
    end
  end
end
