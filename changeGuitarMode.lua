
local guitarModes = {"chord", "solo", "patterns", "clear"}
local guitarModeValues = {0.75, 1.0, 0.5}

function changeGuitarMode(guitarName, arg)

	local trackEnvelope = getTrackEnvelope(guitarName)
	deleteEnvelopePoints(trackEnvelope)

	local previousMode = getMediaItemMessage()

	if previousMode == guitarModes[1] then

		insertEnvelopePoint(trackEnvelope, soloModeValue)

		if guitarName == "tele" then
			setTeleMode("solo")
		end

		if guitarName == "strat" then
			setStratMode("solo")
		end

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