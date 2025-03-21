//! # raylib-zig [core] example - Custom frame control
//!
//! raylib-zig (c) Nikolas Wipper 2025

// TODO: As SUPPORT_CUSTOM_FRAME_CONTROL is required to be set
//       the build system should support examples setting config flags.
//       Until then this example just sits here.

const rl = @import("raylib");

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    rl.initWindow(screen_width, screen_height, "raylib-zig [core] example - custom frame control");
    defer rl.closeWindow(); // Close window and OpenGL context

    // Custom timing variables
    var previous_time: f64 = rl.getTime(); // Previous time measure
    var current_time: f64 = 0; // Current time measure
    var update_draw_time: f64 = 0; // Update + Draw time
    var wait_time: f64 = 0; // Wait time (if target fps required)
    var delta_time: f32 = 0; // Frame time (Update + Draw + Wait time)

    var time_counter: f32 = 0; // Accumulative time counter (seconds)
    var position: f32 = 0; // Circle position
    var pause: bool = false; // Pause control flag

    var target_fps: u32 = 120; // Our initial target fps
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        rl.pollInputEvents(); // Poll input events (SUPPORT_CUSTOM_FRAME_CONTROL)

        if (rl.isKeyPressed(.space))
            pause = !pause;

        // change target fps
        if (rl.isKeyPressed(.up)) {
            const ov = @addWithOverflow(target_fps, 20);
            if (ov[1] == 0)
                target_fps += 20;
        } else if (rl.isKeyPressed(.down)) {
            const ov = @subWithOverflow(target_fps, 20);
            if (ov[1] == 0)
                target_fps -= 20;
        }

        if (target_fps < 0)
            target_fps = 0;

        if (!pause) {
            position += 200 * delta_time; // We move at 200 pixels per second
            if (position >= @as(f32, @floatFromInt(rl.getScreenWidth())))
                position = 0;
            time_counter += delta_time; // We count time (seconds)
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();

        rl.clearBackground(.white);

        for (0..@abs(@divFloor(rl.getScreenWidth(), 200))) |i|
            rl.drawRectangle(@intCast(200 * i), 0, 1, rl.getScreenHeight(), .sky_blue);

        rl.drawCircle(@intFromFloat(position), @divExact(rl.getScreenHeight(), 2) - 25, 50, .red);

        rl.drawText(
            rl.textFormat("%03.0f ms", .{time_counter * 1000}),
            @intFromFloat(position - 40),
            @divExact(rl.getScreenHeight(), 2) - 100,
            20,
            .maroon,
        );
        rl.drawText(
            rl.textFormat("PosX: %03.0f", .{position}),
            @intFromFloat(position - 50),
            @divExact(rl.getScreenHeight(), 2) + 40,
            20,
            .black,
        );

        rl.drawText(
            "Circle is moving at a constant 200 pixels/sec,\nindependently of the frame rate.",
            10,
            10,
            20,
            .dark_gray,
        );
        rl.drawText(
            "PRESS SPACE to PAUSE MOVEMENT",
            10,
            rl.getScreenHeight() - 60,
            20,
            .gray,
        );
        rl.drawText(
            "PRESS UP | DOWN to CHANGE TARGET FPS",
            10,
            rl.getScreenHeight() - 30,
            20,
            .gray,
        );
        rl.drawText(
            rl.textFormat("TARGET FPS: %i", .{target_fps}),
            rl.getScreenWidth() - 220,
            10,
            20,
            .lime,
        );
        rl.drawText(
            rl.textFormat("CURRENT FPS: %.0f", .{@round(1 / delta_time)}),
            rl.getScreenWidth() - 220,
            40,
            20,
            .green,
        );

        rl.endDrawing();

        // NOTE: In case raylib is configured to SUPPORT_CUSTOM_FRAME_CONTROL,
        // Events polling, screen buffer swap and frame time control must be managed by the user

        rl.swapScreenBuffer(); // Flip the back buffer to screen (front buffer)

        current_time = rl.getTime();
        update_draw_time = current_time - previous_time;

        if (target_fps > 0) { // We want a fixed frame rate
            wait_time = (1 / @as(f64, @floatFromInt(target_fps))) - update_draw_time;
            if (wait_time > 0.0) {
                rl.waitTime(wait_time);
                current_time = rl.getTime();
                delta_time = @floatCast(current_time - previous_time);
            }
        } else delta_time = @floatCast(update_draw_time); // Framerate could be variable

        previous_time = current_time;
        //----------------------------------------------------------------------------------
    }
}
