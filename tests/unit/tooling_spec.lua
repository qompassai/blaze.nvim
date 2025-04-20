describe("Pixi Integration", function()
  it("parses pixi.toml", function()
    local mock_toml = [[name = "mojo-project"]]
    local project = require("blaze.pixi").parse(mock_toml)
    assert.are.equal("mojo-project", project.name)
  end)
end)

