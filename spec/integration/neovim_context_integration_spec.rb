# frozen_string_literal: true

require "English"
require "fileutils"
require_relative "../spec_helper"

RSpec.describe "`NeovimContext` integration" do
  SOCKET_PATH = File.expand_path("neovim-context.sock")
  TEST_FILE = File.expand_path("spec/integration/test_file.rb")

  before(:all) do
    skip "Neovim not installed" unless system("which nvim > /dev/null 2>&1")

    # Ensure socket directory exists
    FileUtils.mkdir_p(".opencode")

    # Start Neovim in headless mode
    @neovim_pid = Process.spawn(
      "nvim",
      "--listen", SOCKET_PATH,
      "--headless", TEST_FILE,
      "-c", "normal 5G10|", # Move to line 5, column 10
      out: "/dev/null",
      err: "/dev/null"
    )
  end

  after(:all) do
    Process.kill("TERM", @neovim_pid) if @neovim_pid
    Process.wait(@neovim_pid) if @neovim_pid
    FileUtils.rm_f(SOCKET_PATH)
  end

  it "retrieves the context from the running Neovim instance" do
    output = `ruby bin/neovim-context`

    expect($CHILD_STATUS).to be_success
    expect(JSON.parse(output)).to include(
      "file" => File.expand_path(TEST_FILE),
      "cursor" => { "line" => 5, "col" => 4 }
    )
  end
end
