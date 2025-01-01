
function complex(a, b) -- returns a and b
    return {Re=a, Im=b or 0}
end

i = complex(0, 1)

function magnitude(z) -- returns the magnitude of z
    if type(z) ~= type(complex(2)) then
        z = complex(z)
    end

    return (z.Re^2 + z.Im^2)^0.5
end

function quadrant(z) -- returns the quadrant up(true/false/nil), right(true/false/nil)
    if type(z) ~= type(complex(1)) then
        z = complex(z)
    end
    if z.Re > 0 then
        local right = true
    elseif z.Re < 0 then
        local right = false
    end

    if z.Im > 0 then
        local up = true
    elseif z.Im < 0 then
        local up = false
    end

    return {Re=right, Im=up}
end

function arg(z) -- returns the argument of z
    if type(z) ~= type(complex(2)) then
        z = complex(z)
    end

    a = z.Re
    b = z.Im
    
    local pi = math.pi

    if a > 0 then
        return math.atan(b/a)
    elseif a < 0 and b >= 0 then
        return math.atan(b/a) + pi
    elseif a < 0 and b < 0 then
        return math.atan(b/a) - pi
    elseif a == 0 and b > 0 then
        return pi/2
    elseif a == 0 and b < 0 then
        return -pi/2
    else
        return 0
    end
end

function polar(z) -- returns r and theta      recall : a+bi => re^i0
    if type(z) ~= type(complex(1)) then
        z = complex(z)
    end
    return {r=magnitude(z), theta=arg(z)}
end

function rectangular(z)

    return complex(z.r * math.cos(z.theta), z.r * math.sin(z.theta))
end

function addition(z1, z2)

    if type(z1) ~= type(complex(2)) then
        z1 = complex(z1)
    end

    if type(z2) ~= type(complex(2)) then
        z2 = complex(z2)
    end

    return complex(z1.Re + z2.Re, z1.Im + z2.Im)
end

function substraction(z1, z2)

    if type(z1) ~= type(complex(2)) then
        z1 = complex(z1)
    end

    if type(z2) ~= type(complex(2)) then
        z2 = complex(z2)
    end

    return complex(z1.Re - z2.Re, z1.Im - z2.Im)
end

function multiplication(z1, z2)

    if type(z1) ~= type(complex(2)) then
        z1 = complex(z1)
    end

    if type(z2) ~= type(complex(2)) then
        z2 = complex(z2)
    end

    return complex(z1.Re * z2.Re - z1.Im * z2.Im, z1.Im * z2.Re + z1.Re * z2.Im)
end

function division(z1, z2)

    if type(z1) ~= type(complex(2)) then
        z1 = complex(z1)
    end

    if type(z2) ~= type(complex(2)) then
        z2 = complex(z2)
    end

    local a = z1.Re
    local b = z1.Im
    local c = z2.Re
    local d = z2.Im
    return complex((a*c+b*d)/(c*c+d*d), (b*c-a*d)/(c*c+d*d))
end

function power(z1, z2)

    if type(z1) ~= type(complex(2)) then
        z1 = complex(z1)
    end

    if type(z2) ~= type(complex(2)) then
        z2 = complex(z2)
    end

    return exp(multiplication(z2, log(z1)))
end

function exp(z)
    if type(z) ~= type(complex(1)) then
        z = complex(z)
    end
    return multiplication(complex(math.exp(z.Re), 0), rectangular({r=1, theta=z.Im}))
end

function log(z)
    if type(z) ~= type(complex(1)) then
        z = complex(z)
    end

    local polar = polar(z)
    return  complex(math.log(polar.r), polar.theta)
end