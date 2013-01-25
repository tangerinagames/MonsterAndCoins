-------------------------------------------------------------------------------
--
--
--
--
--
-------------------------------------------------------------------------------

Rect = class("Rect")

function Rect:initialize(x, y, width, height)
  self.x = x
  self.y = y 
  self.width = width
  self.height = height
end

function Rect:overlaps(rect)
  return (rect.x + rect.width > self.x) and
         (rect.y + rect.height > self.y) and
         (rect.x < self.x + self.width) and
         (rect.y < self.y + self.height)
end