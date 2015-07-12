-- #################### Global vars ##################
-- LED
ledTimer=0
ledPin=1
ledFrequency=4
ledCurrentValue=gpio.HIGH
ledCurrentCount=0
ledCount=5
ledTimerPeriod=100
ledMaxCount=(1000/ledTimerPeriod)

-- #################### Functions ###################
-- *** Process next led
function ledNext()
    ledCurrentCount = ledCurrentCount + 1

    if (ledCurrentCount > ledCount) then
        ledCurrentCount = 0
        -- toggle led
        ledCurrentValue = not ledCurrentValue
        if (ledCurrentValue) then
            gpio.write(ledPin, gpio.HIGH)
        else
            gpio.write(ledPin, gpio.LOW)
        end
    end
end
-- *** Config Led
-- * @param freq the freqency the led changing status. If freq == 0, led will not be tongle
-- * @param initVal the initial value of led.
function setLed(freq, initVal)
    if (freq == 0) then
        gpio.write(ledPin, initVal)
        tmr.stop(ledTimer)
        return
    end
    ledFreq = 1000/ledTimerPeriod
    ledCount = ledFreq/freq
    ledCurrentValue = initVal
    tmr.stop(ledTimer)
    tmr.alarm(ledTimer, ledTimerPeriod, 1, ledNext)
end
function init()
    -- ### Init GPIOs
    -- wifi led - off
    gpio.mode(ledPin, gpio.OUTPUT)
    gpio.write(ledPin, gpio.HIGH)
end

-- Code
init()
setLed(2, gpio.LOW)
