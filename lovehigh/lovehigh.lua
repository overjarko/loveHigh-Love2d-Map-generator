local lovehigh = {}

function lovehigh.newMap(size, octaves, decrease, seed_number, strt_points, resolution)--decrease standard = 2 --work on this next
	math.randomseed(os.time())
	resolution = resolution or 2
	strt_points = strt_points or 1
	seed_number = seed_number or math.random(53428)
	decrease = decrease or 2
	local octave_tables = {}
	local seed = makeSeed(size, seed_number, resolution)
	for i=1, octaves do
		octave_tables[i] = {}
		local gap = size/2^(i+strt_points)--make 1 para
		for y=1, size do
			octave_tables[i][y] = {}
			for x=1, size do
				local l_x = (x-1)-(x-1)%gap
				local t_y = (y-1)-(y-1)%gap
				if y%gap == 0 and x%gap == 0 then
					octave_tables[i][y][x] = seed[y][x]
				elseif x%gap == 0 then
					octave_tables[i][y][x] = library.extMath.Intercurves.hermite(seed[t_y][x], seed[t_y+gap][x], y%gap/gap)
				elseif y%gap == 0 then
					octave_tables[i][y][x] = library.extMath.Intercurves.hermite(seed[y][l_x], seed[y][l_x+gap], x%gap/gap)
				else
					octave_tables[i][y][x] = library.extMath.Intercurves.hermite( library.extMath.Intercurves.hermite(seed[t_y][l_x], seed[t_y][l_x+gap], x%gap/gap),
														 			   library.extMath.Intercurves.hermite(seed[t_y+gap][l_x], seed[t_y+gap][l_x+gap], x%gap/gap),
																	   y%gap/gap)
				end
			end
		end
	end
	local final_table = {}
	for y=1, size do
		final_table[y] = {}
		for x=1, size do
			final_table[y][x] = 0
			local value = 0
			local divider = 0
			for i=1, octaves do
				value = value + octave_tables[i][y][x] * 1/decrease^i
				divider = divider + 1/decrease^i
			end
			print(value.."/"..divider.."="..value/divider)
			final_table[y][x] = value/divider
		end
	end
	return final_table, octave_tables
end


function makeSeed(size, seed_number, resolution)
	local seed = {}
	for y=1, size+1 do
		seed[y-1] = {}
		for x=1, size+1 do
			seed[y-1][x-1] = love.math.noise(x*(1/resolution-.01), y*(1/resolution+.01), seed_number)
		end
	end
	return seed
end

return lovehigh