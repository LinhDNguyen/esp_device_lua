print("Set wifi to STATION mode")
wifi.setmode(wifi.STATION)
wifi.sta.autoconnect(1)
print("Set 5s alarm timer to check wifi")
tmr.alarm(0, 5000, 0, function ()
	if (wifi.sta.status() == 5) then
		print("Wifi is connected, IP is " .. wifi.sta.getip())
	else
		print("Wifi is not connected, start smartconfig")
		wifi.startsmart(0, function ()
			print("Start config successed!!!")
			end )
		end
	end )