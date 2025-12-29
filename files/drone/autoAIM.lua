local ctrl = peripheral.find("ShipControlInterface")
local LookAtQuat = require("navigator")
rednet.open("top") 

redstone.setOutput("left", false)
ctrl.setRotation(0, 0, 0, 1)



local function LockAtOBJ(tx, ty, tz)
local pos = ctrl.getPosition()  
local target = {x = tx, y = ty, z = tz}
local q = LookAtQuat.lookAt(pos, target)
ctrl.setRotation(q.x, q.y, q.z, q.w)
sleep(7)
redstone.setOutput("left", true)
sleep(5)
redstone.setOutput("left", false)
end




print("Esperando coordenadas por Rednet...")
while true do 
    local id, msg = rednet.receive() 

    if msg then
        
        
        local texto = tostring(msg) 
        local x, y, z = tostring(msg):match("(%-?%d+)%s+(%-?%d+)%s+(%-?%d+)")
        
        if x and y and z then
            local tx, ty, tz = tonumber(x), tonumber(y), tonumber(z)
            LockAtOBJ(tx, ty, tz)
        else
            print("Formato de mensaje incorrecto. Use: x y z")
        end
    end
end