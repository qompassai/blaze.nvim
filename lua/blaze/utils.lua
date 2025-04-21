---/blaze.nvim/lua/utils.lua
-------------------------------
local M = {}
---
function M.get_os_name()
  local os_name = vim.loop.os_uname().sysname:lower()
  return os_name
end
---
function M.is_linux()
  return M.get_os_name() == "linux"
end
---
function M.is_macos()
  return M.get_os_name() == "darwin"
end
---
function M.get_library_path()
  local os_name = M.get_os_name()
  local ext = os_name == "linux" and "so" or (os_name == "darwin" and "dylib" or "dll")
  local dirname = string.sub(debug.getinfo(1).source, 2, #"/utils.lua" * -1)
  return dirname .. ("../parser/?.%s"):format(ext)
end
function M.file_exists(path)
  local stat = vim.loop.fs_stat(path)
  return stat and stat.type == "file"
end
---
function M.dir_exists(path)
  local stat = vim.loop.fs_stat(path)
  return stat and stat.type == "directory"
end
---
function M.find_up(name, start_path)
  start_path = vim.fn.expand(start_path or vim.fn.getcwd())
  local path = start_path
  while path ~= "/" do
    local check_path = path .. "/" .. name
    if M.file_exists(check_path) or M.dir_exists(check_path) then
      return check_path
    end
    path = vim.fn.fnamemodify(path, ":h")
  end
  return nil
end
---
function M.detect_mojo_env()
  local env = {
    has_mojo = vim.fn.executable("mojo") == 1,
    has_modular = vim.fn.executable("modular") == 1,
    has_pixi = vim.fn.executable("pixi") == 1,
    has_docker = vim.fn.executable("docker") == 1,
    modular_path = vim.fn.expand("~/.modular"),
    pixi_project = M.find_up("pixi.toml") ~= nil,
    in_docker = M.file_exists("/.dockerenv"),
  }
  if env.has_modular then
    local handle = io.popen("modular config mojo.path 2>/dev/null")
    if handle then
      env.mojo_path = handle:read("*l")
      handle:close()
    end
  end
  if env.has_modular then
    local handle = io.popen("modular max list 2>/dev/null")
    if handle then
      local output = handle:read("*a")
      handle:close()
      env.has_max = output and output:match("max%-driver") ~= nil
    end
  end
  return env
end
---
function M.detect_gpu()
  local gpu = {
    has_nvidia = false,
    has_amd = false,
    has_intel = false,
    cuda_version = nil,
    rocm_version = nil,
    gpu_count = 0,
  }
  local nvidia_smi = io.popen("nvidia-smi --query-gpu=count,name,driver_version --format=csv,noheader 2>/dev/null")
  if nvidia_smi then
    local output = nvidia_smi:read("*a")
    nvidia_smi:close()
    if output and #output > 0 then
      gpu.has_nvidia = true
      gpu.gpu_count = tonumber(output:match("^%s*(%d+)") or "0")
      local cuda_version = io.popen("nvcc --version 2>/dev/null")
      if cuda_version then
        local cuda_output = cuda_version:read("*a")
        cuda_version:close()
        gpu.cuda_version = cuda_output and cuda_output:match("release%s+(%d+%.%d+)")
      end
    end
  end
  local rocm_smi = io.popen("rocm-smi --showproductname 2>/dev/null")
  if rocm_smi then
    local output = rocm_smi:read("*a")
    rocm_smi:close()
    if output and output:match("GPU%[") then
      gpu.has_amd = true
      local rocm_version = io.popen("rocm-smi --showversion 2>/dev/null")
      if rocm_version then
        local version_output = rocm_version:read("*a")
        rocm_version:close()
        gpu.rocm_version = version_output and version_output:match("ROCm Version:%s+(%d+%.%d+)")
      end
    end
  end
  local intel_gpu = io.popen("lspci | grep -i 'VGA\\|3D\\|Display' | grep -i intel 2>/dev/null")
  if intel_gpu then
    local output = intel_gpu:read("*a")
    intel_gpu:close()
    gpu.has_intel = output and #output > 0
  end
  return gpu
end
---
function M.detect_magic_docker()
  local magic = {
    enabled = false,
    image = nil,
    config_path = nil,
  }
  local magic_config = M.find_up(".magic.docker")
  if magic_config and M.file_exists(magic_config) then
    magic.enabled = true
    magic.config_path = magic_config
    local file = io.open(magic_config, "r")
    if file then
      local content = file:read("*all")
      file:close()
      magic.image = content:match('IMAGE="([^"]+)"') or content:match("IMAGE='([^']+)'")
    end
  end
  return magic
end
---
function M.setup_pixi_env()
  local pixi_env = {}
  local pixi_toml = M.find_up("pixi.toml")
  if pixi_toml and M.file_exists(pixi_toml) then
    pixi_env.project_root = vim.fn.fnamemodify(pixi_toml, ":h")
    pixi_env.has_pixi = true
    local pixi_path = io.popen("pixi info 2>/dev/null")
    if pixi_path then
      local info = pixi_path:read("*a")
      pixi_path:close()
      pixi_env.env_path = info and info:match("Environment path:%s+([^\n]+)")
    end
    if pixi_env.env_path then
      local bin_path = pixi_env.env_path .. "/bin"
      if M.dir_exists(bin_path) then
        pixi_env.bin_path = bin_path
      end
    end
  end
  return pixi_env
end
---
function M.load_parser_library()
  local library_path = M.get_library_path()
  if library_path and not string.find(package.cpath, library_path, 1, true) then
    local trim_semicolon = function(s)
      return s:sub(-1) == ";" and s:sub(1, -2) or s
    end
    package.cpath = trim_semicolon(package.cpath) .. ";" .. library_path
  end
  return library_path
end
---
function M.setup_ts_runtime_path()
  local runtime_path = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ':p:h:h:h') .. "/runtime"
  if M.dir_exists(runtime_path) then
    local rtp = vim.opt.rtp:get()
    if type(rtp) == "table" then
      if not vim.tbl_contains(rtp, runtime_path) then
        vim.opt.rtp:prepend(runtime_path)
      end
    else
      vim.opt.rtp:prepend(runtime_path)
    end
  end
  return runtime_path
end
---
return M
