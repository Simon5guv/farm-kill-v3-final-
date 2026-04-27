--========================================================
-- SISTEMA DE NAVEGAÇÃO - VERSÃO BASE MILITAR (COM TP)
--========================================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- CONFIGURAÇÕES
local finalDest = Vector3.new(947.71, 159.17, -1196.93)
local TIMEOUT = 10      
local mortesMapa = 0
local emRota = false

--========================================================
-- TABELAS DE POSIÇÕES (ATUALIZADAS)
--========================================================

local LobbyRoutes = {
    ["Rota 1"] = { spawn = Vector3.new(939.35, 159.04, -1146.00), waypoints = { Vector3.new(939.35, 159.04, -1148.97), Vector3.new(942.41, 159.04, -1167.48), Vector3.new(938.64, 159.64, -1187.88) } },
    ["Rota 2"] = { spawn = Vector3.new(929.76, 159.05, -1177.15), waypoints = { Vector3.new(943.62, 159.04, -1190.60) } },
    ["Rota 3"] = { spawn = Vector3.new(916.85, 159.05, -1146.00), waypoints = { Vector3.new(917.79, 159.05, -1161.48), Vector3.new(928.02, 159.05, -1178.60), Vector3.new(945.89, 159.14, -1190.24) } },
    ["Rota 4"] = { spawn = Vector3.new(914.29, 159.05, -1157.99), waypoints = { Vector3.new(928.08, 159.04, -1170.18), Vector3.new(938.83, 159.73, -1185.46), Vector3.new(947.75, 159.17, -1191.27) } },
    ["Rota 5"] = { spawn = Vector3.new(917.85, 159.05, -1167.50), waypoints = { Vector3.new(928.97, 159.05, -1173.36), Vector3.new(942.00, 159.07, -1188.58), Vector3.new(947.38, 159.17, -1189.43) } },
    ["Rota 6"] = { spawn = Vector3.new(927.42, 159.05, -1137.49), waypoints = { Vector3.new(916.88, 159.05, -1153.23), Vector3.new(921.47, 159.05, -1173.30), Vector3.new(938.24, 159.71, -1185.66) } },
    ["Rota 7"] = { spawn = Vector3.new(944.85, 159.05, -1156.00), waypoints = { Vector3.new(937.63, 159.05, -1173.38), Vector3.new(943.26, 159.08, -1191.10), Vector3.new(947.59, 159.17, -1191.38) } },
    ["Rota 8"] = { spawn = Vector3.new(940.85, 159.05, -1168.00), waypoints = { Vector3.new(940.54, 159.17, -1180.12), Vector3.new(947.28, 159.17, -1189.94) } }
}

local MapRoutes = {
    -- FÁBRICA (POSIÇÕES NOVAS SUBSTITUÍDAS)
    fabrica_pos1 = { 
        spawn = Vector3.new(402.53, 48.23, -8990.85), 
        route = { 
            Vector3.new(402.53, 48.23, -8990.85), Vector3.new(406.27, 48.23, -8996.43), Vector3.new(414.81, 48.23, -9001.06), 
            Vector3.new(422.65, 48.88, -9000.04), Vector3.new(425.14, 48.88, -9045.37), Vector3.new(434.36, 48.88, -9045.24), 
            Vector3.new(467.56, 46.38, -9061.23) 
        } 
    },
    fabrica_pos2 = { 
        spawn = Vector3.new(467.30, 46.38, -9061.00), 
        route = { 
            Vector3.new(467.30, 46.38, -9061.00), Vector3.new(462.68, 48.88, -9044.00), Vector3.new(463.92, 46.38, -9013.98), 
            Vector3.new(466.74, 46.38, -8989.83), Vector3.new(463.36, 46.38, -8987.61), Vector3.new(401.83, 48.23, -8990.46) 
        } 
    },

    -- HOSPITAL E OUTROS MANTIDOS
    hospital_pos1 = { spawn = Vector3.new(426.03,39.36,-3980.61), route = { Vector3.new(432.33,39.36,-3984.76), Vector3.new(441.16,39.36,-3993.37), Vector3.new(430.49,39.36,-4012.54), Vector3.new(428.81,39.36,-4038.22) } },
    hospital_pos2 = { spawn = Vector3.new(427.66,39.36,-4037.81), route = { Vector3.new(430.95,39.36,-4027.87), Vector3.new(434.53,39.36,-4011.54), Vector3.new(439.31,39.36,-3997.67), Vector3.new(426.43,39.36,-3980.02) } },
    casa_pos1 = { spawn = Vector3.new(434.94,51.09,-3956.39), route = { Vector3.new(450.38,51.09,-3960.72), Vector3.new(457.99,54.29,-3970.18), Vector3.new(460.87,54.29,-4033.87), Vector3.new(441.12,51.89,-4039.23) } },
    casa_pos2 = { spawn = Vector3.new(440.94, 51.89, -4038.39), route = { Vector3.new(440.94, 51.89, -4038.39), Vector3.new(455.81, 54.29, -4036.45), Vector3.new(458.34, 54.29, -4024.74), Vector3.new(466.31, 54.29, -3998.56), Vector3.new(459.87, 54.29, -3973.98), Vector3.new(449.90, 51.09, -3953.97), Vector3.new(434.98, 51.09, -3956.43) } },

    -- BASE MILITAR
    base_militar_pos1 = {
        spawn = Vector3.new(464.47, 43.10, -9903.65),
        route = {
            Vector3.new(464.47, 43.10, -9903.65), Vector3.new(454.49, 39.93, -9914.38), Vector3.new(438.63, 29.06, -9931.41),
            Vector3.new(423.34, 29.06, -9936.44), Vector3.new(405.75, 29.16, -9937.00), Vector3.new(384.98, 29.06, -9933.86),
            Vector3.new(372.20, 29.16, -9925.20), Vector3.new(352.84, 29.16, -9918.08), Vector3.new(337.54, 29.06, -9912.20),
            Vector3.new(331.10, 29.06, -9891.27)
        }
    },
    base_militar_pos2 = {
        spawn = Vector3.new(331.10, 29.06, -9891.08),
        route = {
            Vector3.new(331.10, 29.06, -9891.08), Vector3.new(334.55, 29.06, -9903.20), Vector3.new(349.12, 29.08, -9915.16),
            Vector3.new(364.24, 29.16, -9922.89), Vector3.new(388.78, 29.06, -9935.63), Vector3.new(409.41, 29.06, -9935.81),
            Vector3.new(430.67, 29.06, -9932.64), Vector3.new(445.45, 29.06, -9923.95), 
            Vector3.new(475.28, 29.06, -9913.53),
            Vector3.new(475.55, 40.90, -9911.50),
            Vector3.new(464.18, 43.14, -9903.49)
        }
    },
    
    nsoficee_pos1 = { spawn = Vector3.new(441.71,52.16,-4020.30), route = { Vector3.new(431.25,52.16,-4010.74), Vector3.new(431.00,52.16,-3978.28), Vector3.new(440.41,52.16,-3947.91) } },
    nsoficee_pos2 = { spawn = Vector3.new(440.92,52.16,-3948.50), route = { Vector3.new(430.05,52.16,-3973.29), Vector3.new(431.15,52.16,-4014.97), Vector3.new(442.42,52.16,-4019.54) } },
    mansao_pos1 = { spawn = Vector3.new(384.11,45.81,-4006.40), route = { Vector3.new(385.52,45.81,-4011.59), Vector3.new(394.75,45.81,-4022.75), Vector3.new(406.98,45.81,-4022.62), Vector3.new(424.02,45.80,-4023.10), Vector3.new(440.80,45.81,-4022.72), Vector3.new(450.89,45.81,-4020.03), Vector3.new(453.29,45.81,-4006.65) } },
    mansao_pos2 = { spawn = Vector3.new(452.91,45.81,-4006.40), route = { Vector3.new(453.02,45.81,-4008.95), Vector3.new(453.13,45.81,-4018.90), Vector3.new(433.64,45.81,-4021.71), Vector3.new(414.24,45.80,-4021.74), Vector3.new(396.00,45.81,-4022.96), Vector3.new(384.77,45.81,-4015.02), Vector3.new(383.90,45.81,-4006.80) } }
}

--========================================================
-- MOTOR DE MOVIMENTO COM LÓGICA DE TELEPORTE
--========================================================

local function getChar() return player.Character end
local function getHum() return getChar() and getChar():FindFirstChildOfClass("Humanoid") end
local function getRoot() return getChar() and getChar():FindFirstChild("HumanoidRootPart") end

-- Interface UI (Mantida)
local sg = player.PlayerGui:FindFirstChild("NavDebug") or Instance.new("ScreenGui", player.PlayerGui)
sg.Name = "NavDebug"
sg.ResetOnSpawn = false
local frame = sg:FindFirstChild("Frame") or Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 300, 0, 180)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.new(0,0,0)
frame.BackgroundTransparency = 0.4
local label = frame:FindFirstChild("Label") or Instance.new("TextLabel", frame)
label.Name = "Label"
label.Size = UDim2.new(1, -10, 1, -10)
label.TextColor3 = Color3.new(1,1,1)
label.TextSize = 14
label.Font = Enum.Font.Code
label.TextXAlignment = "Left"
label.TextYAlignment = "Top"
label.RichText = true
label.BackgroundTransparency = 1

local function log(txt) label.Text = txt end

function mover(destinoReal, nomeRota, passo, offsetZ)
    local tempo = tick()
    
    -- LÓGICA DE TELEPORTE DA BASE MILITAR
    local pontoTeleporteX = 475.55
    local pontoTeleporteZ = -9911.50 + offsetZ
    
    if math.abs(destinoReal.X - pontoTeleporteX) < 1 and math.abs(destinoReal.Z - pontoTeleporteZ) < 1 then
        local r = getRoot()
        if r then
            r.CFrame = CFrame.new(destinoReal)
            log("<b>SISTEMA:</b> Teleporte de Patamar efetuado!")
            task.wait(0.2)
            return "OK"
        end
    end

    while tick() - tempo < TIMEOUT do
        local r = getRoot()
        local h = getHum()
        if not r or not h or h.Health <= 0 then return "MORREU" end
        
        h:MoveTo(destinoReal)
        
        local dist = (r.Position - destinoReal).Magnitude
        log(string.format(
            "<b>POS:</b> %.1f, %.1f, %.1f\n" ..
            "<b>ROTA:</b> %s\n" ..
            "<b>PASSO:</b> %s\n" ..
            "<b>DIST:</b> %.2f\n" ..
            "<b>MORTES:</b> %d",
            r.Position.X, r.Position.Y, r.Position.Z, nomeRota, tostring(passo), dist, mortesMapa
        ))
        
        if dist < 4.0 then return "OK" end
        task.wait(0.1)
    end
    return "TIMEOUT"
end

function executar(dados, nome, tipo)
    if emRota then return end
    emRota = true
    
    local root = getRoot()
    if not root then emRota = false return end
    
    local offsetZ = root.Position.Z - dados.spawn.Z
    local pontos = dados.waypoints or dados.route
    
    for i, p in ipairs(pontos) do
        local dReal = Vector3.new(p.X, p.Y, p.Z + offsetZ)
        if mover(dReal, nome, i, offsetZ) == "MORREU" then emRota = false return end
    end
    
    if tipo == "lobby" then
        mover(finalDest, "Teleporte", "FINAL", 0)
        log("<b>AGUARDANDO TELEPORTE...</b>")
        local startWait = tick()
        while tick() - startWait < 15 do
            local r = getRoot()
            if not r or r.Position.Z < -2000 then break end
            task.wait(0.5)
        end
    end
    
    emRota = false
end

player.CharacterAdded:Connect(function(c)
    mortesMapa = mortesMapa + 1
    emRota = false
end)

local ultimaZona = ""
while true do
    local r = getRoot()
    local h = getHum()
    
    if r and h and h.Health > 0 and not emRota then
        local p = r.Position
        local zonaAtual = (p.Z > -2000) and "lobby" or "mapa"
        
        if ultimaZona ~= "" and ultimaZona ~= zonaAtual then
            ultimaZona = zonaAtual
            task.wait(1.5)
        end
        ultimaZona = zonaAtual

        local melhorRota, nomeRota = nil, nil
        local menorDist = 120 
        local lista = (zonaAtual == "lobby") and LobbyRoutes or MapRoutes
        
        for nome, info in pairs(lista) do
            local diffX = math.abs(p.X - info.spawn.X)
            local diffZ = math.abs(p.Z - info.spawn.Z) % 1000 
            local d = math.sqrt(diffX^2 + (diffZ > 500 and 1000-diffZ or diffZ)^2)
            
            if d < menorDist then
                menorDist = d
                melhorRota = info
                nomeRota = nome
            end
        end
        
        if melhorRota then
            executar(melhorRota, nomeRota, zonaAtual)
        else
            log(string.format("<b>POS:</b> %.1f, %.1f, %.1f\nPROCURANDO SPAWN...", p.X, p.Y, p.Z))
        end
    end
    task.wait(0.5)
end
