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

-- Функция применения настроек шрифта (НОВОЕ)
function EmoteWheel.Wheel:ApplyFontSettings(fontString, fontType)
    local fontSettings = EmoteWheelConfig.fonts[fontType]
    if not fontSettings then return end
    
    fontString:SetFont(fontSettings.font, fontSettings.size, fontSettings.outline)
end

-- Функция применения цветовой схемы (НОВОЕ)
function EmoteWheel.Wheel:ApplyColorToButton(button, groupIndex, isSelected)
    local color = EmoteWheelConfig.groupColors[groupIndex] or {1, 1, 1}
    
    if isSelected then
        button.colorBg:SetVertexColor(1, 1, 1, 1.0) -- Белый для выбранной
        button.border:SetVertexColor(1, 1, 1, 0.8)
    else
        button.colorBg:SetVertexColor(color[1], color[2], color[3], 0.7)
        button.border:SetVertexColor(1, 1, 1, 0)
    end
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
    self.centerCircle:SetSize(420, 420) -- Уменьшили размер
    self.centerCircle:SetPoint("CENTER")
    self.centerCircle:SetTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMask") -- Или используем WHITE8X8
    self.centerCircle:SetVertexColor(0.1, 0.1, 0.1, 1.0) -- Более прозрачный
    
    -- НАЗВАНИЕ ГРУППЫ (НОВОЕ) - над фреймом
    self.groupTitle = self.frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    self.groupTitle:SetPoint("BOTTOM", self.frame, "TOP", 0, 10)
    self.groupTitle:SetText("Группа эмоций")
    self.groupTitle:SetTextColor(1, 1, 1)
    self.groupTitle:SetShadowOffset(1, -1)
    self.groupTitle:SetShadowColor(0, 0, 0, 0.8)
    self:ApplyFontSettings(self.groupTitle, "groupTitle") -- НОВОЕ	
	
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
    button:SetSize(42, 42)
    button.groupIndex = groupIndex
    
    -- Фон кнопки (круглый)
    local bg = button:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(true)
    bg:SetTexture("Interface\\Minimap\\UI-Minimap-Background") -- Нужна круглая текстура
    -- Или создаем "круг" через маску (упрощенный вариант)
    -- bg:SetTexture("Interface\\Buttons\\WHITE8X8")
    bg:SetVertexColor(0, 0, 0, 0.5) -- Черная подложка
	
    local colorBg = button:CreateTexture(nil, "ARTWORK")
    colorBg:SetSize(42, 42)
    colorBg:SetPoint("CENTER")
    colorBg:SetTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMask")
    local color = EmoteWheelConfig.groupColors[groupIndex] or {1, 1, 1}
    colorBg:SetVertexColor(color[1], color[2], color[3], 0.8)
    button.colorBg = colorBg	
	
    -- Белая обводка для выбранной группы
    local border = button:CreateTexture(nil, "BORDER")
    border:SetSize(43, 43)
    border:SetPoint("CENTER")
    border:SetTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMask")
    border:SetVertexColor(0.1, 0.1, 0.1, 1)
    button.border = border	
    
    -- Номер группы в центре
    local text = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    text:SetPoint("CENTER")
    text:SetText(groupIndex)
    text:SetTextColor(1, 1, 1)
    text:SetShadowOffset(1, -1)
    text:SetShadowColor(0, 0, 0, 0.8)
    self:ApplyFontSettings(text, "groupButtons") -- НОВОЕ	
    
    -- Обработчики событий
    button:SetScript("OnClick", function()
        self:SelectGroup(groupIndex)
    end)
    
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
    local emoteButtonSize = EmoteWheelDB.emoteButtonSize or 35
    local groupRadius = (EmoteWheelDB.buttonSize or 50) * 1.2
    local emoteRadius = groupRadius + emoteButtonSize * 1.5 -- Динамический радиус
    
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
        
        -- Применяем цветовые настройки
        if not EmoteWheelDB.enableColors then
            button.bg:SetVertexColor(0.2, 0.2, 0.2, 0.3)
            button.border:SetVertexColor(0.6, 0.6, 0.6, 0.5)
        else
            local color = EmoteWheelConfig.groupColors[self.currentGroup] or {1, 1, 1}
            button.bg:SetVertexColor(color[1] * 0.2, color[2] * 0.2, color[3] * 0.2, 0.3)
            button.border:SetVertexColor(color[1], color[2], color[3], 0.5)
        end
    end
end

function EmoteWheel.Wheel:CreateEmoteButton(emoteData, index)
    local button = CreateFrame("Button", nil, self.frame)
    button:SetSize(130, 28) -- Немного уменьшили
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
    self:ApplyFontSettings(text, "emoteButtons") -- НОВОЕ	
    
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
            btn.border:SetVertexColor(1, 1, 1, 0.8) -- Белая обводка			
            btn:SetAlpha(1.0)
            btn:SetScale(0.85) -- Немного увеличиваем выбранную группу
        else
            local btnColor = EmoteWheelConfig.groupColors[i] or {1, 1, 1}
            btn.colorBg:SetVertexColor(btnColor[1], btnColor[2], btnColor[3], 0.6)
            btn.border:SetVertexColor(1, 1, 1, 0) -- Прозрачная обводка			
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
    
    -- Обновляем все настройки
    self:UpdateBackground()
    self:UpdateColors()
    self:UpdateButtonSizes()
    
    -- Обновляем отображение для текущей группы
    self:SelectGroup(self.currentGroup)
    
    -- Регистрируем обработчик OnUpdate для отслеживания наведения
    self.frame:SetScript("OnUpdate", function()
        if EmoteWheelDB.hoverGroupSwitch then
            self:HandleHoverGroupSwitch()
        end
    end)
    
    self.frame:Show()
end

function EmoteWheel.Wheel:Hide()
    -- -- Скрываем тултип при закрытии колеса
    -- if GameTooltip:IsOwned(self.frame) or GameTooltip:IsShown() then
        -- GameTooltip:Hide()
    -- end
	
	-- Гарантированно скрываем все тултипы
    GameTooltip:Hide()
    self.clickCatcher:Hide()
    self.frame:SetScript("OnUpdate", nil) -- Убираем обработчик
    self.frame:Hide()
end

function EmoteWheel.Wheel:SetGroup(groupIndex)
    self:SelectGroup(groupIndex)
end

-- Функция обновления размеров кнопок (ОБНОВЛЕННАЯ)
function EmoteWheel.Wheel:UpdateButtonSizes()
    local groupButtonSize = EmoteWheelDB.buttonSize or 50
    local emoteButtonSize = EmoteWheelDB.emoteButtonSize or 35
    
    -- Обновляем размеры кнопок групп
    for i, button in ipairs(self.groupButtons or {}) do
        button:SetSize(groupButtonSize, groupButtonSize)
        if button.colorBg then
            button.colorBg:SetSize(groupButtonSize, groupButtonSize)
        end
        if button.border then
            button.border:SetSize(groupButtonSize + 1, groupButtonSize + 1)
        end
    end
    
    -- Обновляем размеры кнопок эмоций (ширина и высота отдельно)
    for i, button in ipairs(self.emoteButtons or {}) do
        button:SetSize(emoteButtonSize * 3, emoteButtonSize) -- Ширина в 3 раза больше высоты
    end
    
    -- Пересчитываем позиции
    self:UpdateButtonPositions()
end

-- Функция обновления позиций кнопок (ОБНОВЛЕННАЯ)
function EmoteWheel.Wheel:UpdateButtonPositions()
    local groupCount = math.min(EmoteWheelConfig.maxGroups or 4, 8)
    local groupButtonSize = EmoteWheelDB.buttonSize or 50
    local emoteButtonSize = EmoteWheelDB.emoteButtonSize or 35
    
    local groupRadius = groupButtonSize * 1.2 -- Радиус для групп
    local emoteRadius = groupRadius + emoteButtonSize * 1.5 -- Радиус для эмоций (дальше от центра)
    
    -- Обновляем позиции кнопок групп
    for i, button in ipairs(self.groupButtons or {}) do
        local angle = (i / groupCount) * 2 * math.pi
        local x = math.cos(angle) * groupRadius
        local y = math.sin(angle) * groupRadius
        button:SetPoint("CENTER", self.frame, "CENTER", x, y)
    end
    
    -- Обновляем позиции кнопок эмоций
    self:UpdateEmoteButtons()
end

-- Функция обновления фона
function EmoteWheel.Wheel:UpdateBackground()
    if EmoteWheelDB.showBackground then
        self.centerCircle:Show()
    else
        self.centerCircle:Hide()
    end
end

-- Функция обновления цветов (ИСПРАВЛЕННАЯ)
function EmoteWheel.Wheel:UpdateColors()
    if not EmoteWheelDB.enableColors then
        -- Отключаем цвета - используем нейтральные тона
        self.centerCircle:SetVertexColor(0.3, 0.3, 0.3, 0.2) -- Темно-серый прозрачный
        
        -- Обновляем кнопки групп
        for i, button in ipairs(self.groupButtons or {}) do
            if i == self.currentGroup then
                button.colorBg:SetVertexColor(0.8, 0.8, 0.8, 0.9) -- Светло-серый для выбранной
                button.border:SetVertexColor(1, 1, 1, 0.8)
            else
                button.colorBg:SetVertexColor(0.5, 0.5, 0.5, 0.6) -- Серый для остальных
                button.border:SetVertexColor(1, 1, 1, 0)
            end
        end
        
        -- Обновляем кнопки эмоций
        for i, button in ipairs(self.emoteButtons or {}) do
            button.bg:SetVertexColor(0.2, 0.2, 0.2, 0.3) -- Темно-серый фон
            button.border:SetVertexColor(0.6, 0.6, 0.6, 0.5) -- Серый бордер
            
            -- Обновляем текст эмоций на белый
            local text = button:GetRegions()
            if text and text:GetObjectType() == "FontString" then
                text:SetTextColor(1, 1, 1) -- Белый текст
            end
        end
        
        -- Обновляем заголовок группы
        self.groupTitle:SetTextColor(1, 1, 1) -- Белый текст заголовка
    else
        -- Включаем цвета групп
        self:SelectGroup(self.currentGroup)
    end
end

-- Функция обработки смены группы по наведению
function EmoteWheel.Wheel:HandleHoverGroupSwitch()
    if not self.frame:IsVisible() then return end
    
    local x, y = GetCursorPosition()
    local scale = self.frame:GetEffectiveScale()
    x, y = x / scale, y / scale
    
    local centerX, centerY = self.frame:GetCenter()
    local deltaX, deltaY = x - centerX, y - centerY
    
    -- Вычисляем расстояние от центра
    local distance = math.sqrt(deltaX * deltaX + deltaY * deltaY)
    local buttonSize = EmoteWheelDB.buttonSize or 50
    local groupRadius = buttonSize * 1.2
    
    -- Если курсор в зоне кнопок групп
    if distance > groupRadius - buttonSize/2 and distance < groupRadius + buttonSize/2 then
        -- Вычисляем угол
        local angle = math.atan2(deltaY, deltaX)
        if angle < 0 then angle = angle + 2 * math.pi end
        
        -- Определяем группу по углу
        local groupCount = math.min(EmoteWheelConfig.maxGroups or 4, 8)
        local groupIndex = math.floor((angle / (2 * math.pi)) * groupCount) + 1
        groupIndex = math.min(math.max(groupIndex, 1), groupCount)
        
        if groupIndex ~= self.currentGroup then
            self:SelectGroup(groupIndex)
        end
    end
end

function EmoteWheel.Wheel:OnUpdate()
    if not self:IsVisible() then return end
    
    local x, y = GetCursorPosition()
    local scale = self.frame:GetEffectiveScale()
    x, y = x / scale, y / scale
    
    local centerX, centerY = self.frame:GetCenter()
    local deltaX, deltaY = x - centerX, y - centerY
    
    -- Вычисляем угол курсора относительно центра
    local angle = math.atan2(deltaY, deltaX)
    if angle < 0 then angle = angle + 2 * math.pi end
    
    -- Определяем, над какой кнопкой находится курсор
    local buttonIndex = self:GetButtonIndexFromAngle(angle)
    
    -- Если курсор переместился на другую кнопку
    if buttonIndex ~= self.currentHoverButton then
        self.currentHoverButton = buttonIndex
        
        -- Если включена смена по наведению и это кнопка группы
        if EmoteWheelDB.hoverGroupSwitch and self:IsGroupButton(buttonIndex) then
            local groupIndex = self:GetGroupFromButton(buttonIndex)
            self:SelectGroup(groupIndex)
        end
    end
end