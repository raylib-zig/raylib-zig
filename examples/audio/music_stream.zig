const rl = @import("raylib");

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() !void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib [audio] example - music playing (streaming)");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.initAudioDevice(); // Initialize audio device
    defer rl.closeAudioDevice(); // Close audio device (music streaming is automatically stopped)

    const music: rl.Music = try rl.loadMusicStream("resources/audio/country.mp3");
    defer rl.unloadMusicStream(music); // Unload music stream buffers from RAM

    rl.playMusicStream(music);

    var timePlayed: f32 = 0; // Time played normalized [0.0f..1.0f]
    var pause: bool = false; // Music playing paused

    rl.setTargetFPS(30); // Set our game to run at 30 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        rl.updateMusicStream(music); // Update music buffer with new stream data

        // Restart music playing (stop and play)
        if (rl.isKeyPressed(.space)) {
            rl.stopMusicStream(music);
            rl.playMusicStream(music);
        }

        // Pause/Resume music playing
        if (rl.isKeyPressed(.p)) {
            pause = !pause;

            if (pause) {
                rl.pauseMusicStream(music);
            } else {
                rl.resumeMusicStream(music);
            }
        }

        // Get normalized time played for current music stream
        timePlayed = rl.getMusicTimePlayed(music) / rl.getMusicTimeLength(music);

        if (timePlayed > 1.0) {
            timePlayed = 1.0; // Make sure time played is no longer than music
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.white);

        rl.drawText("MUSIC SHOULD BE PLAYING!", 255, 150, 20, .light_gray);

        rl.drawRectangle(200, 200, 400, 12, .light_gray);
        rl.drawRectangle(200, 200, @intFromFloat(timePlayed * 400), 12, .maroon);
        rl.drawRectangleLines(200, 200, 400, 12, .gray);

        rl.drawText("PRESS SPACE TO RESTART MUSIC", 215, 250, 20, .light_gray);
        rl.drawText("PRESS P TO PAUSE/RESUME MUSIC", 208, 280, 20, .light_gray);
        //----------------------------------------------------------------------------------
    }
}
