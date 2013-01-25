-------------------------------------------------------------------------------
--
--
--
--
--
-------------------------------------------------------------------------------

require "textureloader"
require "animation"

MOAISim.openWindow("Monster And Coins", 320, 480)

viewport = MOAIViewport.new()
viewport:setSize(320, 480)
viewport:setScale(320, -480)
viewport:setOffset(-1, 1)

layer = MOAILayer2D.new()
layer:setViewport(viewport)
MOAISim.pushRenderPass(layer)

-- load some stuff
TextureLoader.loadTextureAtlas("assets/player/moves.png", "assets/player/moves.plist")
AnimationCache.loadAnimations("assets/player/animations.plist")

local player = MOAIProp2D.new()
player:setLoc(200, 80)
player:setPiv(37, 48)
--player:moveLoc(-100, 0, 5)

layer:insertProp(player)

local right = Animation:new('player_right', player)
right:start()

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

