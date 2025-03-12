// raylib-zig (c) Nikolas Wipper 2023

const rl = @import("raylib");

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [core] example - mouse input");
    defer rl.closeWindow(); // Close window and OpenGL context

    var ballPosition = rl.Vector2.init(-100, -100);
    var ballColor = rl.Color.dark_blue;

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        ballPosition = rl.getMousePosition();
        ballPosition.x = @as(f32, @floatFromInt(rl.getMouseX()));
        ballPosition.y = @as(f32, @floatFromInt(rl.getMouseY()));

        if (rl.isMouseButtonPressed(.left)) {
            ballColor = .maroon;
        } else if (rl.isMouseButtonPressed(.middle)) {
            ballColor = .lime;
        } else if (rl.isMouseButtonPressed(.right)) {
            ballColor = .dark_blue;
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        rl.drawCircleV(ballPosition, 40, ballColor);

        rl.drawText("move ball with mouse and click mouse button to change color", 10, 10, 20, .dark_gray);
        //----------------------------------------------------------------------------------
    }
}
