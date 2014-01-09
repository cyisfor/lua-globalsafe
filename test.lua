derp = 23

require("globalsafe")
print(derp)
local bad1,bad2 = require("bad")
assert(derp == 23)
print(bad1.derp(39))
print(derp)
