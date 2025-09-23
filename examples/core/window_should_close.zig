//! # raylib-zig [core] example - Window should close
//!
//! raylib-zig (c) Nikolas Wipper 2025

const rl = @import("raylib");

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    rl.initWindow(screen_width, screen_height, "raylib-zig [core] example - window should close");
    defer rl.closeWindow(); // Close window and OpenGL context

    // Disable KEY_ESCAPE to close window, the window's "X-button" still works
    rl.setExitKey(.null);

    var exit_window_requested: bool = false; // Flag to request window to exit
    var exit_window: bool = false; // Flag to set window to exit

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!exit_window) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // Detect if "X-button" or KEY_ESCAPE have been pressed to close window
        if (rl.windowShouldClose() or rl.isKeyPressed(.escape))
            exit_window_requested = true;

        if (exit_window_requested) {
            // A request for close window has been issued, we can save data before closing
            // or just show a message asking for confirmation

            if (rl.isKeyPressed(.y))
                exit_window = true
            else if (rl.isKeyPressed(.n))
                exit_window_requested = false;
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();

        rl.clearBackground(.white);

        if (exit_window_requested) {
            rl.drawRectangle(0, 100, screen_width, 200, .black);
            rl.drawText(
                "Are you sure you want to exit program? [Y/N]",
                40,
                180,
                30,
                .white,
            );
        } else rl.drawText(
            "Try to close the window to get confirmation message!",
            120,
            200,
            20,
            .light_gray,
        );

        rl.endDrawing();
        //----------------------------------------------------------------------------------
    }
}
