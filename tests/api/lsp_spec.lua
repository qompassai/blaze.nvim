describe("LSP API", function()
  it("starts Mojo LSP client", function()
    require("blaze").setup({ lsp = { enabled = true } })
    local clients = vim.lsp.get_active_clients({ name = "mojo-lsp" })
    assert.are.equal(1, #clients)
  end)
end)

