-- Regular expressions


-- @function string.findt: Do string.find, returning captures as a list
--   @param s: target string
--   @param p: pattern
--   @param [init]: start position [1]
--   @param [plain]: inhibit magic characters [nil]
-- returns
--   @param from, to: start and finish of match
--   @param capt: table of captures
function string.findt (s, p, init, plain)
  local pack =
    function (from, to, ...)
      return from, to, arg
    end
  return pack (string.find (s, p, init, plain))
end

-- @function string.finds: Do multiple string.find's on a string
--   @param s: target string
--   @param p: pattern
--   @param [init]: start position [1]
--   @param [plain]: inhibit magic characters [nil]
-- returns
--   @param t: table of {from=from, to=to; capt = {captures}}
function string.finds (s, p, init, plain)
  init = init or 1
  local t = {}
  local from, to, r
  repeat
    from, to, r = string.findt (s, p, init, plain)
    if from ~= nil then
      table.insert (t, {from = from, to = to, capt = r})
      init = to + 1
    end
  until not from
  return t
end

-- @function string.gsubs: Perform multiple calls to string.gsub
--   @param s: string to call string.gsub on
--   @param sub: {pattern1=replacement1 ...}
--   @param [n]: upper limit on replacements [infinite]
-- returns
--   @param s_: result string
--   @param r: number of replacements made
function string.gsubs (s, sub, n)
  local r = 0
  for i, v in pairs (sub) do
    local rep
    if n ~= nil then
      s, rep = string.gsub (s, i, v, n)
      r = r + rep
      n = n - rep
      if n == 0 then
        break
      end
    else
      s, rep = string.gsub (s, i, v)
      r = r + rep
    end
  end
  return s, r
end

-- @function string.split: Turn a string into a list of strings,
-- breaking at sep
--   @param [sep]: separator regex ["%s+"]
--   @param s: string to split
-- returns
--   @param l: list of strings
function string.split (sep, s)
  if s == nil then
    s, sep = sep, "%s+"
  end
  local t, len = {n = 0}, string.len (s)
  local init, oldto, from = 1, 0, 0
  local to
  while init <= len and from do
    from, to = string.find (s, sep, init)
    if from ~= nil then
      if oldto > 0 or to > 0 then
        table.insert (t, string.sub (s, oldto, from - 1))
      end
      init = math.max (from + 1, to + 1)
      oldto = to + 1
    end
  end
  if (oldto <= len or to == len) and len > 0 then
    table.insert (t, string.sub (s, oldto))
  end
  return t
end

-- TODO: @function string.rgsub: string.gsub-like wrapper for match
-- really needs to be in C for speed (replace gmatch)
--   @param s: target string
--   @param p: pattern
--   @param r: function
--     @param t: table of captures
--   @param [n]: maximum number of substutions [infinite]
--   returns
--     @param rep: replacement
-- returns
--   @param n: number of substitutions made

-- TODO: @function string.checkRegex: check regex is valid
--   @param p: regex pattern
-- returns
--   @param f: true if regex is valid, or nil otherwise

-- TODO: @function rex.check{Posix,PCRE}Regex: check POSIX regex is valid
--   @param p: POSIX regex pattern
-- returns
--   @param f: true if regex is valid, or nil otherwise

-- @function string.next: iterator for strings
-- TODO: Update for new for
--   @param s: string being iterated over
--   @param p: pattern being iterated with
--   @param f: function to be iterated
--     @param from, to: start and end points of substring
--     @param capt: table of captures
--     @param t: result accumulator (initialised to t below)
--     @param s: string being iterated over (same as s above)
--   returns
--     @param cont: point at which to continue, or false to stop
--   @param t: result accumulator (usually result table)
-- returns
--   @param u: result accumulator (same as u argument)
function string.next (s, p, f, t)
  t = t or {}
  local from, to, capt
  repeat
    from, to, capt = string.findt (s, p, from)
    if from and to then
      from = f (from, to, capt, t, s)
    end
  until not (from and to)
  return t
end
