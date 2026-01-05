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
```sh
amp skill add majjoha/nvim-context/nvim-context
```

#### Claude Code
```sh
# Add the repository as a marketplace
/plugin marketplace add majjoha/nvim-context

# Install the plugin
/plugin install nvim-context@nvim-context
```

The plugin provides the `nvim-context` skill which gives Claude Code access to
your live Neovim editor state.

#### Codex
```sh
$skill-installer install https://github.com/majjoha/nvim-context/tree/main/.codex/skills/nvim-context
```

#### Gemini
TBD.

#### OpenCode
<details>
<summary><code>~/.config/opencode/command/nvim-context.md</code></summary>
<pre>
---
description: Show current Neovim context
---

!`nvim-context`
</pre>
</details>

## Disclaimer
Since building software with AI can still be divisive, it might be worth
pointing out here that `nvim-context` itself has been built using OpenCode and
Claude Code, but with human guidance and continuous review of its work.

## License
See [LICENSE](https://github.com/majjoha/nvim-context/blob/main/LICENSE).
