describe(":BlazeBuild command", function()
  it("triggers build workflow", function()
    vim.cmd("BlazeBuild")
    assert.matches("Build started", vim.fn.getqflist()[1].text)
  end)
end)

