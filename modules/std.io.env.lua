-- Environment

require "std.list"


-- @func io.shell: Perform a shell command and return its output
--   @param c: command
-- returns
--   @param o: output, or nil if error
function io.shell (c)
  local h = io.popen (c)
  local o
  if h then
    o = h:read ("*a")
    h:close ()
  end
  return o
end

-- @func io.processFiles: Process files specified on the command-line
-- file name "-" means io.stdin
--   @param f: function to process files with
--     @param name: the name of the file being read
--     @param i: the number of the argument
function io.processFiles (f)
  for i = 1, table.getn (arg) do
    if arg[i] == "-" then
      io.input (io.stdin)
    else
      io.input (arg[i])
    end
    prog.file = arg[i]
    f (arg[i], i)
  end
end

-- @func readDir: Make a list of a directory's contents
--   @param d: directory
-- returns
--   @param l: list of files
function io.readDir (d)
  local l = split ("\n", string.chomp (shell ("ls -aU " .. d ..
                                       " 2>/dev/null")))
  table.remove (l, 1) -- remove . and ..
  table.remove (l, 1)
  return l
end
