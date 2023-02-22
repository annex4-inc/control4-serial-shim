local VERSION = "Driver Version"

local ID_MASTER = 1

local ID_OUTPUT_START = 2
local ID_OUTPUT_END   = 11

Driver = (function()
    local class = {};

    function class.ReceivedFromSerial(idBinding, data)
        Logger.Trace("Driver.ReceivedFromSerial")
        Logger.Debug({ idBinding, data })

        if (idBinding == ID_MASTER) then
            for index = ID_OUTPUT_START, ID_OUTPUT_END, 1 do
                C4:SendToProxy(index, "SERIAL_DATA", C4:Base64Encode(data), "NOTIFY")
            end
        end
    end

    function class.ReceivedFromProxy(idBinding, strCommand, tParams)
        Logger.Trace("Driver.ReceivedFromProxy")
        Logger.Debug({ idBinding, strCommand, tParams })

        if (strCommand == "SEND") then
            C4:SendToSerial(ID_MASTER, C4:Base64Decode(tParams.data))
        end
    end

    function class.OnDriverLateInit()
        C4:UpdateProperty(VERSION, C4:GetDriverConfigInfo("semver"))
    end

    if (Hooks) then
        Hooks.Register(class, "Driver")
    end

    return class
end) ()
