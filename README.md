<!-- /qompassai/blaze.nvim/README.md -->

<!-- ---------------------------- -->

<!-- Copyright (C) 2025 Qompass AI, All rights reserved -->

<h1 align="center">Qompass AI blaze.nvim</h1>

<h2 align="center">A blazingly fast mojo.vim fork</h2>

<p align="center">**

**Under Active development expect breaking changes until stable release**

![GitHub all releases](https://img.shields.io/github/downloads/qompassai/blaze.nvim/total?style=flat-square)

<p align="center">
  <a href="https://luarocks.org/modules/phaedrusflow/blaze.nvim">
    <img src="https://img.shields.io/luarocks/dt/phaedrusflow/blaze.nvim?color=blue&label=LuaRocks%20downloads" alt="LuaRocks Downloads">
  </a>
  <br><br>
  <a href="https://www.lua.org/">
    <img src="https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white" alt="Lua">
  </a>
  <br><br>
  <a href="https://www.lua.org/docs.html">
    <img src="https://img.shields.io/badge/Lua-Documentation-blue?style=flat-square" alt="Lua Documentation">
  </a><p align="center">
[![LuaRocks Downloads](https://img.shields.io/luarocks/dt/phaedrusflow/blaze.nvim?color=blue&label=LuaRocks%20downloads)](https://luarocks.org/modules/phaedrusflow/blaze.nvim)

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
  <a href="https://github.com/topics/lua-tutorial">
    <img src="https://img.shields.io/badge/Lua-Tutorials-green?style=flat-square" alt="Lua Tutorials">
  </a>
  <br><br>
  <a href="https://www.modular.com/mojo">
    <img src="https://img.shields.io/badge/Mojo%F0%9F%94%A5-000000?style=for-the-badge&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAACXBIWXMAAA7EAAAOxAGVKw4bAAABR0lEQVQ4y52TvUoDQRSFz51ZJdndGIxYpBIRtLEQLARBsLCxEfEBfAGfQHyEFDbpU9kIFoKdrU1AEFGCkH92Z+ZaZDcJm91IOoeB4d7vfHNnLpBimqaUp2mHmuDz12v/ETBJEgrdA9eABjrNpnm4vpr1fO/0t4zGGFar1aNzQTPOTg+8MqBB6wgA3ntJ0gGcn1/MGLtY2a2M54s+L+97qwASRCQgQ/0OOO/F4y7KfwklD8Dl3UM0DpNqBjRsQf9WuVg8rtfb3l3pBmMMQggIIRA1I4gO4Ksdr9uOYRxLlRv/B2xBC0DKrDJzc04fgxvbytR00HdUYTTCVmtEfgUoAVUAfYkgxGbbjjJrUgYA0AaGC6A9Yl0CvdVQBnR3lHkbX4/73fYpIJ1njBARZlmG+R7FmHFhBFdvj1fm5+jkG8bYPSbznRSKAAAAAElFTkSuQmCC" alt="Mojo">
  </a>
  <br><br>
  <a href="https://docs.modular.com/mojo">
    <img src="https://img.shields.io/badge/Mojo-Documentation-blue?style=flat-square" alt="Mojo Documentation">
  </a>
  <a href="https://www.gnu.org/licenses/agpl-3.0">
    <img src="https://img.shields.io/badge/License-AGPL%20v3-blue.svg" alt="License: AGPL v3">
  </a>
  <a href="./LICENSE-QCDA">
    <img src="https://img.shields.io/badge/license-Q--CDA-lightgrey.svg" alt="License: Q-CDA">
  </a>
</p>

<details>
<summary style="font-size: 1.4em; font-weight: bold; padding: 15px; background: #667eea; color: white; border-radius: 10px; cursor: pointer; margin: 10px 0;"><strong>🔥 How to Light Up Blaze.nvim</strong></summary>
<blockquote style="font-size: 1.2em; line-height: 1.8; padding: 25px; background: #f8f9fa; border-left: 6px solid #667eea; border-radius: 8px; margin: 15px 0; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">

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

</blockquote>
</details>

<details>
<summary style="font-size: 1.4em; font-weight: bold; padding: 15px; background: #667eea; color: white; border-radius: 10px; cursor: pointer; margin: 10px 0;"><strong>🧭 About Qompass AI</strong></summary>
<blockquote style="font-size: 1.2em; line-height: 1.8; padding: 25px; background: #f8f9fa; border-left: 6px solid #667eea; border-radius: 8px; margin: 15px 0; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">

<div align="center">
  <p>Matthew A. Porter<br>
  Former Intelligence Officer<br>
  Educator & Learner<br>
  DeepTech Founder & CEO</p>
</div>

<h3>Publications</h3>
  <p>
    <a href="https://orcid.org/0000-0002-0302-4812">
      <img src="https://img.shields.io/badge/ORCID-0000--0002--0302--4812-green?style=flat-square&logo=orcid" alt="ORCID">
    </a>
    <a href="https://www.researchgate.net/profile/Matt-Porter-7">
      <img src="https://img.shields.io/badge/ResearchGate-Open--Research-blue?style=flat-square&logo=researchgate" alt="ResearchGate">
    </a>
    <a href="https://zenodo.org/communities/qompassai">
      <img src="https://img.shields.io/badge/Zenodo-Publications-blue?style=flat-square&logo=zenodo" alt="Zenodo">
    </a>
  </p>

<h3>Developer Programs</h3>

[![NVIDIA Developer](https://img.shields.io/badge/NVIDIA-Developer_Program-76B900?style=for-the-badge\&logo=nvidia\&logoColor=white)](https://developer.nvidia.com/)
[![Meta Developer](https://img.shields.io/badge/Meta-Developer_Program-0668E1?style=for-the-badge\&logo=meta\&logoColor=white)](https://developers.facebook.com/)
[![HackerOne](https://img.shields.io/badge/-HackerOne-%23494649?style=for-the-badge\&logo=hackerone\&logoColor=white)](https://hackerone.com/phaedrusflow)
[![HuggingFace](https://img.shields.io/badge/HuggingFace-qompass-yellow?style=flat-square\&logo=huggingface)](https://huggingface.co/qompass)
[![Epic Games Developer](https://img.shields.io/badge/Epic_Games-Developer_Program-313131?style=for-the-badge\&logo=epic-games\&logoColor=white)](https://dev.epicgames.com/)

<h3>Professional Profiles</h3>
  <p>
    <a href="https://www.linkedin.com/in/matt-a-porter-103535224/">
      <img src="https://img.shields.io/badge/LinkedIn-Matt--Porter-blue?style=flat-square&logo=linkedin" alt="Personal LinkedIn">
    </a>
    <a href="https://www.linkedin.com/company/95058568/">
      <img src="https://img.shields.io/badge/LinkedIn-Qompass--AI-blue?style=flat-square&logo=linkedin" alt="Startup LinkedIn">
    </a>
  </p>

<h3>Social Media</h3>
  <p>
    <a href="https://twitter.com/PhaedrusFlow">
      <img src="https://img.shields.io/badge/Twitter-@PhaedrusFlow-blue?style=flat-square&logo=twitter" alt="X/Twitter">
    </a>
    <a href="https://www.instagram.com/phaedrusflow">
      <img src="https://img.shields.io/badge/Instagram-phaedrusflow-purple?style=flat-square&logo=instagram" alt="Instagram">
    </a>
    <a href="https://www.youtube.com/@qompassai">
      <img src="https://img.shields.io/badge/YouTube-QompassAI-red?style=flat-square&logo=youtube" alt="YouTube">
    </a>
  </p>

</blockquote>
</details>

<details>
<summary style="font-size: 1.4em; font-weight: bold; padding: 15px; background: #ff6b6b; color: white; border-radius: 10px; cursor: pointer; margin: 10px 0;"><strong>🔥 How Do I Support</strong></summary>
<blockquote style="font-size: 1.2em; line-height: 1.8; padding: 25px; background: #fff5f5; border-left: 6px solid #ff6b6b; border-radius: 8px; margin: 15px 0; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">

<div align="center">

<table>
<tr>
<th align="center">🏛️ Qompass AI Pre-Seed Funding 2023-2025</th>
<th align="center">🏆 Amount</th>
<th align="center">📅 Date</th>
</tr>
<tr>
<td><a href="https://github.com/qompassai/r4r" title="RJOS/Zimmer Biomet Research Grant Repository">RJOS/Zimmer Biomet Research Grant</a></td>
<td align="center">$30,000</td>
<td align="center">March 2024</td>
</tr>
<tr>
<td><a href="https://github.com/qompassai/PathFinders" title="GitHub Repository">Pathfinders Intern Program</a><br>
<small><a href="https://www.linkedin.com/posts/evergreenbio_bioscience-internships-workforcedevelopment-activity-7253166461416812544-uWUM/" target="_blank">View on LinkedIn</a></small></td>
<td align="center">$2,000</td>
<td align="center">October 2024</td>
</tr>
</table>

<br>
<h4>🤝 How To Support Our Mission</h4>

[![GitHub Sponsors](https://img.shields.io/badge/GitHub-Sponsor-EA4AAA?style=for-the-badge\&logo=github-sponsors\&logoColor=white)](https://github.com/sponsors/phaedrusflow)
[![Patreon](https://img.shields.io/badge/Patreon-Support-F96854?style=for-the-badge\&logo=patreon\&logoColor=white)](https://patreon.com/qompassai)
[![Liberapay](https://img.shields.io/badge/Liberapay-Donate-F6C915?style=for-the-badge\&logo=liberapay\&logoColor=black)](https://liberapay.com/qompassai)
[![Open Collective](https://img.shields.io/badge/Open%20Collective-Support-7FADF2?style=for-the-badge\&logo=opencollective\&logoColor=white)](https://opencollective.com/qompassai)
[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-Support-FFDD00?style=for-the-badge\&logo=buy-me-a-coffee\&logoColor=black)](https://www.buymeacoffee.com/phaedrusflow)

<details markdown="1">
<summary><strong>🔐 Cryptocurrency Donations</strong></summary>

**Monero (XMR):**

<div align="center">
  <img src="./assets/monero-qr.png" alt="Monero QR Code" width="180">
</div>

<div style="margin: 10px 0;">
    <code>42HGspSFJQ4MjM5ZusAiKZj9JZWhfNgVraKb1eGCsHoC6QJqpo2ERCBZDhhKfByVjECernQ6KeZwFcnq8hVwTTnD8v4PzyH</code>
  </div>

<button onclick="navigator.clipboard.writeText('42HGspSFJQ4MjM5ZusAiKZj9JZWhfNgVraKb1eGCsHoC6QJqpo2ERCBZDhhKfByVjECernQ6KeZwFcnq8hVwTTnD8v4PzyH')" style="padding: 6px 12px; background: #FF6600; color: white; border: none; border-radius: 4px; cursor: pointer;">
    📋 Copy Address
  </button>
<p><i>Funding helps us continue our research at the intersection of AI, healthcare, and education</i></p>

</blockquote>
</details>
</details>
