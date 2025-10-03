--[[
    Меню настроек для EmoteWheel - версия 2.0.0 с локализацией
]]

function EmoteWheel:CreateOptionsFrame()
    -- Создаем фрейм настроек
    self.optionsFrame = CreateFrame("Frame", "EmoteWheelOptions", InterfaceOptionsFramePanelContainer)
    self.optionsFrame.name = EW_L("ADDON_NAME")
    self.optionsFrame:SetSize(1, 1) -- Важно для работы скролла
	
    -- Создаем ScrollFrame
    local scrollFrame = CreateFrame("ScrollFrame", "EmoteWheelScrollFrame", self.optionsFrame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 10, -10)
    scrollFrame:SetPoint("BOTTOMRIGHT", -30, 10)
    
    -- Создаем child frame для содержимого
    local scrollChild = CreateFrame("Frame", "EmoteWheelScrollChild")
    scrollFrame:SetScrollChild(scrollChild)
    scrollChild:SetWidth(InterfaceOptionsFramePanelContainer:GetWidth() - 40)
    scrollChild:SetHeight(1) -- Высота будет регулироваться по содержимому
    
    -- Автоматически рассчитываем высоту содержимого
    local function UpdateScrollChildHeight()
        local height = 1
        local lastElement = instructionText -- или самый нижний элемент
        
        if lastElement then
            local _, _, _, bottom = lastElement:GetBoundsRect()
            height = math.abs(bottom) + 10
        end
        
        scrollChild:SetHeight(math.max(height, scrollFrame:GetHeight()))
    end
    
    -- Заголовок	
    local title = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText(EW_L("SETTINGS_TITLE"))
	
    -- Чекбокс включения аддона
    local enableCheckbox = CreateFrame("CheckButton", "EmoteWheelEnableCheckbox", scrollChild, "OptionsCheckButtonTemplate")
    enableCheckbox:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -20)
    enableCheckbox:SetChecked(EmoteWheelDB.enabled)
    
    local enableText = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    enableText:SetPoint("LEFT", enableCheckbox, "RIGHT", 5, 0)
    enableText:SetText(EW_L("SETTINGS_ENABLE"))
    
    enableCheckbox:SetScript("OnClick", function(self)
        EmoteWheelDB.enabled = self:GetChecked()
        if EmoteWheelDB.enabled then
            EmoteWheel:Print(EW_L("ADDON_ENABLED"))
        else
            EmoteWheel:Print(EW_L("ADDON_DISABLED"))
        end
    end)
    
    -- Выбор группы эмоций
    local groupText = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    groupText:SetPoint("TOPLEFT", enableCheckbox, "BOTTOMLEFT", 0, -15)
    groupText:SetText(EW_L("SETTINGS_CURRENT_GROUP"))
    
    local groupDropdown = CreateFrame("Frame", "EmoteWheelGroupDropdown", scrollChild, "UIDropDownMenuTemplate")
    groupDropdown:SetPoint("TOPLEFT", groupText, "BOTTOMLEFT", 0, -10)
    groupDropdown:SetWidth(150)
    
    -- Функция для обновления текста выпадающего списка
    local function UpdateDropdownText()
        local groupIndex = EmoteWheelDB.currentGroup or 1
        local groupData = EmoteWheelData.groups[groupIndex]
        local text = groupData and groupData.name or (EW_L("GROUP_MAIN") .. " " .. groupIndex)
        UIDropDownMenu_SetText(groupDropdown, text)
    end
    
    -- Инициализация выпадающего списка
    UIDropDownMenu_Initialize(groupDropdown, function(self, level)
        local info = UIDropDownMenu_CreateInfo()
        
        for i = 1, (EmoteWheelConfig.maxGroups or 4) do
            local groupData = EmoteWheelData.groups[i]
            info.text = groupData and groupData.name or (EW_L("GROUP_MAIN") .. " " .. i)
            info.value = i
            info.func = function(button)
                EmoteWheelDB.currentGroup = button.value
                UpdateDropdownText()
                if EmoteWheel.Wheel and EmoteWheel.Wheel.SetGroup then
                    EmoteWheel.Wheel:SetGroup(button.value)
                end
                EmoteWheel:Print(EW_L("SETTINGS_CURRENT_GROUP") .. " " .. info.text)
            end
            info.checked = (i == EmoteWheelDB.currentGroup)
            UIDropDownMenu_AddButton(info)
        end
    end)
    
    -- Устанавливаем начальный текст
    UpdateDropdownText()
	
	-- Настройка размера шрифта эмоций
	local fontSizeText = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	fontSizeText:SetPoint("TOPLEFT", groupDropdown, "BOTTOMLEFT", 0, -15)
	fontSizeText:SetText(EW_L("SETTINGS_FONT_SIZE"))

	local fontSizeSlider = CreateFrame("Slider", "EmoteWheelFontSizeSlider", scrollChild, "OptionsSliderTemplate")
	fontSizeSlider:SetPoint("TOPLEFT", fontSizeText, "BOTTOMLEFT", 0, -15)
	fontSizeSlider:SetWidth(180)
	fontSizeSlider:SetHeight(15)
	fontSizeSlider:SetMinMaxValues(6, 30)
	fontSizeSlider:SetValueStep(1)
	fontSizeSlider:SetValue(EmoteWheelConfig.fonts.emoteButtons.size or 12)
	fontSizeSlider:SetScript("OnValueChanged", function(self, value)
		value = math.floor(value)
		EmoteWheelConfig.fonts.emoteButtons.size = value
		_G[self:GetName().."Text"]:SetText(EW_L("SETTINGS_FONT_SIZE") .. ": " .. value)
		-- Обновляем колесо если оно открыто
		if EmoteWheel.Wheel and EmoteWheel.Wheel.frame and EmoteWheel.Wheel.frame:IsVisible() then
			EmoteWheel.Wheel:SelectGroup(EmoteWheelDB.currentGroup or 1)
		end
	end)

	_G[fontSizeSlider:GetName().."Low"]:SetText("6")
	_G[fontSizeSlider:GetName().."High"]:SetText("30")
	_G[fontSizeSlider:GetName().."Text"]:SetText(EW_L("SETTINGS_FONT_SIZE") .. ": " .. (EmoteWheelConfig.fonts.emoteButtons.size or 12))	
    
    -- Чекбокс показа текста эмоций
    local textCheckbox = CreateFrame("CheckButton", "EmoteWheelTextCheckbox", scrollChild, "OptionsCheckButtonTemplate")
    textCheckbox:SetPoint("TOPLEFT", fontSizeSlider, "BOTTOMLEFT", 0, -15)
    textCheckbox:SetChecked(EmoteWheelDB.showText)
    
    local textText = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    textText:SetPoint("TOPLEFT", textCheckbox, "RIGHT", 5, 5)
    textText:SetText(EW_L("SETTINGS_SHOW_TEXT"))
    
    textCheckbox:SetScript("OnClick", function(self)
        EmoteWheelDB.showText = self:GetChecked()
        EmoteWheel:Print(EW_L("SETTINGS_SHOW_TEXT") .. " " .. (EmoteWheelDB.showText and EW_L("ADDON_ENABLED") or EW_L("ADDON_DISABLED")))
    end)
	
    -- Чекбокс включения горячей клавиши
    local hotkeyCheckbox = CreateFrame("CheckButton", "EmoteWheelHotkeyCheckbox", scrollChild, "OptionsCheckButtonTemplate")
    hotkeyCheckbox:SetPoint("TOPLEFT", textCheckbox, "BOTTOMLEFT", 0, -15)
    hotkeyCheckbox:SetChecked(EmoteWheelDB.enableHotkey)

    local hotkeyText = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    hotkeyText:SetPoint("LEFT", hotkeyCheckbox, "RIGHT", 5, 0)
    hotkeyText:SetText(EW_L("SETTINGS_ENABLE_HOTKEY"))

    hotkeyCheckbox:SetScript("OnClick", function(self)
        EmoteWheelDB.enableHotkey = self:GetChecked()
        EmoteWheel:Print(EW_L("SETTINGS_ENABLE_HOTKEY") .. " " .. (EmoteWheelDB.enableHotkey and EW_L("ADDON_ENABLED") or EW_L("ADDON_DISABLED")))
        -- Перерегистрируем обработчик
        EmoteWheel:RegisterMouseHandler()
    end)	
	
    -- Выбор клавиши для вызова
    local triggerText = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    triggerText:SetPoint("TOPLEFT", hotkeyCheckbox, "BOTTOMLEFT", 0, -15)
    triggerText:SetText(EW_L("SETTINGS_TRIGGER_KEY"))
    
    local triggerDropdown = CreateFrame("Frame", "EmoteWheelTriggerDropdown", scrollChild, "UIDropDownMenuTemplate")
    triggerDropdown:SetPoint("TOPLEFT", triggerText, "BOTTOMLEFT", 0, -10)
    triggerDropdown:SetWidth(120)
    
    UIDropDownMenu_Initialize(triggerDropdown, function(self, level)
        local info = UIDropDownMenu_CreateInfo()
        
        local triggers = {
            {text = EW_L("TRIGGER_SHIFT"), value = "SHIFT"},
            {text = EW_L("TRIGGER_CTRL"), value = "CTRL"},
            {text = EW_L("TRIGGER_ALT"), value = "ALT"},
            {text = EW_L("TRIGGER_NONE"), value = "NONE"}
        }
        
        for i, trigger in ipairs(triggers) do
            info.text = trigger.text
            info.value = trigger.value
            info.func = function(button)
                EmoteWheelDB.triggerKey = button.value
                UIDropDownMenu_SetText(triggerDropdown, trigger.text)
                EmoteWheel:Print(EW_L("SETTINGS_TRIGGER_KEY") .. " " .. trigger.text)
            end
            info.checked = (trigger.value == EmoteWheelDB.triggerKey)
            UIDropDownMenu_AddButton(info)
        end
    end)
    
    -- Устанавливаем начальный текст
    local currentTrigger = EmoteWheelDB.triggerKey or "SHIFT"
    local triggerTextMap = {
        SHIFT = EW_L("TRIGGER_SHIFT"), 
        CTRL = EW_L("TRIGGER_CTRL"), 
        ALT = EW_L("TRIGGER_ALT"), 
        NONE = EW_L("TRIGGER_NONE")
    }
    UIDropDownMenu_SetText(triggerDropdown, triggerTextMap[currentTrigger])	
    
    -- Кнопка просмотра лога
    local logButton = CreateFrame("Button", nil, scrollChild, "UIPanelButtonTemplate")
    logButton:SetPoint("TOPLEFT", triggerDropdown, "BOTTOMLEFT", 0, -15)
    logButton:SetSize(120, 25)
    logButton:SetText(EW_L("BUTTON_VIEW_LOG"))
    logButton:SetScript("OnClick", function()
        self:ToggleLogFrame()
    end)
    
    -- Кнопка тестирования колеса
    local testButton = CreateFrame("Button", nil, scrollChild, "UIPanelButtonTemplate")
    testButton:SetPoint("LEFT", logButton, "RIGHT", 10, 0)
    testButton:SetSize(120, 25)
    testButton:SetText(EW_L("BUTTON_TEST_WHEEL"))
    testButton:SetScript("OnClick", function()
        if EmoteWheel.Wheel and EmoteWheel.Wheel.Show then
            EmoteWheel.Wheel:Show()
        else
            EmoteWheel:Print("Колесо еще не инициализировано")
        end
    end)
    
    -- Кнопка сброса настроек
    local resetButton = CreateFrame("Button", nil, scrollChild, "UIPanelButtonTemplate")
    resetButton:SetPoint("TOPLEFT", logButton, "BOTTOMLEFT", 0, -10)
    resetButton:SetSize(120, 25)
    resetButton:SetText(EW_L("BUTTON_RESET"))
	resetButton:SetScript("OnClick", function()
		EmoteWheelDB = {
			enabled = true,
			currentGroup = 1,
			showText = true,
			closeOnClick = true,
			triggerKey = "SHIFT",
			buttonSize = 50,
			emoteButtonSize = 35,
			showBackground = true,
			enableColors = true,
			hoverGroupSwitch = false,
			showIcons = true,
			enableHotkey = false,
			log = {}
		}
		ReloadUI()
	end)
    
    -- Инструкция по использованию
    local instructionText = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    instructionText:SetPoint("TOPLEFT", resetButton, "BOTTOMLEFT", 0, -20)
    instructionText:SetText(EW_L("INSTRUCTION"))
    instructionText:SetTextColor(0.8, 0.8, 0.8)
    
    -- Создаем фрейм лога
    self:CreateLogFrame()
	
	-- Слайдер размера кнопок групп
	local buttonSizeText = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	buttonSizeText:SetPoint("TOPLEFT", instructionText, "BOTTOMLEFT", 0, -15)
	buttonSizeText:SetText(EW_L("SETTINGS_BUTTON_SIZE"))

	local buttonSizeSlider = CreateFrame("Slider", "EmoteWheelButtonSizeSlider", scrollChild, "OptionsSliderTemplate")
	buttonSizeSlider:SetPoint("TOPLEFT", buttonSizeText, "BOTTOMLEFT", 0, -10)
	buttonSizeSlider:SetWidth(180)
	buttonSizeSlider:SetMinMaxValues(30, 80)
	buttonSizeSlider:SetValueStep(1)
	buttonSizeSlider:SetValue(EmoteWheelDB.buttonSize or 50)
	buttonSizeSlider:SetScript("OnValueChanged", function(self, value)
		value = math.floor(value)
		EmoteWheelDB.buttonSize = value
		_G[self:GetName().."Text"]:SetText(EW_L("SETTINGS_BUTTON_SIZE") .. ": " .. value)
		-- Обновляем колесо
		if EmoteWheel.Wheel and EmoteWheel.Wheel.UpdateButtonSizes then
			EmoteWheel.Wheel:UpdateButtonSizes()
		end
	end)
	
	_G[buttonSizeSlider:GetName().."Low"]:SetText("30")
	_G[buttonSizeSlider:GetName().."High"]:SetText("80")
	_G[buttonSizeSlider:GetName().."Text"]:SetText(EW_L("SETTINGS_BUTTON_SIZE") .. ": " .. (EmoteWheelDB.buttonSize or 50))
	
	-- Слайдер размера кнопок эмоций
	local emoteButtonSizeText = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	emoteButtonSizeText:SetPoint("TOPLEFT", buttonSizeSlider, "BOTTOMLEFT", 0, -15)
	emoteButtonSizeText:SetText(EW_L("SETTINGS_EMOTE_SIZE"))

	local emoteButtonSizeSlider = CreateFrame("Slider", "EmoteWheelEmoteButtonSizeSlider", scrollChild, "OptionsSliderTemplate")
	emoteButtonSizeSlider:SetPoint("TOPLEFT", emoteButtonSizeText, "BOTTOMLEFT", 0, -10)
	emoteButtonSizeSlider:SetWidth(180)
	emoteButtonSizeSlider:SetMinMaxValues(20, 60)
	emoteButtonSizeSlider:SetValueStep(1)
	emoteButtonSizeSlider:SetValue(EmoteWheelDB.emoteButtonSize or 35)
	emoteButtonSizeSlider:SetScript("OnValueChanged", function(self, value)
		value = math.floor(value)
		EmoteWheelDB.emoteButtonSize = value
		_G[self:GetName().."Text"]:SetText(EW_L("SETTINGS_EMOTE_SIZE") .. ": " .. value)
		-- Обновляем колесо
		if EmoteWheel.Wheel and EmoteWheel.Wheel.UpdateButtonSizes then
			EmoteWheel.Wheel:UpdateButtonSizes()
		end
	end)
	
	_G[emoteButtonSizeSlider:GetName().."Low"]:SetText("20")
	_G[emoteButtonSizeSlider:GetName().."High"]:SetText("60")
	_G[emoteButtonSizeSlider:GetName().."Text"]:SetText(EW_L("SETTINGS_EMOTE_SIZE") .. ": " .. (EmoteWheelDB.emoteButtonSize or 35))	
	
	-- Чекбокс фона колеса
	local bgCheckbox = CreateFrame("CheckButton", "EmoteWheelBgCheckbox", scrollChild, "OptionsCheckButtonTemplate")
	bgCheckbox:SetPoint("TOPLEFT", emoteButtonSizeSlider, "BOTTOMLEFT", 0, -15)
	bgCheckbox:SetChecked(EmoteWheelDB.showBackground)

	local bgText = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	bgText:SetPoint("LEFT", bgCheckbox, "RIGHT", 5, 0)
	bgText:SetText(EW_L("SETTINGS_SHOW_BG"))

	bgCheckbox:SetScript("OnClick", function(self)
		EmoteWheelDB.showBackground = self:GetChecked()
		-- Обновляем отображение фона
		if EmoteWheel.Wheel and EmoteWheel.Wheel.UpdateBackground then
			EmoteWheel.Wheel:UpdateBackground()
		end
	end)	
	
	-- Чекбокс цветового оформления
	local colorsCheckbox = CreateFrame("CheckButton", "EmoteWheelColorsCheckbox", scrollChild, "OptionsCheckButtonTemplate")
	colorsCheckbox:SetPoint("TOPLEFT", bgCheckbox, "BOTTOMLEFT", 0, -15)
	colorsCheckbox:SetChecked(EmoteWheelDB.enableColors)

	local colorsText = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	colorsText:SetPoint("LEFT", colorsCheckbox, "RIGHT", 5, 0)
	colorsText:SetText(EW_L("SETTINGS_ENABLE_COLORS"))

	colorsCheckbox:SetScript("OnClick", function(self)
		EmoteWheelDB.enableColors = self:GetChecked()
		-- Обновляем все визуальные элементы
		if EmoteWheel.Wheel and EmoteWheel.Wheel.UpdateColors then
			EmoteWheel.Wheel:UpdateColors()
		end
	end)	
	
	-- Чекбокс смены группы по наведению
	local hoverCheckbox = CreateFrame("CheckButton", "EmoteWheelHoverCheckbox", scrollChild, "OptionsCheckButtonTemplate")
	hoverCheckbox:SetPoint("TOPLEFT", colorsCheckbox, "BOTTOMLEFT", 0, -15)
	hoverCheckbox:SetChecked(EmoteWheelDB.hoverGroupSwitch)

	local hoverText = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	hoverText:SetPoint("LEFT", hoverCheckbox, "RIGHT", 5, 0)
	hoverText:SetText(EW_L("SETTINGS_HOVER_SWITCH"))

	hoverCheckbox:SetScript("OnClick", function(self)
		EmoteWheelDB.hoverGroupSwitch = self:GetChecked()
		EmoteWheel:Print(EW_L("SETTINGS_HOVER_SWITCH") .. " " .. (EmoteWheelDB.hoverGroupSwitch and EW_L("ADDON_ENABLED") or EW_L("ADDON_DISABLED")))
	end)	
	
	-- Чекбокс показа иконок групп
	local iconsCheckbox = CreateFrame("CheckButton", "EmoteWheelIconsCheckbox", scrollChild, "OptionsCheckButtonTemplate")
	iconsCheckbox:SetPoint("TOPLEFT", hoverCheckbox, "BOTTOMLEFT", 0, -15)
	iconsCheckbox:SetChecked(EmoteWheelDB.showIcons)

	local iconsText = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	iconsText:SetPoint("LEFT", iconsCheckbox, "RIGHT", 5, 0)
	iconsText:SetText(EW_L("SETTINGS_SHOW_ICONS"))

	iconsCheckbox:SetScript("OnClick", function(self)
		EmoteWheelDB.showIcons = self:GetChecked()
		-- Обновляем отображение кнопок групп
		if EmoteWheel.Wheel and EmoteWheel.Wheel.UpdateGroupIcons then
			EmoteWheel.Wheel:UpdateGroupIcons()
		end
	end)
	
	-- НОВОЕ: Выбор иконок для групп
	local groupIconsText = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	groupIconsText:SetPoint("TOPLEFT", iconsCheckbox, "BOTTOMLEFT", 0, -20)
	groupIconsText:SetText("Выбор иконок для групп:")
	
	-- Создаем кнопки выбора иконок для каждой группы
	self.groupIconButtons = {}
	
	-- ИСПРАВЛЕНО: Правильное расположение в 2 столбика с одинаковым расстоянием
	for i = 1, (EmoteWheelConfig.maxGroups or 8) do
		local groupIconButton = CreateFrame("Button", "EmoteWheelGroupIconBtn"..i, scrollChild, "UIPanelButtonTemplate")
		groupIconButton:SetSize(120, 30)
		
		-- Вычисляем позицию для 2 столбиков
		local col = (i - 1) % 2  -- 0 или 1
		local row = math.floor((i - 1) / 2) -- 0, 1, 2, 3
		
		local xOffset = col * 130  -- 130 = ширина кнопки (120) + отступ (10)
		local yOffset = -row * 35  -- 35 = высота кнопки (30) + отступ (5)
		
		-- Все кнопки позиционируем от groupIconsText
		groupIconButton:SetPoint("TOPLEFT", groupIconsText, "BOTTOMLEFT", xOffset, yOffset - 10)
		
		local groupData = EmoteWheelData.groups[i]
		local groupName = groupData and groupData.name or ("Группа "..i)
		groupIconButton:SetText(groupName)
		groupIconButton.groupIndex = i
		
		-- Создаем текстуру для предпросмотра иконки
		local iconPreview = groupIconButton:CreateTexture(nil, "OVERLAY")
		iconPreview:SetSize(20, 20)
		iconPreview:SetPoint("LEFT", groupIconButton, "LEFT", 5, 0)
		
		-- ИСПРАВЛЕНО: Безопасное обращение к groupIcons
		local iconPath
		if EmoteWheelDB.groupIcons and EmoteWheelDB.groupIcons[i] then
			iconPath = EmoteWheelIcons:GetIconPath(EmoteWheelDB.groupIcons[i])
		else
			iconPath = EmoteWheelConfig.groupIcons[i] or "Interface\\Icons\\INV_Misc_QuestionMark"
		end
		iconPreview:SetTexture(iconPath)
		groupIconButton.iconPreview = iconPreview
		
		-- Текст кнопки смещаем вправо от иконки
		local buttonText = groupIconButton:GetFontString()
		buttonText:ClearAllPoints()
		buttonText:SetPoint("LEFT", iconPreview, "RIGHT", 5, 0)
		buttonText:SetPoint("RIGHT", groupIconButton, "RIGHT", -5, 0)
		buttonText:SetJustifyH("LEFT")
		
		groupIconButton:SetScript("OnClick", function(self)
			EmoteWheel:SelectGroupIcon(self.groupIndex)
		end)
		
		-- Добавляем тултип
		groupIconButton:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText("Изменить иконку для " .. groupName)
			GameTooltip:AddLine("Текущая иконка: " .. ((EmoteWheelDB.groupIcons and EmoteWheelDB.groupIcons[i]) and "Пользовательская" or "По умолчанию"), 1, 1, 1)
			GameTooltip:Show()
		end)
		
		groupIconButton:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)
		
		self.groupIconButtons[i] = groupIconButton
	end
	
	-- Кнопка сброса всех иконок
	local resetIconsButton = CreateFrame("Button", nil, scrollChild, "UIPanelButtonTemplate")
	-- ИСПРАВЛЕНО: Правильное расположение кнопки сброса под последней строкой
	local lastButtonInColumn = self.groupIconButtons[7] or self.groupIconButtons[#self.groupIconButtons]
	resetIconsButton:SetPoint("TOPLEFT", lastButtonInColumn, "BOTTOMLEFT", 0, -15)
	resetIconsButton:SetSize(140, 25)
	resetIconsButton:SetText("Сбросить все иконки")
	resetIconsButton:SetScript("OnClick", function()
		EmoteWheelDB.groupIcons = {}
		EmoteWheel:Print("Все иконки групп сброшены к значениям по умолчанию")
		-- Обновляем предпросмотр иконок
		for i, button in ipairs(self.groupIconButtons) do
			local defaultIcon = EmoteWheelConfig.groupIcons[i] or "Interface\\Icons\\INV_Misc_QuestionMark"
			button.iconPreview:SetTexture(defaultIcon)
		end
		-- Обновляем колесо
		if EmoteWheel.Wheel and EmoteWheel.Wheel.UpdateGroupIcons then
			EmoteWheel.Wheel:UpdateGroupIcons()
		end
	end)
	
    -- Вызываем после создания всех элементов
    UpdateScrollChildHeight()	
	
    InterfaceOptions_AddCategory(self.optionsFrame)	
	
end

-- НОВАЯ ФУНКЦИЯ: Выбор иконки для группы (с прокруткой и apply)
function EmoteWheel:SelectGroupIcon(groupIndex)
    if not groupIndex then return end
    
    -- Создаем фрейм выбора иконки
    local iconSelector = CreateFrame("Frame", "EmoteWheelIconSelector", UIParent)
    iconSelector:SetSize(500, 600)
    iconSelector:SetPoint("CENTER")
    iconSelector:SetFrameStrata("DIALOG")
    iconSelector:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    })
    iconSelector:SetMovable(true)
    iconSelector:EnableMouse(true)
    iconSelector:RegisterForDrag("LeftButton")
    iconSelector:SetScript("OnDragStart", iconSelector.StartMoving)
    iconSelector:SetScript("OnDragStop", iconSelector.StopMovingOrSizing)

    -- Заголовок
    local title = iconSelector:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetPoint("TOP", 0, -15)
    title:SetText("Выбор иконки для группы " .. groupIndex)
    
    -- Поле поиска
    local searchBox = CreateFrame("EditBox", "EmoteWheelIconSearch", iconSelector, "InputBoxTemplate")
    searchBox:SetSize(300, 20)
    searchBox:SetPoint("TOP", 0, -40)
    searchBox:SetAutoFocus(false)
    
    local searchLabel = iconSelector:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    searchLabel:SetPoint("BOTTOM", searchBox, "TOP", 0, 5)
    searchLabel:SetText("Поиск иконок:")

    -- Скроллируемый фрейм для иконок
    local scrollFrame = CreateFrame("ScrollFrame", "EmoteWheelIconScroll", iconSelector, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 20, -70)
    scrollFrame:SetPoint("BOTTOMRIGHT", -40, 50)
    
    local scrollChild = CreateFrame("Frame", "EmoteWheelIconScrollChild", scrollFrame)
    scrollChild:SetWidth(scrollFrame:GetWidth() - 20)
    scrollChild:SetHeight(1)
    scrollFrame:SetScrollChild(scrollChild)

    -- Получаем скролл-бар
    local scrollBar = _G[scrollFrame:GetName() .. "ScrollBar"]

    -- Кнопки действий
    local cancelButton = CreateFrame("Button", nil, iconSelector, "UIPanelButtonTemplate")
    cancelButton:SetSize(100, 25)
    cancelButton:SetPoint("BOTTOMRIGHT", -10, 10)
    cancelButton:SetText("Отмена")
    cancelButton:SetScript("OnClick", function() 
        iconSelector:Hide() 
    end)
    
    local defaultButton = CreateFrame("Button", nil, iconSelector, "UIPanelButtonTemplate")
    defaultButton:SetSize(120, 25)
    defaultButton:SetPoint("BOTTOM", 0, 10)
    defaultButton:SetText("По умолчанию")
    defaultButton:SetScript("OnClick", function()
        if not EmoteWheelDB.groupIcons then EmoteWheelDB.groupIcons = {} end
        EmoteWheelDB.groupIcons[groupIndex] = nil
        EmoteWheel:UpdateGroupIconButton(groupIndex)
        -- ПОКАЗЫВАЕМ кнопку "Применить" при сбросе
        applyButton:Show()
        EmoteWheel:Print("Иконка сброшена. Нажмите 'Применить' для обновления колеса.")
    end)

    -- Кнопка применения (скрытая по умолчанию)
    local applyButton = CreateFrame("Button", nil, iconSelector, "UIPanelButtonTemplate")
    applyButton:SetSize(120, 25)
    applyButton:SetPoint("BOTTOMLEFT", 10, 10)
    applyButton:SetText("Применить")
    applyButton:SetScript("OnClick", function()
        -- Принудительно обновляем все иконки в колесе
        if EmoteWheel.Wheel and EmoteWheel.Wheel.UpdateGroupIcons then
            EmoteWheel.Wheel:UpdateGroupIcons()
            EmoteWheel:Print("Иконки применены к колесу")
        end
        iconSelector:Hide()
    end)
    applyButton:Hide() -- Изначально скрыта

    -- Таблица для хранения кнопок иконок
    local iconButtons = {}
    
    -- Функция обновления списка иконок (с прокруткой)
    local function UpdateIconList(searchTerm)
        local icons
        if searchTerm and searchTerm ~= "" then
            icons = EmoteWheelIcons:SearchIcons(searchTerm)
        else
            icons = EmoteWheelIcons:GetAllIcons()
        end
        
        -- УДАЛЯЕМ все старые кнопки
        for i, btn in ipairs(iconButtons) do
            if btn then
                btn:Hide()
                btn:SetParent(nil)
            end
        end
        iconButtons = {}
        
        -- Очищаем старый текст количества
        if iconSelector.countText then
            iconSelector.countText:Hide()
        end
        
        -- СОЗДАЕМ новые кнопки (13 иконок в строке)
        local iconSize = 32
        local iconsPerRow = 13  -- Увеличили до 13
        local spacing = 1
        
        for i, iconData in ipairs(icons) do
            local row = math.floor((i-1) / iconsPerRow)
            local col = (i-1) % iconsPerRow
            
            local iconButton = CreateFrame("Button", nil, scrollChild)
            iconButton:SetSize(iconSize, iconSize)
            iconButton:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 
                col * (iconSize + spacing), 
                -row * (iconSize + spacing))
            
            -- Иконка
            local iconTex = iconButton:CreateTexture(nil, "ARTWORK")
            iconTex:SetAllPoints(true)
            iconTex:SetTexture(iconData.path)
            
            -- Подсветка
            local highlight = iconButton:CreateTexture(nil, "HIGHLIGHT")
            highlight:SetAllPoints(true)
            highlight:SetTexture("Interface\\Buttons\\UI-Common-MouseHilight")
            highlight:SetBlendMode("ADD")
            
            -- Рамка при наведении
            local border = iconButton:CreateTexture(nil, "BORDER")
            border:SetAllPoints(true)
            border:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
            border:SetBlendMode("ADD")
            border:SetAlpha(0)
            iconButton.border = border
            
            -- Обработчик клика
            iconButton:SetScript("OnClick", function()
                if not EmoteWheelDB.groupIcons then EmoteWheelDB.groupIcons = {} end
                EmoteWheelDB.groupIcons[groupIndex] = iconData.name
                
                -- Обновляем предпросмотр в настройках
                EmoteWheel:UpdateGroupIconButton(groupIndex)
                
                -- ПОКАЗЫВАЕМ кнопку "Применить"
                applyButton:Show()
                
                EmoteWheel:Print("Иконка выбрана. Нажмите 'Применить' для обновления колеса.")
            end)
            
            -- Обработчик наведения
            iconButton:SetScript("OnEnter", function()
                border:SetAlpha(1)
                GameTooltip:SetOwner(iconButton, "ANCHOR_RIGHT")
                GameTooltip:SetText(iconData.name)
                GameTooltip:Show()
            end)
            
            iconButton:SetScript("OnLeave", function()
                border:SetAlpha(0)
                GameTooltip:Hide()
            end)
            
            table.insert(iconButtons, iconButton)
        end
        
        -- Обновляем высоту скролл-части
        local totalRows = math.ceil(#icons / iconsPerRow)
        local neededHeight = totalRows * (iconSize + spacing) + 10
        scrollChild:SetHeight(math.max(neededHeight, 1))
        
        -- Обновляем скролл
        scrollFrame:UpdateScrollChildRect()
        scrollFrame:SetVerticalScroll(0)
        
        if scrollBar then
            local maxValue = math.max(0, neededHeight - scrollFrame:GetHeight())
            scrollBar:SetMinMaxValues(0, maxValue)
            scrollBar:SetValue(0)
        end
        
        -- Информация о количестве
        local countText = iconSelector:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        countText:SetPoint("BOTTOM", scrollFrame, "TOP", 0, 5)
        countText:SetText("Найдено иконок: " .. #icons)
        countText:SetTextColor(0.8, 0.8, 0.8)
        
        iconSelector.countText = countText
    end
    
    -- Обработчик поиска
    searchBox:SetScript("OnTextChanged", function(self)
        UpdateIconList(self:GetText())
    end)
    
    -- Обработчик закрытия фрейма
    iconSelector:SetScript("OnHide", function()
        -- Очищаем кнопки при закрытии
        for i, btn in ipairs(iconButtons) do
            if btn then
                btn:Hide()
                btn:SetParent(nil)
            end
        end
        iconButtons = {}
    end)
    
    -- Инициализация
    searchBox:SetText("")
    UpdateIconList("")
    iconSelector:Show()
end

-- Функция обновления кнопки выбора иконки
function EmoteWheel:UpdateGroupIconButton(groupIndex)
    local button = self.groupIconButtons[groupIndex]
    if not button then return end
    
    -- Обновляем иконку в настройках
    local iconPath
    if EmoteWheelDB.groupIcons and EmoteWheelDB.groupIcons[groupIndex] then
        iconPath = EmoteWheelIcons:GetIconPath(EmoteWheelDB.groupIcons[groupIndex])
    else
        iconPath = EmoteWheelConfig.groupIcons[groupIndex] or "Interface\\Icons\\INV_Misc_QuestionMark"
    end
    
    if button.iconPreview then
        button.iconPreview:SetTexture(iconPath)
    end
    
    -- ОБНОВЛЯЕМ ИКОНКУ В КОЛЕСЕ НА ЛЕТУ
    if EmoteWheel.Wheel and EmoteWheel.Wheel.groupButtons then
        local wheelButton = EmoteWheel.Wheel.groupButtons[groupIndex]
        if wheelButton and wheelButton.icon then
            wheelButton.icon:SetTexture(iconPath)
            EmoteWheel:AddToLog("Иконка группы " .. groupIndex .. " обновлена на лету")
        end
    end
end


-- Фрейм лога (обновлен с локализацией)
function EmoteWheel:CreateLogFrame()
    self.logFrame = CreateFrame("Frame", "EmoteWheelLogFrame", UIParent)
    self.logFrame:SetSize(400, 300)
    self.logFrame:SetPoint("CENTER")
    self.logFrame:SetFrameStrata("DIALOG")
    self.logFrame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, 
        tileSize = 32, 
        edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    })
    self.logFrame:Hide()
    self.logFrame:SetMovable(true)
    self.logFrame:EnableMouse(true)
    self.logFrame:RegisterForDrag("LeftButton")
    self.logFrame:SetScript("OnDragStart", self.logFrame.StartMoving)
    self.logFrame:SetScript("OnDragStop", self.logFrame.StopMovingOrSizing)
    
    -- Заголовок лога
    local title = self.logFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetPoint("TOP", 0, -15)
    title:SetText(EW_L("LOG_TITLE"))
    
    -- Текст лога
    self.logContent = self.logFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    self.logContent:SetPoint("TOPLEFT", 20, -40)
    self.logContent:SetPoint("BOTTOMRIGHT", -20, 40)
    self.logContent:SetJustifyH("LEFT")
    self.logContent:SetJustifyV("TOP")
    
    -- Кнопка закрытия
    local closeButton = CreateFrame("Button", nil, self.logFrame, "UIPanelButtonTemplate")
    closeButton:SetPoint("BOTTOM", 0, 15)
    closeButton:SetSize(100, 25)
    closeButton:SetText(CLOSE)
    closeButton:SetScript("OnClick", function()
        self.logFrame:Hide()
    end)
    
    -- Кнопка очистки лога
    local clearButton = CreateFrame("Button", nil, self.logFrame, "UIPanelButtonTemplate")
    clearButton:SetPoint("BOTTOM", 0, 45)
    clearButton:SetSize(100, 25)
    clearButton:SetText(EW_L("LOG_CLEAR"))
    clearButton:SetScript("OnClick", function()
        EmoteWheelDB.log = {}
        self:UpdateLogDisplay()
    end)
end

function EmoteWheel:UpdateLogDisplay()
    if not self.logContent then return end
    
    local logText = EW_L("LOG_TITLE") .. ":\n\n"
    if EmoteWheelDB.log and #EmoteWheelDB.log > 0 then
        for i, entry in ipairs(EmoteWheelDB.log) do
            logText = logText .. entry .. "\n"
        end
    else
        logText = logText .. EW_L("LOG_EMPTY")
    end
    
    self.logContent:SetText(logText)
end

function EmoteWheel:ToggleLogFrame()
    if self.logFrame:IsVisible() then
        self.logFrame:Hide()
    else
        self:UpdateLogDisplay()
        self.logFrame:Show()
    end
end