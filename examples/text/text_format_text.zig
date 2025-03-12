// A raylib port of https://github.com/raysan5/raylib/blob/master/examples/text/text_format_text.c

const rl = @import("raylib");
const std = @import("std");

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib [text] example - text formatting");
    defer rl.closeWindow(); // Close window and OpenGL context

    // Set as 'const' for demonstration purposes, but would need to be 'var' once you actually update them to real values.
    const score: i32 = 100020;
    const hiscore: i32 = 200450;
    const lives: i32 = 5;

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

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

        rl.clearBackground(.white);

        rl.drawText(rl.textFormat("Score: %08i", .{score}), 200, 80, 20, .red);

        rl.drawText(rl.textFormat("HiScore: %08i", .{hiscore}), 200, 120, 20, .green);

        rl.drawText(rl.textFormat("Lives: %02i", .{lives}), 200, 160, 40, .blue);

        rl.drawText(rl.textFormat("Elapsed Time: %02.02f ms", .{rl.getFrameTime() * 1000}), 200, 220, 20, .black);
        //----------------------------------------------------------------------------------
    }
}
