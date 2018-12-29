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

function set_scene()
  p = Plane(0,1,0,0,10)
  p.pos = btVector3(0,-0.5,0)
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
  
  s = Sphere(1,1)
  s.pos = btVector3(0,10,0)
  
  --Optimizer value here:
  s.vel = btVector3(v.optimizer.value,0,0)
  s.col = "red"
  s.restitution = 0.925
  v:add(s) --print(s.pov)
end

function setcam()
  v.cam:setUpVector(btVector3(0,1,0), false)
  v.cam:setHorizontalFieldOfView(0.4)
  d = 80
  v.cam.pos  = btVector3(15,7,d)
  v.cam.look = btVector3(15,4,0)
end

setcam()

r = 0
v:postSim(function(N) print(N)
  setcam()
  if (render) then
    if (N % 50 == 0) then
      povray.render("-d +L/usr/share/bpp/includes +Lincludes -p +W320 +H240", "/tmp", "00-hello-pov", r)
      r = r + 1
    end
  end
end)

number_of_iterations = 0
v.optimizer:targetFunc(function()
  number_of_iterations = number_of_iterations + 1
  print("Sphere's x value: " .. s.pos.x)
  -- TODO: Why won't s.pos.length() work?
  d = s.pos:length()
  d2 = math.sqrt(s.pos.x^2 + s.pos.y^2 + s.pos.z^2)
  print("a", d, "b", d2)
  return math.floor(d)
end)
v.optimizer:optimize(set_scene)
