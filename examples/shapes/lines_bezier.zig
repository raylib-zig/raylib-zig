const rl = @import("raylib");

fn collisionFmt(isColliding: bool) f32 {
    if (isColliding) return 14.0;
    return 8.0;
}

fn movingFmt(isMoving: bool) rl.Color {
    if (isMoving) return .red;
    return .blue;
}

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    //rl.setConfigFlags(@enumFromInt(rl.ConfigFlags.flag_msaa_4x_hint));
    rl.initWindow(screenWidth, screenHeight, "raylib-zig [shapes] example - cubic-bezier lines");
    defer rl.closeWindow(); // Close window and OpenGL context

    var startPoint = rl.Vector2{ .x = 30, .y = 30 };
    var endPoint = rl.Vector2{ .x = screenWidth - 30, .y = screenHeight - 30 };
    var moveStartPoint = false;
    var moveEndPoint = false;

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        const mouse: rl.Vector2 = rl.getMousePosition();

        if (rl.checkCollisionPointCircle(mouse, startPoint, 10.0) and rl.isMouseButtonDown(.left)) {
            moveStartPoint = true;
        } else if (rl.checkCollisionPointCircle(mouse, endPoint, 10.0) and rl.isMouseButtonDown(.left)) {
            moveEndPoint = true;
        }

        if (moveStartPoint) {
            startPoint = mouse;
            if (rl.isMouseButtonReleased(.left)) {
                moveStartPoint = false;
            }
        }

        if (moveEndPoint) {
            endPoint = mouse;
            if (rl.isMouseButtonReleased(.left)) {
                moveEndPoint = false;
            }
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        rl.drawText("MOVE START-END POINTS WITH MOUSE", 15, 20, 20, .gray);

        // Draw line Cubic Bezier, in-out interpolation (easing), no control points
        rl.drawLineBezier(startPoint, endPoint, 4.0, .blue);

        // Draw start-end spline circles with some details
        rl.drawCircleV(startPoint, collisionFmt(rl.checkCollisionPointCircle(mouse, startPoint, 10.0)), movingFmt(moveStartPoint));
        rl.drawCircleV(endPoint, collisionFmt(rl.checkCollisionPointCircle(mouse, endPoint, 10.0)), movingFmt(moveEndPoint));
        //----------------------------------------------------------------------------------
    }
}
