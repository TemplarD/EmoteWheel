--[[
    КРУГОВОЕ меню эмоций для WoW 3.3.5a
]]

EmoteWheel.Wheel = {}

function EmoteWheel.Wheel:Initialize()
    self:CreateMainFrame()
    self:CreateCentralWheel()  -- Центральный круг с группами
    self:CreateEmoteRing()     -- Кольцо эмоций вокруг
    self.currentGroup = EmoteWheelDB.currentGroup or 1
    self:Hide()
    EmoteWheel:Print("Круговое меню эмоций инициализировано!")
end

function EmoteWheel.Wheel:CreateMainFrame()
    self.frame = CreateFrame("Frame", "EmoteWheelFrame", UIParent)
    self.frame:SetSize(350, 350) -- Увеличиваем для кругового расположения
    self.frame:SetPoint("CENTER")
    self.frame:SetFrameStrata("DIALOG")
    self.frame:SetClampedToScreen(true)
    self.frame:Hide()
    
    -- Фон всего меню (круглый)
    self.background = self.frame:CreateTexture(nil, "BACKGROUND")
    self.background:SetSize(320, 320)
    self.background:SetPoint("CENTER")
    self.background:SetTexture("Interface\\AddOns\\EmoteWheel\\Textures\\CircleBackground")
    self.background:SetVertexColor(0, 0, 0, 0.8)
    
    -- Перехватчик кликов снаружи (уже работает)
    self.clickCatcher = CreateFrame("Frame", nil, UIParent)
    self.clickCatcher:SetAllPoints(UIParent)
    self.clickCatcher:SetFrameStrata("DIALOG")
    self.clickCatcher:EnableMouse(true)
    self.clickCatcher:SetScript("OnMouseDown", function() self:Hide() end)
    self.clickCatcher:Hide()
end

function EmoteWheel.Wheel:CreateCentralWheel()
    -- Центральный круг будет разделен на 8 секторов
    self.groupSectors = {}
    local sectors = 8
    local radius = 60 -- Радиус центрального круга
    
    for i = 1, sectors do
        local sector = self:CreateGroupSector(i, radius, sectors)
        self.groupSectors[i] = sector
    end
end

function EmoteWheel.Wheel:CreateGroupSector(sectorIndex, radius, totalSectors)
    -- Создаем сектор круга (кусок пирога)
    local sector = CreateFrame("Frame", nil, self.frame)
    sector:SetSize(radius * 2, radius * 2)
    sector:SetPoint("CENTER")
    
    -- Здесь будет текстура сектора с цветом группы
    -- Пока используем простую реализацию
    
    return sector
end

function EmoteWheel.Wheel:CreateEmoteRing()
    -- Эмоции будут расположены по кругу вокруг центра
    self.emoteButtons = {}
end