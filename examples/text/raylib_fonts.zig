const rl = @import("raylib");
const Color = rl.Color;

const MAX_FONTS = 8;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() !void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib [text] example - raylib fonts");
    defer rl.closeWindow(); // Close window and OpenGL context

    // NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)
    var fonts: [MAX_FONTS]rl.Font = undefined;

    fonts[0] = try rl.loadFont("resources/text/fonts/alagard.png");
    fonts[1] = try rl.loadFont("resources/text/fonts/pixelplay.png");
    fonts[2] = try rl.loadFont("resources/text/fonts/mecha.png");
    fonts[3] = try rl.loadFont("resources/text/fonts/setback.png");
    fonts[4] = try rl.loadFont("resources/text/fonts/romulus.png");
    fonts[5] = try rl.loadFont("resources/text/fonts/pixantiqua.png");
    fonts[6] = try rl.loadFont("resources/text/fonts/alpha_beta.png");
    fonts[7] = try rl.loadFont("resources/text/fonts/jupiter_crash.png");

    // Fonts unloading
    defer for (fonts) |font| {
        rl.unloadFont(font);
    };

    const messages = [MAX_FONTS][:0]const u8{
        "ALAGARD FONT designed by Hewett Tsoi",
        "PIXELPLAY FONT designed by Aleksander Shevchuk",
        "MECHA FONT designed by Captain Falcon",
        "SETBACK FONT designed by Brian Kent (AEnigma)",
        "ROMULUS FONT designed by Hewett Tsoi",
        "PIXANTIQUA FONT designed by Gerhard Grossmann",
        "ALPHA_BETA FONT designed by Brian Kent (AEnigma)",
        "JUPITER_CRASH FONT designed by Brian Kent (AEnigma)",
    };

    const spacings = [_]i32{ 2, 4, 8, 4, 3, 4, 4, 1 };

    var positions: [MAX_FONTS]rl.Vector2 = undefined;
    for (0..MAX_FONTS) |i| {
        const font_base_size = @as(f32, @floatFromInt(fonts[i].baseSize));
        positions[i].x = screenWidth / 2.0 - rl.measureTextEx(fonts[i], messages[i], font_base_size * 2.0, @floatFromInt(spacings[i])).x / 2.0;
        positions[i].y = 60.0 + font_base_size + 45.0 * @as(f32, @floatFromInt(i));
    }

    // Small Y position corrections
    positions[3].y += 8;
    positions[4].y += 2;
    positions[7].y -= 8;

    const colors = [MAX_FONTS]Color{ Color.maroon, Color.orange, Color.dark_green, Color.dark_blue, Color.dark_purple, Color.lime, Color.gold, Color.red };

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

        rl.clearBackground(Color.white);

        rl.drawText("free fonts included with raylib", 250, 20, 20, Color.dark_gray);
        rl.drawLine(220, 50, 590, 50, Color.dark_gray);

        for (0..MAX_FONTS) |i| {
            const font_base_size = @as(f32, @floatFromInt(fonts[i].baseSize));
            rl.drawTextEx(fonts[i], messages[i], positions[i], font_base_size * 2.0, @floatFromInt(spacings[i]), colors[i]);
        }

        rl.endDrawing();
        //----------------------------------------------------------------------------------
    }
}
