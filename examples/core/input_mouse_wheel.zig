// raylib-zig (c) Nikolas Wipper 2023

const rl = @import("raylib");
const std = @import("std");

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [core] example - basic window");
    defer rl.closeWindow(); // Close window and OpenGL context

    var boxPositionY: f32 = screenHeight / 2 - 40;
    const scrollSpeed: f32 = 4; // Scrolling speed in pixels

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        boxPositionY -= (rl.getMouseWheelMove() * scrollSpeed);
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.white);

        rl.drawRectangle(screenWidth / 2 - 40, @as(i32, @intFromFloat(boxPositionY)), 80, 80, .maroon);

        rl.drawText("Use mouse wheel to move the cube up and down!", 10, 10, 20, .gray);

        rl.drawText(
            rl.textFormat("Box position Y: %03i", .{@as(i32, @intFromFloat(boxPositionY))}),
            10,
            40,
            20,
            .light_gray,
        );
        //----------------------------------------------------------------------------------
    }
}
