const rl = @import("raylib");

fn boxFmt(colliding: bool) rl.Color {
    if (colliding) return .red;
    return .black;
}

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [shapes] example - collision area");
    defer rl.closeWindow(); // Close window and OpenGL context

    // Box A: Movingbox
    var boxA = rl.Rectangle{ .x = 10, .y = (@as(f32, @floatFromInt(rl.getScreenHeight())) / 2.0) - 50, .width = 200, .height = 100 };
    var boxASpeedX: f32 = 4;

    // Box B: Mouse moved box
    var boxB = rl.Rectangle{ .x = (@as(f32, @floatFromInt(rl.getScreenWidth())) / 2.0) - 30, .y = (@as(f32, @floatFromInt(rl.getScreenHeight())) / 2.0) - 30, .width = 60, .height = 60 };

    var boxCollision = rl.Rectangle{ .x = 0, .y = 0, .width = 0, .height = 0 };

    const screenUpperLimit = 40;

    var pause = false;
    var collision = false;

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // Move box if not paused
        if (!pause) {
            boxA.x += boxASpeedX;
        }

        // Bounce box on x screen limits
        if ((boxA.x + boxA.width) >= @as(f32, @floatFromInt(rl.getScreenWidth())) or (boxA.x <= 0)) {
            boxASpeedX *= -1;
        }

        // Update player-controlled-box (box02)
        boxB.x = @as(f32, @floatFromInt(rl.getMouseX())) - boxB.width / 2;
        boxB.y = @as(f32, @floatFromInt(rl.getMouseY())) - boxB.height / 2;

        // Make sure Box B does not go out of move area limits
        if ((boxB.x + boxB.width) >= @as(f32, @floatFromInt(rl.getScreenWidth()))) {
            boxB.x = @as(f32, @floatFromInt(rl.getScreenWidth())) - boxB.width;
        } else if (boxB.x <= 0) {
            boxB.x = 0;
        }

        if ((boxB.y + boxB.height) >= @as(f32, @floatFromInt(rl.getScreenHeight()))) {
            boxB.y = @as(f32, @floatFromInt(rl.getScreenHeight())) - boxB.height;
        } else if (boxB.y <= screenUpperLimit) {
            boxB.y = screenUpperLimit;
        }

        // Check boxes collision
        collision = rl.checkCollisionRecs(boxA, boxB);

        // Get collision rectangle (only on collision)
        if (collision) {
            boxCollision = rl.getCollisionRec(boxA, boxB);
        }

        // Pause Box A movement
        if (rl.isKeyPressed(.space)) {
            pause = !pause;
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.drawRectangle(0, 0, screenWidth, screenUpperLimit, boxFmt(collision));

        rl.drawRectangleRec(boxA, .gold);
        rl.drawRectangleRec(boxB, .blue);

        if (collision) {
            // Draw collision area
            rl.drawRectangleRec(boxCollision, .lime);

            // Draw collision message
            rl.drawText(
                "COLLISION!",
                @divFloor(rl.getScreenWidth(), @as(i32, 2)) - @divFloor(rl.measureText("COLLISION!", 20), @as(i32, 2)),
                screenUpperLimit / 2 - 10,
                20,
                .black,
            );

            // Draw collision area
            rl.drawText(rl.textFormat("Collision Area: %i", .{@as(i32, @intFromFloat(boxCollision.width * boxCollision.height))}), @divFloor(rl.getScreenWidth(), 2) - 100, screenUpperLimit + 10, 20, .black);
        }

        // Draw help instructions
        rl.drawText("Press SPACE to PAUSE/RESUME", 20, screenHeight - 35, 20, .light_gray);

        rl.drawFPS(10, 10);

        rl.clearBackground(.ray_white);
        //----------------------------------------------------------------------------------
    }
}
