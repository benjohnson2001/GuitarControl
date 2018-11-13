local envelopeTimeDelta = 0.03

function getTrackEnvelope(guitarName)

	local pluginTrack = getTrack("UVIWorkstation")
	return reaper.GetTrackEnvelopeByName(pluginTrack, guitarName .. "Mode / UVIWorkstation")
end

function deleteEnvelopePoints(trackEnvelope)

	local timeOfCurrentBar = getTimeOfCurrentBar()
	local timeOfNextBar = getTimeOfNextBar()
	reaper.DeleteEnvelopePointRange(trackEnvelope, timeOfCurrentBar-envelopeTimeDelta/2-tolerance, timeOfNextBar-envelopeTimeDelta+tolerance)
end

function insertEnvelopePoint(trackEnvelope, envelopePointValue)
	
	local timeOfCurrentBar = getTimeOfCurrentBar()
	local timeOfNextBar = getTimeOfNextBar()

	local shape = -1
	local tension = -1
	local pointIsSelected = false

	reaper.InsertEnvelopePoint(trackEnvelope, timeOfCurrentBar-envelopeTimeDelta/2, envelopePointValue, shape, tension, pointIsSelected)
	reaper.InsertEnvelopePoint(trackEnvelope, timeOfNextBar-envelopeTimeDelta, envelopePointValue, shape, tension, pointIsSelected)
end
