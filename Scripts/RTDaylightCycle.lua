-- Clientside Realtime Daylight&Fog Renderer by NathanLithia.
-- https://github.com/NathanLithia


-- (true/false) Set time script to Realtime mode or Testing cycle.
local debug = true
-- How long in mins should the time skip ahead in debug mode.
local minutesAfterMidnight = 0
-- Fog density will not go below the value of fogBase.
local fogBase = 0.3
-- The time the fog will begin to build up 24hr.
local fogStart = 0
-- The time the fog will clear up in 24hr.
local fogEnd = 12


while true do 
	
	
	--Daylight Renderer.
	if debug == false then
		-- Get IRL time, convert and set it to ingame time.
		local timeString = os.date("*t")["hour"]..":"..os.date("*t")["min"]..":"..os.date("*t")["sec"]
		intHours = os.date("*t")["hour"]
		game.Lighting.TimeOfDay = timeString
		wait(60)
	else
		-- Rapid daylight cycle for debugging purposes.
		minutesAfterMidnight = minutesAfterMidnight + 1
		local minutesNormalised = minutesAfterMidnight % (60 * 24)
		local seconds = minutesNormalised * 60
		local hours = string.format("%02.f", math.floor(seconds/3600))
		local mins = string.format("%02.f", math.floor(seconds/60-(hours*60)))
		local secs = string.format("%02.f", math.floor(seconds-hours*3600-mins*60))
		local timeString = hours..":"..mins..":"..secs
		intHours = tonumber(hours:match("0*(%d+)"))
		game.Lighting.TimeOfDay = timeString
		wait(0.001)
	end
	
	
	--Fog Renderer.
	if  intHours >= fogStart and intHours <= fogEnd then
		local fogMiddle = fogEnd/2
		if intHours <= fogMiddle-1 then
			fogDensity = (intHours/fogMiddle)*100/100
		else
			fogDensity = 1-(intHours/fogEnd)*100/100
		end
		if fogDensity < fogBase then
			fogDensity = fogBase
		end
		game.Lighting.Atmosphere.Density = fogDensity
	end
	
	
	--Debug console output.
	if debug == true then
		print("Hour: ".. intHours .." Atmos: ".. game.Lighting.Atmosphere.Density)
	end
	
	
end
