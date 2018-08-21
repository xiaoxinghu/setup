hyper:bind({}, "return", function()
    local win = hs.window.frontmostWindow()
    win:setFullscreen(not win:isFullscreen())
    hyper.triggered = true
end)

hyper:bind({}, "Left", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w / 3
    f.h = max.h
    win:setFrame(f)
end)

hyper:bind({}, "Right", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w / 3 * 2)
    f.y = max.y
    f.w = max.w / 3
    f.h = max.h
    win:setFrame(f)
end)
