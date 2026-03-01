local function base64_encode(input)
  local b64chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
  local result = {}

  local i = 1
  while i <= #input do
    local a = input:byte(i) or 0
    local b = input:byte(i + 1) or 0
    local c = input:byte(i + 2) or 0

    local triple = a * 65536 + b * 256 + c

    local s1 = math.floor(triple / 262144) % 64 + 1
    local s2 = math.floor(triple / 4096) % 64 + 1
    local s3 = math.floor(triple / 64) % 64 + 1
    local s4 = triple % 64 + 1

    result[#result + 1] = b64chars:sub(s1, s1)
    result[#result + 1] = b64chars:sub(s2, s2)
    result[#result + 1] = b64chars:sub(s3, s3)
    result[#result + 1] = b64chars:sub(s4, s4)

    i = i + 3
  end

  local padding = (3 - (#input % 3)) % 3
  if padding > 0 then
    result[#result] = "="
    if padding == 2 then
      result[#result - 1] = "="
    end
  end

  return table.concat(result)
end

local function chan_send(data)
  if vim.api and vim.api.nvim_chan_send and vim.v and vim.v.stderr then
    vim.api.nvim_chan_send(vim.v.stderr, data)
    return
  end
  if vim.fn and vim.fn.chansend and vim.v and vim.v.stderr then
    vim.fn.chansend(vim.v.stderr, data)
    return
  end
  local ok = pcall(function()
    io.stderr:write(data)
    io.stderr:flush()
  end)
  if not ok and vim.api and vim.api.nvim_echo then
    vim.api.nvim_echo({ { data, "None" } }, false, {})
  end
end

local last_paste = {
  lines = { "" },
  regtype = "v",
}

local function osc52_copy(lines, regtype)
  if type(lines) ~= "table" then
    return
  end

  last_paste.lines = lines
  last_paste.regtype = regtype or "v"

  local text = table.concat(lines, "\n")
  local encoded = base64_encode(text)
  local seq = "\x1b]52;c;" .. encoded .. "\x1b\\"
  chan_send(seq)
end

local function osc52_paste()
  return last_paste.lines, last_paste.regtype
end

vim.g.clipboard = {
  name = "osc52",
  copy = {
    ["+"] = osc52_copy,
    ["*"] = osc52_copy,
  },
  paste = {
    ["+"] = osc52_paste,
    ["*"] = osc52_paste,
  },
}
