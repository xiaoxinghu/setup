-- A global variable for the Hyper Mode
hyper = hs.hotkey.modal.new({}, 'F17')
hs.window.animationDuration = 0 -- disable animations

-- Enter Hyper Mode when F18 (Hyper/Capslock) is pressed
function enterHyperMode()
  hyper.triggered = false
  hyper:enter()
end

-- Leave Hyper Mode when F18 (Hyper/Capslock) is pressed,
-- send ESCAPE if no other keys are pressed.
function exitHyperMode()
  hyper:exit()
  if not hyper.triggered then
    hs.eventtap.keyStroke({}, 'ESCAPE')
  end
end

-- Bind the Hyper key
f18 = hs.hotkey.bind({}, 'F18', enterHyperMode, exitHyperMode)

hyper:bind({}, 'u', function()
    hs.eventtap.keyStroke({'cmd','alt','shift','ctrl'}, 'u')
    hyper.triggered = true
end)

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
