# Github-coauthors.nvim

This is a telescope extension for adding co-authors in your git commits.  This
works by looking at anyone that has committed to your repo.  You can fuzzy find
and multiselect the results.

## Requirements

- Neovim (>= 0.5)
- Telescope

### Installation

- Packer.nvim (adjust for your preferred plugin manager)

     `use('cwebster2/github-coauthors.nvim')`

- Register the extension with telescope

    `require('telescope').load_extension('githubcoauthors')`

- Add a mapping for

    `"<cmd>lua require('telescope').extensions.githubcoauthors.coauthors()<CR>"`

### Using this

When you pick your coauthors this plugin will put 2 blank lines below your current
position in your buffer and then an additional "Co-authored-by:" line for everyone
selected in the telescope picker.
