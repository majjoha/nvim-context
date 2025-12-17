# frozen_string_literal: true

require_relative "../../spec_helper"

RSpec.describe NvimContext::VERSION do
  describe "VERSION" do
    it "is version 1.0.0" do
      expect(NvimContext::VERSION).to eq("1.0.0")
    end
  end
end
