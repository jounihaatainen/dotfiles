local setup = function()
  vim.g.fzf_vim = {
    preview_window = {
      "down,50%",
      "ctrl-/",
    }
  }
  -- vim.g.fzf_layout = {
  --   window = { width = 0.9, height = 0.6, relative = true, yoffset = 1.0 }
  -- }
end

return {
  setup = setup
}
