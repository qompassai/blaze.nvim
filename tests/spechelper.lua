-- tests/spechelper.lua

local plugin_root = assert(os.getenv("PWD"),
  "PWD environment variable must point to your plugin root")

package.path = table.concat({
  plugin_root .. "/lua/?.lua",
  plugin_root .. "/lua/?/init.lua",
  package.path,
}, ";")

package.preload["helpers"] = function()
  return dofile(plugin_root .. "/tests/helpers/init.lua")
end

require("helpers")
