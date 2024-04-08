local formatter = require "lvim.lsp.null-ls.formatters"

formatter.setup {
  {
    name = "prettier",
    filetypes = { "typescript", "typescriptreact" },
  },
}
