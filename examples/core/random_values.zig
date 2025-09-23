//! # raylib-zig [core] example - Generate random values
//!
//! raylib-zig (c) Nikolas Wipper 2025

const rl = @import("raylib");

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    rl.initWindow(screen_width, screen_height, "raylib-zig [core] example - generate random values");
    defer rl.closeWindow(); // Close window and OpenGL context

    // Set a custom random seed if desired, by default: "std.time.timestamp()"
    // rl.setRandomSeed(0xaabbccff);

    // Get a random integer number between -8 and 5 (both included)
    var rand_value = rl.getRandomValue(-8, 5);

    var frames_counter: u32 = 0;

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        frames_counter += 1;

        // Every two seconds (120 frames) a new random value is generated
        if (((frames_counter / 120) % 2) == 1) {
            rand_value = rl.getRandomValue(-8, 5);
            frames_counter = 0;
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();

        rl.clearBackground(.white);

        rl.drawText("Every 2 seconds a new random value is generated:", 130, 100, 20, .maroon);

        rl.drawText(rl.textFormat("%i", .{rand_value}), 360, 180, 80, .light_gray);

        rl.endDrawing();
        //----------------------------------------------------------------------------------
    }
}
