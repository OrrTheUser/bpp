--
-- Blocks tower colliding with random spheres
--

require "module/povray"

objective_floor=55
objective_block=6

-- different values of v.fixedTimeStep:
-- reproduce stable / unstable tower
v.timeStep      = 1/25  -- 25fps

--v.fixedTimeStep = 0.017 -- unstable tower
v.fixedTimeStep = 0.005 --   stable   tower

-- timeStep < maxSubSteps * fixedTimeStep
v.maxSubSteps   = 2 * v.timeStep / v.fixedTimeStep

---

plane = Plane(0,1,0,0,200)
plane.col = "#fff"
v:add(plane)


target_width = 5
target_height = 0.2
target_depth = 5
target_mass = 100
target = Cube(target_width, target_height, target_depth, target_mass)
target.pos = btVector3(30,target_height/2,0)
v:add(target)

cube_width = 5
cube_height = 5
cube_depth = 5
cube_mass = 1
cube1 = Cube(cube_width, cube_height, cube_depth, cube_mass)
cube1.pos = btVector3(20,cube_height/2,0)
cube1.col = "red"
cube2 = Cube(cube_width, cube_height, cube_depth, cube_mass)
cube2.pos = btVector3(20,3*cube_height/2,0)
cube2.col = "green"
cube3 = Cube(cube_width, cube_height, cube_depth, cube_mass)
cube3.pos = btVector3(20,5*cube_height/2,0)
cube3.col = "blue"
v:add(cube1)
v:add(cube2)
v:add(cube3)

v.optimizer:addOptimizationValues("x_speed", 1, 30, 1)
v.optimizer:addOptimizationValues("y_speed", 0, 25, 1)
v.optimizer:addOptimizationValues("x_location", -20, 10, 5)
--v.optimizer:addOptimizationValues("y_location", 20, 50, 5)

s1 = Sphere(2.75,1.5)
s1.pos = btVector3(v.optimizer:getOptimizationValue("x_location"), 30, 0)
s1.col = "#0000ff"
s1.vel = btVector3(v.optimizer:getOptimizationValue("x_speed"), v.optimizer:getOptimizationValue("y_speed"), 0)
s1.friction=.3
s1.restitution=0.1
s1.mass = 10
v:add(s1)

function setcam()
  v.cam:setUpVector(btVector3(0,1,0), false)
  v.cam:setHorizontalFieldOfView(0.4)
  v.cam.pos  = btVector3(0,15,-300)
  v.cam.look = btVector3(0,15,0)
end

v.optimizer:setTargetFunction(function()
  -- Just hit
  d = target.pos:distance(cube3.pos)
  -- Hit fast (need to check this)
  -- d = g.pos:distance(objective.pos) + (1 / (g.vel:length()))
  return d
end)

r = 0
v:postSim(function(N)
  if(N == 0) then
	if (v.optimizer.is_optimized) then
		print("Optimized value")
	end
	--print("--")
	--print(v.optimizer:getOptimizationValue("first"))
	--print(v.optimizer:getOptimizationValue("second"))
  end
  
  if (render) then
    if (N % 50 == 0) then
	  if (v.optimizer.is_optimized) then
	    setcam()
	    povray.render("-d +L/usr/share/bpp/includes +Lincludes -p +W320 +H240", "/tmp", "00-tower", r)
	    r = r + 1
	  end
    end
  end
end)
