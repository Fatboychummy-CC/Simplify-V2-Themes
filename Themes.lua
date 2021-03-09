local expect = require "cc.expect".expect

-- Downloads a file using http from sFileLocation
local function getFile(source)
  expect(1, source, "string")

  local h, err = http.get(source)
  if h then
    local data = h.readAll()
    h.close()
    return data
  else
    printError(string.format("Failed to download file from %s.", source))
    error(err, 2)
  end
end

-- parse the custom CSV format.
local function parseCustomCSV(data)

end

local module = {
  sources = {
    themeList = "https://raw.githubusercontent.com/Fatboychummy-CC/Simplify-V2-Themes/main/List.csv",
    layoutList = "https://raw.githubusercontent.com/Fatboychummy-CC/Simplify-V2-Themes/main/Layout.csv"
    self = "https://raw.githubusercontent.com/Fatboychummy-CC/Simplify-V2-Themes/main/Themes.lua"
  }
}

function module.getThemes()

end

function module.getLayouts()

end

return module
