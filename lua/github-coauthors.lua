local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local action_set = require("telescope.actions.set")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local utils = require("telescope.utils")
local conf = require("telescope.config").values
local sorters = require("telescope.sorters")
local make_entry = require("telescope.make_entry")
local Job = require("plenary.job")

--local previewers = require("github-coauthors.previewers")

local M = {}

local dropdown_opts = require('telescope.themes').get_dropdown({
  results_height = 15;
  width = 0.4;
  previewer = false;
  borderchars = {
    prompt = {'▀', '▐', '▄', '▌', '▛', '▜', '▟', '▙' };
    results = {' ', '▐', '▄', '▌', '▌', '▐', '▟', '▙' };
    preview = {'▀', '▐', '▄', '▌', '▛', '▜', '▟', '▙' };
  };
})

M.coauthors = function(opts)
  local results = utils.get_os_command_output({
    "git", "shortlog", "--summary", "--numbered", "--email", "--all"
  }, opts.cwd)

  pickers.new(opts, {
    prompt_title = 'Git Coauthors',
    finder = finders.new_table {
      results = results,
      entry_maker = opts.entry_maker or make_entry.gen_from_git_commits(opts),
    },
    previewer = previewers.git_commit_diff.new(opts),
    sorter = conf.file_sorter(opts),
    -- attach_mappings = function()
    --   actions.select_default:replace(actions.git_checkout)
    --   return true
    -- end
  }):find()
end

return M;
