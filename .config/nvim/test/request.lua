local parent_function_names = {}
local cursor_node = vim.treesitter.get_node()

local function test()
  local function test2() end
end
require('mini.ai').setup(
)
local node = cursor_node
while node do
  local type = node:type()
  if type and type:find('function_declaration') then
    for child_node, name in node:iter_children() do
      if name == 'name' then
        local function_name = vim.treesitter.get_node_text(child_node, 0)
        table.insert(parent_function_names, function_name)
      end
    end
  end
  node = node:parent()
end
vim.print(table.concat(parent_function_names, ' > '))
