-- TODO: this is native-love-only, and no special windows handling (for no-curl scenerio)
-- use love.system.getOS() to detect what to load

local lovehandles = require('lovehandles')

local req = lovehandles([[
  local function encode(str)
    str = string.gsub (str, "\r?\n", "\r\n")
    str = string.gsub (str, "([^%w%-%.%_%~ ])", function (c) return string.format ("%%%02X", string.byte(c)) end)
    str = string.gsub (str, " ", "+")
    return str
  end

  local function table_to_url(t)
    local argts = {}
    local i = 1
    for k, v in pairs(t) do
      argts[i]=encode(k).."="..encode(v)
      i=i+1
    end
    return table.concat(argts,'&')
  end

  local req = require("luajit-request")
  local json = require("dkjson")
  local url = args[1]
  local options = args[2] or {}

  if options["data"] then
    options["data"] = json.encode(options["data"])
  end
  
  if options["_raw"] then
    table.remove(options, "_raw")
    return req.send(url, options)
  else
    options.headers = options.headers or {}
    options.headers["accept"] = "application/json"
    local r = req.send(url, options)
    if r and r.body then
      return json.decode(r.body)
    else
      error("Issue parsing body.")
    end
  end
]])

local rest = {}

-- Don't manage input/output, just return the raw request-object
function rest:request(url, options)
  options = options or {}
  options["_raw"] = true
  return req(url, options)
end

-- Perform a HEAD request
function rest:head(url, options)
  options = options or {}
  options["method"] = "HEAD"
  return req(url, options)
end

-- Perform a GET request
function rest:get(url, options)
  return req(url, options or {})
end

-- Perform a POST request
function rest:post(url, input, options)
  options = options or {}
  options["method"] = "POST"
  if input then
    options["data"] = input or {}
  end
  return req(url, options)
end

-- Perform a PUT request
function rest:put(url, input, options)
  options = options or {}
  options["method"] = "PUT"
  if input then
    options["data"] = input or {}
  end
  return req(url, options)
end

-- Perform a PATCH request
function rest:patch(url, input, options)
  options = options or {}
  options["method"] = "PATCH"
  if input then
    options["data"] = input or {}
  end
  return req(url, options)
end

-- Perform a DELETE request
function rest:delete(url, input, options)
  options = options or {}
  options["method"] = "DELETE"
  if input then
    options["data"] = input or {}
  end
  return req(url, options)
end

return rest