local activeProjectIndex = 0
local sectionName = "com.pandabot.GuitarControl"

local teleModeKey = "teleMode"

--

local function setValue(key, value)
  reaper.SetProjExtState(activeProjectIndex, sectionName, key, value)
end

local function getValue(key)

  local valueExists, value = reaper.GetProjExtState(activeProjectIndex, sectionName, key)
  return value
end

--

function getTeleMode()
  return getValue(teleModeKey, defaultTeleModeValue)
end

function setTeleMode(arg)
  setValue(teleModeKey, arg)
end
