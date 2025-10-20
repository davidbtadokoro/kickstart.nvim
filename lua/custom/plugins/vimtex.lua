return {
  'lervag/vimtex',
  lazy = false,
  ft = { 'tex' },
  init = function()
    -- Basic VimTeX settings
    vim.g.vimtex_compiler_method = 'latexmk'
    vim.g.vimtex_view_method = 'zathura' -- or 'mupdf', 'skim', 'okular', etc.
    vim.g.vimtex_quickfix_mode = 0 -- optional: disable quickfix popup
  end,
}
