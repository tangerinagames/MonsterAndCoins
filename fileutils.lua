-------------------------------------------------------------------------------
--
--
--
--
--
-------------------------------------------------------------------------------

FileUtils = {}

function FileUtils.toString(filename)
  local f = io.open(filename, "rb")
  local content = f:read("*all")
  f:close()
  return content
end