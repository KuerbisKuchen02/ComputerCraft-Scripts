rednet.open("left")

rednet.host("mobfarm", "turtle")

while true do
    local id, message = rednet.receive("mobfarm")
    print(("Computer %d sent message %s"):format(id, message))
    if message == "ping" then
        sleep(1)
        print("Sending pong")
        rednet.send(id, turtle.getSelectedSlot(), "mobfarm")
    elseif type(message) == "number" then
        print("Selecting: "..message)
        turtle.suckDown()
        turtle.select(message)
        turtle.dropDown()
    end
end
