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
  expect(1, data, "string")

  local parsed = {}

  -- clear out whitespace
  data = data:gsub(' ', "")

  -- clear out comments
  data = data:gsub('#.-\n', "\n")

  -- basic crappy error handling
  if data:find(",,") or data:find(",\n") then
    local i = 1
    for line in data:gmatch("[^\n]+") do
      if data:find(",,") or data:find(",\n") then
        error(string.format("CSV syntax error on line %d of input.", i))
      end
      i = i + 1
    end
  end

  -- process each line that has data in it.
  local i = 1
  for line in data:gmatch("[^\n]+") do
    local index = 1
    local items = {}
    local category, subcategory

    -- process each comma seperated value
    for label in line:gmatch("[^,]+") do
      if index == 1 then
        category = label
      elseif index == 2 then
        subcategory = label
      else
        items[#items + 1] = label
      end
      index = index + 1
    end

    -- basic error check for missing data
    if not category or not subcategory or #items == 0 then
      error(string.format("CSV missing data on line %d of input.", i))
    end

    -- add to parsed data
    parsed[#parsed + 1] = {
      category = category,
      subcategory = subcategory,
      items = items
    }

    i = i + 1
  end

  return parsed
end

local module = {
  sources = {
    themeList = "https://raw.githubusercontent.com/Fatboychummy-CC/Simplify-V2-Themes/main/List.csv",
    layoutList = "https://raw.githubusercontent.com/Fatboychummy-CC/Simplify-V2-Themes/main/Layout.csv",
    self = "https://raw.githubusercontent.com/Fatboychummy-CC/Simplify-V2-Themes/main/Themes.lua",
    rootTheme = "https://raw.githubusercontent.com/Fatboychummy-CC/Simplify-V2-Themes/main/Themes",
    rootLayouts = "https://raw.githubusercontent.com/Fatboychummy-CC/Simplify-V2-Themes/main/Layouts"
  },
  getFormat = "%s/%s/%s/%s"
}

function module.getThemes()
  return parseCustomCSV(getFile(module.sources.themeList))
end

function module.getTheme(category, subcategory, label)
  local source = string.format(module.getFormat, module.sources.rootTheme, category, subcategory, label)

end

function module.getLayouts()
  return parseCustomCSV(getFile(module.sources.layoutList))
end

function module.getLayout(category, subcategory, label)
  local source = string.format(module.getFormat, module.sources.rootLayout, category, subcategory, label)
  
end

return module
