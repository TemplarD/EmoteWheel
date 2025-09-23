--[[
    Круговое меню эмоций для WoW 3.3.5a
    Версия с circular layout
]]

EmoteWheel.Wheel = {}

function EmoteWheel.Wheel:Initialize()
    self:CreateFrame()
    self.currentGroup = EmoteWheelDB.currentGroup or 1
    self:Hide()
    EmoteWheel:Print("Круговое меню эмоций инициализировано! Shift+ПКМ для вызова.")
end

function EmoteWheel.Wheel:CreateFrame()
    self.frame = CreateFrame("Frame", "EmoteWheelFrame", UIParent)
    self.frame:SetSize(350, 350) -- Увеличили для кругового расположения
    self.frame:SetPoint("CENTER")
    self.frame:SetFrameStrata("DIALOG")
    self.frame:SetClampedToScreen(true)
    self.frame:Hide()
    
    -- Фон меню (круглый)
    self.background = self.frame:CreateTexture(nil, "BACKGROUND")
    self.background:SetAllPoints(true)
    self.background:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
    self.background:SetVertexColor(0, 0, 0, 0.9)
    
    -- Центральный круг-индикатор
    self.centerCircle = self.frame:CreateTexture(nil, "ARTWORK")
    self.centerCircle:SetSize(80, 80)
    self.centerCircle:SetPoint("CENTER")
    self.centerCircle:SetTexture("Interface\\Buttons\\WHITE8X8")
    self.centerCircle:SetVertexColor(0.3, 0.3, 0.3, 0.8)
    
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

function EmoteWheel.Wheel:CreateGroupButtons()
    self.groupButtons = {}
    local groupCount = math.min(EmoteWheelConfig.maxGroups or 4, 8) -- Максимум 8 групп по кругу
    local radius = 100 -- Радиус круга для групп
    
    for i = 1, groupCount do
        -- Вычисляем позицию на круге
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
    button:SetSize(40, 40)
    button.groupIndex = groupIndex
    
    -- Фон кнопки (круглый)
    local bg = button:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(true)
    bg:SetTexture("Interface\\Buttons\\WHITE8X8")
    local color = EmoteWheelConfig.groupColors[groupIndex] or {1, 1, 1}
    bg:SetVertexColor(color[1], color[2], color[3], 0.8)
    button.bg = bg
    
    -- Номер группы в центре
    local text = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    text:SetPoint("CENTER")
    text:SetText(groupIndex)
    text:SetTextColor(1, 1, 1)
    
    -- Обработчики событий
    button:SetScript("OnClick", function()
        self:SelectGroup(groupIndex)
    end)
    
    button:SetScript("OnEnter", function()
        bg:SetAlpha(1.0)
        local groupName = EmoteWheelData.groups[groupIndex] and EmoteWheelData.groups[groupIndex].name or "Группа "..groupIndex
        GameTooltip:SetOwner(button, "ANCHOR_CURSOR")
        GameTooltip:SetText(groupName)
        GameTooltip:Show()
    end)
    
    button:SetScript("OnLeave", function()
        bg:SetAlpha(0.8)
        GameTooltip:Hide()
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
    local emoteRadius = 150 -- Радиус для эмоций (внешнее кольцо)
    
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
    button:SetSize(120, 25)
    button.emoteData = emoteData
    
    -- Фон кнопки эмоции
    local bg = button:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(true)
    bg:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
    bg:SetVertexColor(0.1, 0.1, 0.1, 0.7)
    button.bg = bg
    
    -- Текст эмоции
    local text = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    text:SetPoint("CENTER")
    text:SetText(emoteData.name)
    text:SetTextColor(1, 1, 1)
    
    button:SetScript("OnClick", function()
        self:ExecuteEmote(emoteData.command, emoteData.name)
    end)
    
    button:SetScript("OnEnter", function()
        bg:SetVertexColor(0.3, 0.3, 0.3, 0.9)
        text:SetTextColor(1, 0.8, 0)
        GameTooltip:SetOwner(button, "ANCHOR_CURSOR")
        GameTooltip:SetText(emoteData.name)
        GameTooltip:AddLine("Нажмите для выполнения", 0.8, 0.8, 0.8)
        GameTooltip:Show()
    end)
    
    button:SetScript("OnLeave", function()
        -- Возвращаем цвет группы для фона
        local color = EmoteWheelConfig.groupColors[self.currentGroup] or {1, 1, 1}
        bg:SetVertexColor(color[1] * 0.3, color[2] * 0.3, color[3] * 0.3, 0.7)
        text:SetTextColor(1, 1, 1)
        GameTooltip:Hide()
    end)
    
    return button
end

function EmoteWheel.Wheel:SelectGroup(groupIndex)
    self.currentGroup = groupIndex
    EmoteWheelDB.currentGroup = groupIndex
    
    -- Обновляем центральный круг цветом группы
    local color = EmoteWheelConfig.groupColors[groupIndex] or {1, 1, 1}
    self.centerCircle:SetVertexColor(color[1] * 0.5, color[2] * 0.5, color[3] * 0.5, 0.8)
    
    -- Обновляем кнопки эмоций
    self:UpdateEmoteButtons()
    
    -- Подсвечиваем выбранную группу
    for i, btn in ipairs(self.groupButtons) do
        if i == groupIndex then
            btn.bg:SetVertexColor(1, 1, 1, 1.0) -- Белый для выбранной
            btn:SetAlpha(1.0)
        else
            local color = EmoteWheelConfig.groupColors[i] or {1, 1, 1}
            btn.bg:SetVertexColor(color[1], color[2], color[3], 0.6)
            btn:SetAlpha(0.7)
        end
    end
    
    local groupName = EmoteWheelData.groups[groupIndex] and EmoteWheelData.groups[groupIndex].name or "Группа "..groupIndex
    EmoteWheel:Print("Выбрана группа: " .. groupName)
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