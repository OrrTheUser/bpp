--
-- Blocks tower colliding with random spheres
--

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

function tower(floors,blocks_per_floor)

  tower_radius=blocks_per_floor/(2*math.pi)+7
  for i = 0,floors-1 do
    if (i%2==0) then
      disp=0
    else
      disp=.5
    end
    for j = 0, blocks_per_floor-1 do
      d = Cube(6,1,1.5,1)
      d.mass=1
      q = btQuaternion(0,math.sin((2*math.pi*(j+disp)/blocks_per_floor)/2),0,math.cos((2*math.pi*(j+disp)/blocks_per_floor)/2))
      o = btVector3(tower_radius*math.sin(2*math.pi*(j+disp)/blocks_per_floor),.5+i*1,tower_radius*math.cos(2*math.pi*(j+disp)/blocks_per_floor))
      d.trans = btTransform(q,o)    
      d.col = "#f0a020"
      d.friction=.5
      d.restitution=.1
      v:add(d)
	  if (objective_floor == i) then
		if (objective_block == j) then
			d.col = "green"
			objective = d
		end
	  end
    end
  end

end

tower(80,8)

s1 = Sphere(2.75,1.5)
s1.pos = btVector3(600, 70, 0)
s1.col = "#0000ff"
-- TODO: optimize these values
s1.vel = btVector3(-math.random(150,350),math.random(0,10)*.1,math.random(0,10)*.1)
s1.friction=.3
s1.restitution=0.1
s1.mass = 3
v:add(s1)

g = Sphere(4,3)
g.pos = btVector3(-90, 0, -100)
g.vel = btVector3(0, 0, 30)
g.col = "green"
v:add(g)

v.optimizer:targetFunc(function()
  -- Just hit
  d = g.pos:distance(objective.pos)
  -- Hit fast (need to check this)
  -- d = g.pos:distance(objective.pos) + (1 / (g.vel:length()))
  return d
end)
