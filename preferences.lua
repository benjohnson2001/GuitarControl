local activeProjectIndex = 0
local sectionName = "com.pandabot.GuitarControl"

local teleModeKey = "teleMode"
local stratModeKey = "stratMode"

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
  return getValue(teleModeKey)
end

function setTeleMode(arg)
  setValue(teleModeKey, arg)
end

--

function getStratMode()
  return getValue(stratModeKey)
end

function setStratMode(arg)
  setValue(stratModeKey, arg)
end

--

function getGuitarMode(guitarName)

  if guitarName == "tele" then
    return getTeleMode()
  end

  if guitarName == "strat" then
    return getStratMode()
  end
end 

function setGuitarMode(guitarName, arg)

  if guitarName == "tele" then
    setTeleMode(arg)
  end

  if guitarName == "strat" then
    setStratMode(arg)
  end
end
