--[[
    Полная база данных эмоций и макросов для WoW 3.3.5a
    Версия: 2.0.0
]]

EmoteWheelAllEmotes = {
    -- Основные эмоции
    {command = "agree", name = "Согласиться", type = "emote"},
    {command = "amaze", name = "Восхищение", type = "emote"},
    {command = "angry", name = "Злость", type = "emote"},
    {command = "apologize", name = "Извинение", type = "emote"},
    {command = "applaud", name = "Аплодисменты", type = "emote"},
    {command = "bashful", name = "Смущение", type = "emote"},
    {command = "beckon", name = "Подозвать", type = "emote"},
    {command = "beg", name = "Умолять", type = "emote"},
    {command = "bite", name = "Укусить", type = "emote"},
    {command = "blink", name = "Моргнуть", type = "emote"},
    {command = "blush", name = "Краснеть", type = "emote"},
    {command = "bonk", name = "Шлепок", type = "emote"},
    {command = "bored", name = "Скука", type = "emote"},
    {command = "bow", name = "Поклон", type = "emote"},
    {command = "brb", name = "Скоро вернусь", type = "emote"},
    {command = "burp", name = "Отрыжка", type = "emote"},
    
    -- Боевые эмоции
    {command = "charge", name = "В атаку", type = "emote"},
    {command = "cheer", name = "Радоваться", type = "emote"},
    {command = "chicken", name = "Цыпленок", type = "emote"},
    {command = "chuckle", name = "Усмешка", type = "emote"},
    {command = "clap", name = "Хлопать", type = "emote"},
    {command = "comfort", name = "Утешить", type = "emote"},
    {command = "commend", name = "Похвалить", type = "emote"},
    {command = "confused", name = "Растерянность", type = "emote"},
    {command = "congratulate", name = "Поздравлять", type = "emote"},
    {command = "cough", name = "Кашель", type = "emote"},
    {command = "cower", name = "Устрашиться", type = "emote"},
    {command = "crack", name = "Хруст", type = "emote"},
    {command = "cringe", name = "Съежиться", type = "emote"},
    {command = "cry", name = "Плакать", type = "emote"},
    {command = "curious", name = "Любопытство", type = "emote"},
    {command = "curtsey", name = "Реверанс", type = "emote"},
    
    -- Действия
    {command = "dance", name = "Танец", type = "emote"},
    {command = "drink", name = "Выпить", type = "emote"},
    {command = "eat", name = "Есть", type = "emote"},
    {command = "eye", name = "Смотреть", type = "emote"},
    {command = "fart", name = "Пердеть", type = "emote"},
    {command = "fidget", name = "Ерзать", type = "emote"},
    {command = "flex", name = "Мускулы", type = "emote"},
    {command = "flirt", name = "Флирт", type = "emote"},
    {command = "flop", name = "Шлепнуться", type = "emote"},
    {command = "followme", name = "За мной", type = "emote"},
    {command = "gasp", name = "Вздох", type = "emote"},
    {command = "gaze", name = "Взор", type = "emote"},
    {command = "giggle", name = "Хихикать", type = "emote"},
    {command = "glare", name = "Взгляд", type = "emote"},
    
    -- Звуки
    {command = "golfclap", name = "Сарказм", type = "emote"},
    {command = "greet", name = "Привет", type = "emote"},
    {command = "grin", name = "Ухмылка", type = "emote"},
    {command = "groan", name = "Стон", type = "emote"},
    {command = "grovel", name = "Ползать", type = "emote"},
    {command = "growl", name = "Рык", type = "emote"},
    {command = "guffaw", name = "Хохот", type = "emote"},
    {command = "hail", name = "Приветствие", type = "emote"},
    {command = "happy", name = "Счастье", type = "emote"},
    {command = "hello", name = "Здравствуй", type = "emote"},
    {command = "hi", name = "Привет", type = "emote"},
    {command = "hug", name = "Обнять", type = "emote"},
    {command = "hungry", name = "Голод", type = "emote"},
    {command = "kiss", name = "Поцелуй", type = "emote"},
    
    -- Реакции
    {command = "kneel", name = "Стать на колени", type = "emote"},
    {command = "laugh", name = "Смех", type = "emote"},
    {command = "lay", name = "Лечь", type = "emote"},
    {command = "massage", name = "Массаж", type = "emote"},
    {command = "moan", name = "Стон", type = "emote"},
    {command = "moon", name = "Луна", type = "emote"},
    {command = "mourn", name = "Скорбеть", type = "emote"},
    {command = "no", name = "Нет", type = "emote"},
    {command = "nod", name = "Да", type = "emote"},
    {command = "nosepick", name = "Ковырять в носу", type = "emote"},
    {command = "panic", name = "Паника", type = "emote"},
    {command = "peer", name = "Вглядываться", type = "emote"},
    {command = "plead", name = "Умолять", type = "emote"},
    {command = "point", name = "Указать", type = "emote"},
    
    -- Специальные
    {command = "pounce", name = "Наброситься", type = "emote"},
    {command = "praise", name = "Хвала", type = "emote"},
    {command = "pray", name = "Молиться", type = "emote"},
    {command = "purr", name = "Мурлыкать", type = "emote"},
    {command = "puzzled", name = "Озадаченность", type = "emote"},
    {command = "raise", name = "Поднять", type = "emote"},
    {command = "rasp", name = "Насмешка", type = "emote"},
    {command = "ready", name = "Готовность", type = "emote"},
    {command = "roar", name = "Рев", type = "emote"},
    {command = "rofl", name = "Ржать", type = "emote"},
    {command = "rude", name = "Грубость", type = "emote"},
    {command = "salute", name = "Салют", type = "emote"},
    {command = "scratch", name = "Почесаться", type = "emote"},
    {command = "sexy", name = "Сексуальный", type = "emote"},
    
    -- Завершающие
    {command = "shake", name = "Трясти", type = "emote"},
    {command = "shimmy", name = "Трясти бедрами", type = "emote"},
    {command = "shiver", name = "Дрожать", type = "emote"},
    {command = "shoo", name = "Отстань", type = "emote"},
    {command = "shrug", name = "Пожать плечами", type = "emote"},
    {command = "shy", name = "Стеснение", type = "emote"},
    {command = "sigh", name = "Вздох", type = "emote"},
    {command = "signal", name = "Сигнал", type = "emote"},
    {command = "silence", name = "Тишина", type = "emote"},
    {command = "sing", name = "Петь", type = "emote"},
    {command = "slap", name = "Пощечина", type = "emote"},
    {command = "sleep", name = "Спать", type = "emote"},
    {command = "smell", name = "Нюхать", type = "emote"},
    {command = "smile", name = "Улыбка", type = "emote"},
    {command = "smirk", name = "Усмешка", type = "emote"},
    {command = "snarl", name = "Рычание", type = "emote"},
    {command = "snicker", name = "Хихикать", type = "emote"},
    {command = "sniff", name = "Нюхать", type = "emote"},
    {command = "snub", name = "Пренебрежение", type = "emote"},
    {command = "soothe", name = "Успокоить", type = "emote"},
    {command = "spit", name = "Плевать", type = "emote"},
    {command = "stare", name = "Пялиться", type = "emote"},
    {command = "stink", name = "Вонять", type = "emote"},
    {command = "surprised", name = "Удивление", type = "emote"},
    {command = "surrender", name = "Сдаться", type = "emote"},
    {command = "talk", name = "Разговор", type = "emote"},
    {command = "talkex", name = "Возбужденный разговор", type = "emote"},
    {command = "talkq", name = "Вопрос", type = "emote"},
    {command = "tap", name = "Постучать", type = "emote"},
    {command = "taunt", name = "Насмешка", type = "emote"},
    {command = "tease", name = "Дразнить", type = "emote"},
    {command = "thank", name = "Благодарить", type = "emote"},
    {command = "threaten", name = "Угроза", type = "emote"},
    {command = "tickle", name = "Щекотка", type = "emote"},
    {command = "tired", name = "Усталость", type = "emote"},
    {command = "victory", name = "Победа", type = "emote"},
    {command = "volunteer", name = "Волонтер", type = "emote"},
    {command = "wave", name = "Привет", type = "emote"},
    {command = "welcome", name = "Добро пожаловать", type = "emote"},
    {command = "whine", name = "Нытье", type = "emote"},
    {command = "whistle", name = "Свист", type = "emote"},
    {command = "work", name = "Работа", type = "emote"},
    {command = "yawn", name = "Зевота", type = "emote"},
    {command = "yell", name = "Крик", type = "emote"},

    -- Макросы (примеры)
    {command = "/cast Рывок", name = "Рывок", type = "macro"},
    {command = "/cast Огненный шар", name = "Огненный шар", type = "macro"},
    {command = "/say Привет всем!", name = "Сказать Привет", type = "macro"},
    {command = "/dance", name = "Танец (макрос)", type = "macro"},
    {command = "/follow", name = "Следовать", type = "macro"},
    {command = "/train", name = "Тренировка", type = "macro"}
}

-- Функции для работы с эмоциями
function EmoteWheelAllEmotes:SearchEmotes(searchTerm)
    local results = {}
    searchTerm = searchTerm:lower()
    
    for i, emote in ipairs(self) do
        if emote.name:lower():find(searchTerm, 1, true) or 
           emote.command:lower():find(searchTerm, 1, true) then
            table.insert(results, emote)
        end
    end
    
    return results
end

function EmoteWheelAllEmotes:GetByCommand(cmd)
    for i, emote in ipairs(self) do
        if emote.command == cmd then
            return emote
        end
    end
    return nil
end