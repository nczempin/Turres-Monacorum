
--
function distance_manhattan(x1,y1,x2,y2) --TODO let's not leave this global
	-- manhattan is sufficient for now
	return math.abs(x1-x2)+math.abs(y1-y2)
end

function distance_euclid(x1,y1,x2,y2)
	local x = x1-x2
	local y = y1-y2
	return math.sqrt(x*x+y*y)
end

love.turris.drawMessage = function(x1,x2,y1,rectX1,text,scale,alignment)
	love.postshader.addEffect("monochrom")
	G.setFont(FONT_SMALLER)
	G.setColor(0, 0, 0, 127)
	G.rectangle("fill", rectX1, 160 - 16, x2 + 32, 256 + 32);
	G.setColor(255, 127, 0)
	G.rectangle("line", rectX1+4, 160 - 12, x2 + 24, 256 + 24);
	G.setColor(255, 127, 0)
	G.printf(text, x1, y1, x2, alignment, 0, scale, scale)
end