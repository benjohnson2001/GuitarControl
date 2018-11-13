local workingDirectory = reaper.GetResourcePath() .. "/Scripts/GuitarControl"
require(workingDirectory .. "/util")
require(workingDirectory .. "/preferences")
require(workingDirectory .. "/mediaItemMessages")

local function getTeleModeTrackEnvelope()

	local pluginTrack = getTrack("UVIWorkstation")
	return reaper.GetTrackEnvelopeByName(pluginTrack, "teleMode / UVIWorkstation")
end

local function getCurrentModeValue()

	local trackEnvelope = getTrackEnvelope()

	local timeOfCurrentBar = getTimeOfCurrentBar()
	local envelopePointIndex = reaper.GetEnvelopePointByTime(trackEnvelope, timeOfCurrentBar)
	local _, _, envelopePoint = reaper.GetEnvelopePoint(trackEnvelope, envelopePointIndex)

	return envelopePoint
end

local envelopeTimeDelta = 0.03

local function deleteEnvelopePoints(trackEnvelope)

	local timeOfCurrentBar = getTimeOfCurrentBar()
	local timeOfNextBar = getTimeOfNextBar()
	reaper.DeleteEnvelopePointRange(trackEnvelope, timeOfCurrentBar-envelopeTimeDelta/2-tolerance, timeOfNextBar-envelopeTimeDelta+tolerance)
end

local function insertEnvelopePoint(trackEnvelope, envelopePointValue)
	
	local timeOfCurrentBar = getTimeOfCurrentBar()
	local timeOfNextBar = getTimeOfNextBar()

	local shape = -1
	local tension = -1
	local pointIsSelected = false

	reaper.InsertEnvelopePoint(trackEnvelope, timeOfCurrentBar-envelopeTimeDelta/2, envelopePointValue, shape, tension, pointIsSelected)
	reaper.InsertEnvelopePoint(trackEnvelope, timeOfNextBar-envelopeTimeDelta, envelopePointValue, shape, tension, pointIsSelected)
end

local soloModeValue = 1.0
local chordModeValue = 0.75
local patternsModeValue = 0.5

function incrementTeleGuitarMode()

	local trackEnvelope = getTeleModeTrackEnvelope()
	deleteEnvelopePoints(trackEnvelope)

	local previousMode = getMediaItemMessage()

	if previousMode == "chord" then

		insertEnvelopePoint(trackEnvelope, soloModeValue)
		setTeleMode("solo")

	elseif previousMode == "solo" then

		insertEnvelopePoint(trackEnvelope, patternsModeValue)
		setTeleMode("patterns")
	
	elseif previousMode == "patterns" then

		setTeleMode("clear")

	elseif previousMode == "clear" then

		insertEnvelopePoint(trackEnvelope, chordModeValue)
		setTeleMode("chord")
	end

	local currentMode = getTeleMode()

	deleteMediaItem()

	if currentMode ~= "clear" then
		insertMediaItem(currentMode)
	end
end

incrementTeleGuitarMode()
reaper.UpdateArrange()