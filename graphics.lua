
function love.graphics.ellipse(mode, x, y, a, b, phi, points)
	phi = phi or 0
	points = points or 10
	if points <= 0 then points = 1 end

	local two_pi = math.pi*2
	local angle_shift = two_pi/points
	local theta = 0
	local sin_phi = math.sin(phi)
	local cos_phi = math.cos(phi)

	local coords = {}
	for i = 1, points do
		theta = theta + angle_shift
		coords[2*i-1] = x + a * math.cos(theta) * cos_phi
			- b * math.sin(theta) * sin_phi
		coords[2*i] = y + a * math.cos(theta) * sin_phi
			+ b * math.sin(theta) * cos_phi
	end

	coords[2*points+1] = coords[1]
	coords[2*points+2] = coords[2]

	love.graphics.polygon(mode, coords)
end