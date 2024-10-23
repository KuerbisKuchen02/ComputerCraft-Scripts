local m = peripheral.find("monitor") or error("No monitor found")
local buttons = {}

local width, height = m.getSize()
local spacing = 2
local button_height = 3
local row_cnt = height / (button_height + 1)

local function drawButton(x, y, width, height, text, toggle)
    m.setCursorPos(x, y)
    if toggle then
        m.setBackgroundColor(colors.lime)
    else
        m.setBackgroundColor(colors.red)
    end
    for i = 0, height - 1 do
        m.setCursorPos(x, y + i)
        m.write(string.rep(" ", width))
    end
    if width < #text then
        text = text:sub(1, width - 2)
    end
    m.setCursorPos(x + math.floor(width / 2 - #text / 2), y + math.floor(height / 2))
    m.write(text)
    m.setBackgroundColor(colors.black)
end

local function addButton(text, func)
    table.insert(buttons, {text = text, func = func})
end

local function calc(i)
    local row = (i - 1) % row_cnt
    local col = math.floor((i - 1) / row_cnt)
    local col_cnt = math.ceil(#buttons / row_cnt)
    local button_width = math.floor((width - (spacing * col_cnt)) / col_cnt)
    return row, col, button_width
end

local function draw()
    for i, button in ipairs(buttons) do
        local row, col, button_width = calc(i)
        drawButton(2 + col * (button_width + spacing), 2 + row * (button_height + 1), 
        button_width, button_height, button.text, false)
    end
end

local function toggleButton(i)
    local button = buttons[i]
    local row, col, button_width = calc(i)
    draw()
    drawButton(2 + col * (button_width + spacing),
               2 + row * (button_height + 1),
               button_width, button_height, button.text,
               true)
end

local function click(x, y)
    for i, button in ipairs(buttons) do
        local row, col, button_width = calc(i)
        if x >= 2 + col * (button_width + spacing) 
            and x <= 2 + col * (button_width + spacing) + button_width
            and y >= 2 + row * (button_height + 1)
            and y <= 2 + row * (button_height + 1) + button_height then

            button.func(i)
            draw()
            drawButton(2 + math.floor((i - 1) / row_cnt) * (button_width + spacing),
                                      2 + (i - 1) % row_cnt * (button_height + 1),
                                      button_width, button_height, button.text,
                                      true)
        end
    end
end

local function pull()
    while true do
        local event, side, x, y = os.pullEvent("monitor_touch")
        click(x, y)
    end
end

return {
    addButton = addButton,
    draw = draw,
    pull = pull,
    toggleButton = toggleButton
}

