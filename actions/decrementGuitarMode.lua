local workingDirectory = reaper.GetResourcePath() .. "/Scripts/GuitarControl"
require(workingDirectory .. "/util")
require(workingDirectory .. "/preferences")
require(workingDirectory .. "/mediaItemMessages")
require(workingDirectory .. "/envelopeFunctions")

function decrementGuitarMode(guitarName)

	local soloModeValue = 1.0
	local chordModeValue = 0.75
	local patternModeValue = 0.5

	local trackEnvelope = getTrackEnvelope(guitarName)
	deleteEnvelopePoints(trackEnvelope)
	setFirstEnvelopePointShapeToBeSquare(trackEnvelope)

	local previousMode = getMediaItemMessage(guitarName)

	if previousMode == "chord" then

		setGuitarMode(guitarName, "clear")

	elseif previousMode == "clear" then

		insertEnvelopePoint(trackEnvelope, patternModeValue)
		setGuitarMode(guitarName, "pattern")
	
	elseif previousMode == "pattern" then

		insertEnvelopePoint(trackEnvelope, soloModeValue)
		setGuitarMode(guitarName, "solo")

	elseif previousMode == "solo" then

		insertEnvelopePoint(trackEnvelope, chordModeValue)
		setGuitarMode(guitarName, "chord")
	end

	local currentMode = getGuitarMode(guitarName)

	deleteMediaItem(guitarName)

	if currentMode ~= "clear" then
		insertMediaItem(guitarName, currentMode)
	end
end


local teleModeHasNotBeenChanged = true
local stratModeHasNotBeenChanged = true
function decrementGuitarModeForSelectedTracks()

	local activeProjectIndex = 0
	local selectedTrackIndex = 0
	local wantMaster = false

	while true do

		local track = reaper.GetSelectedTrack2(activeProjectIndex, selectedTrackIndex, wantMaster)

		if track == nil then
			return
		end

	 	local _, trackName = reaper.GetTrackName(track, "")

	 	if teleModeHasNotBeenChanged and string.match(trackName, "tele") then
	 		decrementGuitarMode("tele")
	 		teleModeHasNotBeenChanged = false
	 	end

	 	if stratModeHasNotBeenChanged and string.match(trackName, "strat") then
	 		decrementGuitarMode("strat")
	 		stratModeHasNotBeenChanged = false
	 	end

		selectedTrackIndex = selectedTrackIndex + 1
	end
end

startUndoBlock()
decrementGuitarModeForSelectedTracks()
reaper.UpdateArrange()
endUndoBlock("decrement guitar mode")