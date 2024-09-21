--[[
Copyright: Ren Tatsumoto and contributors
License: GNU GPL, version 3 or later; http://www.gnu.org/licenses/gpl.html

Platform-specific functions for *nix systems.
]]

local h = require('helpers')
local self = { healthy = true, clip_util = "", clip_cmd = "", }

local function split_string(string_, sep)
    local ret_val = {}
    for substr in string.gmatch(string_, "([^" .. sep .. "]+)")do
        table.insert(ret_val, substr)
    end
    return ret_val
end

local function contains(string_list, target)
    for i=1, #string_list do
        if string_list[i] == target then
            return true
        end
    end
    return false
end

if h.is_mac() then
    self.clip_util = "pbcopy"
    self.clip_cmd = "LANG=en_US.UTF-8 " .. self.clip_util
elseif h.is_wayland() then
    local function is_wl_copy_installed()
        local handle = h.subprocess { 'wl-copy', '--version' }
        return handle.status == 0 and contains(split_string(handle.stdout, "%s"), "wl-clipboard")--handle.stdout:match("wl-clipboard") ~= nil
    end
    self.clip_util = "wl-copy"
    self.clip_cmd = self.clip_util
    self.healthy = is_wl_copy_installed()
else
    local function is_xclip_installed()
        local handle = h.subprocess { 'xclip', '-version' }
        return handle.status == 0 and contains(split_string(handle.stdout, "%s"), "xclip version")--handle.stderr:match("xclip version") ~= nil
    end

    self.clip_util = "xclip"
    self.clip_cmd = self.clip_util .. " -i -selection clipboard"
    self.healthy = is_xclip_installed()
end

self.tmp_dir = function()
    return os.getenv("TMPDIR") or '/tmp'
end

self.copy_to_clipboard = function(text)
    local handle = io.popen(self.clip_cmd, 'w')
    handle:write(text)
    handle:close()
end

self.curl_request = function(url, request_json, completion_fn)
    local args = { 'curl', '-s', url, '-X', 'POST', '-d', request_json }
    return h.subprocess(args, completion_fn)
end


return self
