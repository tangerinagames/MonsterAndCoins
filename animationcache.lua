-------------------------------------------------------------------------------
--
--
--
--
--
-------------------------------------------------------------------------------

require "middleclass"
require "plist"
require "fileutils"
require "textureloader"

local function count(t)
  local count = 0
  for _ in pairs(t) do count = count + 1 end
  return count
end

AnimationCache = class("AnimationCache")

local cache = {}

function AnimationCache.static.loadAnimations(propertiesName)
  local data = plist(FileUtils.toString(propertiesName))

  for name, animation in pairs(data.animations) do
    local textures = {}
    for index, frame in ipairs(animation.frames) do
      textures[index] = TextureLoader.getTexture(frame)
    end
    cache[name] = { textures=textures, delay=animation.delay}
  end
end

function AnimationCache.static.getAnimation(name)
  return cache[name]
end
