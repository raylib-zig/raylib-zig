const rl = @import("raylib");

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() !void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib [audio] example - sound loading and playing");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.initAudioDevice(); // Initialize audio device
    defer rl.closeAudioDevice(); // Close audio device

    const fxWav: rl.Sound = try rl.loadSound("resources/audio/sound.wav"); // Load WAV audio file
    const fxOgg: rl.Sound = try rl.loadSound("resources/audio/target.ogg"); // Load OGG audio file
    defer rl.unloadSound(fxWav); // Unload sound data
    defer rl.unloadSound(fxOgg); // Unload sound data

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        if (rl.isKeyPressed(.space)) rl.playSound(fxWav); // Play WAV sound
        if (rl.isKeyPressed(.enter)) rl.playSound(fxOgg); // Play OGG sound
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.white);

        rl.drawText("Press SPACE to PLAY the WAV sound!", 200, 180, 20, .light_gray);
        rl.drawText("Press ENTER to PLAY the OGG sound!", 200, 220, 20, .light_gray);
        //----------------------------------------------------------------------------------
    }
}
