--/blaze/lua/pixi.lua
local M = {}

M.config = {
  bin = nil,
  commands = true,
  auto_detect = true,
  notify = true,
  output = {
    split = "horizontal", -- or "vertical", "tab", "float"
    height = 15, -- height of output window
  }
}

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})

  M.bin = M.config.bin or M.find_pixi_binary()

  if M.config.commands then
    M.create_commands()
  end

  if M.config.auto_detect then
    vim.api.nvim_create_autocmd("BufEnter", {
      callback = function()
        M.detect_pixi_project()
      end
    })
  end
end

function M.find_pixi_binary()
  local possible_paths = {
    vim.fn.expand("~/.pixi/bin/pixi"),
    "/usr/local/bin/pixi",
    "/usr/bin/pixi",
    vim.fn.expand("~/AppData/Local/pixi/bin/pixi.exe"),
  }

  for _, path in ipairs(possible_paths) do
    if vim.fn.executable(path) == 1 then
      return path
    end
  end
  if vim.fn.executable("pixi") == 1 then
    return "pixi"
  end

  vim.notify("Pixi binary not found. Please install pixi or set the path manually.", vim.log.levels.WARN)
  return nil
end

-- TO DO Show pixi environment information in a float window
function M.show_env_info()
  M.run_command("info", "", {
    callback = function(output, success)
      if not success then
        vim.notify("Failed to get environment info", vim.log.levels.ERROR)
        return
      end

      -- Basic parsing of the output
      local info = M.parse_pixi_info(output)

      -- Display in a float window
      local buf = vim.api.nvim_create_buf(false, true)
      local width = 60
      local height = 20
      local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        col = math.floor((vim.o.columns - width) / 2),
        row = math.floor((vim.o.lines - height) / 2),
        style = "minimal",
        border = "rounded",
        title = "Pixi Environment Info",
      })

      -- Set content
      local lines = {}
      for section, data in pairs(info) do
        table.insert(lines, "== " .. section .. " ==")
        for k, v in pairs(data) do
          table.insert(lines, k .. ": " .. v)
        end
        table.insert(lines, "")
      end

      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      vim.api.nvim_buf_set_option(buf, "modifiable", false)
      vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")

      -- Close with 'q'
      vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>close<CR>', {noremap = true, silent = true})
    end
  })
end

function M.parse_pixi_info(output)
  local info = {
    project = {},
    environment = {},
    system = {}
  }

  local current_section = nil

  for _, line in ipairs(vim.split(output, "\n")) do
    line = line:gsub("^%s+", ""):gsub("%s+$", "")

    if line:match("^Project:") then
      current_section = "project"
    elseif line:match("^Environment:") then
      current_section = "environment"
    elseif line:match("^System:") then
      current_section = "system"
    elseif current_section and line:match(":") then
      local key, value = line:match("([^:]+):%s*(.*)")
      if key and value then
        info[current_section][key:gsub("^%s+", "")] = value
      end
    end
  end

  return info
end

function M.detect_pixi_project()
  local pixi_toml = vim.fn.findfile("pixi.toml", ".;")
  if pixi_toml ~= "" then
    vim.b.is_pixi_project = true
  end
end

function M.run_command(cmd, args, opts)
  if not M.bin then
    vim.notify("Pixi binary not found", vim.log.levels.ERROR)
    return
  end

  opts = opts or {}
  local command = M.bin .. " " .. cmd
  if args then
    command = command .. " " .. args
  end

end

function M.create_commands()
  vim.api.nvim_create_user_command("PixiInit", function(opts)
    M.run_command("init", opts.args)
  end, {nargs = "?", desc = "Initialize a new pixi project"})

  vim.api.nvim_create_user_command("PixiAdd", function(opts)
    M.run_command("add", opts.args)
  end, {nargs = "+", desc = "Add a dependency to the pixi project"})

  vim.api.nvim_create_user_command("PixiRun", function(opts)
    M.run_command("run", opts.args)
  end, {nargs = "+", desc = "Run a command in the pixi environment"})

  vim.api.nvim_create_user_command("PixiShell", function()
    M.run_command("shell", "", {terminal = true})
  end, {desc = "Start a shell in the pixi environment"})

  vim.api.nvim_create_user_command("PixiInstall", function()
    M.run_command("install")
  end, {desc = "Install pixi dependencies"})

    vim.api.nvim_create_user_command("PixiInit", function(opts)
    M.run_command("init", opts.args)
  end, {nargs = "?", desc = "Initialize a new pixi project"})

  vim.api.nvim_create_user_command("PixiAdd", function(opts)
    M.run_command("add", opts.args)
  end, {nargs = "+", desc = "Add a dependency to the pixi project"})

  vim.api.nvim_create_user_command("PixiRun", function(opts)
    M.run_command("run", opts.args)
  end, {nargs = "+", desc = "Run a command in the pixi environment"})

  vim.api.nvim_create_user_command("PixiShell", function()
    M.run_command("shell", "", {terminal = true})
  end, {desc = "Start a shell in the pixi environment"})

  vim.api.nvim_create_user_command("PixiInstall", function()
    M.run_command("install")
  end, {desc = "Install pixi dependencies"})

  -- Add remaining commands from the pixi CLI
  vim.api.nvim_create_user_command("PixiCompletion", function(opts)
    M.run_command("completion", opts.args)
  end, {nargs = "?", desc = "Generate shell completion script"})

  vim.api.nvim_create_user_command("PixiGlobal", function(opts)
    M.run_command("global", opts.args)
  end, {nargs = "*", desc = "Global pixi management"})

  vim.api.nvim_create_user_command("PixiAuth", function(opts)
    M.run_command("auth", opts.args)
  end, {nargs = "*", desc = "Login to package servers"})

  vim.api.nvim_create_user_command("PixiTask", function(opts)
    M.run_command("task", opts.args)
  end, {nargs = "*", desc = "Manage project tasks"})

  vim.api.nvim_create_user_command("PixiInfo", function()
    M.run_command("info")
  end, {desc = "Show project and system information"})

  vim.api.nvim_create_user_command("PixiUpload", function(opts)
    M.run_command("upload", opts.args)
  end, {nargs = "+", desc = "Upload package to prefix.dev"})

  vim.api.nvim_create_user_command("PixiSearch", function(opts)
    M.run_command("search", opts.args)
  end, {nargs = "+", desc = "Search for packages"})

  vim.api.nvim_create_user_command("PixiProject", function(opts)
    M.run_command("project", opts.args)
  end, {nargs = "*", desc = "Project management"})

  vim.api.nvim_create_user_command("PixiHelp", function(opts)
    M.run_command("help", opts.args)
  end, {nargs = "?", desc = "Show pixi help"})
end


return M
