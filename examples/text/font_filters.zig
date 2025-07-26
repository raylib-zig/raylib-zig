//!*******************************************************************************************
//!
//!   raylib-zig port of the [text] example - Font filters
//!   https://github.com/raysan5/raylib/blob/master/examples/text/text_font_filters.c
//!
//!   Example complexity rating: [★★☆☆] 2/4
//!
//!   NOTE: After font loading, font texture atlas filter could be configured for a softer
//!   display of the font when scaling it to different sizes, that way, it's not required
//!   to generate multiple fonts at multiple sizes (as long as the scaling is not very different)
//!
//!   Example originally created with raylib 1.3, last time updated with raylib 4.2
//!
//!   Translated to raylib-zig by Timothy Fiss (@TheFissk)
//!
//!   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//!   BSD-like license that allows static linking with closed source software
//!
//!   Copyright (c) 2015-2025 Ramon Santamaria (@raysan5)
//!
//!*******************************************************************************************

const std = @import("std");
const rl = @import("raylib");

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    rl.initWindow(screen_width, screen_height, "raylib [text] example - font filters");
    defer rl.closeWindow();

    const msg = "Loaded Font";

    // NOTE: Textures/Fonts MUST be loaded after Window initialization (OpenGL context is required)

    // TTF Font loading with custom generation parameters
    var font = try rl.loadFontEx("examples/text/resources/KAISG.ttf", 96, null);

    // Generate mipmap levels to use trilinear filtering
    // NOTE: On 2D drawing it won't be noticeable, it looks like FILTER_BILINEAR
    rl.genTextureMipmaps(&font.texture);

    var font_size: f32 = @floatFromInt(font.baseSize);
    var fontPosition = rl.Vector2{ .x = 40.0, .y = screen_height / 2.0 - 80.0 };
    var text_size = rl.Vector2{ .x = 0.0, .y = 0.0 };

    // Setup texture scaling filter
    rl.setTextureFilter(font.texture, .point);
    var currentFontFilter: i32 = 0; // TEXTURE_FILTER_POINT

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        font_size += rl.getMouseWheelMove() * 4.0;

        // Choose font texture filter method
        const key_pressed = rl.getKeyPressed();
        switch (key_pressed) {
            .one => {
                rl.setTextureFilter(font.texture, .point);
                currentFontFilter = 0;
            },
            .two => {
                rl.setTextureFilter(font.texture, .bilinear);
                currentFontFilter = 1;
            },
            .three => {
                // NOTE: Trilinear filter won't be noticed on 2D drawing
                rl.setTextureFilter(font.texture, .trilinear);
                currentFontFilter = 2;
            },
            else => {},
        }

        text_size = rl.measureTextEx(font, msg, font_size, 0);

        if (rl.isKeyDown(.left)) {
            fontPosition.x -= 10;
        } else if (rl.isKeyDown(.right)) {
            fontPosition.x += 10;
        }

        // Load a dropped TTF file dynamically (at current fontSize)
        if (rl.isFileDropped()) {
            const dropped_files: rl.FilePathList = rl.loadDroppedFiles();
            defer rl.unloadDroppedFiles(dropped_files); // Unload filepaths from memory

            // NOTE: We only support first ttf file dropped
            const path: [:0]const u8 = std.mem.span(dropped_files.paths[0]);
            if (rl.isFileExtension(path, ".ttf")) {
                rl.unloadFont(font);
                font = try rl.loadFontEx(path, @intFromFloat(font_size), null);
            } else if (rl.isFileExtension(path, ".fnt")) {
                rl.unloadFont(font);
                font = try rl.loadFont(path);
                font_size = @floatFromInt(font.baseSize);
            }
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        rl.drawText("Use mouse wheel to change font size", 20, 20, 10, .gray);
        rl.drawText("Use KEY_RIGHT and KEY_LEFT to move text", 20, 40, 10, .gray);
        rl.drawText("Use 1, 2, 3 to change texture filter", 20, 60, 10, .gray);
        rl.drawText("Drop a new TTF font for dynamic loading", 20, 80, 10, .dark_gray);

        rl.drawTextEx(font, msg, fontPosition, font_size, 0, .black);

        // TODO: It seems texSize measurement is not accurate due to chars offsets...
        //DrawRectangleLines(fontPosition.x, fontPosition.y, textSize.x, textSize.y, RED);

        rl.drawRectangle(0, screen_height - 80, screen_width, 80, .light_gray);
        rl.drawText(rl.textFormat("Font size: %02.02f", .{font_size}), 20, screen_height - 50, 10, .dark_gray);
        rl.drawText(rl.textFormat("Text size: [%02.02f, %02.02f]", .{ text_size.x, text_size.y }), 20, screen_height - 30, 10, .dark_gray);
        rl.drawText("CURRENT TEXTURE FILTER:", 250, 400, 20, .gray);

        switch (currentFontFilter) {
            0 => rl.drawText("POINT", 570, 400, 20, .black),
            1 => rl.drawText("BILINEAR", 570, 400, 20, .black),
            2 => rl.drawText("TRILINEAR", 570, 400, 20, .black),
            else => unreachable,
        }

        //----------------------------------------------------------------------------------
    }
}
