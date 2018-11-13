function deleteMediaItem(guitarName)

	local timeOfCurrentBar = getTimeOfCurrentBar()

	local messageTrack = getTrack(guitarName .. " mode")
	local numberOfMediaItems = reaper.CountTrackMediaItems(messageTrack)

	for i = 0, numberOfMediaItems - 1 do

		local mediaItem = reaper.GetTrackMediaItem(messageTrack, i)

		if mediaItem ~= nil then

			local position = reaper.GetMediaItemInfo_Value(mediaItem, "D_POSITION")

			if position > timeOfCurrentBar-tolerance and position < timeOfCurrentBar+tolerance then
				reaper.DeleteTrackMediaItem(messageTrack, mediaItem)
			end
		end
	end
end

function getMediaItemMessage(guitarName)

	local timeOfCurrentBar = getTimeOfCurrentBar()

	local messageTrack = getTrack(guitarName .. " mode")
	local numberOfMediaItems = reaper.CountTrackMediaItems(messageTrack)

	for i = 0, numberOfMediaItems - 1 do

		local mediaItem = reaper.GetTrackMediaItem(messageTrack, i)

		if mediaItem ~= nil then

			local position = reaper.GetMediaItemInfo_Value(mediaItem, "D_POSITION")

			if position > timeOfCurrentBar-tolerance and position < timeOfCurrentBar+tolerance then

					local isNewValue = false

					local _, message = reaper.GetSetMediaItemInfo_String(mediaItem, "P_NOTES", "", isNewValue)
					return message
			end
		end
	end

	return "clear"
end

function insertMediaItem(guitarName, message)

	local messageTrack = getTrack(guitarName .. " mode")
	local timeOfCurrentBar = getTimeOfCurrentBar()

	local mediaItem = reaper.AddMediaItemToTrack(messageTrack)
	reaper.SetMediaItemInfo_Value(mediaItem, "D_POSITION", timeOfCurrentBar)
	reaper.SetMediaItemInfo_Value(mediaItem, "D_LENGTH", barWidth())


	local isNewValue = true
	reaper.GetSetMediaItemInfo_String(mediaItem, "P_NOTES", message, isNewValue)

	local isUndo = false
	local _, stateChunk = reaper.GetItemStateChunk(mediaItem, "", isUndo)

	local newStateChunk = string.gsub(stateChunk, "IMGRESOURCEFLAGS 0", "IMGRESOURCEFLAGS 2")
	reaper.SetItemStateChunk(mediaItem, newStateChunk, isUndo)
end