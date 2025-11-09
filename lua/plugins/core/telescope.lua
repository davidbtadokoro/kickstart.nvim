return { -- Fuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',

      build = 'make',

      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },

    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    require('telescope').setup {
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    local pickers = require 'telescope.pickers'
    local finders = require 'telescope.finders'
    local conf = require('telescope.config').values

    local function format_lhs(lhs)
      if lhs:find('^' .. ' ') then
        lhs = lhs:gsub('^%s', '<leader>')
      end
      return lhs
    end

    local function keymaps_with_rhs(opts)
      opts = opts or {}
      local modes = opts.modes or { 'n', 'i', 'c', 'x' }
      local results = {}

      for _, mode in ipairs(modes) do
        for _, map in ipairs(vim.api.nvim_get_keymap(mode)) do
          table.insert(results, {
            mode = mode,
            lhs = map.lhs,
            rhs = map.rhs or '[no-rhs]',
            desc = map.desc or '[no-desc]',
          })
        end
      end

      pickers
        .new(opts, {
          prompt_title = 'Keymaps',
          finder = finders.new_table {
            results = results,
            entry_maker = function(entry)
              local lhs_display = format_lhs(entry.lhs)
              return {
                value = entry,
                display = string.format('%-2s │ %-30s │ %-40s │ %s', entry.mode, lhs_display, entry.desc, entry.rhs),
                ordinal = lhs_display .. ' ' .. (entry.desc or '') .. ' ' .. (entry.rhs or ''),
              }
            end,
          },
          sorter = conf.generic_sorter(opts),
          attach_mappings = function(prompt_bufnr, map)
            local action_state = require 'telescope.actions.state'

            local function scroll_horiz(direction)
              local results_win = action_state.get_current_picker(prompt_bufnr).results_win
              vim.api.nvim_win_call(results_win, function()
                if direction > 0 then
                  vim.cmd 'normal! 10zl' -- scroll right
                else
                  vim.cmd 'normal! 10zh' -- scroll left
                end
              end)
            end

            -- Map <C-l> (scroll right) and <C-h> (scroll left)
            map('n', '<C-l>', function()
              scroll_horiz(1)
            end)
            map('n', '<C-h>', function()
              scroll_horiz(-1)
            end)
            map('i', '<C-l>', function()
              scroll_horiz(1)
            end)
            map('i', '<C-h>', function()
              scroll_horiz(-1)
            end)

            return true
          end,
        })
        :find()
    end

    vim.keymap.set('n', '<leader>sk', keymaps_with_rhs, { desc = '[S]earch [K]eymaps' })

    local builtin = require 'telescope.builtin'

    vim.keymap.set('n', '<leader>sf', function()
      builtin.find_files {
        hidden = true,
        find_command = function(_)
          return { 'fdfind', '--type', 'f', '--hidden', '--no-ignore', '--exclude', '.git/' }
        end,
      }
    end, { desc = '[S]earch [F]iles' })

    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

    vim.keymap.set('n', '<leader>/', function()
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = '[S]earch [/] in Open Files' })

    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })
  end,
}
