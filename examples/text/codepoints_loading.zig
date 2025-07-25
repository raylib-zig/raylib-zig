//!******************************************************************************************
//!
//!   raylib-zog port of the [text] example - Codepoints loading
//!   https://github.com/raysan5/raylib/blob/master/examples/text/text_codepoints_loading.c
//!
//!   Example complexity rating: [★★★☆] 3/4
//!
//!   Example originally created with raylib 4.2, last time updated with raylib 2.5
//!
//!   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//!   BSD-like license that allows static linking with closed source software
//!
//!   Translated to raylib-zig by Timothy Fiss (@TheFissk)
//!
//!   Copyright (c) 2022-2025 Ramon Santamaria (@raysan5)
//!
//!*******************************************************************************************

const rl = @import("raylib");
const std = @import("std");

/// Text to be displayed, must be UTF-8 (save this code file as UTF-8)
/// NOTE: It can contain all the required text for the game,
/// this text will be scanned to get all the required codepoints
const text = "いろはにほへと　ちりぬるを\nわかよたれそ　つねならむ\nうゐのおくやま　けふこえて\nあさきゆめみし　ゑひもせす";

// Remove codepoint duplicates if requested
// static int *CodepointRemoveDuplicates(int *codepoints, int codepointCount, int *codepointResultCount);

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    rl.initWindow(screen_width, screen_height, "raylib [text] example - codepoints loading");
    defer rl.closeWindow(); // Close window and OpenGL context

    // Convert each utf-8 character into its
    // corresponding codepoint in the font file.
    const codepoints = try rl.loadCodepoints(text);
    const codepoints_count = codepoints.len;

    //the DebugAllocator provides us with a nice general purpose allocator, great for small projects like this
    var font: rl.Font = undefined;
    var codepoints_no_dups: [:0]i32 = undefined;
    var codepoints_no_dups_count: usize = undefined;
    {
        var dba = std.heap.DebugAllocator(.{}){};
        var alloc = dba.allocator();
        // Removed duplicate codepoints to generate smaller font atlas
        codepoints_no_dups = try CodepointRemoveDuplicates(alloc, codepoints);
        codepoints_no_dups_count = std.mem.len(codepoints_no_dups.ptr);
        defer alloc.free(codepoints_no_dups);
        // we can free codepoints at the end of this block, atlas has already been generated
        rl.unloadCodepoints(codepoints);

        // Load font containing all the provided codepoint glyphs
        // A texture font atlas is automatically generated
        // example assumes it is being run from the root of the project
        font = try rl.loadFontEx("examples/text/resources/DotGothic16-Regular.ttf", 36, codepoints_no_dups);

        // Set bilinear scale filter for better font scaling
        rl.setTextureFilter(font.texture, .bilinear);
        rl.setTextLineSpacing(20); // Set line spacing for multiline text (when line breaks are included '\n')
    }
    defer rl.unloadFont(font); // Unload font at the end of the program

    var show_font_atlas = false;

    var codepoint_size: i32 = 0;
    var start: i32 = 0;

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        if (rl.isKeyPressed(.space)) show_font_atlas = !show_font_atlas;

        // Testing code: getting next and previous codepoints on provided text
        if (rl.isKeyPressed(.right)) {
            // Get next codepoint in string and move pointer
            const err = rl.getCodepointNext(text[@intCast(start)..text.len], &codepoint_size);
            if (err == '?') @panic("getCodepointNext failed");
            if (start + codepoint_size < text.len) {
                start += codepoint_size;
            } else {
                start = text.len;
            }
        } else if (rl.isKeyPressed(.left)) {
            // Get previous codepoint in string and move pointer
            const err = rl.getCodepointPrevious(text[@intCast(start)..text.len], &codepoint_size);
            if (err == '?') @panic("getCodepointNext failed");
            if (start - codepoint_size > 0) {
                start -= codepoint_size;
            } else {
                start = 0;
            }
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();
        rl.clearBackground(.ray_white);

        rl.drawRectangle(0, 0, rl.getScreenWidth(), 70, .black);
        rl.drawText(rl.textFormat("Total codepoints contained in provided text: %i", .{codepoints_count}), 10, 10, 20, .green);
        rl.drawText(rl.textFormat("Total codepoints required for font atlas (duplicates excluded): %u", .{codepoints_no_dups_count}), 10, 40, 20, .green);

        if (show_font_atlas) {
            // Draw generated font texture atlas containing provided codepoints
            rl.drawTexture(font.texture, 150, 100, .black);
            rl.drawRectangleLines(150, 100, font.texture.width, font.texture.height, .black);
        } else {
            // Draw provided text with loaded font, containing all required codepoint glyphs
            rl.drawTextEx(font, text, .{ .x = 160, .y = 110 }, 48, 5, .black);
        }

        rl.drawText("Press SPACE to toggle font atlas view!", 10, rl.getScreenHeight() - 30, 20, .gray);

        //----------------------------------------------------------------------------------
    }
}

/// Remove codepoint duplicates if requested
/// WARNING: This process could be a bit slow if there text to process is very long
fn CodepointRemoveDuplicates(allocator: std.mem.Allocator, codepoints: []i32) ![:0]i32 {
    var no_dups: [:0]i32 = try allocator.allocSentinel(i32, codepoints.len, 0);
    std.mem.copyForwards(i32, no_dups, codepoints);

    var no_dups_count: usize = no_dups.len;

    // Remove duplicates
    var i: usize = 0;
    while (i < no_dups_count) {
        defer i += 1;
        var j: usize = i + 1;
        while (j < no_dups_count) {
            defer j += 1;
            const match = no_dups[i] == no_dups[j];
            if (match) {
                var k: usize = j;
                while (k < no_dups_count) {
                    defer k += 1;
                    no_dups[k] = no_dups[k + 1];
                }
                no_dups_count -= 1;
                j -= 1;
                no_dups[no_dups_count] = 0;
            }
        }
    }

    // NOTE: The size of codepointsNoDups is the same as original array but
    // only required positions are filled (codepointsNoDupsCount)
    return no_dups;
}
