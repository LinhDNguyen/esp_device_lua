-- ### TEST GPIO INTERRUPT ###
-- Press button GPIO2 to tongle LED GPIO4
-- use pin 0 as the input pulse width counter
ledPin=1
swPin=4

-- init
gpio.mode(ledPin, gpio.OUTPUT)
gpio.write(ledPin, gpio.HIGH)
gpio.mode(swPin, gpio.INT)

-- Install button interrupt
function swCb(level)
	val=gpio.read(ledPin)
	print("Curval: " .. val)
	if (val == 0) then
		val = gpio.HIGH
	else
		val = gpio.LOW
	end
	gpio.write(ledPin, val)
end
gpio.trig(swPin, "down", swCb)