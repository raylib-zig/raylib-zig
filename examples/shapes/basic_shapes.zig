const rl = @import("raylib");

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [shapes] example - basic shapes drawing");
    defer rl.closeWindow(); // Close window and OpenGL context

    var rotation: f32 = 0.0;

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        rotation += 0.2;
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        rl.drawText("some basic shapes available on raylib", 20, 20, 20, .dark_gray);

        // Circle shapes and lines
        rl.drawCircle(screenWidth / 5, 120, 35, .dark_blue);
        rl.drawCircleGradient(screenWidth / 5, 220, 60, .green, .sky_blue);
        rl.drawCircleLines(screenWidth / 5, 340, 80, .dark_blue);

        // Rectangle shapes and lines
        rl.drawRectangle(screenWidth / 4 * 2 - 60, 100, 120, 60, .red);
        rl.drawRectangleGradientH(screenWidth / 4 * 2 - 90, 170, 180, 130, .maroon, .gold);
        rl.drawRectangleLines(screenWidth / 4 * 2 - 40, 320, 80, 60, .orange); // NOTE: Uses QUADS internally, not lines

        // Triangle shapes and lines
        rl.drawTriangle(.{ .x = (screenWidth / 4.0 * 3.0), .y = 80.0 }, .{ .x = (screenWidth / 4.0 * 3.0 - 60.0), .y = 150.0 }, .{ .x = (screenWidth / 4.0 * 3.0 + 60.0), .y = 150.0 }, .violet);

        rl.drawTriangleLines(.{ .x = (screenWidth / 4.0 * 3.0), .y = 160.0 }, .{ .x = (screenWidth / 4.0 * 3.0 - 20.0), .y = 230.0 }, .{ .x = (screenWidth / 4.0 * 3.0 + 20.0), .y = 230.0 }, .dark_blue);

        // Polygon shapes and lines
        rl.drawPoly(.{ .x = (screenWidth / 4.0 * 3), .y = 330 }, 6, 80, rotation, .brown);
        rl.drawPolyLines(.{ .x = (screenWidth / 4.0 * 3), .y = 330 }, 6, 90, rotation, .brown);
        rl.drawPolyLinesEx(.{ .x = (screenWidth / 4.0 * 3), .y = 330 }, 6, 85, rotation, 6, .beige);

        // NOTE: We draw all LINES based shapes together to optimize internal drawing,
        // this way, all LINES are rendered in a single draw pass
        rl.drawLine(18, 42, screenWidth - 18, 42, .black);
        //----------------------------------------------------------------------------------
    }
}
