// raylib [shaders] example - Raymarching shapes generation
//
// Example complexity rating: [★★★★] 4/4
//
// NOTE: This example requires raylib OpenGL 3.3 for shaders support and only #version 330
//       is currently supported. OpenGL ES 2.0 platforms are not supported at the moment.
//
// Example originally created with raylib 2.0, last time updated with raylib 4.2
//
// Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
// BSD-like license that allows static linking with closed source software
//
// Copyright (c) 2018-2025 Ramon Santamaria (@raysan5)

const rl = @import("raylib");
const std = @import("std");

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.setConfigFlags(rl.ConfigFlags{ .window_resizable = true });
    rl.initWindow(screenWidth, screenHeight, "raylib [shaders] example - raymarching shapes");
    defer rl.closeWindow(); // Close window and OpenGL context

    // Define the camera to look into our 3d world
    var camera = rl.Camera3D{
        .position = .{ .x = 2.5, .y = 2.5, .z = 3.0 }, // Camera position
        .target = .{ .x = 0.0, .y = 0.0, .z = 0.7 }, // Camera looking at point
        .up = .{ .x = 0.0, .y = 1.0, .z = 0.0 }, // Camera up vector (rotation towards target)
        .fovy = 65.0, // Camera field-of-view Y
        .projection = .perspective, // Camera projection type
    };

    // Load raymarching shader
    const shader = try rl.loadShader(null, "resources/shaders/glsl330/raymarching.fs");
    defer rl.unloadShader(shader);

    // Get shader locations for required uniforms
    const viewEyeLoc = rl.getShaderLocation(shader, "viewEye");
    const viewCenterLoc = rl.getShaderLocation(shader, "viewCenter");
    const runTimeLoc = rl.getShaderLocation(shader, "runTime");
    const resolutionLoc = rl.getShaderLocation(shader, "resolution");

    var resolution = [2]f32{ @floatFromInt(screenWidth), @floatFromInt(screenHeight) };
    rl.setShaderValue(shader, resolutionLoc, &resolution, .vec2);

    var runTime: f32 = 0.0;

    rl.disableCursor(); // Limit cursor to relative movement inside the window
    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        rl.updateCamera(&camera, .first_person);

        const cameraPos = [3]f32{ camera.position.x, camera.position.y, camera.position.z };
        const cameraTarget = [3]f32{ camera.target.x, camera.target.y, camera.target.z };

        const deltaTime = rl.getFrameTime();
        runTime += deltaTime;

        // Set shader required uniform values
        rl.setShaderValue(shader, viewEyeLoc, &cameraPos, .vec3);
        rl.setShaderValue(shader, viewCenterLoc, &cameraTarget, .vec3);
        rl.setShaderValue(shader, runTimeLoc, &runTime, .float);

        // Check if screen is resized
        if (rl.isWindowResized()) {
            resolution = [2]f32{
                @floatFromInt(rl.getScreenWidth()),
                @floatFromInt(rl.getScreenHeight()),
            };
            rl.setShaderValue(shader, resolutionLoc, &resolution, .vec2);
        }

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.ray_white);

        // We only draw a white full-screen rectangle,
        // frame is generated in shader using raymarching
        {
            rl.beginShaderMode(shader);
            defer rl.endShaderMode();

            rl.drawRectangle(
                0,
                0,
                rl.getScreenWidth(),
                rl.getScreenHeight(),
                rl.Color.white,
            );
        }

        rl.drawText(
            "(c) Raymarching shader by Iñigo Quilez. MIT License.",
            rl.getScreenWidth() - 280,
            rl.getScreenHeight() - 20,
            10,
            rl.Color.black,
        );
        //----------------------------------------------------------------------------------
    }
}

