//!******************************************************************************************
//!
//!   raylib-zig port of the [text] example - Sprite font loading
//!   https://github.com/raysan5/raylib/blob/master/examples/text/text_font_spritefont.c
//!
//!   Example complexity rating: [★☆☆☆] 1/4
//!
//!   NOTE: Sprite fonts should be generated following this conventions:
//!
//!     - Characters must be ordered starting with character 32 (Space)
//!     - Every character must be contained within the same Rectangle height
//!     - Every character and every line must be separated by the same distance (margin/padding)
//!     - Rectangles must be defined by a MAGENTA color background
//!
//!   Following those constraints, a font can be provided just by an image,
//!   this is quite handy to avoid additional font descriptor files (like BMFonts use).
//!
//!   Example originally created with raylib 1.0, last time updated with raylib 1.0
//!
//!   Translated to raylib-zig by Timothy Fiss (@TheFissk)
//!
//!   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//!   BSD-like license that allows static linking with closed source software
//!
//!   Copyright (c) 2014-2025 Ramon Santamaria (@raysan5)
//!
//!*******************************************************************************************

const rl = @import("raylib");

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    rl.initWindow(screen_width, screen_height, "raylib [text] example - sprite font loading");
    defer rl.closeWindow();

    const msg1 = "THIS IS A custom SPRITE FONT...";
    const msg2 = "...and this is ANOTHER CUSTOM font...";
    const msg3 = "...and a THIRD one! GREAT! :D";

    // NOTE: Textures/Fonts MUST be loaded after Window initialization (OpenGL context is required)
    const font1 = try rl.loadFont("examples/text/resources/custom_mecha.png"); // Font loading
    defer rl.unloadFont(font1);
    const font2 = try rl.loadFont("examples/text/resources/custom_alagard.png"); // Font loading
    defer rl.unloadFont(font2);
    const font3 = try rl.loadFont("examples/text/resources/custom_jupiter_crash.png"); // Font loading
    defer rl.unloadFont(font3);

    const font_position1 = rl.Vector2{
        .x = @as(f32, @floatFromInt(screen_width)) / 2.0 - rl.measureTextEx(font1, msg1, @floatFromInt(font1.baseSize), -3).x / 2,
        .y = @as(f32, @floatFromInt(screen_height)) / 2.0 - @as(f32, @floatFromInt(font1.baseSize)) / 2.0 - 80.0,
    };

    const font_position2 = rl.Vector2{
        .x = @as(f32, @floatFromInt(screen_width)) / 2.0 - rl.measureTextEx(font2, msg2, @floatFromInt(font2.baseSize), -2).x / 2,
        .y = @as(f32, @floatFromInt(screen_height)) / 2.0 - @as(f32, @floatFromInt(font1.baseSize)) / 2.0 - 10.0,
    };

    const font_position3 = rl.Vector2{
        .x = @as(f32, @floatFromInt(screen_width)) / 2.0 - rl.measureTextEx(font3, msg3, @floatFromInt(font3.baseSize), 2).x / 2,
        .y = @as(f32, @floatFromInt(screen_height)) / 2.0 - @as(f32, @floatFromInt(font1.baseSize)) / 2.0 + 50.0,
    };

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update variables here...
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        rl.drawTextEx(font1, msg1, font_position1, @floatFromInt(font1.baseSize), -3, .white);
        rl.drawTextEx(font2, msg2, font_position2, @floatFromInt(font2.baseSize), -2, .white);
        rl.drawTextEx(font3, msg3, font_position3, @floatFromInt(font3.baseSize), 2, .white);

        //----------------------------------------------------------------------------------
    }
}
