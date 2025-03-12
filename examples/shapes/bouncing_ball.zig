const rl = @import("raylib");

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [shapes] example - bouncing ball");
    defer rl.closeWindow(); // Close window and OpenGL context

    var ballPosition: rl.Vector2 = rl.Vector2{
        .x = @floatFromInt(@divExact(rl.getScreenWidth(), 2)),
        .y = @floatFromInt(@divExact(rl.getScreenHeight(), 2)),
    };
    var ballSpeed: rl.Vector2 = rl.Vector2{ .x = 5.0, .y = 4.0 };
    const ballRadius: i32 = 20;

    var pause: bool = false;
    var framesCounter: i32 = 0;

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        if (rl.isKeyPressed(.space)) {
            pause = !pause;
        }

        if (!pause) {
            ballPosition.x += ballSpeed.x;
            ballPosition.y += ballSpeed.y;

            const ballWidthEdge: f32 = @floatFromInt(rl.getScreenWidth() - ballRadius);
            if ((ballPosition.x >= ballWidthEdge) or (ballPosition.x <= ballRadius)) {
                ballSpeed.x = ballSpeed.x * -1.0;
            }

            const ballHeightEdge: f32 = @floatFromInt(rl.getScreenHeight() - ballRadius);
            if ((ballPosition.y >= ballHeightEdge) or (ballPosition.y <= ballRadius)) {
                ballSpeed.y = ballSpeed.y * -1.0;
            }
        } else {
            framesCounter += 1;
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        rl.drawCircleV(ballPosition, ballRadius, .maroon);
        rl.drawText("PRESS SPACE to PAUSE BALL MOVEMENT", 10, rl.getScreenHeight() - 25, 20, .light_gray);

        // On pause, we draw a blinking message
        if (pause and @mod(@divFloor(framesCounter, 30), 2) == 0) {
            rl.drawText("PAUSED", 350, 200, 30, .gray);
        }

        rl.drawFPS(10, 10);
        //----------------------------------------------------------------------------------
    }
}
