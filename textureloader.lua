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

local function count(t)
  local count = 0
  for _ in pairs(t) do count = count + 1 end
  return count
end

TextureLoader = class("TextureLoader")

local cache = {}

function TextureLoader.static.loadTextureAtlas(textureName, propertiesName)
  local data = plist(FileUtils.toString(propertiesName))

  local texture = MOAITexture.new()
  texture:load(textureName)

  local deck = MOAIGfxQuadDeck2D.new()
  deck:setTexture(texture)
  deck:reserve(count(data.frames))

  local index = 0

  for filename, frame in pairs(data.frames) do
    index = index + 1

    local uv = {}
    uv.u0 = frame.x / data.texture.width
    uv.v0 = frame.y / data.texture.height
    uv.u1 = (frame.x + frame.width) / data.texture.width
    uv.v1 = (frame.y + frame.height) / data.texture.height

    deck:setRect(index, 0, 0, frame.width, frame.height)
    deck:setUVRect(index, uv.u0, uv.v0, uv.u1, uv.v1)

    cache[filename] = { index=index, deck=deck }
  end
end

function TextureLoader.static.getTexture(filename)
  return cache[filename]
end
