-- plain Lua example (desktop Lua interpreter)
local chunk = loadstring("return 2 + 2")
print(chunk())  -- prints 4

local code = "for i=1,3 do print('hi', i) end"
local f = loadstring(code)
f()  -- executes the code in `code`
