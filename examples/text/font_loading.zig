//!******************************************************************************************
//!
//!   raylib-zig port of the [text] example - Font loading
//!   https://github.com/raysan5/raylib/blob/master/examples/text/text_font_loading.c
//!
//!   Example complexity rating: [★☆☆☆] 1/4
//!
//!   NOTE: raylib can load fonts from multiple input file formats:
//!
//!     - TTF/OTF > Sprite font atlas is generated on loading, user can configure
//!                 some of the generation parameters (size, characters to include)
//!     - BMFonts > Angel code font fileformat, sprite font image must be provided
//!                 together with the .fnt file, font generation cna not be configured
//!     - XNA Spritefont > Sprite font image, following XNA Spritefont conventions,
//!                 Characters in image must follow some spacing and order rules
//!
//!   Example originally created with raylib 1.4, last time updated with raylib 3.0
//!
//!   Translated to raylib-zig by Timothy Fiss (@TheFissk)
//!
//!   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//!   BSD-like license that allows static linking with closed source software
//!
//!   Copyright (c) 2016-2025 Ramon Santamaria (@raysan5)
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

    rl.initWindow(screen_width, screen_height, "raylib [text] example - font loading");
    defer rl.closeWindow();

    // Define characters to draw
    // NOTE: raylib supports UTF-8 encoding, following list is actually codified as UTF8 internally
    const msg = "!\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHI\nJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmn\nopqrstuvwxyz{|}~¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓ\nÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷\nøùúûüýþÿ";

    // NOTE: Textures/Fonts MUST be loaded after Window initialization (OpenGL context is required)

    // BMFont (AngelCode) : Font data and image atlas have been generated using external program
    const font_bm = try rl.loadFont("examples/text/resources/pixantiqua.fnt");
    defer rl.unloadFont(font_bm);

    // TTF font : Font data and atlas are generated directly from TTF
    // NOTE: We define a font base size of 32 pixels tall and up-to 250 characters
    const font_ttf = try rl.loadFontEx("examples/text/resources/pixantiqua.ttf", 32, null);
    defer rl.unloadFont(font_ttf);

    rl.setTextLineSpacing(16); // Set line spacing for multiline text (when line breaks are included '\n')

    var use_ttf = false;

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        if (rl.isKeyDown(.space)) {
            use_ttf = true;
        } else {
            use_ttf = false;
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        rl.drawText("Hold SPACE to use TTF generated font", 20, 20, 20, .light_gray);

        if (!use_ttf) {
            rl.drawTextEx(font_bm, msg, .{ .x = 20.0, .y = 100.0 }, @floatFromInt(font_bm.baseSize), 2, .maroon);
            rl.drawText("Using BMFont (Angelcode) imported", 20, rl.getScreenHeight() - 30, 20, .gray);
        } else {
            rl.drawTextEx(font_ttf, msg, .{ .x = 20.0, .y = 100.0 }, @floatFromInt(font_ttf.baseSize), 2, .lime);
            rl.drawText("Using TTF font generated", 20, rl.getScreenHeight() - 30, 20, .gray);
        }

        //----------------------------------------------------------------------------------
    }
}
