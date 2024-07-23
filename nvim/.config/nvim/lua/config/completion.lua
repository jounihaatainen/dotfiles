local M = {}

M.setup = function()
  local cmp = require 'cmp'
  local luasnip = require 'luasnip'

  cmp.setup {
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert {
      ['<C-p>'] = cmp.mapping.scroll_docs(-4),
      ['<C-n>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
      ['<C-j>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<C-k>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<C-h>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<C-f>'] = cmp.mapping(function(fallback)
        if luasnip.choice_active() then
          luasnip.change_choice(1)
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<C-d>'] = cmp.mapping(function(fallback)
        if luasnip.choice_active() then
          luasnip.change_choice(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
    },
  }

  local ls = require('luasnip')
  local types = require("luasnip.util.types")

  ls.config.set_config({
    history = true,
    update_events = "TextChanged,TextChangedI",
    delete_checked_events = "TextChanged",
    ext_base_prio = 300,
    ext_prio_increase = 1,
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { "<- [choice]", "Error" } },
        }
      }
    }
  })
  ls.filetype_extend("javascriptreact", { "html" })
  ls.filetype_extend("typescriptreact", { "html" })
  ls.filetype_extend("razor", { "html" })

  require("luasnip.loaders.from_vscode").lazy_load()
end

return M

-- vim: ts=2 sts=2 sw=2 et
