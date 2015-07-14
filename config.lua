-- Global vars

-- Startup, led blink 10 times per second.
setLed(1, gpio.LOW)

-- COMMAND functions
function printTable( c )
   -- print keys and values of table
   for key,value in pairs(configurationTable) do
      c:send("\r\n[" .. key .."]: [" .. value .. "]")
   end
end
function set(c, key, value)
   configurationTable[key] = value
   c:send("\r\n[" .. key .. "]: [" .. configurationTable[key] .. "]")
end
function get(c, key)
   if (not key) then
      printTable(c)
   else
      c:send("\r\n[" .. key .. "]: [" .. configurationTable[key] .. "]")
   end
end
function save(c)
   c:send("\r\nStore following configurations:")
   printTable(c)
   file.remove("config")
   file.open("config", "w+")
   file.write(cjson.encode(configurationTable))
   file.close()
end
function help(c)
   c:send("\r\nSmart device configuration")
   c:send("\r\nCommands:")
   c:send("\r\n   help: Print this help")
   c:send("\r\n   save: Save configuration into config file")
   c:send("\r\n   get [key]: Print value of the key or print all key & value if key is not specified")
   c:send("\r\n   set <key> <value>: Set value of the key")
end

-- a simple telnet server
configServer=net.createServer(net.TCP, 300)
configServer:listen(2323,function(conn)
   conn:on("receive",function(c,l)
      -- node.input(l)           -- works like pcall(loadstring(l)) but support multiple separate line
      s = l:gsub("[\n\r]", "")   -- remove newlines
      idx = s:find("%s")
      cmd = s
      if (idx and (idx > 0)) then
         cmd = s:sub(0, idx - 1)
      end
      if (cmd == "help") then
         help(c)
      elseif (cmd == "save") then
         save(c)
      elseif (cmd == "get") then
         key = nil
         if (idx and (idx > 0)) then
            i = idx
            for i=idx,s:len(),1 do
               if (s:sub(i, i) ~= " ") then
                  idx = i
                  break
               end
            end
            if (idx < (s:len() - 1)) then
               key = s:sub(idx, s:len())
            end
         end
         get(c, key)
      elseif (cmd == "set") then
         key = nil
         value = nil
         if (idx and (idx > 0)) then
            i = idx
            for i=idx,s:len(),1 do
               if (s:sub(i, i) ~= " ") then
                  idx = i
                  break
               end
            end
            if (idx < (s:len() - 1)) then
               key = s:sub(idx, s:len())
               value = key
            end
            idx = key:find("%s")
            if (idx and (idx > 0)) then
               key = key:sub(0, idx - 1)
               value = value:sub(idx, value:len())
            end
            idx = value:find("%w")
            if (idx and (idx > 0) and (idx < value:len())) then
               value = value:sub(idx, value:len())
            end
            if (key and value) then
               set(c, key, value)
            end
         end
      end
      c:send("\r\n>")
   end)
   conn:on("disconnection",function(c)
      print("Config client disconnected")
   end)
end)
