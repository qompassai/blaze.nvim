# Contributing to 🔥.nvim

Thank you for considering a contribution to **🔥.nvim**! Whether it’s a bug fix, feature, documentation update, or performance improvement — your help is appreciated. 🙏

---

## 🚀 Getting Started

1. **Fork and Clone the Repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/🔥.nvim
   cd 🔥.nvim
   ```

2. **Create a New Branch**
   ```bash
   git checkout -b feat/your-new-feature
   ```

3. **Make Changes**
   - Use **2-space indentation** (Lua convention)
   - Format with [`stylua`](https://github.com/JohnnyMorganz/StyLua)
   - Follow Neovim plugin Lua style conventions

4. **Test and Lint**
   - Check formatting
   - Run `:Fever` (healthcheck)
   - Test Tree-sitter grammar if applicable

5. **Commit and Push**
   ```bash
   git commit -m "feat: add feature or fix"
   git push origin feat/your-new-feature
   ```

6. **Open a Pull Request**
   - Describe your changes clearly
   - Reference any related issues

---

## 🐞 Bug Reports & Feature Requests

Use the [GitHub Issues](https://github.com/qompassai/🔥.nvim/issues) tab to:
- Report bugs (with reproduction steps if possible)
- Propose features or improvements
- Ask questions

---

## 🛠️ Developer Tools

- **Formatter**: [`stylua`](https://github.com/JohnnyMorganz/StyLua)
- **Linting**: [`nvim-lint`](https://github.com/mfussenegger/nvim-lint)
- **Debugging**: [`nvim-dap`](https://github.com/mfussenegger/nvim-dap)
- **Syntax**: [`tree-sitter-cli`](https://tree-sitter.github.io/tree-sitter/)
- **Status Line**: [`lualine.nvim`](https://github.com/nvim-lualine/lualine.nvim)  
  Add this to your config:
  ```lua
  require("lualine").setup {
    sections = {
      lualine_c = {
        { "filename" },
        { function() return vim.g.loaded_mojo and "🔥" or "" end }
      }
    }
  }
  ```

---

## 📜 License

By contributing, you agree to license your changes under the same dual AGPL-3.0 and Q-CDA terms used in the main repository.

