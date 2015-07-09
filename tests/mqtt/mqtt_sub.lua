broker = "192.168.1.198"
mqttport = 1883
userID = "linh"
userPWD  = "secret"
clientID = "ESP1"
ledPin = 2

gpio.mode(ledPin , gpio.OUTPUT, gpio.PULLUP)

-- Wifi credentials
wifi.setmode(wifi.STATION)
-- wifi.sta.config("Vinh 1102","22446688")

function wifi_connect()
	ip = wifi.sta.getip()
	if ip ~= nil then
		print('Connected, ip is:' .. ip)
		tmr.stop(1)
		ready = 1
	else
		ready = 0
	end
end

function mqtt_do()
	if ready == 1 then
		m = mqtt.Client(clientID, 120, userID, userPWD)
		m:connect( broker , mqttport, 0, function(conn)
			print("Connected to MQTT:" .. broker .. ":" .. mqttport .." as " .. clientID )
			tmr.stop(0)
			connected = 1;
			sub_mqtt()
			m:on('message', function(conn, topic, input)
				print("Received:" .. input)
				if input == "1" then
					gpio.write(ledPin, gpio.HIGH)
				elseif input == "0" then
					gpio.write(ledPin, gpio.LOW)
				else
					print('error')
				end
			end)
		end)
	end
end


function sub_mqtt()
	m:subscribe('linh/home/devices/livingroom/thermostat/value', 0, function(conn)
		print('Subscribed')
	end)
end

tmr.alarm(0, 1000, 1, function() 
	mqtt_do()
	tmr.delay(1000)
	end)

tmr.alarm(1, 1111, 1, function()
	wifi_connect() 
	end)