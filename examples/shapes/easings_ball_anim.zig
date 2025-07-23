const rl = @import("raylib");
const reasings = @import("reasings.zig");

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib [shapes] example - easings ball anim");
    defer rl.closeWindow(); // Defer closing window and OpenGL context

    // Ball variable value to be animated with easings
    var ballPositionX: i32 = -100;
    var ballRadius: f32 = 20;
    var ballAlpha: f32 = 0;

    var state: i32 = 0;
    var framesCounter: i32 = 0;

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        switch (state) {
            0 => { // Move ball position X with easing
                framesCounter += 1;
                ballPositionX = @intFromFloat(reasings.elasticOut(@floatFromInt(framesCounter), -100, @as(f32, @floatFromInt(screenWidth)) / 2 + 100, 120));

                if (framesCounter >= 120) {
                    framesCounter = 0;
                    state = 1;
                }
            },
            1 => { // Increase ball radius with easing
                framesCounter += 1;
                ballRadius = reasings.elasticIn(@floatFromInt(framesCounter), 20, 500, 200);

                if (framesCounter >= 200) {
                    framesCounter = 0;
                    state = 2;
                }
            },
            2 => { // Change ball alpha with easing (background color blending)
                framesCounter += 1;
                ballAlpha = reasings.cubicOut(@floatFromInt(framesCounter), 0.0, 1.0, 200);
                if (framesCounter >= 200) {
                    framesCounter = 0;
                    state = 3;
                }
            },
            3 => { // Reset state to play again
                if (rl.isKeyPressed(.enter)) {
                    ballPositionX = -100;
                    ballRadius = 20;
                    ballAlpha = 0.0;
                    state = 0;
                }
            },
            else => unreachable,
        }

        if (rl.isKeyPressed(.r)) framesCounter = 0;
        //----------------------------------------------------------------------------------
        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        if (state >= 2) rl.drawRectangle(0, 0, screenWidth, screenHeight, .green);
        rl.drawCircle(ballPositionX, 200, ballRadius, .fade(.red, 1.0 - ballAlpha));

        if (state == 3) rl.drawText("PRESS [ENTER] TO PLAY AGAIN!", 240, 200, 20, .black);

        //----------------------------------------------------------------------------------
    }
}
