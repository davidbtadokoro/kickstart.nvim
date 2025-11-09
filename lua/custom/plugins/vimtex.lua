return {
  'lervag/vimtex',
  lazy = false,
  ft = { 'tex' },
  init = function()
    vim.g.vimtex_compiler_method = 'latexmk'

    -- Disable all forms of automatic compilation
    vim.g.vimtex_compiler_latexmk = {
      continuous = 0, -- no continuous compilation
      callback = 0, -- no automatic callback
      aux_dir = 'aux',
      out_dir = 'out',
      options = {
        '-pdf',
        '-interaction=nonstopmode',
        '-synctex=1',
      },
    }
    vim.g.vimtex_compiler_autostart = 0

    vim.g.vimtex_view_method = 'zathura'
    vim.g.vimtex_quickfix_mode = 1
  end,
  config = function()
    vim.keymap.set('n', '<leader>lc', function()
      vim.fn.delete('aux', 'rf') -- equivalent to `rm -rf aux`
      vim.cmd 'echohl Question | echom "VimTex: " | echohl None | echon "Cleaned aux files!"'
    end, { desc = 'VimTex [c]lean' })

    vim.keymap.set('n', '<leader>lC', function()
      vim.fn.delete('aux', 'rf')
      vim.fn.delete('out', 'rf')
      vim.cmd 'echohl Question | echom "VimTex: " | echohl None | echon "Cleaned aux and out files!"'
    end, { desc = 'VimTex full [C]lean' })
  end,
}
