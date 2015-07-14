-- Global vars
gpioPins = {[0]=3,[1]=10,[2]=4,[3]=9,[4]=1,[5]=2,[10]=12,[12]=6,[14]=5,[15]=8,[16]=0}

dofile("led.lc")

-- Startup, led blink 10 times per second.
setLed(10, gpio.LOW)

-- Setup config trigger. In first 5s, if GPIO 0 switch is pressed, goto config
configSw=(gpioPins[0])
isConfigEnable = false
isWifiConnected = false
configTmr = 1
configurationTable = {}
function readConfigTable()
    local isConfigExist = false
    l = file.list();
    for k,v in pairs(l) do
        if (k == "config") then
            isConfigExist = true
            break
        end
    end
    if (isConfigExist) then
        str = ""
        file.open("config", "r+")
        str = file.read()
        file.close()
        configurationTable = cjson.decode(str)
    else
        --write init config
        file.open("config", "w")
        file.write("{}")
        file.flush()
        file.close()
    end
end
function checkConnected( )
    -- Check wifi connected and do smt
    if (wifi.sta.status() == 5) then
        tmr.stop(configTmr)
        setLed(0, gpio.LOW)
        if (isConfigEnable) then
            dofile("config.lc")
        end
    end
end
function smartConfigSuccessedCb(ssid, pass)
    wifi.sta.config(ssid, pass, 1)
    wifi.stopsmart()
    tmr.alarm(configTmr, 1000, 1, checkConnected)
end
function checkWifi()
    tmr.stop(configTmr)
    if (wifi.sta.status() ~= 5) then
        -- not connected, start smartconfig
        wifi.setmode(wifi.STATION)
        setLed(10, gpio.LOW)
        wifi.startsmart(0, smartConfigSuccessedCb)
    else
        -- wifi connected and got IP, do smt
        tmr.alarm(configTmr, 1000, 1, checkConnected)
    end
end
function configStop()
    gpio.mode(configSw, gpio.INPUT, gpio.FLOAT)
    tmr.stop(configTmr)
    -- Check wifi status after 10s
    tmr.alarm(configTmr, 10000, 0, checkWifi)
    setLed(5, gpio.LOW)
end
function configSwitchCb( level )
    isConfigEnable = true
    configStop()
end
function initConfig()
    gpio.mode(configSw, gpio.INT)
    gpio.trig(configSw, "down", configSwitchCb)
end

-- Code
initConfig()
readConfigTable()
tmr.alarm(configTmr, 5000, 0, configStop)
wifi.setmode(wifi.STATION)
wifi.sta.autoconnect(1)
wifi.sta.connect()
