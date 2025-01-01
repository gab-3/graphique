function love.load()
    require "complex"
    fonctions = {}
    cursor = love.mouse.newCursor("cursor.png", 5, 5)
    love.mouse.setCursor(cursor)
    Im = love.graphics.newImage("Im.png")
    Re = love.graphics.newImage("Re.png")
    imaginary_plane = false
    opacity = .2
    rx, ry = 10, 20
    inputing = "false"
    new_f = ""
    love.window.setFullscreen(true)
    L, l = love.graphics.getDimensions()
    precision = 4
    scale = 140
    k1, k2 = 1, 1
    nombre = {}
    nombre.x, nombre.y = 1, 1
    nombres = {}
    e = math.exp(1)
    pi = math.pi
    tan = math.tan
    cos = math.cos
    sin = math.sin
    abs = math.abs
    sgn = function(x) return x/abs(x) end
    floor = math.floor
    t = 0
    time = 20
    speed = 1
end

function love.wheelmoved(x, y)
    scale = scale + y*scale/30
end

function love.keypressed(key)
    if not new_function then
        if key == "<" then
            imaginary_plane = not imaginary_plane
        end
        if key == "up" then
            scale = scale * 1.1
        end
        if key == "down" then
            scale = scale/1.1
        end
    else
        if key == "return" then
            new_function = false
            fonctions[#fonctions+1] = {formule = load("return function(x) return tonumber("..new_f..") or math.huge end"), texte = new_f}
        elseif key == "backspace" then
            last_key = nil
            new_f = string.sub(new_f, 1, #new_f-1)
        elseif key ~= "lshift" and key ~= "rshift" then
            if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
                if key == "3" then
                    new_f = new_f.."*"
                    last_key = "*"
                elseif key == "7" then
                    new_f = new_f.."/"
                    last_key = "/"
                elseif key == "8" then
                    if last_key == "x" or type(tonumber(last_key)) == type(1) then
                        new_f = new_f.."*("
                    else
                        new_f = new_f.."("
                    end
                    last_key = "("
                elseif key == "9" then
                    new_f = new_f..")"
                    last_key = ")"
                elseif key == "5" then
                    new_f = new_f.."%"
                    last_key = "%"
                elseif key == "1" then
                    new_f = new_f.."+"
                    last_key = "+"
                else
                    new_f = new_f..key
                end
            else
                if key == "x" and type(tonumber(last_key)) == type(1) then
                    new_f = new_f.."*x"
                else
                    new_f = new_f..key
                end
                last_key = key
            end
        end
    end
end

function love.mousepressed(x, y, button)
    if not new_function then
        if x > rx and y > ry and x < rx + 100 and y < ry + 16.3 then
            if button == 1 then
                new_function = true
                new_f = ""
            elseif button == 2 then
                if grabing ~= true then
                    ar, br = x - rx, y - ry
                    grabing = true
                end
            end
        end
    else
    end
end

function love.update(dt)
    if not new_function then
        t = t + dt*speed
        if math.abs(t) > math.abs(time) then
            speed = -speed
            time = -time
        end
        if grabing then
            rx = love.mouse.getX() - ar
            ry = love.mouse.getY() - br
            
        end
    else
    end
end

function love.mousereleased(x, y)
    if grabing then
        rx = x - ar
        ry = y - br
        grabing = false
    end
end


function love.draw()
    if not new_function then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle("fill", rx, ry, 30, 16.3)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.print("NEW", rx, ry)
        love.graphics.setColor(1, 1, 1, 1)
        
        
        
        
        if imaginary_plane then
            love.graphics.draw(Im, 1000, 30, 0, 1, 1)
            love.graphics.print({round((love.mouse.getX() - L/2)/scale, 3), "; ", round((-love.mouse.getY() + l/2)/scale, 3)}, 200, 15)
        else
            love.graphics.draw(Re, 1000, 30, 0, 1, 1)
            love.graphics.print({round((love.mouse.getX() - L/2)/scale, 3), "; ", round((-love.mouse.getY() + l/2)/scale, 3)}, 200, 15)
        end
        
        love.graphics.setColor(1, 1, 1, 0.15)
        love.graphics.line(0, love.mouse.getY()+0.5, L, love.mouse.getY()+0.5)
        love.graphics.line(love.mouse.getX()+0.5, 0, love.mouse.getX()+0.5, l)
        love.graphics.setColor(1, 1, 1, 1)
        
        for i=-30, 30 do
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.points(i*scale + L/2, l/2)
            love.graphics.print(i, i*scale + L/2 - 10, l/2)
            love.graphics.points(L/2, i*scale + l/2)
            love.graphics.print(i, L/2 - 10, -i*scale + l/2)
        end

        love.graphics.setColor(0, 1, 1, 1)
        for i=1, #fonctions do
            local f = fonctions[i].formule
            if type(f) == type(love.load) then
            for j=-1,1, 0.0001 do
                local x = j*30/scale*140
                if imaginary_plane then
                    graph(x, derivative(f())(x))
                else
                    graph(x, f()(x))
                end
            end
        end
    end
    for i=-1, 1, 0.001 do
        x = i*30/scale*140
        for j = -10, 10 do
            love.graphics.setColor(1,1,1, 1/2 + ((abs(j)-1)%2)*1/4)
            if j ~= 0 then
                graph(x, j)
                graph(j, x)
            end
        end
    end
        -- la ndérivée de x^n = x! 
        
        love.graphics.setColor(1, 1, 1, 0.4)
        --love.graphics.circle("line", L/2, l/2, scale)
        love.graphics.line(0, l/2, L, l/2)
        love.graphics.line(L/2, 0, L/2, l)
        
        
        
        if inputing == "a + bi" then
            love.graphics.setColor(0, 0, 0, 1)
            love.graphics.rectangle("fill", 0, 0, L, l)
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.print({k1, " + ", k2, "i"})
        elseif inputing == "re^i0" then
            love.graphics.setColor(0, 0, 0, 1)
            love.graphics.rectangle("fill", 0, 0, L, l)
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.print({k1, "e^i", k2})
        end
    else
        love.graphics.setColor(1, 1, 1, 1)
        for i=0, #fonctions do
            if i == 0 then
                love.graphics.print("f(x) = "..new_f, 0, 0, 0, 3, 3)
            else
                love.graphics.print("f"..i.."(x) = "..fonctions[i].texte, 0, 40*i, 0, 3, 3)
            end
        end
    end
end

function ax(x)
    if type(x) ~= type(2) then
        x = x.Re
    end
    return x*scale + L/2
end

function ay(x)
    if type(x) ~= type(2) then
        x = x.Re
    end
    return (-x*scale + l/2)
end


function round(x, dec)
    dec = dec or 0
    return math.floor(x*10^dec + 0.5)/10^dec
end

function fac(n)
    if math.floor(n*100)/100 == math.floor(n) and n >= 0 then
        local res = 1
        for i=1, n do
            res = res*i
        end
        return res
    else return 0/0
    end
end

function faca(x)
    return math.sqrt(2*pi*x) * (x/e)^x
end



function somme(i, n, fonction)
    local res = 0
    if n > i then
        for i=i, n do
            res = res + fonction(i)
        end
    elseif n < i then
        for i=i, math.abs(n) do
            res = (res + fonction(-i))
        end
    end
    return res
end

function produit(i, n, fonction)
    local res = 1
    for i=i, n do
        res = res * fonction(i)
    end
    return res
end

function derivative(f, d)
    d = d or 10^-10
    local function g(x)
        return (f(x + d) - f(x))/d
    end
    return g
end

function Nderivative(f, n, d)
    d = d or 10^-10
    local g = heart
    for i=0, n do
        if i == 0 then
            g = f
        else
            g = derivative(g, d^(1/n))
        end
    end
    return g
end

function heart(x)
    return math.abs(x)^(2/3) + 0.9*(3.3 - math.abs(x)^2)^0.5 * math.sin(80*pi*x)
end

function integral(f, dx)
    dx = dx or 0.1
    
    local function g(x)
        local sum = 0
        if x > 0 then
            for i=0, x, dx do
                sum = sum + (f(i) or 0)*dx
            end
        elseif x < 0 then
            for i=0, x, -dx do
                sum = sum - (f(i) or 0)*dx
            end
        end
        return sum
    end
    
    return g
end

function graph(x, y)
    love.graphics.points(ax(x), ay(y))
end

function toBase(x, b1, b2)
    num = {}
    if b2 == nil then
        b2 = b1
        b1 = 10
    end
    len = #tostring(x)
    for i=0, len do
        num[len - i] = math.floor(x/10^i) - math.floor(x/10^(i+1))*10
    end
    
    for i=1, len do
        a = num[i]/10^(len-i)
    end
end