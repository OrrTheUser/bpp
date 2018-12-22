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

o = OpenSCAD([===[
d = 4;
s = 5;
scale([0.3, 0.3, 0.3]) {
difference() {
    cube(10, center=true);
    union() {
     translate([-d,-d,d]) {
        sphere(s);
    }   
    translate([d,-d,d]) {
        sphere(s);
    }
    translate([-d,d,d]) {
        sphere(s);
    }
    translate([d,d,d]) {
        sphere(s);
    }
    translate([-d,-d,-d]) {
        sphere(s);
    }
    translate([d,-d,-d]) {
        sphere(s);
    }
    translate([-d,d,-d]) {
        sphere(s);
    }
    translate([d,d,-d]) {
        sphere(s);
    }
    }
}
}

]===], 10)
o.pos = btVector3(17,13,0)
v:add(o)

for i= 0,5 do
o = OpenSCAD([===[
d2 = 7;
s2 = 10;
scale([0.3, 0.3, 0.3]) {
translate([10, 10, 10]) {
difference() {
    cube(10, center=true);
    union() {
     translate([-d2,-d2,d2]) {
        sphere(s2);
    }   
    translate([d2,-d2,d2]) {
        sphere(s2);
    }
    translate([-d2,d2,d2]) {
        sphere(s2);
    }
    translate([d2,d2,d2]) {
        sphere(s2);
    }
    translate([-d2,-d2,-d2]) {
        sphere(s2);
    }
    translate([d2,-d2,-d2]) {
        sphere(s2);
    }
    translate([-d2,d2,-d2]) {
        sphere(s2);
    }
    translate([d2,d2,-d2]) {
        sphere(s2);
    }
    }
}
}
}
]===], 10)
o.pos = btVector3(2 + (5 * i),10 - (2 * i),0)
v:add(o)
o.restitution = 0.800 + (0.03 * i)
end

s = Sphere(1,1)
s.pos = btVector3(10,3,0)
s.vel = btVector3(0,0,0)
s.restitution = 0.605
v:add(s) --print(s.pov)

s = Sphere(1,1)
s.pos = btVector3(18,15,0)
s.vel = btVector3(0,0,0)
s.restitution = 0.925
v:add(s) --print(s.pov)

s = Sphere(0.7,0.7)
s.pos = btVector3(4,15,0)
s.vel = btVector3(0,0,0)
s.restitution = 0.700
v:add(s) --print(s.pov)

s = Sphere(0.7,0.7)
s.pos = btVector3(14,8,0)
s.vel = btVector3(0,0,0)
s.restitution = 0.700
v:add(s) --print(s.pov)

s = Sphere(1,1)
s.pos = btVector3(24,15,0)
s.vel = btVector3(0,0,0)
s.restitution = 0.925
v:add(s) --print(s.pov)

s = Sphere(0.7,0.7)
s.pos = btVector3(27,15,0)
s.vel = btVector3(0,0,0)
s.restitution = 0.700
v:add(s) --print(s.pov)

s = Sphere(0.7,0.7)
s.pos = btVector3(8,8,0)
s.vel = btVector3(0,0,0)
s.restitution = 0.700
v:add(s) --print(s.pov)

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
    if (N % 1 == 0) then
      povray.render("-d +L/usr/share/bpp/includes +L/home/orr/.cache/bpp +Lincludes -p +W320 +H240", "/tmp", "00-hello-pov", r)
      r = r + 1
    end
  end
end)
