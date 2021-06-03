local coauthors = require'something'
return require("telescope").register_extension {
  exports = {
    coauthors = coauthors,
  },
}
