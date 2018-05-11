function call_go(r, a_number)
    local power = require("power")
    local rtn = power.go(a_number);
    info(rtn)
    return rtn
end
