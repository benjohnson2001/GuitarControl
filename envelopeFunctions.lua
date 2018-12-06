local envelopeTimeDelta = 0.03

function teleTrackEnvelope()

	local pluginTrack = getTrack("tele")
	return reaper.GetTrackEnvelopeByName(pluginTrack, "Modes / UVIWorkstation")
end

function stratTrackEnvelope()

	local pluginTrack = getTrack("strat")
	return reaper.GetTrackEnvelopeByName(pluginTrack, "Modes / UVIWorkstation")
end

function getTrackEnvelope(guitarName)

	if guitarName == "tele" then
		return teleTrackEnvelope()
	end

	if guitarName == "strat" then
		return stratTrackEnvelope()
	end

	return nil
end

function deleteEnvelopePoints(trackEnvelope)

	local timeOfCurrentBar = getTimeOfCurrentBar()
	local timeOfNextBar = getTimeOfNextBar()
	reaper.DeleteEnvelopePointRange(trackEnvelope, timeOfCurrentBar-envelopeTimeDelta/2-tolerance, timeOfNextBar-envelopeTimeDelta+tolerance)
end

function squareEnvelopeShape()
	return 1
end

function cursorIsAtTheBeginning()
	return reaper.GetCursorPosition() == 0
end

function setFirstEnvelopePointShapeToBeSquare(trackEnvelope)

	local envelopePointIndex = 0
	local shape = squareEnvelopeShape()

	local _, time, value, _, tension, selected = reaper.GetEnvelopePoint(trackEnvelope, envelopePointIndex)
	reaper.SetEnvelopePoint(trackEnvelope, envelopePointIndex, time, value, shape, tension)
end

function setFirstEnvelopePoint(trackEnvelope, envelopePointValue)

	local envelopePointIndex = 0

	local shape = squareEnvelopeShape()
	local tension = -1

	reaper.SetEnvelopePoint(trackEnvelope, envelopePointIndex, 0, envelopePointValue, shape, tension)
end

function insertEnvelopePoint(trackEnvelope, envelopePointValue)

	if cursorIsAtTheBeginning() then
		setFirstEnvelopePoint(trackEnvelope, envelopePointValue)
		return
	end

	local timeOfCurrentBar = getTimeOfCurrentBar()
	local timeOfNextBar = getTimeOfNextBar()

	local shape = squareEnvelopeShape()
	local tension = -1
	local isSelected = false

	reaper.InsertEnvelopePoint(trackEnvelope, timeOfCurrentBar-envelopeTimeDelta/2, envelopePointValue, shape, tension, isSelected)
	reaper.InsertEnvelopePoint(trackEnvelope, timeOfNextBar-envelopeTimeDelta, envelopePointValue, shape, tension, isSelected)
end
