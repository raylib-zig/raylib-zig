const std = @import("std");
const math = std.math;
const rl = @import("raylib");

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [shapes] example - following eyes");
    defer rl.closeWindow(); // Close window and OpenGL context

    const scleraLeftPosition = rl.Vector2{ .x = @as(f32, @floatFromInt(rl.getScreenWidth())) / 2.0 - 100.0, .y = @as(f32, @floatFromInt(rl.getScreenHeight())) / 2.0 };
    const scleraRightPosition = rl.Vector2{ .x = @as(f32, @floatFromInt(rl.getScreenWidth())) / 2.0 + 100.0, .y = @as(f32, @floatFromInt(rl.getScreenHeight())) / 2.0 };
    const scleraRadius: i32 = 80;

    var irisLeftPosition = rl.Vector2{ .x = @as(f32, @floatFromInt(rl.getScreenWidth())) / 2.0 - 100.0, .y = @as(f32, @floatFromInt(rl.getScreenHeight())) / 2.0 };
    var irisRightPosition = rl.Vector2{ .x = @as(f32, @floatFromInt(rl.getScreenWidth())) / 2.0 + 100.0, .y = @as(f32, @floatFromInt(rl.getScreenHeight())) / 2.0 };
    const irisRadius: i32 = 24;

    var angle: f32 = 0.0;
    var dx: f32 = 0.0;
    var dy: f32 = 0.0;
    var dxx: f32 = 0.0;
    var dyy: f32 = 0.0;

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        irisLeftPosition = rl.getMousePosition();
        irisRightPosition = rl.getMousePosition();

        // Check not inside the left eye sclera
        if (!rl.checkCollisionPointCircle(irisLeftPosition, scleraLeftPosition, scleraRadius - irisRadius)) {
            dx = irisLeftPosition.x - scleraLeftPosition.x;
            dy = irisLeftPosition.y - scleraLeftPosition.y;

            angle = math.atan2(dy, dx);

            dxx = (scleraRadius - irisRadius) * math.cos(angle);
            dyy = (scleraRadius - irisRadius) * math.sin(angle);

            irisLeftPosition.x = scleraLeftPosition.x + dxx;
            irisLeftPosition.y = scleraLeftPosition.y + dyy;
        }

        // Check not inside the right eye sclera
        if (!rl.checkCollisionPointCircle(irisRightPosition, scleraRightPosition, scleraRadius - irisRadius)) {
            dx = irisRightPosition.x - scleraRightPosition.x;
            dy = irisRightPosition.y - scleraRightPosition.y;

            angle = math.atan2(dy, dx);

            dxx = (scleraRadius - irisRadius) * math.cos(angle);
            dyy = (scleraRadius - irisRadius) * math.sin(angle);

            irisRightPosition.x = scleraRightPosition.x + dxx;
            irisRightPosition.y = scleraRightPosition.y + dyy;
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.drawCircleV(scleraLeftPosition, scleraRadius, .light_gray);
        rl.drawCircleV(irisLeftPosition, irisRadius, .brown);
        rl.drawCircleV(irisLeftPosition, 10, .black);

        rl.drawCircleV(scleraRightPosition, scleraRadius, .light_gray);
        rl.drawCircleV(irisRightPosition, irisRadius, .dark_green);
        rl.drawCircleV(irisRightPosition, 10, .black);

        rl.drawFPS(10, 10);

        rl.clearBackground(.ray_white);
        //----------------------------------------------------------------------------------
    }
}
