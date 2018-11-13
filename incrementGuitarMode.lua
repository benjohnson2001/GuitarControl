local workingDirectory = reaper.GetResourcePath() .. "/Scripts/GuitarControl"
require(workingDirectory .. "/util")
require(workingDirectory .. "/preferences")
require(workingDirectory .. "/mediaItemMessages")
require(workingDirectory .. "/envelopeFunctions")

function incrementGuitarMode(guitarName)

	local soloModeValue = 1.0
	local chordModeValue = 0.75
	local patternsModeValue = 0.5

	local trackEnvelope = getTrackEnvelope(guitarName)
	deleteEnvelopePoints(trackEnvelope)

	local previousMode = getMediaItemMessage(guitarName)

	if previousMode == "chord" then

		insertEnvelopePoint(trackEnvelope, soloModeValue)
		setGuitarMode(guitarName, "solo")

	elseif previousMode == "solo" then

		insertEnvelopePoint(trackEnvelope, patternsModeValue)
		setGuitarMode(guitarName, "patterns")
	
	elseif previousMode == "patterns" then

		setGuitarMode(guitarName, "clear")

	elseif previousMode == "clear" then

		insertEnvelopePoint(trackEnvelope, chordModeValue)
		setGuitarMode(guitarName, "chord")
	end

	local currentMode = getGuitarMode(guitarName)

	deleteMediaItem(guitarName)

	if currentMode ~= "clear" then
		insertMediaItem(guitarName, currentMode)
	end
end


function incrementGuitarModeForSelectedTracks()

	local activeProjectIndex = 0
	local selectedTrackIndex = 0
	local wantMaster = false

	while true do

		local track = reaper.GetSelectedTrack2(activeProjectIndex, selectedTrackIndex, wantMaster)

		if track == nil then
			return
		end

	 	local _, trackName = reaper.GetTrackName(track, "")

	 	if string.match(trackName, "tele") then
	 		incrementGuitarMode("tele")
	 	end

	 	if string.match(trackName, "strat") then
	 		incrementGuitarMode("strat")
	 	end

		selectedTrackIndex = selectedTrackIndex + 1
	end
end

incrementGuitarModeForSelectedTracks()
reaper.UpdateArrange()