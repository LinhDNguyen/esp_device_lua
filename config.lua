-- Global vars
gpioPins = {[0]=3,[1]=10,[2]=4,[3]=9,[4]=1,[5]=2,[10]=12,[12]=6,[14]=5,[15]=8,[16]=0}

dofile(led.lc)

-- Startup, led blink 10 times per second.
setLed(10, gpio.LOW)

