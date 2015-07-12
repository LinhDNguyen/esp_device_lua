-- #################### Global vars ##################
insmart=0
wifiTimeout=15000
-- LED
ledTimer=0
configLed=1
ledFrequency=4
ledCurrentValue=gpio.HIGH
ledCurrentCount=0
ledCount=5
ledTimerPeriod=100
ledMaxCount=(1000/ledTimerPeriod)
configSwitch=4

-- #################### Functions ###################
-- *** Process next led
function ledNext()
	ledCurrentCount = ledCurrentCount + 1

	if (ledCurrentCount > ledCount) then
		ledCurrentCount = 0
		-- toggle led
		ledCurrentValue = not ledCurrentValue
		gpio.write(configLed, ledCurrentValue)
	end
end
-- *** Config Led
-- * @param freq the freqency the led changing status. If freq == 0, led will not be tongle
-- * @param initVal the initial value of led.
function setLed(freq, initVal)
	if (freq == 0) then
		gpio.write(configLed, initVal)
		tmr.stop(ledTimer)
		return
	end
	ledFreq = 1000/ledTimerPeriod
	ledCount = ledFreq/freq
	ledCurrentValue=initVal
	tmr.start(ledTimer, ledTimerPeriod, 1, ledNext)
end
function init()
	-- ### Init GPIOs
	-- wifi led - off
	gpio.mode(configLed, gpio.OUTPUT)
	gpio.write(configLed, gpio.HIGH)
	-- Config button - falling interrupt
	gpio.mode(configSwitch, gpio.INT)
	-- config timer
end

-- *******************************************************************
-- * Smart config successed callback. Set wifi station config.
function smartSuccessCb (ssid, pass)
	print("Smartconfig successed, id is [" .. ssid .."] and pass [" .. pass .."]")
	wifi.sta.config(ssid, pass, 1)
	wifi.stopsmart()
end

-- Code
init()
sedLed(1, gpio.LOW)
tmr.delay(5000000)
sedLed(5, gpio.LOW)
tmr.delay(5000000)
sedLed(10, gpio.LOW)
tmr.delay(5000000)
sedLed(0, gpio.LOW)
