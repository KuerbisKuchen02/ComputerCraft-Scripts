local button = require "button"

local monitor = peripheral.find("monitor") or error("No monitor found")

rednet.open("top")
rednet.host("mobfarm", "computer")

local turtle_id  = rednet.lookup("mobfarm", "turtle")
print(("Turtle ID: %d"):format(turtle_id))

rednet.send(turtle_id, "ping", "mobfarm")

local id, message = rednet.receive("mobfarm")
print(("Turtle %d sent message %s"):format(id, message))

if not type(message) == "number" then
    rednet.unhost("mobfarm")
    rednet.close("top")
    error("Turtle did not respond with slot number")
end

monitor.clear()
monitor.setTextScale(0.5)
monitor.setBackgroundColor(colors.black)
monitor.setTextColor(colors.white)
monitor.setCursorPos(1, 1)

local function selectSlot(slot)
    print("Selecting: "..slot)
    rednet.send(turtle_id, slot, "mobfarm")
end

button.addButton("Enderman", selectSlot)
button.addButton("Chicken", selectSlot)
button.addButton("Pigman", selectSlot)

button.draw()
button.toggleButton(message)
button.pull()

rednet.unhost("mobfarm")
rednet.close("top")