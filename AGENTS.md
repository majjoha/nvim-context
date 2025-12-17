# AGENTS.md
## Project overview
`nvim-context` is a Ruby gem that bridges running Neovim instances and agentic
coding tools. It extracts live context from the editor via a Unix socket
connection and outputs JSON with cursor position, current file, visual
selection and diagnostics.

**Version**: 1.0.0
**Ruby**: >= 3.4.0
**Dependencies**: `neovim` gem (~> 0.10.0)

## Commands
- **Test all**: `bundle exec rspec`
- **Test unit**: `bundle exec rspec --exclude-pattern "spec/integration/*"`
- **Test integration**: `bundle exec rspec spec/integration/`
- **Test single file**: `bundle exec rspec path/to/spec.rb`
- **Lint**: `bundle exec rubocop`
- **Run tool**: `bin/nvim-context`
- **Build gem**: `gem build nvim-context.gemspec`

## Architecture
### Entry point
`bin/nvim-context` - CLI executable that calls `NvimContext::Fetcher.fetch` and
prints JSON to stdout.

### Core components (`lib/nvim_context/`)
- `fetcher.rb` - Main entry point class with static `fetch` method. Orchestrates
  data extraction, handles all error types, and returns JSON responses
- `connector.rb` - Manages Neovim socket connection using the `neovim` gem.
  Reads socket path from `NVIM_CONTEXT_SOCKET` env var or defaults to
  `nvim-context.sock` in current directory
- `data_extractor.rb` - Static methods to extract cursor position, current file
  path, visual selection (with text content), and diagnostics from Neovim
- `errors.rb` - Custom error classes: `ConnectionError` (socket failures) and
  `ContextError` (Neovim operation failures)
- `version.rb` - Gem version constant

### Data Flow
1. User runs `nvim-context` CLI
2. `Fetcher.fetch` creates a `Connector` instance
3. `Connector` attaches to Neovim via Unix socket
4. `DataExtractor` methods query Neovim for context data
5. JSON output returned to stdout (or error JSON on failure)

### JSON output format
Success:
```json
{
  "cursor": { "line": 43, "col": 3 },
  "file": "/path/to/file.rb",
  "selection": null,
  "diagnostics": []
}
```

Error:
```json
{
  "error": "Connection failed",
  "details": "Failed to connect to Neovim socket: No such file"
}
```

## Code style
- Ruby 3.4, line length max 80 chars
- Use double quotes for strings, frozen string literals enabled
- Classes in `NvimContext` module with descriptive names
- Private constants at class bottom with `private_constant`
- Error handling with custom error classes in `errors.rb`
- Use `attr_reader` for private instance variables
- RSpec with expect syntax, monkey patching disabled
- Follow Rubocop rules in `.rubocop.yml`

## Testing
- Unit tests mock the Neovim client
- Integration tests require a running Neovim instance with socket
- Test files mirror lib structure: `spec/lib/nvim_context/`

## Integration examples
The gem is designed for use with agentic coding tools like Claude Code,
OpenCode, Amp Code, Codex, and Gemini. See README.md for integration examples
including Claude Code skill configuration and OpenCode custom tool setup.
