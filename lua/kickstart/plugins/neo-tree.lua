-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    filesystem = {
      filtered_items = {
        visible = true, -- show filtered items as "dimmed"
        hide_dotfiles = false, -- show dotfiles
        hide_gitignored = false,
        hide_hidden = false, -- for Windows support
      },
      window = {
        position = 'float',
        popup = {
          size = {
            width = 0.8, -- 80% of editor width
            height = 0.8, -- 80% of editor height
          },
          -- Optional: add a border
          border = 'rounded',
          -- Center the float automatically
          -- Neo-tree centers by default when using float
        },
        mappings = {
          ['\\'] = 'close_window',
          ['t'] = 'open_tabnew',
          ['w'] = 'open',
        },
      },
    },
  },

  config = function(_, opts)
    require('neo-tree').setup(opts)

    -- Make Neo-tree transparent
    vim.api.nvim_create_autocmd('ColorScheme', {
      callback = function()
        vim.cmd [[
          highlight NeoTreeNormal guibg=NONE ctermbg=NONE
          highlight NeoTreeNormalNC guibg=NONE ctermbg=NONE
        ]]
      end,
    })

    -- Also apply transparency right away (in case colorscheme already loaded)
    vim.cmd [[
      highlight NeoTreeNormal guibg=NONE ctermbg=NONE
      highlight NeoTreeNormalNC guibg=NONE ctermbg=NONE
    ]]
  end,
}
