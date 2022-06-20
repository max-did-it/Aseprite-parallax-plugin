local sprite = app.activeSprite
local frames_count = #(sprite.frames)

Dlg = Dialog("Easy parallax")
Dlg:label { id = "debug", label = "Debug output", text = tostring(frames_count) }
Dlg:slider { id = "frameCount", label = "Timeline size", min = frames_count, max = frames_count + sprite.width,
  value = frames_count }
Dlg:slider { id = "speed", label = "Speed (px):", min = 1, max = sprite.width, value = 1 }
Dlg:button { id = "leftBtn", text = "move left" }
Dlg:button { id = "rigthBtn", text = "move right" }
Dlg:show()

function moveSprite(direction)
  local firstFrame = app.activeFrame
  local speed = Dlg.data.speed
  if direction == "left" then
    speed = -speed
  end
  local layer = app.activeLayer
  local image = layer:cel(firstFrame.frameNumber).image
  for frame_inx = firstFrame.frameNumber + 1, Dlg.data.frameCount do
    fillFrame(layer, frame_inx, image, speed)
  end
  app.activeCel = layer:cel(1)
end

function fillFrame(layer, frame, image, speed)
  if #(sprite.frames) < (Dlg.data.frameCount) then
    sprite:newEmptyFrame()
  end
  local localSpeed = speed * (frame - 1)

  local newCelPos = Point(0, image.cel.position.y)

  local newImg = Image(sprite.width + math.abs(localSpeed), image.height)

  local newCoords1 = Point(image.cel.position.x + localSpeed, 0)
  local newCoords2 = Point(image.width + localSpeed, 0)

  newImg:drawImage(image, newCoords1)
  newImg:drawImage(image, newCoords2)

  sprite:newCel(layer, frame, newImg, newCelPos)
end

function moveLeft()
  return moveSprite("left")
end

function moveRight()
  return moveSprite("rigth")
end

if Dlg.data.leftBtn then
  app.transaction(moveLeft)
elseif Dlg.data.rigthBtn then
  app.transaction(moveRight)
end
