describe("Magic Integration - Environment Setup", function()
  it("validates environment with frozen lockfile", function()
    local output = vim.fn.system("magic list --frozen")
    assert.matches("Environment is up-to-date", output)
  end)

  it("revalidates broken environments", function()
    local output = vim.fn.system("magic list --revalidate")
    assert.matches("Reinstalled broken environment", output)
  end)
end)

