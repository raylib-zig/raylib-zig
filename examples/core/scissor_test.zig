//! # raylib-zig [core] example - Scissor test
//!
//! raylib-zig (c) Nikolas Wipper 2025

const rl = @import("raylib");

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    rl.initWindow(screen_width, screen_height, "raylib-zig [core] example - scissor test");

    var scissor_area = rl.Rectangle.init(0, 0, 300, 300);
    var scissor_mode: bool = true;

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        if (rl.isKeyPressed(.s))
            scissor_mode = !scissor_mode;

        // Centre the scissor area around the mouse position
        scissor_area.x = @as(f32, @floatFromInt(rl.getMouseX())) - scissor_area.width / 2;
        scissor_area.y = @as(f32, @floatFromInt(rl.getMouseY())) - scissor_area.height / 2;
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();

        rl.clearBackground(.white);

        if (scissor_mode)
            rl.beginScissorMode(
                @intFromFloat(scissor_area.x),
                @intFromFloat(scissor_area.y),
                @intFromFloat(scissor_area.width),
                @intFromFloat(scissor_area.height),
            );

        // Draw full screen rectangle and some text
        // NOTE: Only part defined by scissor area will be rendered
        rl.drawRectangle(0, 0, rl.getScreenWidth(), rl.getScreenHeight(), .red);
        rl.drawText("Move the mouse around to reveal this text!", 190, 200, 20, .light_gray);

        if (scissor_mode)
            rl.endScissorMode();

        rl.drawRectangleLinesEx(scissor_area, 1, .black);
        rl.drawText("Press S to toggle scissor test", 10, 10, 20, .black);

        rl.endDrawing();
        //----------------------------------------------------------------------------------
    }
}
