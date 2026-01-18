// raylib [core] example - delta time
//
// Example complexity rating: [★☆☆☆] 1/4
//
// Example originally created with raylib 5.5, last time updated with raylib 5.6-dev
//
// Example contributed by Robin (@RobinsAviary) and reviewed by Ramon Santamaria (@raysan5)
//
// Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
// BSD-like license that allows static linking with closed source software
//
// Copyright (c) 2025 Robin (@RobinsAviary)
//
// Ported to Zig by Isaac de Andrade in Jan 2026

const rl = @import("raylib");

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [core] example - delta time");
    defer rl.closeWindow(); // Close window and OpenGL context

    var current_fps: i32 = 60;

    // Store the position for the both of the circles
    var delta_circle = rl.Vector2{ .x = 0, .y = screenHeight / 3.0 };
    var frame_circle = rl.Vector2{ .x = 0, .y = screenHeight * (2.0 / 3.0) };

    // The speed applied to both circles
    const speed = 10.0;
    const circle_radius = 32.0;

    rl.setTargetFPS(current_fps);
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // Adjust the FPS target based on the mouse wheel
        const mouse_wheel = rl.getMouseWheelMove();

        if (mouse_wheel != 0) {
            current_fps += @intFromFloat(mouse_wheel);
            if (current_fps < 0) current_fps = 0;
            rl.setTargetFPS(current_fps);
        }

        // rl.getFrameTime() returns the time it took to draw the last frame, in seconds (usually called delta time)
        // Uses the delta time to make the circle look like it's moving at a "consistent" speed regardless of FPS

        // Multiply by 6.0 (an arbitrary value) in order to make the speed
        // visually closer to the other circle (at 60 fps), for comparison
        delta_circle.x += rl.getFrameTime() * 6 * speed;
        // This circle can move faster or slower visually depending on the FPS
        frame_circle.x += 0.1 * speed;

        if (delta_circle.x > screenWidth) delta_circle.x = 0;
        if (frame_circle.x > screenWidth) frame_circle.x = 0;

        // Reset both circles positions
        if (rl.isKeyPressed(rl.KeyboardKey.r)) {
            delta_circle.x = 0;
            frame_circle.x = 0;
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.ray_white);

        // Draw both circles to the screen
        rl.drawCircleV(delta_circle, circle_radius, rl.Color.red);
        rl.drawCircleV(frame_circle, circle_radius, rl.Color.blue);

        // Draw the help text
        // Determine what help text to show depending on the current FPS target uses the c string format syntax
        const fps_text: [:0]const u8 = if (current_fps <= 0)
            rl.textFormat("FPS: unlimited (%i)", .{rl.getFPS()}) // uses C string format syntax from raylib
        else
            rl.textFormat("FPS: %i (target: %i)", .{ rl.getFPS(), current_fps });

        rl.drawText(fps_text, 10, 10, 20, rl.Color.dark_gray);
        // uses C string format syntax
        rl.drawText(rl.textFormat("Frame time: %02.02f ms", .{rl.getFrameTime()}), 10, 30, 20, rl.Color.dark_gray);
        rl.drawText("Use the scroll wheel to change the fps limit, r to reset", 10, 50, 20, rl.Color.dark_gray);

        // Draw the text above the circles
        rl.drawText("FUNC: x += rl.getFrameTime() * speed", 10, 90, 20, rl.Color.red);
        rl.drawText("FUNC: x += speed", 10, 240, 20, rl.Color.blue);
    }
}
