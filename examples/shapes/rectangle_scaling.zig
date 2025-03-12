const rl = @import("raylib");

const mouseScaleMarkSize = 12;

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [shapes] example - rectangle scaling mouse");
    defer rl.closeWindow(); // Close window and OpenGL context

    var rec: rl.Rectangle = rl.Rectangle{ .x = 100, .y = 100, .width = 200, .height = 80 };
    var mousePosition: rl.Vector2 = rl.Vector2{ .x = 0, .y = 0 };

    var mouseScaleReady: bool = false;
    var mouseScaleMode: bool = false;

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        mousePosition = rl.getMousePosition();

        if (rl.checkCollisionPointRec(mousePosition, rl.Rectangle{ .x = (rec.x + rec.width) - mouseScaleMarkSize, .y = (rec.y + rec.height) - mouseScaleMarkSize, .width = mouseScaleMarkSize, .height = mouseScaleMarkSize })) {
            mouseScaleReady = true;
            if (rl.isMouseButtonPressed(.left)) {
                mouseScaleMode = true;
            }
        } else {
            mouseScaleReady = false;
        }

        if (mouseScaleMode) {
            mouseScaleReady = true;

            rec.width = (mousePosition.x - rec.x);
            rec.height = (mousePosition.y - rec.y);

            // Check minimum rec size
            if (rec.width < mouseScaleMarkSize) {
                rec.width = mouseScaleMarkSize;
            }
            if (rec.height < mouseScaleMarkSize) {
                rec.height = mouseScaleMarkSize;
            }

            // Check maximum rec size
            if (rec.width > (@as(f32, @floatFromInt(rl.getScreenWidth())) - rec.x)) {
                rec.width = @as(f32, @floatFromInt(rl.getScreenWidth())) - rec.x;
            }
            if (rec.height > (@as(f32, @floatFromInt(rl.getScreenHeight())) - rec.y)) {
                rec.height = @as(f32, @floatFromInt(rl.getScreenHeight())) - rec.y;
            }

            if (rl.isMouseButtonReleased(.left)) {
                mouseScaleMode = false;
            }
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        rl.drawText("Scale rectangle dragging from bottom-right corner!", 10, 10, 20, .gray);

        rl.drawRectangleRec(rec, .fade(.green, 0.5));

        if (mouseScaleReady) {
            rl.drawRectangleLinesEx(rec, 1, .red);
            rl.drawTriangle(rl.Vector2{ .x = rec.x + rec.width - mouseScaleMarkSize, .y = rec.y + rec.height }, rl.Vector2{ .x = rec.x + rec.width, .y = rec.y + rec.height }, rl.Vector2{ .x = rec.x + rec.width, .y = rec.y + rec.height - mouseScaleMarkSize }, .red);
        }
        //----------------------------------------------------------------------------------
    }
}
