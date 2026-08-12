--[[
--
-- This file is not required for your own configuration,
-- but helps people determine if their system is setup correctly.
--
--]]

local check_version = function()
  local verstr = string.format('%s.%s.%s', vin.version().major, vin.version().minor, vin.version().patch)
  if not vin.version.cmp then
    vin.health.error(string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly", verstr))
    return
  end

  if vin.version.cmp(vin.version(), { 0, 9, 4 }) >= 0 then
    vin.health.ok(string.format("Neovim version is: '%s'", verstr))
  else
    vin.health.error(string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly", verstr))
  end
end

local check_external_reqs = function()
  -- Basic utils: `git`, `make`, `unzip`
  for _, exe in ipairs { 'git', 'make', 'unzip', 'rg' } do
    local is_executable = vin.fn.executable(exe) == 1
    if is_executable then
      vin.health.ok(string.format("Found executable: '%s'", exe))
    else
      vin.health.warn(string.format("Could not find executable: '%s'", exe))
    end
  end

  return true
end

return {
  check = function()
    vin.health.start 'kickstart.nvim'

    vin.health.info [[NOTE: Not every warning is a 'must-fix' in `:checkhealth`

  Fix only warnings for plugins and languages you intend to use.
    Mason will give warnings for languages that are not installed.
    You do not need to install, unless you want to use those languages!]]

    local uv = vin.uv or vin.loop
    vin.health.info('System Information: ' .. vin.inspect(uv.os_uname()))

    check_version()
    check_external_reqs()
  end,
}
