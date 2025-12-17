# `nvim-context`
![CI](https://github.com/majjoha/nvim-context/workflows/CI/badge.svg)
[![Gem Version](https://badge.fury.io/rb/nvim-context.svg)](https://badge.fury.io/rb/nvim-context)

`nvim-context` is a bridge between running Neovim instances and agentic coding
tools. It extracts context from the editor via a Unix socket connection and
outputs JSON with the cursor position, current file, visual selection and
diagnostics.

It allows agentic coding tools running outside Neovim to answer questions such
as:
- What does this line do?
- Can you convert the current line to uppercase?
- What does the method under my cursor do?
- Are these lines idiomatic Ruby?

## Motivation
While the Neovim community provides several plugins for integrating agentic
coding assistants into the editor (see the [AI section in the Awesome Neovim
repository](https://github.com/rockerboo/awesome-neovim?tab=readme-ov-file#ai)),
it seems that few tools offer a way to let any agentic coding tool running
*outside* Neovim retrieve the state of the editor in an agnostic manner.

The goal with `nvim-context` is to separate concerns, so Amp Code, Claude Code,
Codex, etc., can query the current state of a Neovim session by calling
this tool. See the [Integration with agentic
tools](#integration-with-agentic-tools) section below for suggestions on how to
set this up.

## Installation
```sh
gem install nvim-context
```

## Setup
When starting Neovim ensure that you open it using the `--listen` flag and pass
a path to the socket as follows:

```sh
nvim --listen $(pwd)/nvim-context.sock
```

Alternatively, you can set the `NVIM_CONTEXT_SOCKET` environment variable to
specify the socket path:

```sh
export NVIM_CONTEXT_SOCKET=/tmp/nvim-context.sock
nvim --listen $NVIM_CONTEXT_SOCKET
```

If no environment variable is set, the tool defaults to `nvim-context.sock` in
the current directory.

## Usage
Once Neovim is running, you can retrieve the current context by running
`nvim-context`.

This will output JSON containing the current file, cursor position, visual
selection (if any), and diagnostics in this format:

```json
{
  "cursor": {
    "line": 43,
    "col": 3
  },
  "file": "/path/to/current/file.rb",
  "selection": null,
  "diagnostics": []
}
```

### Integration with agentic tools
#### Amp Code
[Amp Code supports Claude Skills natively.](https://ampcode.com/news/agent-skills)

#### Claude Code
<details>
<summary><code>~/.claude/skills/nvim-context/SKILL.md</code></summary>
<pre>
---
name: nvim-context
description: Get the current Neovim context as JSON (cursor position, current
file, visual selection and diagnostics) to help answer questions about code at
the current cursor position, visual selections and diagnostics. Use when users
ask about "this line", "current file", "selection" or need context about their
Neovim editor state.
---

# Neovim context provider
## Purpose
Provides live context from the user's Neovim editor session to help answer
context-aware questions about code.

## How it works
1. Executes the `nvim-context` tool to get the current editor state.
2. Returns JSON data including cursor position, open file, visual selection and
   diagnostics.
3. Use this information to understand references like "this line", "the
   selection", "current file", etc.

## Usage examples
- "What's wrong with this line?" → Check diagnostics at cursor
- "Explain the selected code" → Analyze visual selection
- "What file am I in?" → Return current file path
- "Show me all errors" → List all LSP diagnostics

## Technical details
The skill runs: `nvim-context`

This provides JSON output like:
```json
{
  "cursor": {
    "line": 43,
    "col": 3
  },
  "file": "/path/to/current/file.rb",
  "selection": null,
  "diagnostics": []
}
```
</pre>
</details>

### Codex
<details>
<summary><code>~/.codex/prompts/nvim-context.md</code></summary>
<pre>
---
description: Answer questions about the code referenced by `nvim-context`
---

By running `nvim-context`, answer questions such as:
- "What's wrong with this line?"
- "Explain the selected code"
- "What file am I in?"
- "Show me all errors"

`nvim-context` returns JSON in this format:
```json
{
  "cursor": {
    "line": 43,
    "col": 3
  },
  "file": "/path/to/current/file.rb",
  "selection": null,
  "diagnostics": []
}
```
Use this data to look up the file and position in the file, and then utilize
this context to answer the user's question. 
</pre>
</details>

#### Gemini
TBD.

#### OpenCode
<details>
<summary><code>~/.config/opencode/tool/nvim-context.ts</code></summary>

```typescript
import { execSync } from "child_process";

export default {
  description:
    "Get the current Neovim context as JSON (cursor position, current file, visual selection and diagnostics)",
  args: {},
  async execute(args) {
    try {
      const output = execSync(
        "nvim-context",
        {
          encoding: "utf8",
          timeout: 5000,
        },
      );
      return output.trim();
    } catch (error) {
      return `nvim-context unavailable: ${error.message}`;
    }
  },
};
```
</details>

## Disclaimer
Since building software with AI can still be divisive, it might be worth
pointing out here that `nvim-context` itself has been built using OpenCode and
Claude Code, but with human guidance and continuous review of its work.

## License
See [LICENSE](https://github.com/majjoha/nvim-context/blob/main/LICENSE).
