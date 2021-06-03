local actions = require("telescope.actions")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local utils = require("telescope.utils")
local conf = require("telescope.config").values
local sorters = require("telescope.sorters")
local make_entry = require("telescope.make_entry")

return require("telescope").register_extension {
  export = {
    coauthors = function(opts)
      local results = utils.get_os_command_output({
        "git", "shortlog", "--summary", "--numbered", "--email", "--all"
      }, opts.cwd)

      pickers.new(opts, {
        prompt_title = 'Git Coauthors',
        finder = finders.new_table {
          results = results,
          --entry_maker = opts.entry_maker or make_entry.gen_from_git_commits(opts),
        },
        --previewer = previewers.git_commit_diff.new(opts),
        sorter = conf.get_generic_fuzzy_sorter(),
        -- attach_mappings = function()
        --   actions.select_default:replace(actions.git_checkout)
        --   return true
        -- end
      }):find()
    end
  }
}

