#!/usr/bin/bpp -f
--
-- A red sphere drops on a gray plane
--

--
-- To simulate and render a 400 frames animation of this scene
-- with POV-Ray, run from the console:
--
-- echo "render = 1" | bpp -f demo/basic/00-hello-pov.lua -n 400 -i
--

require "module/povray"

p = Plane(0,1,0,0,10)
p.pos = btVector3(0,0,0)
p.col = "#777"
p.restitution = 1
p.sdl = [[
texture {
  pigment{ color White }
  finish { ambient 0.45 diffuse 0.85 }
}
rotate<0,0,0>
no_shadow
]]
v:add(p) --print(p.pov)

v.optimizer:addOptimizationValues("first", 3, 12, 1)
v.optimizer:addOptimizationValues("second", -5, 7, 1)

ball = Sphere(1,1)
ball.pos = btVector3(10,10,v.optimizer:getOptimizationValue("second"))

--Optimizer value here:
ball.vel = btVector3(v.optimizer:getOptimizationValue("first"),0,0)
ball.col = "red"
ball.restitution = 0.925
v:add(ball) --print(ball.pov)

target_width = 5
target_height = 0.2
target_depth = 5
target_mass = 100
target = Cube(target_width, target_height, target_depth, target_mass)
target.pos = btVector3(20,target_height/2,0)

--Optimizer value here:
target.col = "blue"
target.restitution = 0.925
v:add(target) --print(target.pov)


function setcam()
  v.cam:setUpVector(btVector3(0,1,0), false)
  v.cam:setHorizontalFieldOfView(0.4)
  d = 80
  v.cam.pos  = btVector3(15,7,d)
  v.cam.look = btVector3(15,4,0)
end

setcam()

r = 0
v:postSim(function(N)
  setcam()
  if (render) then
    if (N % 20 == 0) then
	  if (v.optimizer.is_optimized) then
	    print(v.optimizer:getOptimizationValue("first"))
	    print(v.optimizer:getOptimizationValue("second"))
	    povray.render("-d +L/usr/share/bpp/includes +Lincludes -p +W320 +H240", "/tmp", "00-hello-pov", r)
	    r = r + 1
	  end
    end
  end
end)

-- Minimizing the distance between our ball and its target
v.optimizer:setTargetFunction(function()
  --print(ball.pos)
  --print(target.pos)
  return ball.pos:distance(target.pos)
end)

