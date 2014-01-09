-- usage: 
-- require("globalsafe")
-- local module,arg1,arg2 = require("somemodule")

local oldrequire = require

-- a shallow copy of a table
-- shallow means t.b.c = 3 is the same as tablecopy(t).b.c = 3

local tablecopy = function(t,newt)
    newt = newt or {}
    for n,v in pairs(t) do
        newt[n] = v
    end
    return newt
end


local function requireEnv(...) 
    -- first make a copy of the old environment
    -- this is a shallow copy
    local oldG = tablecopy(_G)
    -- second, save whatever require is right now
    local savereq = nil
    if require == requireEnv then
        savereq = require
    end
    -- now set require to the old require
    -- (so sub-requires don't return the globals)    
    require = oldrequire

    -- then get the results from the old require
    local results = {oldrequire(...)}

    -- restore the original require
    if savereq ~= nil then require = savereq end

    -- just in case
    _G.pairs = oldG.pairs
    -- newG will be the table we return, but not the _G when we return
    local newG = tablecopy(_G)
    -- _G will be a copy of oldG, i.e. the original global environment
    tablecopy(oldG,_G)
    -- and _G won't have any sneaky new things added to it that aren't in oldG
    for n,v in pairs(_G) do
        if oldG[n] == nil then
            _G[n] = nil
        end
    end
    -- returns globals,... instead of ... where globals is a table of (possibly modified) 
    -- global variables
    return newG,unpack(results)
end

require = requireEnv
