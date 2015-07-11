print("Set wifi to STATION mode")
wifi.setmode(wifi.STATION)
wifi.sta.autoconnect(1)
function smartok (ssid, pass)
	print("Smartconfig successed, id is [" .. ssid .."] and pass [" .. pass .."]")
	wifi.sta.config(ssid, pass, 1)
	wifi.stopsmart()
end
insmart=0
checkInteval=5000
ssid, password, bssid_set, bssid=wifi.sta.getconfig()
if ( ssid ~= "" ) then
checkInteval=15000
end
print("Set " .. (checkInteval/1000) .. "s alarm timer to check wifi")
tmr.alarm(0, checkInteval, 1, function ()
	if (insmart == 0) then
		if (wifi.sta.status() == 5) then
			print("Wifi is connected, IP is " .. wifi.sta.getip())
			tmr.stop(0)
		else
			print("Wifi is not connected, start smartconfig")
			wifi.setmode(wifi.STATION)
			insmart=1
			wifi.startsmart(0, smartok)
			end
	else
		print("In smart config...")
	end
	end )
