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

local get_coauthors = function()
  Job:new({
    command = "git",
    args = { "shortlog", "--summary", "--numbered", "--email", "--all" },
    --cwd,
    --env,
    on_exit = function(j, return_val)
      print(return_val)
      print(j:result())
    end,
  }):start()
end

function M.coauthors()
  get_coauthors()
end

return M;
