const std = @import("std");
const rl = @import("raylib");
const rlgl = rl.gl;

pub fn main() anyerror!void {
    const screenWidth: i32 = 800;
    const screenHeight: i32 = 450;

    const sunRadius = 4.0;
    const earthRadius = 0.6;
    const earthOrbitRadius = 8.0;
    const moonRadius = 0.16;
    const moonOrbitRadius = 1.5;

    rl.initWindow(screenWidth, screenHeight, "raylib [models] example - rlgl solar system");

    // Define the camera to look into our 3d world
    var camera: rl.Camera = std.mem.zeroes(rl.Camera);

    camera.position = .{ .x = 16.0, .y = 16.0, .z = 16.0 }; // Camera position
    camera.target = .{ .x = 0.0, .y = 0.0, .z = 0.0 }; // Camera looking at point
    camera.up = .{ .x = 0.0, .y = 1.0, .z = 0.0 }; // Camera up vector (rotation towards target)
    camera.fovy = 45.0; // Camera field-of-view Y
    camera.projection = .perspective; // Camera projection type

    const rotationSpeed: f32 = 0.2; // General system rotation speed

    var earthRotation: f32 = 0.0; // Rotation of earth around itself (days) in degrees
    var earthOrbitRotation: f32 = 0.0; // Rotation of earth around the Sun (years) in degrees
    var moonRotation: f32 = 0.0; // Rotation of moon around itself
    var moonOrbitRotation: f32 = 0.0; // Rotation of moon around earth in degrees

    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer rl.closeWindow(); // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second

    while (!rl.windowShouldClose()) {

        // Update
        //----------------------------------------------------------------------------------
        rl.updateCamera(&camera, .orbital);

        earthRotation += (5.0 * rotationSpeed);
        earthOrbitRotation += (365.0 / 360.0 * (5.0 * rotationSpeed) * rotationSpeed);
        moonRotation += (2.0 * rotationSpeed);
        moonOrbitRotation += (8.0 * rotationSpeed);
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);
        {
            rl.beginMode3D(camera);
            defer rl.endMode3D();

            rlgl.rlPushMatrix();
            rlgl.rlScalef(sunRadius, sunRadius, sunRadius); // Scale Sun
            drawSphereBasic(.gold); // Draw the Sun
            rlgl.rlPopMatrix();

            rlgl.rlPushMatrix();
            rlgl.rlRotatef(earthOrbitRotation, 0.0, 1.0, 0.0); // Rotation for Earth orbit around Sun
            rlgl.rlTranslatef(earthOrbitRadius, 0.0, 0.0); // Translation for Earth orbit

            rlgl.rlPushMatrix();
            rlgl.rlRotatef(earthRotation, 0.25, 1.0, 0.0); // Rotation for Earth itself
            rlgl.rlScalef(earthRadius, earthRadius, earthRadius); // Scale Earth

            drawSphereBasic(.blue); // Draw the Earth
            rlgl.rlPopMatrix();

            rlgl.rlRotatef(moonOrbitRotation, 0.0, 1.0, 0.0); // Rotation for Moon orbit around Earth
            rlgl.rlTranslatef(moonOrbitRadius, 0.0, 0.0); // Translation for Moon orbit
            rlgl.rlRotatef(moonRotation, 0.0, 1.0, 0.0); // Rotation for Moon itself
            rlgl.rlScalef(moonRadius, moonRadius, moonRadius); // Scale Moon

            drawSphereBasic(.light_gray); // Draw the Moon
            rlgl.rlPopMatrix();

            // Some reference elements (not affected by previous matrix transformations)
            rl.drawCircle3D(.{ .x = 0.0, .y = 0.0, .z = 0.0 }, earthOrbitRadius, .{ .x = 1, .y = 0, .z = 0 }, 90.0, rl.fade(.red, 0.5));
            rl.drawGrid(20, 1.0);
        }

        rl.drawText("EARTH ORBITING AROUND THE SUN!", 400, 10, 20, .maroon);
        rl.drawFPS(10, 10);
        //----------------------------------------------------------------------------------
    }
}

//--------------------------------------------------------------------------------------------
// Module Functions Definition
//--------------------------------------------------------------------------------------------
// Draw sphere without any matrix transformation
// NOTE: Sphere is drawn in world position ( 0, 0, 0 ) with radius 1.0f
fn drawSphereBasic(color: rl.Color) void {
    const rings: usize = 16;
    const slices: usize = 16;
    const floatRings: f32 = @floatFromInt(rings);
    const floatSlices: f32 = @floatFromInt(slices);

    // Make sure there is enough space in the internal render batch
    // buffer to store all required vertex, batch is reseted if required
    _ = rlgl.rlCheckRenderBatchLimit((rings + 2) * slices * 6);

    rlgl.rlBegin(rlgl.rl_triangles);
    rlgl.rlColor4ub(color.r, color.g, color.b, color.a);

    for (0..(rings + 2)) |i| {
        const floatI: f32 = @floatFromInt(i);
        for (0..slices) |j| {
            const floatJ: f32 = @floatFromInt(j);
            rlgl.rlVertex3f(
                std.math.cos(std.math.rad_per_deg * (270.0 + (180.0 / (floatRings + 1.0)) * floatI)) * std.math.sin(std.math.rad_per_deg * (floatJ * 360 / floatSlices)),
                std.math.sin(std.math.rad_per_deg * (270.0 + (180.0 / (floatRings + 1.0)) * floatI)),
                std.math.cos(std.math.rad_per_deg * (270.0 + (180.0 / (floatRings + 1.0)) * floatI)) * std.math.cos(std.math.rad_per_deg * (floatJ * 360 / floatSlices)),
            );
            rlgl.rlVertex3f(
                std.math.cos(std.math.rad_per_deg * (270.0 + (180.0 / (floatRings + 1.0)) * (floatI + 1.0))) * std.math.sin(std.math.rad_per_deg * ((floatJ + 1.0) * 360 / floatSlices)),
                std.math.sin(std.math.rad_per_deg * (270.0 + (180.0 / (floatRings + 1.0)) * (floatI + 1.0))),
                std.math.cos(std.math.rad_per_deg * (270.0 + (180.0 / (floatRings + 1.0)) * (floatI + 1.0))) * std.math.cos(std.math.rad_per_deg * ((floatJ + 1.0) * 360 / floatSlices)),
            );
            rlgl.rlVertex3f(
                std.math.cos(std.math.rad_per_deg * (270.0 + (180.0 / (floatRings + 1.0)) * (floatI + 1.0))) * std.math.sin(std.math.rad_per_deg * (floatJ * 360 / floatSlices)),
                std.math.sin(std.math.rad_per_deg * (270.0 + (180.0 / (floatRings + 1.0)) * (floatI + 1.0))),
                std.math.cos(std.math.rad_per_deg * (270.0 + (180.0 / (floatRings + 1.0)) * (floatI + 1.0))) * std.math.cos(std.math.rad_per_deg * (floatJ * 360 / floatSlices)),
            );

            rlgl.rlVertex3f(
                std.math.cos(std.math.rad_per_deg * (270.0 + (180.0 / (floatRings + 1.0)) * floatI)) * std.math.sin(std.math.rad_per_deg * (floatJ * 360 / floatSlices)),
                std.math.sin(std.math.rad_per_deg * (270.0 + (180.0 / (floatRings + 1.0)) * floatI)),
                std.math.cos(std.math.rad_per_deg * (270.0 + (180.0 / (floatRings + 1.0)) * floatI)) * std.math.cos(std.math.rad_per_deg * (floatJ * 360 / floatSlices)),
            );
            rlgl.rlVertex3f(
                std.math.cos(std.math.rad_per_deg * (270.0 + (180.0 / (floatRings + 1.0)) * (floatI))) * std.math.sin(std.math.rad_per_deg * ((floatJ + 1.0) * 360 / floatSlices)),
                std.math.sin(std.math.rad_per_deg * (270.0 + (180.0 / (floatRings + 1.0)) * (floatI))),
                std.math.cos(std.math.rad_per_deg * (270.0 + (180.0 / (floatRings + 1.0)) * (floatI))) * std.math.cos(std.math.rad_per_deg * ((floatJ + 1.0) * 360 / floatSlices)),
            );
            rlgl.rlVertex3f(
                std.math.cos(std.math.rad_per_deg * (270.0 + (180.0 / (floatRings + 1.0)) * (floatI + 1.0))) * std.math.sin(std.math.rad_per_deg * ((floatJ + 1.0) * 360 / floatSlices)),
                std.math.sin(std.math.rad_per_deg * (270.0 + (180.0 / (floatRings + 1.0)) * (floatI + 1.0))),
                std.math.cos(std.math.rad_per_deg * (270.0 + (180.0 / (floatRings + 1.0)) * (floatI + 1.0))) * std.math.cos(std.math.rad_per_deg * ((floatJ + 1.0) * 360 / floatSlices)),
            );
        }
    }
    rlgl.rlEnd();
}
