local M = {}
function M.copy_to_clipboard(with_line)
  local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
  if path == "" then return vim.notify("Salve o arquivo primeiro", vim.log.levels.WARN) end
  if with_line then path = path .. ":" .. vim.fn.line(".") end
  vim.fn.setreg("+", path)
  vim.notify("Copiado: " .. path)
end
function M.shallow_copy(source)
  local copy = {}
  for k, v in pairs(source) do copy[k] = v end
  return copy
end
function M.shallow_merge(a, b)
  local result = M.shallow_copy(a)
  for k, v in pairs(b) do result[k] = v end
  return result
end
function M.hex_to_rgb(hex)
  local value = hex:gsub("^#", "")
  assert(value:match("^%x+$") and (#value == 3 or #value == 6), "Cor hex inválida")
  if #value == 3 then value = value:gsub("%x", function(c) return c .. c end) end
  return { tonumber(value:sub(1, 2), 16), tonumber(value:sub(3, 4), 16), tonumber(value:sub(5, 6), 16) }
end
function M.rgb_to_hsl(r, g, b)
  r, g, b = r / 255, g / 255, b / 255
  local hi, lo = math.max(r, g, b), math.min(r, g, b)
  local delta, light = hi - lo, (hi + lo) / 2
  if delta == 0 then return 0, 0, light * 100 end
  local hue
  if hi == r then hue = ((g - b) / delta) % 6
  elseif hi == g then hue = (b - r) / delta + 2
  else hue = (r - g) / delta + 4 end
  return hue * 60, delta / (1 - math.abs(2 * light - 1)) * 100, light * 100
end
function M.hex_to_HSL(hex)
  local rgb = M.hex_to_rgb(hex)
  local h, s, l = M.rgb_to_hsl(unpack(rgb))
  return string.format("hsl(%d, %d%%, %d%%)", math.floor(h + .5), math.floor(s + .5), math.floor(l + .5))
end
function M.replace_hex_with_HSL()
  local line = vim.api.nvim_get_current_line()
  local converted = line:gsub("#(%x+)(%f[^%w_])", function(hex)
    if #hex ~= 3 and #hex ~= 6 then return "#" .. hex end
    return M.hex_to_HSL(hex)
  end)
  vim.api.nvim_set_current_line(converted)
end
return M
