// raylib-zig (c) Nikolas Wipper 2023

const rl = @import("raylib");

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [shapes] example - raylib logo using shapes");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    const raylib_zig = rl.Color.init(247, 164, 29, 255);

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        rl.drawRectangle(screenWidth / 2 - 128, screenHeight / 2 - 128, 256, 256, raylib_zig);
        rl.drawRectangle(screenWidth / 2 - 112, screenHeight / 2 - 112, 224, 224, .ray_white);
        rl.drawText("raylib-zig", screenWidth / 2 - 96, screenHeight / 2 + 57, 41, raylib_zig);

        rl.drawText("this is NOT a texture!", 350, 370, 10, .gray);
        //----------------------------------------------------------------------------------
    }
}
