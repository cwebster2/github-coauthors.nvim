local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local utils = require("telescope.utils")
local sorters = require("telescope.sorters")
local api = vim.api

return require("telescope").register_extension {
  exports = {
    coauthors = function(opts)
      opts = opts or {}
      opts.cwd = opts.cwd or vim.fn.getcwd()

      -- get authors that have contributed to the current repo
      local results = utils.get_os_command_output({
        "git", "shortlog", "--summary", "--numbered", "--email", "--all"
      }, opts.cwd)

      -- strip commit counts from the results
      for k, r in ipairs(results) do
        results[k] = r:match("^%s*%d+%s+(.*)$")
      end

      pickers.new(opts, {
        prompt_title = 'Git Coauthors',
        finder = finders.new_table {
          results = results,
        },
        sorter = sorters.get_generic_fuzzy_sorter(),
        attach_mappings = function(prompt_bufnr, map)
          local insert_coauthors = function()
            -- local selections = action_state.get_selected_entry()
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

