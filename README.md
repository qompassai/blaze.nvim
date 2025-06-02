<!-- /qompassai/blaze.nvim/README.md -->

<!-- ---------------------------- -->

<!-- Copyright (C) 2025 Qompass AI, All rights reserved -->

<h1 align="center">Qompass AI blaze.nvim</h1>

<h2 align="center">A blazingly fast mojo.vim fork</h2>

<p align="center">**

Under Active development expect breaking changes until stable release\*\*

![GitHub all releases](https://img.shields.io/github/downloads/qompassai/blaze.nvim/total?style=flat-square)

<p align="center">
<a href="https://luarocks.org/modules/phaedrusflow/blaze.nvim">
<img src="https://img.shields.io/luarocks/dt/blaze.nvim?color=blue&label=LuaRocks%20downloads" alt="LuaRocks Downloads">
</a>
</p>
<a href="https://www.lua.org/"><img src="https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white" alt="Lua"></a>
<br>
  <a href="https://www.lua.org/docs.html"><img src="https://img.shields.io/badge/Lua-Documentation-blue?style=flat-square" alt="Lua Documentation"></a>
  <a href="https://github.com/topics/lua-tutorial"><img src="https://img.shields.io/badge/Lua-Tutorials-green?style=flat-square" alt="Lua Tutorials"></a>
  <br>
  <a href="https://www.modular.com/mojo"><img src="https://img.shields.io/badge/Mojo%F0%9F%94%A5-000000?style=for-the-badge&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAACXBIWXMAAA7EAAAOxAGVKw4bAAABR0lEQVQ4y52TvUoDQRSFz51ZJdndGIxYpBIRtLEQLARBsLCxEfEBfAGfQHyEFDbpU9kIFoKdrU1AEFGCkH92Z+ZaZDcJm91IOoeB4d7vfHNnLpBimqaUp2mHmuDz12v/ETBJEgrdA9eABjrNpnm4vpr1fO/0t4zGGFar1aNzQTPOTg+8MqBB6wgA3ntJ0gGcn1/MGLtY2a2M54s+L+97qwASRCQgQ/0OOO/F4y7KfwklD8Dl3UM0DpNqBjRsQf9WuVg8rtfb3l3pBmMMQggIIRA1I4gO4Ksdr9uOYRxLlRv/B2xBC0DKrDJzc04fgxvbytR00HdUYTTCVmtEfgUoAVUAfYkgxGbbjjJrUgYA0AaGC6A9Yl0CvdVQBnR3lHkbX4/73fYpIJ1njBARZlmG+R7FmHFhBFdvj1fm5+jkG8bYPSbznRSKAAAAAElFTkSuQmCC" alt="Mojo"></a>
  <br>
  <a href="https://docs.modular.com/mojo"><img src="https://img.shields.io/badge/Mojo-Documentation-blue?style=flat-square" alt="Mojo Documentation"></a>
  <a href="https://www.gnu.org/licenses/agpl-3.0"><img src="https://img.shields.io/badge/License-AGPL%20v3-blue.svg" alt="License: AGPL v3"></a>
  <a href="./LICENSE-QCDA"><img src="https://img.shields.io/badge/license-Q--CDA-lightgrey.svg" alt="License: Q-CDA"></a>
</p>

<p align="center">
  <a href="https://www.gnu.org/licenses/agpl-3.0">
    <img src="https://img.shields.io/badge/License-AGPL%20v3-blue.svg" alt="License: AGPL v3">
  </a>
  <a href="./LICENSE-QCDA">
    <img src="https://img.shields.io/badge/license-Q--CDA-lightgrey.svg" alt="License: Q-CDA">
  </a>
</p>

## 📦 Features

* ❤️‍🔥 Full integration with Modular's Magic-CLI & Pixi
* 🔥 Tree-sitter support via `blaze-ts.nvim`
* 💡 Autoformatting with `🔥-fmt`
* 🧪 Diagnostics with `null-ls`
* 🐞 Debugging via DAP
* 🌲 Query files: `highlights.scm`, `indents.scm`, etc.
* 💉 LSP integration
* ✅ Healthcheck via `:Fever`

***

## ⚙️ How to setup 🔥 syntax highlighting

1. Add Mojo config files to your Neovim config:

   ```bash
   for FOLDER in autoload ftdetect ftplugin indent syntax; do
   mkdir -p ~/.config/nvim/$FOLDER && ln -s $FOLDER/blaze.nvim ~/.config/nvim/$FOLDER/blaze.nvim
   done
   ```

2. Add to your `init.lua` or plugin loader:

```lua
-- 📁 ~/.config/nvim/lua/plugins/init.lua
-- If you're using lazy.nvim or packer.nvim, this goes in your plugin spec list:
```

```lua
-- 👉 For lazy.nvim
{ "qompassai/blaze.nvim" }
```

```lua
-- 👉 For packer.nvim
use {
  "qompassai/blaze.nvim",
  requires = {
    "qompassai/blaze-ts.nvim",
    "neovim/nvim-lspconfig",
    "mfussenegger/nvim-dap",
    "rcarriga/nvim-dap-ui",
    "mfussenegger/nvim-dap-python",
  },
  config = function()
    require("blaze").setup()
  end,
  ft = { "mojo", "🔥" }
}
```

```lua
-- 👉 Manual Lua setup in your config (e.g., ~/.config/nvim/init.lua or after plugin loads)
require("blaze.config").setup({
  format_on_save = true,
  enable_linting = true,
  keymaps = true, -- Optional which-key mappings
})
```

## 📊 Lualine Integration (Still in development)

```lua
require("lualine").setup({
  sections = {
    lualine_c = {
      "filename",
      require("blaze.lualine").blaze_status,
    },
  },
})

```

## Health Check

````lua

## 🌡️ Healthcheck

Run the following to validate setup:

```lua
:Fever
````

You’ll see:

```
🌲 Tree-sitter parser availability

🔥 Mojo file

🔥-ls LSP active

🔥-fmt Formatter available

🔥-lint Linter available

🔥-dap Debugger attached
```

***

## 🧠 Which-Key Mappings

If `keymaps = true`, the following mappings are automatically registered:

| Mapping      | Description                  |
| ------------ | ---------------------------- |
| `<leader>fm` | Format Mojo file             |
| `<leader>fh` | Run healthcheck via `:Fever` |

***

## 🔍 Plugin Structure

| Path                       | Purpose                               |
| -------------------------- | ------------------------------------- |
| `lua/blaze/autocmds/`      | Paired commands                       |
| `lua/blaze/container.lua`  | Rootless Containers for Magic-Docker  |
| `lua/blaze/dap.lua`        | Debug adapter setup via `nvim-dap`    |
| `lua/blaze/formatting.lua` | Handles formatting with `mojo format` |
| `lua/blaze/health.lua`     | 🔥 Which-Key Bindings                 |
| `lua/blaze/keymaps.lua`    | Which-Key bindings                    |
| `lua/blaze/linting.lua`    | Integrates with `nvim-lint`           |
| `lua/blaze/magic.lua`      | Magic integration                     |
| `lua/blaze/pixi.lua`       | Pixi integration                      |

## 🧰 Dependencies

* [`nvim-dap`](https://github.com/mfussenegger/nvim-dap)
* [`nvim-treesitter`](https://github.com/nvim-treesitter/nvim-treesitter)
* ['blaze-ts.nvim'](https://github.com/qompassai/blaze-ts.nvim)
*
* Optional (But recommended)
* [magic-docker](https://github.com/modular/magic-docker)
* \[Pixi]\(cargo install --locked --git https://github.com/prefix-dev/pixi.git
  [Magic](https://docs.modular.com/magic/)

## 📄 License

This plugin is dual-licensed under the AGPL-3 and Q-CDA licenses. See [LICENSE](/.LICENSE-AGPL) & [LICENSE-AGPL](./LICENSE) for details.

Derived from:

* [Modular](https://github.com/modular)
* [mojo.vim](https://github.com/modularml/mojo.vim) (Apache-2.0)
* [mojo-syntax](https://github.com/ovikrai/mojo-syntax) (MIT)
* [pixi](https://github.com/modular/pixi) (BSD-3)
* [magic-docker](https://github.com/modular/magic-docker)

See [LICENSE-Apache-2.0](./LICENSE-Apache-2.0) and [LICENSES/NOTICE](./LICENSES/NOTICE).

## 🧭 Attribution

* Built by [Qompass AI](https://github.com/qompassai)
* Grammar derived from `mojo.vim` & custom Tree-sitter parser
* Mojo-LSP applied from 'nvim-lspconfig\`(https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/mojo.lua)
* Maintained by [Qompass AI](https://qompass.ai)/(https://github.com/phaedrusflow)

***

## 🔖 Zenodo DOI

Badge

```markdown
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.xxxxxx.svg)](https://doi.org/10.5281/zenodo.xxxxxx)
```

***

## 🔬 Research Metadata

See `.zenodo.json` for metadata, authorship, licensing, and related software attribution.

## ☕ Support

If you like this project, consider [buying me a coffee](https://www.buymeacoffee.com/phaedrusflow) ☕ or sponsoring ❤️.

## What a Dual-License means

### Protection for Vulnerable Populations

The dual licensing aims to address the cybersecurity gap that disproportionately affects underserved populations. As highlighted by recent attacks\[^1], low-income residents, seniors, and foreign language speakers face higher-than-average risks of being victims of cyberattacks. By offering both open-source and commercial licensing options, we encourage the development of cybersecurity solutions that can reach these vulnerable groups while also enabling sustainable development and support.

### Preventing Malicious Use

The AGPL-3.0 license ensures that any modifications to the software remain open source, preventing bad actors from creating closed-source variants that could be used for exploitation. This is especially crucial given the rising threats to vulnerable communities, including children in educational settings. The attack on Minneapolis Public Schools, which resulted in the leak of 300,000 files and a $1 million ransom demand, highlights the importance of transparency and security\[^8].

### Addressing Cybersecurity in Critical Sectors

The commercial license option allows for tailored solutions in critical sectors such as healthcare, which has seen significant impacts from cyberattacks. For example, the recent Change Healthcare attack\[^4] affected millions of Americans and caused widespread disruption for hospitals and other providers. In January 2025, CISA\[^2] and FDA\[^3] jointly warned of critical backdoor vulnerabilities in Contec CMS8000 patient monitors, revealing how medical devices could be compromised for unauthorized remote access and patient data manipulation.

### Supporting Cybersecurity Awareness

The dual licensing model supports initiatives like the Cybersecurity and Infrastructure Security Agency (CISA) efforts to improve cybersecurity awareness\[^7] in "target rich" sectors, including K-12 education\[^5]. By allowing both open-source and commercial use, we aim to facilitate the development of tools that support these critical awareness and protection efforts.

### Bridging the Digital Divide

The unfortunate reality is that too many individuals and organizations have gone into a frenzy in every facet of our daily lives\[^6]. These unfortunate folks identify themselves with their talk of "10X" returns and building towards Artificial General Intelligence aka "AGI" while offering GPT wrappers. Our dual licensing approach aims to acknowledge this deeply concerning predatory paradigm with clear eyes while still operating to bring the best parts of the open-source community with our services and solutions.

### Recent Cybersecurity Attacks

Recent attacks underscore the importance of robust cybersecurity measures:

* The Change Healthcare cyberattack in February 2024 affected millions of Americans and caused significant disruption to healthcare providers.
* The White House and Congress jointly designated October 2024 as Cybersecurity Awareness Month. This designation comes with over 100 actions that align the Federal government and public/private sector partners are taking to help every man, woman, and child to safely navigate the age of AI.

By offering both open source and commercial licensing options, we strive to create a balance that promotes innovation and accessibility. We address the complex cybersecurity challenges faced by vulnerable populations and critical infrastructure sectors as the foundation of our solutions, not an afterthought..

\[^1]: [International Counter Ransomware Initiative 2024 Joint Statement](https://www.whitehouse.gov/briefing-room/statements-releases/2024/10/02/international-counter-ransomware-initiative-2024-joint-statement/)

\[^2]: [Contec CMS8000 Contains a Backdoor](https://www.cisa.gov/sites/default/files/2025-01/fact-sheet-contec-cms8000-contains-a-backdoor-508c.pdf)

\[^3]: [CISA, FDA warn of vulnerabilities in Contec patient monitors](https://www.aha.org/news/headline/2025-01-31-cisa-fda-warn-vulnerabilities-contec-patient-monitors)

\[^4]: [The Top 10 Health Data Breaches of the First Half of 2024](https://www.chiefhealthcareexecutive.com/view/the-top-10-health-data-breaches-of-the-first-half-of-2024)

\[^5]: [CISA's K-12 Cybersecurity Initiatives](https://www.cisa.gov/K12Cybersecurity)

\[^6]: [Federal Trade Commission Operation AI Comply: continuing the crackdown on overpromises and AI-related lies](https://www.ftc.gov/business-guidance/blog/2024/09/operation-ai-comply-continuing-crackdown-overpromises-ai-related-lies)

\[^7]: [A Proclamation on Cybersecurity Awareness Month, 2024 ](https://www.whitehouse.gov/briefing-room/presidential-actions/2024/09/30/a-proclamation-on-cybersecurity-awareness-month-2024/)

\[^8]: [Minneapolis school district says data breach affected more than 100,000 people](https://therecord.media/minneapolis-schools-say-data-breach-affected-100000/)
