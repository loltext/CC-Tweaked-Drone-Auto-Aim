

local LookAtQuat = {}


local function normalize(v)
    local l = math.sqrt(v.x*v.x + v.y*v.y + v.z*v.z)
    if l == 0 then return {x=0, y=0, z=0} end
    return {x = v.x/l, y = v.y/l, z = v.z/l}
end


local function cross(a,b)
    return {
        x = a.y*b.z - a.z*b.y,
        y = a.z*b.x - a.x*b.z,
        z = a.x*b.y - a.y*b.x
    }
end


local function dot(a,b)
    return a.x*b.x + a.y*b.y + a.z*b.z
end


local function quatFromAxisAngle(axis, angle)
    local s = math.sin(angle/2)
    return {
        x = axis.x * s,
        y = axis.y * s,
        z = axis.z * s,
        w = math.cos(angle/2)
    }
end


function LookAtQuat.lookAt(pos, target)
 
    local forward = normalize({
        x = target.x - pos.x,
        y = target.y - pos.y,
        z = target.z - pos.z
    })

  
    local baseForward = {x = 1, y = 0, z = 0}

    local d = dot(baseForward, forward)

   
    if d < -0.999999 then
        
        local axis = cross(baseForward, {x=0,y=1,z=0})
        local len = math.sqrt(axis.x^2 + axis.y^2 + axis.z^2)
        if len < 0.0001 then
            axis = cross(baseForward, {x=0,y=0,z=1})
            len = math.sqrt(axis.x^2 + axis.y^2 + axis.z^2)
        end
        axis = {x = axis.x/len, y = axis.y/len, z = axis.z/len}
        return quatFromAxisAngle(axis, math.pi)
    end

    
    local axis = cross(baseForward, forward)
    local axisLen = math.sqrt(axis.x^2 + axis.y^2 + axis.z^2)

    if axisLen < 0.000001 then
      
        return {x = 0, y = 0, z = 0, w = 1}
    end

    axis = {x = axis.x/axisLen, y = axis.y/axisLen, z = axis.z/axisLen}

  
    local angle = math.acos(d)

    return quatFromAxisAngle(axis, angle)
end

return LookAtQuat


