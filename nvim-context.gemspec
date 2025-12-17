$LOAD_PATH.unshift(File.expand_path("lib", __dir__))

require "nvim_context/version"

Gem::Specification.new do |s|
  s.name                  = "nvim-context"
  s.version               = NvimContext::VERSION
  s.summary               =
    "Bridge between running Neovim instances and agentic coding tools."
  s.description           = <<~DESCRIPTION
    `nvim-context` extracts live context from running Neovim instances via Unix
    socket connections, providing AI coding tools with cursor position, current
    file, visual selections, and diagnostics as JSON. It enables context-aware
    assistance by giving agents awareness of your current Neovim editor state,
    supporting questions like "What does this line do?" or analysis of selected
    code.
  DESCRIPTION
  s.author                = ["Mathias Jean Johansen"]
  s.email                 = "mathias@mjj.io"
  s.files                 = Dir["lib/**/*.rb", "bin/*", "LICENSE", "*.md"]
  s.executables          << "nvim-context"
  s.homepage              = "https://github.com/majjoha/nvim-context"
  s.license               = "ISC"
  s.required_ruby_version = ">= 3.4.0"

  s.add_dependency "neovim", "~> 0.10.0"

  s.metadata["rubygems_mfa_required"] = "true"
  s.metadata["source_code_uri"] = "https://github.com/majjoha/nvim-context"
  s.metadata["changelog_uri"] = "https://github.com/majjoha/nvim-context/blob/main/CHANGELOG.md"
  s.metadata["bug_tracker_uri"] = "https://github.com/majjoha/nvim-context/issues"
end
