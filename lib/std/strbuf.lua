--[[--
 String buffers.

 Prototype Chain
 ---------------

      table
       `-> Object
            `-> StrBuf

 @classmod std.strbuf
]]

local base   = require "std.base"

local Object = require "std.object" {}

local insert = base.insert


--- Add a string to a buffer.
-- @tparam string s string to add
-- @treturn std.strbuf modified buffer
local function concat (self, s)
  return insert (self, s)
end


--- Convert a buffer to a string.
-- @treturn string stringified `self`
local function tostring (self)
  return table.concat (self)
end


return Object {
  -- Derived object type.
  _type = "StrBuf",

  ------
  -- Support concatenation of StrBuf objects.
  --     buffer = buffer .. str
  -- @function __concat
  -- @tparam std.strbuf buffer StrBuf object
  -- @tparam string str a string or string-like object
  -- @treturn std.strbuf modified `buffer`
  -- @see concat
  __concat   = concat,


  ------
  -- Support fast conversion to Lua string.
  --     str = tostring (buffer)
  -- @function __tostring
  -- @tparam std.strbuf buffer Strbuf object
  -- @treturn string concatenation of buffer contents
  -- @see tostring
  __tostring = tostring,


  --- @export
  __index = {
    concat   = concat,
    tostring = tostring,
  },
}
