function clearConsoleWindow()
  reaper.ShowConsoleMsg("")
end

function print(arg)
  reaper.ShowConsoleMsg(tostring(arg) .. "\n")
end

function getTrack(trackNameArg)

  local activeProjectIndex = 0
  local numberOfTracks = reaper.CountTracks(activeProjectIndex)

  for i = 0, numberOfTracks - 1 do

    local track = reaper.GetTrack(activeProjectIndex, i)
    local _, trackName = reaper.GetTrackName(track, "")

    if trackName == trackNameArg then
    	return track
    end
  end

  return nil
end

tolerance = 0.000001
function getTimeOfCurrentBar()

	local activeProjectIndex = 0
	local measureIndex = 0

	while reaper.TimeMap_GetMeasureInfo(activeProjectIndex, measureIndex) <= reaper.GetCursorPosition() + tolerance do
		measureIndex = measureIndex + 1
	end

	return reaper.TimeMap_GetMeasureInfo(activeProjectIndex, measureIndex - 1)
end

function getTimeOfNextBar()

	local activeProjectIndex = 0
	local measureIndex = 0

	while reaper.TimeMap_GetMeasureInfo(activeProjectIndex, measureIndex) <= reaper.GetCursorPosition() + tolerance do
		measureIndex = measureIndex + 1
	end

	return reaper.TimeMap_GetMeasureInfo(activeProjectIndex, measureIndex)
end

function barWidth()

	local activeProjectIndex = 0
	local bpm, numberOfBeatsPerBar = reaper.GetProjectTimeSignature2(activeProjectIndex)
	local numberOfSecondsPerMinute = 60

	return numberOfBeatsPerBar / bpm * numberOfSecondsPerMinute
end

