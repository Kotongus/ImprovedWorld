---@type plugin
local plugin = ...
plugin.name = "Social credits"
plugin.description = "Adds censorship like in china yaaay"
plugin.author = "Koto"

local function censoredWord (filter, credits, reason)
     return {filter = filter, credits = credits, reason = reason}
end

local censoredWords = {
     censoredWord(
          function (message)
               local msg = message:lower()

               if string.find(msg, "nigga") then
                    return true
               elseif string.find(msg, "niga") then
                    return true
               elseif string.find(msg, "nigger") then
                    return true
               elseif string.find(msg, "niger") then
                    return true
               end
          end,
          -10,
          'Said nigga'
     ),

     censoredWord(
          function (message)
               local msg = message:lower()

               if string.find(msg, "i love koto") then
                    return true
               end
          end,
          -10,
          'Being gay towards the owner'
     ),

     censoredWord(
          function (message)
               local msg = message:lower()

               if string.find(msg, "i like koto") then
                    return true
               end
          end,
          10,
          'Being nice towards the owner'
     ),
     
     censoredWord(
          function (message)
               local msg = message:lower()

               if (string.find(msg, "kotus") or string.find(msg, "this server")) and (string.find(msg, "sucks") or string.find(msg, "is bad") or string.find(msg, "is boring")) then
                    return true
               end
          end,
          -100,
          'Saing a bad thing about government'
     ),

     censoredWord(
          function (message)
               local msg = message:lower()

               if (string.find(msg, "kotus") or string.find(msg, "this server")) and (string.find(msg, "is the best") or string.find(msg, "i love") or string.find(msg, "is fun") or string.find(msg, "is cool") or string.find(msg, "i like")) then
                    return true
               end
          end,
          100,
          'Saing a good thing about government'
     ),

     censoredWord(
          function (message)
               local msg = message:lower()

               if (string.find(msg, "kotus") or string.find(msg, "this server")) and (string.find(msg, "i play on") or string.find(msg, "play on") or string.find(msg, "advertise") or string.find(msg, "play")) then
                    return true
               end
          end,
          500,
          'Confessing your loyality to government'
     )
}





plugin:addHook(
     "PlayerChat",
     ---@param Player ply
     ---@param string msg
     function (ply, msg)
          for _, censoredWord in ipairs(censoredWords) do
               if censoredWord.filter(msg) then
                    local sign = ""

                    if censoredWord.credits >= 0 then sign = "+" else sign = "-" end

                    ply:sendMessage(sign.." "..tostring(math.abs(censoredWord.credits)).." Social Credits ("..censoredWord.reason..")")
               end
          end
     end
)
