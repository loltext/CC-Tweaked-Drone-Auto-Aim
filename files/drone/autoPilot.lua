local ctrl = peripheral.find("ShipControlInterface")
local LookAtQuat = require("navigator")
rednet.open("top") 

redstone.setOutput("back", false)
ctrl.setRotation(0, 0, 0, 1)



local tolerancia = 10




local function LockAtOBJ(tx, ty, tz)

    local target = {x = tx, y = ty, z = tz}
    local objetivoLlegado = false

    print("Navegando hacia:", tx, ty, tz)

    while not objetivoLlegado do
        local pos = ctrl.getPosition()
        
      
        local dx = target.x - pos.x
        local dy = target.y - pos.y
        local dz = target.z - pos.z
        local errorDist = math.sqrt(dx*dx + dy*dy + dz*dz)

        if errorDist <= tolerancia then
            objetivoLlegado = true
            ctrl.setMovement(0,0,0)
            ctrl.setRotation(0, 0, 0, 1)
            print("Objetivo alcanzado")
        else    
            local q = LookAtQuat.lookAt(pos, target)
            ctrl.setRotation(q.x, q.y, q.z, q.w)
            ctrl.setMovement(1,0,0)
        end

        os.sleep(0.1) 
    end
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