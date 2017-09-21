--- Wrapping library to game's hierarchy in a shameless way.
Object = require "lib.object.Object"

--- Called before Object references are removed from parent.
-- This is not called when Object is garbage collected.
function Object:delete () end

return Object
