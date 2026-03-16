local M = {}

local function ensure_list(value)
  if value == nil then
    return {}
  end

  if type(value) == "table" then
    return vim.deepcopy(value)
  end

  return { value }
end

local function append_unique(existing, items)
  for _, item in ipairs(items) do
    if not vim.tbl_contains(existing, item) then
      table.insert(existing, item)
    end
  end

  return existing
end

function M.extend_servers(opts, servers)
  opts = opts or {}
  opts.servers = opts.servers or {}

  for server, server_opts in pairs(servers) do
    opts.servers[server] = vim.tbl_deep_extend("force", opts.servers[server] or {}, server_opts)
  end

  return opts
end

function M.extend_formatters(opts, formatters_by_ft)
  opts = opts or {}
  opts.formatters_by_ft = opts.formatters_by_ft or {}

  for ft, formatters in pairs(formatters_by_ft) do
    opts.formatters_by_ft[ft] = append_unique(
      ensure_list(opts.formatters_by_ft[ft]),
      ensure_list(formatters)
    )
  end

  return opts
end

function M.extend_linters(opts, linters_by_ft)
  opts = opts or {}
  opts.linters_by_ft = opts.linters_by_ft or {}

  for ft, linters in pairs(linters_by_ft) do
    opts.linters_by_ft[ft] = append_unique(
      ensure_list(opts.linters_by_ft[ft]),
      ensure_list(linters)
    )
  end

  return opts
end

return M
