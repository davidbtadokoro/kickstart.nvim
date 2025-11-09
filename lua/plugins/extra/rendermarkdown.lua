return {
  'MeanderingProgrammer/render-markdown.nvim',
  ft = { 'markdown' }, -- only loads for markdown files
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' }, -- if you use the mini.nvim suite
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    completions = { lsp = { enabled = true } },
    heading = { icons = { '󰉫 ', '󰉬 ', '󰉭 ', '󰉮 ', '󰉯 ', '󰉰 ' } },
  },
  keys = {
    {
      '<leader>m',
      function()
        require('render-markdown').toggle() -- example function, adjust to your needs
      end,
      desc = 'Toggle Render Markdown',
      ft = 'markdown', -- ensures the keymap is registered for markdown only
    },
  },
}
