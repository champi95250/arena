--------------------------------------------------------------------------
-- Message
--------------------------------------------------------------------------
function BroadcastMessage( sMessage, fDuration )
    local centerMessage = {
        message = sMessage,
        duration = fDuration
    }
    FireGameEvent( "show_center_message", centerMessage )
end

--------------------------------------------------------------------------
-- Timers
--------------------------------------------------------------------------

function CountdownTimer()
    nCOUNTDOWNTIMER = nCOUNTDOWNTIMER - 1
    local t = nCOUNTDOWNTIMER
    --print( t )
    local minutes = math.floor(t / 60) -- 900 = 15min
    local seconds = t - (minutes * 60) -- 901 = 901 - ( 15 * 60= 900) = 1 
    local m10 = math.floor(minutes / 10) -- 15 / 10 = 1 ( math floor arrondi )
    local m01 = minutes - (m10 * 10)     -- 15 - 10 = 5 
    local s10 = math.floor(seconds / 10) -- 1/10 = 0.1 = 0
    local s01 = seconds - (s10 * 10)     -- 1 - 0 = 1
    local broadcast_gametimer = 
        {
            timer_minute_10 = m10,
            timer_minute_01 = m01,
            timer_second_10 = s10,
            timer_second_01 = s01,
        }
    --CustomGameEventManager:Send_ServerToAllClients( "countdown", broadcast_gametimer )
    if t <= 120 then -- si le temps arrive a moins de 120 = 2 minutes 
        --CustomGameEventManager:Send_ServerToAllClients( "time_remaining", broadcast_gametimer )
    end
end

function SetTimer( cmdName, time )
    print( "Set the timer to: " .. time )
    nCOUNTDOWNTIMER = time
end
