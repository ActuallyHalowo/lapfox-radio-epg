local http = require("coro-http")
local fs = require("fs")
local json = require("json")
local timer = require("timer")

local url = "https://radio.lapfoxradio.com/api/nowplaying/lapfox_radio"
local runAsWebServer = true
local serverPort = 8080

local xmlBase = [[
<tv generator-info-name="lapfox-radio-epg" generator-info-url="https://github.com/ActuallyHalowo/lapfox-radio-epg">
	<channel id="LapFoxRadio">
		<display-name lang="en">LapFox Radio</display-name>
		<icon src="https://lapfoxradio.com/lapfox-radio-icon-black.png"></icon>
	</channel>

]]

local xmlEnd = [[
</tv>
]]

local function convertUnixToDate(timestamp)
	local year = os.date("%Y",timestamp)
	local month = os.date("%m",timestamp)
	local day = os.date("%d",timestamp)
	local hour = os.date("%H",timestamp)
	local minute = os.date("%M",timestamp)
	local second = os.date("%S",timestamp)

	return tostring(year..month..day..hour..minute..second)
end

local function generate()
	local response, content = http.request("GET", url)
	local tablifiedContent = json.decode(content)

	local finalXml = xmlBase

	--// now playing
	finalXml = finalXml..'<programme channel="LapFoxRadio" start="'..convertUnixToDate(tablifiedContent.now_playing.played_at)..' +0000" stop="'..convertUnixToDate(tablifiedContent.now_playing.played_at+tablifiedContent.now_playing.duration)..' +0000"> <title lang="en">'..tablifiedContent.now_playing.song.text..'</title> <icon src="'..tablifiedContent.now_playing.song.art..'"/> </programme>'

	--// playing next
	finalXml = finalXml..'<programme channel="LapFoxRadio" start="'..convertUnixToDate(tablifiedContent.playing_next.played_at)..' +0000" stop="'..convertUnixToDate(tablifiedContent.playing_next.played_at+tablifiedContent.playing_next.duration)..' +0000"> <title lang="en">'..tablifiedContent.playing_next.song.text..'</title> <icon src="'..tablifiedContent.playing_next.song.art..'"/> </programme>'

	--// close xml
	finalXml = finalXml..xmlEnd

	if not runAsWebServer then
		fs.writeFileSync("epg.xml",finalXml)
	end

	return finalXml
end

if runAsWebServer then
	local function onRequest(req, res)
		local res_payload = generate()

		local res_headers = {
			{"Content-Length", tostring(#res_payload)},
			{"Content-Type", "text/xml"},
			{"Connection", "close"},
			code = 200,
			reason = "OK",
		}

		return res_headers, res_payload
	end

	coroutine.wrap(function()
		http.createServer("127.0.0.1",serverPort,onRequest)

		print("awesome server online @ http://localhost:"..serverPort.."/")
	end)()
else
	coroutine.wrap(function()
		while timer.sleep(30000) do
			generate()
		end
	end)()
end