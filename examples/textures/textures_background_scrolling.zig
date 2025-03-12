//! # raylib-zig [textures] example - background scrolling
//!
//! Example licensed under an unmodified zlib/libpng license, which is an
//! OSI-certified, BSD-like license that allows static linking with closed
//! source software
//!
//! Copyright (c) Nikolas Wipper 2024

const rl = @import("raylib");

const screen_width = 800;
const screen_height = 450;

pub fn main() anyerror!void {

    // Initialization
    //--------------------------------------------------------------------------------------
    rl.initWindow(screen_width, screen_height, "raylib [textures] example - background scrolling");
    defer rl.closeWindow(); // Close window and OpenGL context

    // NOTE: Be careful, background width must be equal or bigger than screen width
    // if not, texture should be draw more than two times for scrolling effect
    const background = try rl.loadTexture("resources/textures/cyberpunk_street_background.png");
    const midground = try rl.loadTexture("resources/textures/cyberpunk_street_midground.png");
    const foreground = try rl.loadTexture("resources/textures/cyberpunk_street_foreground.png");
    defer rl.unloadTexture(background); // Unload background texture
    defer rl.unloadTexture(midground); // Unload midground texture
    defer rl.unloadTexture(foreground); // Unload foreground texture

    var scrolling_back: f32 = 0;
    var scrolling_mid: f32 = 0;
    var scrolling_fore: f32 = 0;

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        scrolling_back -= 0.1;
        scrolling_mid -= 0.5;
        scrolling_fore -= 1.0;

        // NOTE: Texture is scaled twice its size, so it sould be considered on scrolling
        if (scrolling_back <= @as(f32, @floatFromInt(-background.width * 2))) scrolling_back = 0;
        if (scrolling_mid <= @as(f32, @floatFromInt(-midground.width * 2))) scrolling_mid = 0;
        if (scrolling_fore <= @as(f32, @floatFromInt(-foreground.width * 2))) scrolling_fore = 0;
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        {
            rl.beginDrawing();
            defer rl.endDrawing();

            rl.clearBackground(rl.getColor(0x052c46ff));
            // Draw background image twice
            // NOTE: Texture is scaled twice its size
            rl.drawTextureEx(
                background,
                .init(scrolling_back, 20.0),
                0.0,
                2.0,
                .white,
            );
            rl.drawTextureEx(
                background,
                .init(@as(f32, @floatFromInt(background.width * 2)) + scrolling_back, 20),
                0.0,
                2.0,
                .white,
            );

            // Draw midground image twice
            rl.drawTextureEx(
                midground,
                .init(scrolling_mid, 20.0),
                0.0,
                2.0,
                .white,
            );
            rl.drawTextureEx(
                midground,
                .init(@as(f32, @floatFromInt(midground.width * 2)) + scrolling_mid, 20),
                0.0,
                2.0,
                .white,
            );

            // Draw foreground image twice
            rl.drawTextureEx(
                foreground,
                .init(scrolling_fore, 70.0),
                0.0,
                2.0,
                .white,
            );
            rl.drawTextureEx(
                foreground,
                .init(@as(f32, @floatFromInt(foreground.width * 2)) + scrolling_fore, 70),
                0.0,
                2.0,
                .white,
            );

            rl.drawText(
                "BACKGROUND SCROLLING & PARALLAX",
                10,
                10,
                20,
                .red,
            );
            rl.drawText(
                "(c) Cyberpunk Street Environment by Luis Zuno (@ansimuz)",
                screen_width - 330,
                screen_height - 20,
                10,
                .ray_white,
            );
        }
    }
}
