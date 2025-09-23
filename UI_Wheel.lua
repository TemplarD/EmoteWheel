--[[
    Круговое меню эмоций для WoW 3.3.5a
    Версия с circular layout
]]

EmoteWheel.Wheel = {}

function EmoteWheel.Wheel:Initialize()
    self:CreateFrame()
    self.currentGroup = EmoteWheelDB.currentGroup or 1
    self:Hide()
    EmoteWheel:Print("Улучшенное круговое меню загружено!")
end

function EmoteWheel.Wheel:CreateFrame()
    self.frame = CreateFrame("Frame", "EmoteWheelFrame", UIParent)
    self.frame:SetSize(350, 350) -- Увеличили для кругового расположения
    self.frame:SetPoint("CENTER")
    self.frame:SetFrameStrata("DIALOG")
    self.frame:SetClampedToScreen(true)
    self.frame:Hide()
        
    -- Центральный круг-индикатор группы (уменьшаем и делаем красивее)
    self.centerCircle = self.frame:CreateTexture(nil, "ARTWORK")
    self.centerCircle:SetSize(60, 60) -- Уменьшили размер
    self.centerCircle:SetPoint("CENTER")
    self.centerCircle:SetTexture("Interface\\AddOns\\EmoteWheel\\Textures\\Circle") -- Или используем WHITE8X8
    self.centerCircle:SetVertexColor(0.5, 0.5, 0.5, 0.6) -- Более прозрачный
    
    -- НАЗВАНИЕ ГРУППЫ (НОВОЕ) - над фреймом
    self.groupTitle = self.frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    self.groupTitle:SetPoint("BOTTOM", self.frame, "TOP", 0, 10)
    self.groupTitle:SetText("Группа эмоций")
    self.groupTitle:SetTextColor(1, 1, 1)
    self.groupTitle:SetShadowOffset(1, -1)
    self.groupTitle:SetShadowColor(0, 0, 0, 0.8)
	
    -- Перехватчик кликов снаружи
    self.clickCatcher = CreateFrame("Frame", nil, UIParent)
    self.clickCatcher:SetAllPoints(UIParent)
    self.clickCatcher:SetFrameStrata("DIALOG")
    self.clickCatcher:EnableMouse(true)
    self.clickCatcher:SetScript("OnMouseDown", function()
        self:Hide()
    end)
    self.clickCatcher:Hide()
    
    -- Обработчик ESC
    self.frame:SetScript("OnKeyDown", function(_, key)
        if key == "ESCAPE" then
            self:Hide()
        end
    end)
    self.frame:EnableKeyboard(true)
    
    -- Создаем элементы интерфейса
    self:CreateGroupButtons()
    self:CreateEmoteButtons()
end

function EmoteWheel.Wheel:CreateCentralDiagram()
    -- Создаем кольцо из секторов-кнопок групп
    self.groupSectors = {}
    local sectorCount = EmoteWheelConfig.maxGroups or 4
    local innerRadius = 40  -- Внутренний радиус кольца
    local outerRadius = 80  -- Внешний радиус кольца
    
    for i = 1, sectorCount do
        local sector = self:CreateGroupSector(i, innerRadius, outerRadius, sectorCount)
        self.groupSectors[i] = sector
    end
end

function EmoteWheel.Wheel:CreateGroupSector(sectorIndex, innerRadius, outerRadius, totalSectors)
    local sector = CreateFrame("Button", "EmoteWheelSector"..sectorIndex, self.frame)
    sector:SetFrameStrata("BACKGROUND")
    sector.groupIndex = sectorIndex
    
    -- Вычисляем углы сектора
    local startAngle = ((sectorIndex - 1) / totalSectors) * 2 * math.pi
    local endAngle = (sectorIndex / totalSectors) * 2 * math.pi
    
    -- Создаем текстуру сектора (простой треугольник для начала)
    local texture = sector:CreateTexture(nil, "BACKGROUND")
    texture:SetTexture("Interface\\Buttons\\WHITE8X8")
    local color = EmoteWheelConfig.groupColors[sectorIndex] or {1, 1, 1}
    texture:SetVertexColor(color[1], color[2], color[3], 0.6)
    
    -- Позиционируем сектор (упрощенная версия - круговая кнопка)
    sector:SetSize(outerRadius * 2, outerRadius * 2)
    sector:SetPoint("CENTER")
    
    -- Текст номера группы в центре сектора
    local text = sector:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    text:SetPoint("CENTER")
    text:SetText(sectorIndex)
    text:SetTextColor(1, 1, 1)
    
    sector:SetScript("OnClick", function()
        self:SelectGroup(sectorIndex)
    end)
    
    sector:SetScript("OnEnter", function()
        texture:SetAlpha(0.9)
        local groupName = EmoteWheelData.groups[sectorIndex] and EmoteWheelData.groups[sectorIndex].name or "Группа "..sectorIndex
        GameTooltip:SetOwner(sector, "ANCHOR_CURSOR")
        GameTooltip:SetText(groupName)
        GameTooltip:Show()
    end)
    
    sector:SetScript("OnLeave", function()
        texture:SetAlpha(0.6)
        GameTooltip:Hide()
    end)
    
    sector.texture = texture
    return sector
end

function EmoteWheel.Wheel:CreateGroupButtons()
    self.groupButtons = {}
    local groupCount = math.min(EmoteWheelConfig.maxGroups or 4, 8)
    local radius = 50 -- Уменьшили радиус - ближе к центру
    
    for i = 1, groupCount do
        local angle = (i / groupCount) * 2 * math.pi
        local x = math.cos(angle) * radius
        local y = math.sin(angle) * radius
        
        local button = self:CreateGroupButton(i, angle)
        button:SetPoint("CENTER", self.frame, "CENTER", x, y)
        self.groupButtons[i] = button
    end
end

function EmoteWheel.Wheel:CreateGroupButton(groupIndex, angle)
    local button = CreateFrame("Button", "EmoteWheelGroupBtn"..groupIndex, self.frame)
    button:SetSize(35, 35)
    button.groupIndex = groupIndex
    
    -- Фон кнопки (круглый)
    local bg = button:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(true)
    bg:SetTexture("Interface\\AddOns\\EmoteWheel\\Textures\\Circle") -- Нужна круглая текстура
    -- Или создаем "круг" через маску (упрощенный вариант)
    -- bg:SetTexture("Interface\\Buttons\\WHITE8X8")
    bg:SetVertexColor(0, 0, 0, 0.8) -- Черная подложка
	
    local colorBg = button:CreateTexture(nil, "ARTWORK")
    colorBg:SetSize(30, 30)
    colorBg:SetPoint("CENTER")
    colorBg:SetTexture("Interface\\Buttons\\WHITE8X8")
    local color = EmoteWheelConfig.groupColors[groupIndex] or {1, 1, 1}
    colorBg:SetVertexColor(color[1], color[2], color[3], 0.8)
    button.colorBg = colorBg	
    
    -- Номер группы в центре
    local text = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    text:SetPoint("CENTER")
    text:SetText(groupIndex)
    text:SetTextColor(1, 1, 1)
    
    -- Обработчики событий
    button:SetScript("OnClick", function()
        self:SelectGroup(groupIndex)
    end)
    
    -- button:SetScript("OnEnter", function()
        -- bg:SetAlpha(1.0)
        -- local groupName = EmoteWheelData.groups[groupIndex] and EmoteWheelData.groups[groupIndex].name or "Группа "..groupIndex
        -- GameTooltip:SetOwner(button, "ANCHOR_CURSOR")
        -- GameTooltip:SetText(groupName)
        -- GameTooltip:Show()
    -- end)
	
    button:SetScript("OnEnter", function()
        colorBg:SetAlpha(1.0)
        bg:SetAlpha(1.0)
		
        -- УЛУЧШЕННАЯ ПОДСКАЗКА (НОВОЕ)
        local groupData = EmoteWheelData.groups[groupIndex]
        local groupName = groupData and groupData.name or "Группа "..groupIndex
        local emoteCount = groupData and #groupData.emotes or 0
        
        GameTooltip:SetOwner(button, "ANCHOR_CURSOR")
        GameTooltip:SetText(groupName, color[1], color[2], color[3])
        GameTooltip:AddLine(emoteCount .. " эмоций", 0.3, 0.3, 0.3)
        
        -- Показываем первые 3 эмоции из группы
        -- if groupData and groupData.emotes then
            -- GameTooltip:AddLine(" ", 1, 1, 1) -- Пустая строка
            -- for i = 1, math.min(3, #groupData.emotes) do
                -- GameTooltip:AddLine("• " .. groupData.emotes[i].name, 0.9, 0.9, 0.9)
            -- end
            -- if #groupData.emotes > 3 then
                -- GameTooltip:AddLine("... и еще " .. (#groupData.emotes - 3), 0.7, 0.7, 0.7)
            -- end
        -- end
        
        GameTooltip:Show()		
    end)	
    
    button:SetScript("OnLeave", function()
        colorBg:SetAlpha(0.8)
        bg:SetAlpha(0.8)
    end)
    
    return button
end

function EmoteWheel.Wheel:CreateEmoteButtons()
    self.emoteButtons = {}
    -- Кнопки эмоций будут создаваться динамически
end

function EmoteWheel.Wheel:UpdateEmoteButtons()
    -- Удаляем старые кнопки
    for i, btn in ipairs(self.emoteButtons or {}) do
        btn:Hide()
    end
    
    self.emoteButtons = {}
    
    local groupData = EmoteWheelData.groups[self.currentGroup]
    if not groupData or not groupData.emotes then return end
    
    local emotes = groupData.emotes
    local emoteCount = #emotes
    local groupRadius = 100 -- Радиус групп
    local emoteRadius = 130 -- Радиус для эмоций (внешнее кольцо)
    
    -- Вычисляем угол начала для эмоций текущей группы
    local groupAngle = ((self.currentGroup - 1) / (EmoteWheelConfig.maxGroups or 4)) * 2 * math.pi
    local anglePerEmote = (2 * math.pi) / emoteCount
    
    for i, emote in ipairs(emotes) do
        -- Располагаем эмоции вокруг своей группы
        local angle = groupAngle + (i - 1) * anglePerEmote
        local x = math.cos(angle) * emoteRadius
        local y = math.sin(angle) * emoteRadius
        
        local button = self:CreateEmoteButton(emote, i)
        button:SetPoint("CENTER", self.frame, "CENTER", x, y)
        self.emoteButtons[i] = button
        
        -- Подсвечиваем фон эмоции в цвет группы
        local color = EmoteWheelConfig.groupColors[self.currentGroup] or {1, 1, 1}
        button.bg:SetVertexColor(color[1] * 0.3, color[2] * 0.3, color[3] * 0.3, 0.7)
    end
end

function EmoteWheel.Wheel:CreateEmoteButton(emoteData, index)
    local button = CreateFrame("Button", nil, self.frame)
    button:SetSize(120, 28) -- Немного уменьшили
    button.emoteData = emoteData
    
    -- Фон кнопки эмоции - полупрозрачный в цвет группы
    local bg = button:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(true)
    bg:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
    
    -- Цвет берем от текущей группы, но делаем очень прозрачным
    local color = EmoteWheelConfig.groupColors[self.currentGroup] or {1, 1, 1}
    bg:SetVertexColor(color[1] * 0.2, color[2] * 0.2, color[3] * 0.2, 0.3) -- Очень прозрачный
    
    -- Граница в цвет группы
    local border = button:CreateTexture(nil, "BORDER")
    border:SetAllPoints(true)
    border:SetTexture("Interface\\Tooltips\\UI-Tooltip-Border")
    border:SetVertexColor(color[1], color[2], color[3], 0.5)
    
    button.bg = bg
    button.border = border
    
    -- Текст эмоции
    local text = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    text:SetPoint("CENTER")
    text:SetText(emoteData.name)
    text:SetTextColor(1, 1, 1) -- Белый текст
    text:SetShadowOffset(1, -1) -- Добавляем тень для лучшей читаемости
    text:SetShadowColor(0, 0, 0, 0.8)
    
    button:SetScript("OnClick", function()
        self:ExecuteEmote(emoteData.command, emoteData.name)
    end)
    
    button:SetScript("OnEnter", function()
        bg:SetVertexColor(color[1] * 0.4, color[2] * 0.4, color[3] * 0.4, 0.6) -- Ярче при наведении
        border:SetVertexColor(color[1], color[2], color[3], 0.8)
        text:SetTextColor(1, 0.9, 0.4) -- Золотистый при наведении
    end)
    
    button:SetScript("OnLeave", function()
        bg:SetVertexColor(color[1] * 0.2, color[2] * 0.2, color[3] * 0.2, 0.3)
        border:SetVertexColor(color[1], color[2], color[3], 0.5)
        text:SetTextColor(1, 1, 1)
    end)
    
    return button
end

function EmoteWheel.Wheel:SelectGroup(groupIndex)
    self.currentGroup = groupIndex
    EmoteWheelDB.currentGroup = groupIndex
    
    -- Обновляем центральный круг цветом группы (сделаем его тоньше)
    local color = EmoteWheelConfig.groupColors[groupIndex] or {1, 1, 1}
    self.centerCircle:SetVertexColor(color[1], color[2], color[3], 0.4) -- Более прозрачный
    
    -- ОБНОВЛЯЕМ НАЗВАНИЕ ГРУППЫ (НОВОЕ)
    local groupData = EmoteWheelData.groups[groupIndex]
    local groupName = groupData and groupData.name or ("Группа "..groupIndex)
    self.groupTitle:SetText(groupName)
    self.groupTitle:SetTextColor(color[1], color[2], color[3]) -- Цвет текста как у группы

    -- Обновляем кнопки эмоций с новыми цветами
    self:UpdateEmoteButtons()
    
    -- Подсвечиваем выбранную группу
    for i, btn in ipairs(self.groupButtons) do
        if i == groupIndex then
            btn.colorBg:SetVertexColor(1, 1, 1, 1.0) -- Белая подсветка выбранной
            btn:SetAlpha(1.0)
            btn:SetScale(1.1) -- Немного увеличиваем выбранную группу
        else
            local btnColor = EmoteWheelConfig.groupColors[i] or {1, 1, 1}
            btn.colorBg:SetVertexColor(btnColor[1], btnColor[2], btnColor[3], 0.6)
            btn:SetAlpha(0.6)
            btn:SetScale(1.0) -- Обычный размер
        end
    end
end

function EmoteWheel.Wheel:ExecuteEmote(command, name)
    if command and command ~= "" then
        DoEmote(command)
        EmoteWheel:AddToLog("Эмоция: " .. name)
        self:Hide()
    else
        EmoteWheel:Print("Ошибка: команда эмоции не найдена")
    end
end

function EmoteWheel.Wheel:Show()
    if not EmoteWheelDB.enabled then 
        EmoteWheel:Print("Аддон выключен в настройках")
        return 
    end
    
    -- Позиционируем у курсора
    local x, y = GetCursorPosition()
    local scale = UIParent:GetEffectiveScale()
    self.frame:ClearAllPoints()
    self.frame:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x / scale, y / scale)
    
    -- Показываем перехватчик кликов
    self.clickCatcher:Show()
    
    -- Обновляем отображение для текущей группы
    self:SelectGroup(self.currentGroup)
    
    self.frame:Show()
end

function EmoteWheel.Wheel:Hide()
    self.clickCatcher:Hide()
    self.frame:Hide()
end

function EmoteWheel.Wheel:SetGroup(groupIndex)
    self:SelectGroup(groupIndex)
end