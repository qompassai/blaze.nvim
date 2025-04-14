describe("Treesitter Module", function()
  it("loads Mojo queries", function()
    local queries = vim.treesitter.query.get("mojo", "highlights")
    assert.truthy(queries)
  end)
end)

