-------------------------------------------------------------------------------
--
--
--
--
--
-------------------------------------------------------------------------------

require "middleclass"
require "animationcache"

Animation = class("Animation")

function Animation:initialize(name, prop)
  self.running = false
  self.action = MOAICoroutine.new()

  local animation = AnimationCache.getAnimation(name)
  local delay = math.floor(MOAISim.timeToFrames(animation.delay))
  local count = 0
  local frame = 1

  self.func = function()
    while self.running do
      local texture = animation.textures[frame]
      prop:setIndex(texture.index)
      prop:setDeck(texture.deck)

      count = count + 1
      if count == delay then
        count = 0
        frame = frame + 1
        if frame > #animation.textures then
          frame = 1
        end
      end
      coroutine.yield()
    end
  end
end

function Animation:start()
  self.running = true
  self.action:run(self.func)
end

function Animation:stop()
  self.running = false
end
