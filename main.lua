-------------------------------------------------------------------------------
--
--
--
--
--
-------------------------------------------------------------------------------

require "textureloader"
require "animation"
require "rect"

MOAISim.openWindow("Monster And Coins", 320, 480)

viewport = MOAIViewport.new()
viewport:setSize(320, 480)
viewport:setScale(320, -480)
viewport:setOffset(-1, 1)

layer = MOAILayer2D.new()
layer:setViewport(viewport)
MOAISim.pushRenderPass(layer)

-- world
local worldQuad = MOAIGfxQuad2D.new()
worldQuad:setTexture("assets/world/background.png")
worldQuad:setRect(0, 0, 320, 480)
worldQuad:setUVRect(0, 0, 1, 1)
local world = MOAIProp2D.new()
world:setDeck(worldQuad)
layer:insertProp(world)

-- load some stuff
TextureLoader.loadTextureAtlas("assets/player/moves.png", "assets/player/moves.plist")
TextureLoader.loadTextureAtlas("assets/world/coins.png", "assets/world/coins.plist")
AnimationCache.loadAnimations("assets/player/animations.plist")

local coins = {}

function createCoin()
  local colors = { "50.png", "100.png", "200.png" }
  
  local texture = TextureLoader.getTexture(colors[math.random(1, 3)])
  local coin = MOAIProp2D.new()
  coin:setIndex(texture.index)
  coin:setDeck(texture.deck)
  coin:setLoc(math.random(0, 288), -32)
  coin:moveLoc(0, 550, 2, MOAIEaseType.LINEAR)
  layer:insertProp(coin)

  table.insert(coins, coin)
end

local player = MOAIProp2D.new()
player:setLoc(200, 390)
layer:insertProp(player)

local right = Animation:new('player_right', player)
local left = Animation:new('player_left', player)

-- MOAIInputMgr.device.keyboard:setCallback(
--   function(key, down)
--     if down then
--         print(tostring(key))
--     end
--   end
-- )

local mainloop = MOAICoroutine.new()
mainloop:run(function()
  wait = 0
  while true do
    wait = wait + 1
    
    if (wait == 30) then
      wait = 0
      createCoin()
    end

    local x, y = player:getLoc()

    if MOAIInputMgr.device.keyboard:keyIsDown(44) then
      player:setLoc(x - 2, y)      
      if not left.running then
        left:start()
      end
    else
      left:stop()
    end

    if MOAIInputMgr.device.keyboard:keyIsDown(46) then
      player:setLoc(x + 2, y)      
      if not right.running then
        right:start()
      end
    else
      right:stop()
    end
    coroutine.yield()
  end
end)

local checkCollision = MOAICoroutine.new()
checkCollision:run(function()
  while true do
    local x, y = player:getLoc()
    local playerRect = Rect:new(x, y, 64, 64)

    for index, coin in ipairs(coins) do
      local deleteCoin = function()
        print("Delete Coin!!!")
        layer:removeProp(coin)
        table.remove(coins, index)
      end

      local x, y = coin:getLoc()
      local coinRect = Rect:new(x, y, 32, 32)
      
      if coinRect:overlaps(playerRect) then
        deleteCoin()
        -- CHANGE SCORE
      end

      if y > 500 then        
        deleteCoin()
      end
    end
    coroutine.yield()
  end
end)

-- FPS 
charcodes = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 .,:;!?()&/-'
font = MOAIFont.new()
font:loadFromTTF('assets/DisposableDroidBB.ttf',charcodes, 36, 36)

text = MOAITextBox.new()
text:setFont(font)
text:setTextSize(36, 36)
text:setRect(10, 10, 80, 30)
text:setAlignment(MOAITextBox.LEFT_JUSTIFY, MOAITextBox.BOTTOM_JUSTIFY)
layer:insertProp(text)

local fps = MOAICoroutine.new()
fps:run(function()
  while true do
    text:setString("FPS: " .. math.floor(MOAISim.getPerformance()))
    coroutine.yield()
  end
end)

