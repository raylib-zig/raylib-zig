//! # raylib-zig [core] example - Input multitouch
//!
//! raylib-zig (c) Nikolas Wipper 2025

const rl = @import("raylib");

const MAX_TOUCH_POINTS = 10;

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    rl.initWindow(screen_width, screen_height, "raylib-zig [core] example - input multitouch");
    defer rl.closeWindow(); // Close window and OpenGL context

    var touch_positions: [MAX_TOUCH_POINTS]rl.Vector2 = undefined;

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // Get the touch point count ( how many fingers are touching the screen )
        const touch_count = rl.getTouchPointCount();
        // Clamp touch_count and get touch points positions
        for (0..@min(@as(usize, @intCast(touch_count)), MAX_TOUCH_POINTS)) |i|
            touch_positions[i] = rl.getTouchPosition(@intCast(i));
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();

        rl.clearBackground(.white);

        for (0..@intCast(touch_count)) |i| {
            // Make sure point is not (0, 0) as this means there is no touch for it
            if ((touch_positions[i].x > 0) and (touch_positions[i].y > 0)) {
                // Draw circle and touch index number
                rl.drawCircleV(touch_positions[i], 34, .orange);
                rl.drawText(
                    rl.textFormat("%d", .{i}),
                    @as(i32, @intFromFloat(touch_positions[i].x)) - 10,
                    @as(i32, @intFromFloat(touch_positions[i].y)) - 70,
                    40,
                    .black,
                );
            }
        }

        rl.drawText(
            "touch the screen at multiple locations to get multiple balls",
            10,
            10,
            20,
            .dark_gray,
        );

        rl.endDrawing();
        //----------------------------------------------------------------------------------
    }
}
