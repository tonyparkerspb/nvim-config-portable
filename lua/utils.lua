local fn = vim.fn

local M = {}

function M.executable(name)
  if fn.executable(name) > 0 then return true end

  return false
end

--- check whether a feature exists in Nvim
--- @feat: string
---   the feature name, like `nvim-0.7` or `unix`.
--- return: bool
M.has = function(feat)
  if fn.has(feat) == 1 then return true end

  return false
end

--- Create a dir if it does not exist
function M.may_create_dir(dir)
  local res = fn.isdirectory(dir)

  if res == 0 then fn.mkdir(dir, "p") end
end

function M.get_nvim_version()
  local actual_ver = vim.version()

  local nvim_ver_str = string.format("%d.%d.%d", actual_ver.major,
                                     actual_ver.minor, actual_ver.patch)
  return nvim_ver_str
end

--- Generate random integers in the range [Low, High], inclusive,
--- adapted from https://stackoverflow.com/a/12739441/6064933
--- @low: the lower value for this range
--- @high: the upper value for this range
function M.rand_int(low, high)
  -- Use lua to generate random int, see also: https://stackoverflow.com/a/20157671/6064933
  math.randomseed(os.time())

  return math.random(low, high)
end

--- Select a random element from a sequence/list.
--- @seq: the sequence to choose an element
function M.rand_element(seq)
  local idx = M.rand_int(1, #seq)

  return seq[idx]
end

function M.add_pack(name)
  local status, error = pcall(vim.cmd, "packadd " .. name)

  return status
end

function M.buffers(opts)
  opts = opts or {}
  opts.previewer = false
  -- opts.sort_lastused = true
  -- opts.show_all_buffers = true
  -- opts.shorten_path = false
  opts.attach_mappings = function(prompt_bufnr, map)
    local delete_buf = function()
      local current_picker = action_state.get_current_picker(prompt_bufnr)
      local multi_selections = current_picker:get_multi_selection()

      if next(multi_selections) == nil then
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.api.nvim_buf_delete(selection.bufnr, {force = true})
      else
        actions.close(prompt_bufnr)
        for _, selection in ipairs(multi_selections) do
          vim.api.nvim_buf_delete(selection.bufnr, {force = true})
        end
      end
    end

    map('i', '<C-x>', delete_buf)
    return true
  end
  require('telescope.builtin').buffers(require('telescope.themes').get_dropdown(
                                           opts))
end

return M
