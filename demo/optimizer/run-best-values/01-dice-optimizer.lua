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

die_1 = OpenSCAD([===[
module dodecahedron(height) {
    intersection() {
	// Make a cube
	cube([2 * height, 2 * height, height], center = true); 

	// Loop i from 0 to 4, and intersect results
	intersection_for(i = [0:4]) { 
	    // Make a cube, rotate it 116.565 degrees around the X axis,
	    // then 72 * i around the Z axis
	    rotate([0, 0, 72 * i])
	    rotate([116.565, 0, 0])
	    cube([2 * height, 2 * height, height], center = true); 
	}
    }
}

module octahedron(height) {
    intersection() {
	// Make a cube
	cube([2 * height, 2 * height, height], center = true); 

	// Loop i from 0 to 2, and intersect results
	intersection_for(i = [0:2]) { 
	    // Make a cube, rotate it 109.47122 degrees around the X axis,
	    // then 120 * i around the Z axis
	    rotate([109.47122, 0, 120 * i])
	    cube([2 * height, 2 * height, height], center = true); 
	}
    }
}

w=-15.525;

module icosahedron(height) {
    intersection() {

	octahedron(height);

	rotate([0, 0, 60 + w])
	    octahedron(height);

	intersection_for(i = [1:3]) { 
	    rotate([0, 0, i * 120])
	    rotate([109.471, 0, 0])
	    rotate([0, 0, w])
		octahedron(height);
	}
    }
}

module tetrahedron(height) {
    scale([height, height, height]) {	// Scale by height parameter
	polyhedron(points = [
		[-0.288675, 0.5, /* -0.27217 */ -0.20417],
		[-0.288675, -0.5, /* -0.27217 */ -0.20417],
		[0.57735, 0, /* -0.27217 */ -0.20417],
		[0, 0, /* 0.54432548 */ 0.612325]],
	faces = [[1, 2, 0],
		[3, 2, 1],
		[3, 1, 0],
		[2, 3, 0]]);
    }
}

//------------------------------------------
// Text modules
//------------------------------------------

textvals=["1", "2", "3", "4", "5", "6", "7", "8",
	"9", "10", "11", "12", "13", "14", "15",
	"16", "17", "18", "19", "20"];

underscore=[" ", " ", " ", " ", " ", "_", " ", " ",
	"_", " ", " ", " ", " ", " ", " ",
	" ", " ", " ", " ", " "];


ttext=["1", "2", "3", "4", "3", "2", "4", "2", "1", "4", "1", "3"];

otext=["1", "2", "3", "15", "19", "6", "7", "8",
	"9", "10", "12", "4", "20", "5", "14",
	"11", "18", "17", "13", "16"];

module tetratext(height) {
    rotate([180, 0, 0])
    translate([0, 0, 0.2 * height - 1])
    for (i = [0:2]) { 
	rotate([0, 0, 120 * i])
	translate([0.3 * height, 0, 0])
	rotate([0, 0, -90])
	linear_extrude(height=2)
	    text(ttext[i], size=0.2 * height,
			valign="center", halign="center");
    }

    for (j = [0:2]) { 
	rotate([0, -70.5288, j * 120])
	translate([0, 0, 0.2 * height - 1])
	for (i = [0:2]) { 
	    rotate([0, 0, 120 * i])
	    translate([0.3 * height, 0, 0])
	    rotate([0, 0, -90])
	    linear_extrude(height=2)
		text(ttext[(j + 1) * 3 + i], size=0.2 * height,
			valign="center", halign="center");
	}
    }
}

module octatext(height) {

    rotate([0, 0, 180])
    translate([0, 0, 0.5 * height - 1])
    linear_extrude(height=2)
	text("1", size=0.55 * height,
			valign="center", halign="center");

    translate([0, 0, -0.5 * height + 1])
    rotate([0, 180, 180])
    linear_extrude(height=2)
	text("8", size=0.55 * height,
			valign="center", halign="center");

    // Loop i from 0 to 2, and intersect results
    for (i = [0:2]) { 
	rotate([109.47122, 0, 120 * i]) {
	    translate([0, 0, 0.5 * height - 1])
	    linear_extrude(height=2)
		text(textvals[i*2 + 1], size=0.55 * height,
			valign="center", halign="center");

	    translate([0, 0, -0.5 * height + 1])
	    rotate([0, 180, 180])
	    linear_extrude(height=2)
		text(textvals[6 - i*2], size=0.55 * height,
			valign="center", halign="center");
	}
    }
}

module octahalf(height, j) {
    rotate([0, 0, 180]) {
	rotate([0, 0, 39])
	translate([0, 0, 0.5 * height - 1])
	linear_extrude(height=2)
	    text(otext[j], size=0.21 * height,
			valign="center", halign="center");

	rotate([0, 0, 39])
	translate([0, 4, 0.5 * height - 1])
	linear_extrude(height=2)
	    text(underscore[j], size=0.21 * height,
			valign="center", halign="center");
    }

    // Loop i from 0 to 2, and intersect results
    for (i = [0:2]) { 
	rotate([109.47122, 0, 120 * i]) {
	    rotate([0, 0, 39])
	    translate([0, 0, 0.5 * height - 1])
	    linear_extrude(height=2)
		text(otext[i + j + 1], size=0.21 * height,
			valign="center", halign="center");

	    rotate([0, 0, 39])
	    translate([0, 4, 0.5 * height - 1])
	    linear_extrude(height=2)
		text(underscore[i + j + 1], size=0.21 * height,
			valign="center", halign="center");
	}
    }
}

module cubetext(height) {

    rotate([0, 0, 180])
    translate([0, 0, 0.5 * height - 1])
	linear_extrude(height=2)
	    text("1", size=height * 0.6, valign="center", halign="center");

    translate([0, 0, -0.5 * height + 1])
    rotate([0, 180, 180])
    linear_extrude(height=2)
	text("6", size=height * 0.6, valign="center", halign="center");

    // Loop i from 0 to 2, and intersect results
    for (i = [0:1]) { 
	rotate([90, 0, 90 * i]) {
	    translate([0, 0, 0.5 * height - 1])
	    linear_extrude(height=2)
		text(textvals[i*2 + 1], size=0.6 * height,
			valign="center", halign="center");

	    translate([0, 0, -0.5 * height + 1])
	    rotate([0, 180, 180])
	    linear_extrude(height=2)
		text(textvals[4 - i*2], size=height * 0.6,
			valign="center", halign="center");
	}
    }
}

module dodecatext(height) {

    rotate([0, 0, 180])
    translate([0, 0, 0.5 * height - 1])
    linear_extrude(height=2)
	text("1", size=0.3 * height, valign="center", halign="center");

    translate([0, 0, -0.5 * height + 1])
    rotate([0, 180, 0])
    linear_extrude(height=2)
	text("12", size=0.3 * height, valign="center", halign="center");

    // Loop i from 0 to 4, and intersect results
    for (i = [0:4]) { 
	rotate([0, 0, 72 * i])
	rotate([116.565, 0, 0]) {
	    translate([0, 0, 0.5 * height - 1])
	    linear_extrude(height=2)
		text(textvals[i*2 + 1], size=0.3 * height,
			valign="center", halign="center");

	    translate([0, -4, 0.5 * height - 1])
	    linear_extrude(height=2)
		text(underscore[i*2 + 1], size=0.3 * height,
			valign="center", halign="center");

	    translate([0, 0, -0.5 * height + 1])
	    rotate([0, 180, 180])
	    linear_extrude(height=2)
		text(textvals[10 - i*2], size=0.3 * height,
			valign="center", halign="center");

	    translate([0, 5, -0.5 * height + 1])
	    rotate([0, 180, 0])
	    linear_extrude(height=2)
		text(underscore[10 - i*2], size=0.3 * height,
			valign="center", halign="center");
	}
    }
}

module icosatext(height) {

    rotate([70.5288, 0, 60])
    octahalf(height, 0);

    rotate([0, 0, 60 + w]) {
	octahalf(height, 4);
    }

    for(i = [1:3]) { 
	rotate([0, 0, i * 120])
	rotate([109.471, 0, 0])
	rotate([0, 0, w])
	    octahalf(height, 4 + i * 4);
    }
}

//------------------------------------------
// Complete dice
//------------------------------------------

difference() {
	difference() {
		intersection() {
			cube([16, 16, 16], center = true);
			rotate([125, 0, 45])
			octahedron(26);
		}
		cubetext(16);
	}
	cube([8, 8, 8], center = true);
}   
]===], 1)

die_2 = OpenSCAD([===[
module dodecahedron(height) {
    intersection() {
	// Make a cube
	cube([2 * height, 2 * height, height], center = true); 

	// Loop i from 0 to 4, and intersect results
	intersection_for(i = [0:4]) { 
	    // Make a cube, rotate it 116.565 degrees around the X axis,
	    // then 72 * i around the Z axis
	    rotate([0, 0, 72 * i])
	    rotate([116.565, 0, 0])
	    cube([2 * height, 2 * height, height], center = true); 
	}
    }
}

module octahedron(height) {
    intersection() {
	// Make a cube
	cube([2 * height, 2 * height, height], center = true); 

	// Loop i from 0 to 2, and intersect results
	intersection_for(i = [0:2]) { 
	    // Make a cube, rotate it 109.47122 degrees around the X axis,
	    // then 120 * i around the Z axis
	    rotate([109.47122, 0, 120 * i])
	    cube([2 * height, 2 * height, height], center = true); 
	}
    }
}

w=-15.525;

module icosahedron(height) {
    intersection() {

	octahedron(height);

	rotate([0, 0, 60 + w])
	    octahedron(height);

	intersection_for(i = [1:3]) { 
	    rotate([0, 0, i * 120])
	    rotate([109.471, 0, 0])
	    rotate([0, 0, w])
		octahedron(height);
	}
    }
}

module tetrahedron(height) {
    scale([height, height, height]) {	// Scale by height parameter
	polyhedron(points = [
		[-0.288675, 0.5, /* -0.27217 */ -0.20417],
		[-0.288675, -0.5, /* -0.27217 */ -0.20417],
		[0.57735, 0, /* -0.27217 */ -0.20417],
		[0, 0, /* 0.54432548 */ 0.612325]],
	faces = [[1, 2, 0],
		[3, 2, 1],
		[3, 1, 0],
		[2, 3, 0]]);
    }
}

//------------------------------------------
// Text modules
//------------------------------------------

textvals=["1", "2", "3", "4", "5", "6", "7", "8",
	"9", "10", "11", "12", "13", "14", "15",
	"16", "17", "18", "19", "20"];

underscore=[" ", " ", " ", " ", " ", "_", " ", " ",
	"_", " ", " ", " ", " ", " ", " ",
	" ", " ", " ", " ", " "];


ttext=["1", "2", "3", "4", "3", "2", "4", "2", "1", "4", "1", "3"];

otext=["1", "2", "3", "15", "19", "6", "7", "8",
	"9", "10", "12", "4", "20", "5", "14",
	"11", "18", "17", "13", "16"];

module tetratext(height) {
    rotate([180, 0, 0])
    translate([0, 0, 0.2 * height - 1])
    for (i = [0:2]) { 
	rotate([0, 0, 120 * i])
	translate([0.3 * height, 0, 0])
	rotate([0, 0, -90])
	linear_extrude(height=2)
	    text(ttext[i], size=0.2 * height,
			valign="center", halign="center");
    }

    for (j = [0:2]) { 
	rotate([0, -70.5288, j * 120])
	translate([0, 0, 0.2 * height - 1])
	for (i = [0:2]) { 
	    rotate([0, 0, 120 * i])
	    translate([0.3 * height, 0, 0])
	    rotate([0, 0, -90])
	    linear_extrude(height=2)
		text(ttext[(j + 1) * 3 + i], size=0.2 * height,
			valign="center", halign="center");
	}
    }
}

module octatext(height) {

    rotate([0, 0, 180])
    translate([0, 0, 0.5 * height - 1])
    linear_extrude(height=2)
	text("1", size=0.55 * height,
			valign="center", halign="center");

    translate([0, 0, -0.5 * height + 1])
    rotate([0, 180, 180])
    linear_extrude(height=2)
	text("8", size=0.55 * height,
			valign="center", halign="center");

    // Loop i from 0 to 2, and intersect results
    for (i = [0:2]) { 
	rotate([109.47122, 0, 120 * i]) {
	    translate([0, 0, 0.5 * height - 1])
	    linear_extrude(height=2)
		text(textvals[i*2 + 1], size=0.55 * height,
			valign="center", halign="center");

	    translate([0, 0, -0.5 * height + 1])
	    rotate([0, 180, 180])
	    linear_extrude(height=2)
		text(textvals[6 - i*2], size=0.55 * height,
			valign="center", halign="center");
	}
    }
}

module octahalf(height, j) {
    rotate([0, 0, 180]) {
	rotate([0, 0, 39])
	translate([0, 0, 0.5 * height - 1])
	linear_extrude(height=2)
	    text(otext[j], size=0.21 * height,
			valign="center", halign="center");

	rotate([0, 0, 39])
	translate([0, 4, 0.5 * height - 1])
	linear_extrude(height=2)
	    text(underscore[j], size=0.21 * height,
			valign="center", halign="center");
    }

    // Loop i from 0 to 2, and intersect results
    for (i = [0:2]) { 
	rotate([109.47122, 0, 120 * i]) {
	    rotate([0, 0, 39])
	    translate([0, 0, 0.5 * height - 1])
	    linear_extrude(height=2)
		text(otext[i + j + 1], size=0.21 * height,
			valign="center", halign="center");

	    rotate([0, 0, 39])
	    translate([0, 4, 0.5 * height - 1])
	    linear_extrude(height=2)
		text(underscore[i + j + 1], size=0.21 * height,
			valign="center", halign="center");
	}
    }
}

module cubetext(height) {

    rotate([0, 0, 180])
    translate([0, 0, 0.5 * height - 1])
	linear_extrude(height=2)
	    text("1", size=height * 0.6, valign="center", halign="center");

    translate([0, 0, -0.5 * height + 1])
    rotate([0, 180, 180])
    linear_extrude(height=2)
	text("6", size=height * 0.6, valign="center", halign="center");

    // Loop i from 0 to 2, and intersect results
    for (i = [0:1]) { 
	rotate([90, 0, 90 * i]) {
	    translate([0, 0, 0.5 * height - 1])
	    linear_extrude(height=2)
		text(textvals[i*2 + 1], size=0.6 * height,
			valign="center", halign="center");

	    translate([0, 0, -0.5 * height + 1])
	    rotate([0, 180, 180])
	    linear_extrude(height=2)
		text(textvals[4 - i*2], size=height * 0.6,
			valign="center", halign="center");
	}
    }
}

module dodecatext(height) {

    rotate([0, 0, 180])
    translate([0, 0, 0.5 * height - 1])
    linear_extrude(height=2)
	text("1", size=0.3 * height, valign="center", halign="center");

    translate([0, 0, -0.5 * height + 1])
    rotate([0, 180, 0])
    linear_extrude(height=2)
	text("12", size=0.3 * height, valign="center", halign="center");

    // Loop i from 0 to 4, and intersect results
    for (i = [0:4]) { 
	rotate([0, 0, 72 * i])
	rotate([116.565, 0, 0]) {
	    translate([0, 0, 0.5 * height - 1])
	    linear_extrude(height=2)
		text(textvals[i*2 + 1], size=0.3 * height,
			valign="center", halign="center");

	    translate([0, -4, 0.5 * height - 1])
	    linear_extrude(height=2)
		text(underscore[i*2 + 1], size=0.3 * height,
			valign="center", halign="center");

	    translate([0, 0, -0.5 * height + 1])
	    rotate([0, 180, 180])
	    linear_extrude(height=2)
		text(textvals[10 - i*2], size=0.3 * height,
			valign="center", halign="center");

	    translate([0, 5, -0.5 * height + 1])
	    rotate([0, 180, 0])
	    linear_extrude(height=2)
		text(underscore[10 - i*2], size=0.3 * height,
			valign="center", halign="center");
	}
    }
}

module icosatext(height) {

    rotate([70.5288, 0, 60])
    octahalf(height, 0);

    rotate([0, 0, 60 + w]) {
	octahalf(height, 4);
    }

    for(i = [1:3]) { 
	rotate([0, 0, i * 120])
	rotate([109.471, 0, 0])
	rotate([0, 0, w])
	    octahalf(height, 4 + i * 4);
    }
}

//------------------------------------------
// Complete dice
//------------------------------------------

difference() {
	difference() {
		intersection() {
		dodecahedron(22);
		rotate([35, 10, -18])
			icosahedron(26.8);
		}
		dodecatext(22);
	}
	dodecahedron(14);
}
]===], 1)

die_3 = OpenSCAD([===[
module dodecahedron(height) {
    intersection() {
	// Make a cube
	cube([2 * height, 2 * height, height], center = true); 

	// Loop i from 0 to 4, and intersect results
	intersection_for(i = [0:4]) { 
	    // Make a cube, rotate it 116.565 degrees around the X axis,
	    // then 72 * i around the Z axis
	    rotate([0, 0, 72 * i])
	    rotate([116.565, 0, 0])
	    cube([2 * height, 2 * height, height], center = true); 
	}
    }
}

module octahedron(height) {
    intersection() {
	// Make a cube
	cube([2 * height, 2 * height, height], center = true); 

	// Loop i from 0 to 2, and intersect results
	intersection_for(i = [0:2]) { 
	    // Make a cube, rotate it 109.47122 degrees around the X axis,
	    // then 120 * i around the Z axis
	    rotate([109.47122, 0, 120 * i])
	    cube([2 * height, 2 * height, height], center = true); 
	}
    }
}

w=-15.525;

module icosahedron(height) {
    intersection() {

	octahedron(height);

	rotate([0, 0, 60 + w])
	    octahedron(height);

	intersection_for(i = [1:3]) { 
	    rotate([0, 0, i * 120])
	    rotate([109.471, 0, 0])
	    rotate([0, 0, w])
		octahedron(height);
	}
    }
}

module tetrahedron(height) {
    scale([height, height, height]) {	// Scale by height parameter
	polyhedron(points = [
		[-0.288675, 0.5, /* -0.27217 */ -0.20417],
		[-0.288675, -0.5, /* -0.27217 */ -0.20417],
		[0.57735, 0, /* -0.27217 */ -0.20417],
		[0, 0, /* 0.54432548 */ 0.612325]],
	faces = [[1, 2, 0],
		[3, 2, 1],
		[3, 1, 0],
		[2, 3, 0]]);
    }
}

//------------------------------------------
// Text modules
//------------------------------------------

textvals=["1", "2", "3", "4", "5", "6", "7", "8",
	"9", "10", "11", "12", "13", "14", "15",
	"16", "17", "18", "19", "20"];

underscore=[" ", " ", " ", " ", " ", "_", " ", " ",
	"_", " ", " ", " ", " ", " ", " ",
	" ", " ", " ", " ", " "];


ttext=["1", "2", "3", "4", "3", "2", "4", "2", "1", "4", "1", "3"];

otext=["1", "2", "3", "15", "19", "6", "7", "8",
	"9", "10", "12", "4", "20", "5", "14",
	"11", "18", "17", "13", "16"];

module tetratext(height) {
    rotate([180, 0, 0])
    translate([0, 0, 0.2 * height - 1])
    for (i = [0:2]) { 
	rotate([0, 0, 120 * i])
	translate([0.3 * height, 0, 0])
	rotate([0, 0, -90])
	linear_extrude(height=2)
	    text(ttext[i], size=0.2 * height,
			valign="center", halign="center");
    }

    for (j = [0:2]) { 
	rotate([0, -70.5288, j * 120])
	translate([0, 0, 0.2 * height - 1])
	for (i = [0:2]) { 
	    rotate([0, 0, 120 * i])
	    translate([0.3 * height, 0, 0])
	    rotate([0, 0, -90])
	    linear_extrude(height=2)
		text(ttext[(j + 1) * 3 + i], size=0.2 * height,
			valign="center", halign="center");
	}
    }
}

module octatext(height) {

    rotate([0, 0, 180])
    translate([0, 0, 0.5 * height - 1])
    linear_extrude(height=2)
	text("1", size=0.55 * height,
			valign="center", halign="center");

    translate([0, 0, -0.5 * height + 1])
    rotate([0, 180, 180])
    linear_extrude(height=2)
	text("8", size=0.55 * height,
			valign="center", halign="center");

    // Loop i from 0 to 2, and intersect results
    for (i = [0:2]) { 
	rotate([109.47122, 0, 120 * i]) {
	    translate([0, 0, 0.5 * height - 1])
	    linear_extrude(height=2)
		text(textvals[i*2 + 1], size=0.55 * height,
			valign="center", halign="center");

	    translate([0, 0, -0.5 * height + 1])
	    rotate([0, 180, 180])
	    linear_extrude(height=2)
		text(textvals[6 - i*2], size=0.55 * height,
			valign="center", halign="center");
	}
    }
}

module octahalf(height, j) {
    rotate([0, 0, 180]) {
	rotate([0, 0, 39])
	translate([0, 0, 0.5 * height - 1])
	linear_extrude(height=2)
	    text(otext[j], size=0.21 * height,
			valign="center", halign="center");

	rotate([0, 0, 39])
	translate([0, 4, 0.5 * height - 1])
	linear_extrude(height=2)
	    text(underscore[j], size=0.21 * height,
			valign="center", halign="center");
    }

    // Loop i from 0 to 2, and intersect results
    for (i = [0:2]) { 
	rotate([109.47122, 0, 120 * i]) {
	    rotate([0, 0, 39])
	    translate([0, 0, 0.5 * height - 1])
	    linear_extrude(height=2)
		text(otext[i + j + 1], size=0.21 * height,
			valign="center", halign="center");

	    rotate([0, 0, 39])
	    translate([0, 4, 0.5 * height - 1])
	    linear_extrude(height=2)
		text(underscore[i + j + 1], size=0.21 * height,
			valign="center", halign="center");
	}
    }
}

module cubetext(height) {

    rotate([0, 0, 180])
    translate([0, 0, 0.5 * height - 1])
	linear_extrude(height=2)
	    text("1", size=height * 0.6, valign="center", halign="center");

    translate([0, 0, -0.5 * height + 1])
    rotate([0, 180, 180])
    linear_extrude(height=2)
	text("6", size=height * 0.6, valign="center", halign="center");

    // Loop i from 0 to 2, and intersect results
    for (i = [0:1]) { 
	rotate([90, 0, 90 * i]) {
	    translate([0, 0, 0.5 * height - 1])
	    linear_extrude(height=2)
		text(textvals[i*2 + 1], size=0.6 * height,
			valign="center", halign="center");

	    translate([0, 0, -0.5 * height + 1])
	    rotate([0, 180, 180])
	    linear_extrude(height=2)
		text(textvals[4 - i*2], size=height * 0.6,
			valign="center", halign="center");
	}
    }
}

module dodecatext(height) {

    rotate([0, 0, 180])
    translate([0, 0, 0.5 * height - 1])
    linear_extrude(height=2)
	text("1", size=0.3 * height, valign="center", halign="center");

    translate([0, 0, -0.5 * height + 1])
    rotate([0, 180, 0])
    linear_extrude(height=2)
	text("12", size=0.3 * height, valign="center", halign="center");

    // Loop i from 0 to 4, and intersect results
    for (i = [0:4]) { 
	rotate([0, 0, 72 * i])
	rotate([116.565, 0, 0]) {
	    translate([0, 0, 0.5 * height - 1])
	    linear_extrude(height=2)
		text(textvals[i*2 + 1], size=0.3 * height,
			valign="center", halign="center");

	    translate([0, -4, 0.5 * height - 1])
	    linear_extrude(height=2)
		text(underscore[i*2 + 1], size=0.3 * height,
			valign="center", halign="center");

	    translate([0, 0, -0.5 * height + 1])
	    rotate([0, 180, 180])
	    linear_extrude(height=2)
		text(textvals[10 - i*2], size=0.3 * height,
			valign="center", halign="center");

	    translate([0, 5, -0.5 * height + 1])
	    rotate([0, 180, 0])
	    linear_extrude(height=2)
		text(underscore[10 - i*2], size=0.3 * height,
			valign="center", halign="center");
	}
    }
}

module icosatext(height) {

    rotate([70.5288, 0, 60])
    octahalf(height, 0);

    rotate([0, 0, 60 + w]) {
	octahalf(height, 4);
    }

    for(i = [1:3]) { 
	rotate([0, 0, i * 120])
	rotate([109.471, 0, 0])
	rotate([0, 0, w])
	    octahalf(height, 4 + i * 4);
    }
}

//------------------------------------------
// Complete dice
//------------------------------------------

difference() {
	difference() {
		intersection() {
		octahedron(18);
		rotate([45, 35, -30])
			cube([29, 29, 29], center = true);
		}
		octatext(18);
	}
	octahedron(10);
}
]===], 1)

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


die_1.col = "red"
die_1.restitution = 0.2
die_1.pos = btVector3(0,0,8)
v:add(die_1)

die_2.col = "blue"
die_2.restitution = 0.2
die_2.pos = btVector3(30,30,50)
die_2.mass = 100
v:add(die_2)

die_3.col = "green"
die_3.restitution = 0.2
die_3.pos = btVector3(-30,0,9)
v:add(die_3)

-- Position rotations - for parameter optimization
die_1_top_face_is_1 = btQuaternion(btVector3(1,0,0),0)
die_1_top_face_is_6 = die_1_top_face_is_1:inverse()
die_2_top_face_is_1 = btQuaternion(btVector3(-0.989712, 0.139253, 0.0328627),0.46830707788467)
die_2_top_face_is_12 = die_2_top_face_is_1:inverse()
die_3_top_face_is_1 = btQuaternion(btVector3(-0.999958,-0.00888235,-0.00152324),0.3398530712691)
die_3_top_face_is_8 = die_3_top_face_is_1:inverse()

-- Set parameters here
optimized_die = die_2
optimized_rotation = die_1_top_face_is_1

original_rotation = optimized_die.trans:getRotation()

die_2.vel = btVector3(2,3,0.1 * (-321))
optimized_die.trans:setRotation(die_2_top_face_is_12)
die_2.vel = btVector3(0,0,0)

function target_func()  
  is_right_face_up = optimized_die.trans:getRotation():angle(optimized_rotation)
  velocity = optimized_die.vel:length()
  height = optimized_die.pos:getY()
  return (200 * is_right_face_up) + velocity + height
end

function setcam()
  v.cam:setUpVector(btVector3(0,1,0), false)
  v.cam:setHorizontalFieldOfView(0.4)
  d = -1000
  v.cam.pos  = die_2.pos + btVector3(0,80,0)
  v.cam.look = die_2.pos
end

setcam()

r = 0
v:postSim(function(N)
	setcam()
  print(target_func())
  print(optimized_die.trans:getRotation():angle(optimized_rotation))
  if (render) then
    if (N % 10 == 0) then
	
	povray.render("-d +L/usr/share/bpp/includes +L/home/orr/.cache/bpp +Lincludes -p +W320 +H240", "/tmp", "00-hello-pov", r)
	r = r + 1
    end
  end
end)
