# frozen_string_literal: true

require_relative "../../spec_helper"

RSpec.describe NeovimContext::VERSION do
  describe "VERSION" do
    it "is version 1.0.0" do
      expect(NeovimContext::VERSION).to eq("1.0.0")
    end
  end
end
