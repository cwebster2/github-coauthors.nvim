local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local utils = require("telescope.utils")
local sorters = require("telescope.sorters")
local make_entry = require("telescope.make_entry")
local api = vim.api

return require("telescope").register_extension {
  exports = {
    coauthors = function(opts)
      opts = opts or {}
      opts.cwd = opts.cwd or vim.fn.getcwd()

      local command = {"git", "log", "--pretty=%aN <%aE>"}

      local seen = {};
      local string_entry_maker = make_entry.gen_from_string()
      opts.entry_maker = function(string)
        if (not seen[string]) then
          seen[string] = true
          return string_entry_maker(string)
        else
          return nil
        end
      end

      pickers.new(opts, {
        prompt_title = 'Git Coauthors',
        finder = finders.new_oneshot_job(command, opts),
        sorter = sorters.get_generic_fuzzy_sorter(),
        attach_mappings = function(prompt_bufnr, map)
          local insert_coauthors = function()
            local picker = action_state.get_current_picker(prompt_bufnr)
            local selections = picker:get_multi_selection()
            if next(selections) == nil then
              selections = {picker:get_selection()}
            end
            actions.close(prompt_bufnr)

            local coauthors = {"",""}
            for _, c in ipairs(selections) do
              table.insert(coauthors, "Co-authored-by: "..c[1])
            end
            api.nvim_put(coauthors, "l", true, false)
          end

          map('i', '<CR>', insert_coauthors)
          map('n', '<CR>', insert_coauthors)

          return true
        end,
      }):find()
    end
  }
}

