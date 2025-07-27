//!******************************************************************************************
//!
//!   raylib-zig port of the [text] example - Rectangle bounds
//!
//!   Example complexity rating: [★★★★] 4/4
//!
//!   Example originally created with raylib 2.5, last time updated with raylib 4.0
//!
//!   Example contributed by Vlad Adrian (@demizdor) and reviewed by Ramon Santamaria (@raysan5)
//!
//!   Translated to raylib-zig by Timothy Fiss (@TheFissk)
//!
//!   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//!   BSD-like license that allows static linking with closed source software
//!
//!   Copyright (c) 2018-2025 Vlad Adrian (@demizdor) and Ramon Santamaria (@raysan5)
//!
//!*******************************************************************************************

const rl = @import("raylib");
const std = @import("std");

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    rl.initWindow(screen_width, screen_height, "raylib [text] example - draw text inside a rectangle");
    defer rl.closeWindow();

    const text: [:0]const u8 = "Text cannot escape\tthis container\t...word wrap also works when active so here's a long text for testing.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Nec ullamcorper sit amet risus nullam eget felis eget.";

    var resizing = false;
    var word_wrap = true;

    var container = rl.Rectangle{
        .x = 25.0,
        .y = 25.0,
        .width = @floatFromInt(screen_width - 50),
        .height = @floatFromInt(screen_height - 250),
    };
    var resizer = rl.Rectangle{
        .x = container.x + container.width - 17,
        .y = container.y + container.height - 17,
        .width = 14,
        .height = 14,
    };

    // Minimum width and heigh for the container rectangle
    const minWidth = 60.0;
    const minHeight = 60.0;
    const maxWidth = screen_width - 50.0;
    const maxHeight = screen_height - 160.0;

    var lastMouse = rl.Vector2{ .x = 0.0, .y = 0.0 }; // Stores last mouse coordinates
    var border_color = rl.Color.maroon; // Container border color
    const font = try rl.getFontDefault(); // Get default system font

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        if (rl.isKeyPressed(.space)) word_wrap = !word_wrap;

        const mouse = rl.getMousePosition();

        // Check if the mouse is inside the container and toggle border color
        if (rl.checkCollisionPointRec(mouse, container)) {
            border_color = rl.fade(.maroon, 0.4);
        } else if (!resizing) {
            border_color = .maroon;
        }

        // Container resizing logic
        if (resizing) {
            if (rl.isMouseButtonReleased(.left)) resizing = false;

            const width = container.width + (mouse.x - lastMouse.x);
            container.width = if (width > minWidth) if (width < maxWidth) width else maxWidth else minWidth;

            const height = container.height + (mouse.y - lastMouse.y);
            container.height = if (height > minHeight) if (height < maxHeight) height else maxHeight else minHeight;
        } else {
            // Check if we're resizing
            if (rl.isMouseButtonDown(.left) and rl.checkCollisionPointRec(mouse, resizer)) resizing = true;
        }

        // Move resizer rectangle properly
        resizer.x = container.x + container.width - 17;
        resizer.y = container.y + container.height - 17;

        lastMouse = mouse; // Update mouse
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        rl.drawRectangleLinesEx(container, 3, border_color); // Draw container border

        // Draw text in container (add some padding)
        drawTextBoxed(font, text, .{
            .x = container.x + 4,
            .y = container.y + 4,
            .width = container.width - 4,
            .height = container.height - 4,
        }, 20.0, 2.0, word_wrap, .gray);

        rl.drawRectangleRec(resizer, border_color); // Draw the resize box

        // Draw bottom info
        rl.drawRectangle(0, screen_height - 54, screen_width, 54, .gray);
        rl.drawRectangleRec(.{
            .x = 382.0,
            .y = screen_height - 34.0,
            .width = 12.0,
            .height = 12.0,
        }, .maroon);

        rl.drawText("Word Wrap: ", 313, screen_height - 115, 20, .black);
        if (word_wrap) {
            rl.drawText("ON", 447, screen_height - 115, 20, .red);
        } else {
            rl.drawText("OFF", 447, screen_height - 115, 20, .black);
        }

        rl.drawText("Press [SPACE] to toggle word wrap", 218, screen_height - 86, 20, .gray);

        rl.drawText("Click hold & drag the    to resize the container", 155, screen_height - 38, 20, .ray_white);

        //----------------------------------------------------------------------------------
    }
}

//--------------------------------------------------------------------------------------
// Module functions definition
//--------------------------------------------------------------------------------------

// Draw text using font inside rectangle limits
fn drawTextBoxed(font: rl.Font, text: [:0]const u8, rec: rl.Rectangle, font_size: f32, spacing: f32, word_wrap: bool, tint: rl.Color) void {
    drawTextBoxedSelectable(font, text, rec, font_size, spacing, word_wrap, tint, 0, 0, .white, .white);
}

// Draw text using font inside rectangle limits with support for text selection
fn drawTextBoxedSelectable(font: rl.Font, text: [:0]const u8, rec: rl.Rectangle, font_size: f32, spacing: f32, word_wrap: bool, tint: rl.Color, select_box_start: i32, select_length: i32, select_tint: rl.Color, select_back_tint: rl.Color) void {
    var select_start = select_box_start;
    const length = rl.textLength(text); // Total length in bytes of the text, scanned by codepoints in loop

    var text_offset_y: f32 = 0; // Offset between lines (on line break '\n')
    var text_offset_x: f32 = 0.0; // Offset X to next character to draw

    const scale_factor = font_size / @as(f32, @floatFromInt(font.baseSize)); // Character rectangle scaling factor

    // Word/character wrapping mechanism variables
    const MeasureState = enum(u8) { measure, draw };
    var state: MeasureState = if (word_wrap) .measure else .draw;

    var start_line: i32 = -1; // Index where to begin drawing (where a line begins)
    var end_line: i32 = -1; // Index where to stop drawing (where a line ends)
    var last_char: i32 = -1; // Holds last value of the character position

    var i: i32 = 0;
    var k: i32 = 0;
    while (i < length) : ({
        i += 1;
        k += 1;
    }) {
        // Get next codepoint from byte string and glyph index in font
        var codepoint_byte_count: i32 = 0;
        const codepoint = rl.getCodepoint(text[@intCast(i)..], &codepoint_byte_count);
        const index: usize = @intCast(rl.getGlyphIndex(font, codepoint));

        // NOTE: Normally we exit the decoding sequence as soon as a bad byte is found (and return 0x3f)
        // but we need to draw all of the bad bytes using the '?' symbol moving one byte
        if (codepoint == 0x3f) codepoint_byte_count = 1;
        i += @intCast(codepoint_byte_count - 1);

        var glyph_width: f32 = 0;
        if (codepoint != '\n') {
            glyph_width = if (font.glyphs[index].advanceX == 0) font.recs[index].width * scale_factor else @as(f32, @floatFromInt(font.glyphs[index].advanceX)) * scale_factor;

            if (i + 1 < length) glyph_width = glyph_width + spacing;
        }
        // NOTE: When wordWrap is ON we first measure how much of the text we can draw before going outside of the rec container
        // We store this info in startLine and endLine, then we change states, draw the text between those two variables
        // and change states again and again recursively until the end of the text (or until we get outside of the container).
        // When wordWrap is OFF we don't need the measure state so we go to the drawing state immediately
        // and begin drawing on the next line before we can get outside the container.
        if (state == .measure) {
            // TODO: There are multiple types of spaces in UNICODE, maybe it's a good idea to add support for more
            // Ref: http://jkorpela.fi/chars/spaces.html
            if ((codepoint == ' ') or (codepoint == '\t') or (codepoint == '\n')) end_line = @intCast(i);

            if ((text_offset_x + glyph_width) > rec.width) {
                end_line = if (end_line < 1) @intCast(i) else end_line;
                if (i == end_line) end_line -= codepoint_byte_count;
                if ((start_line + codepoint_byte_count) == end_line) end_line = @as(i32, @intCast(i)) - codepoint_byte_count;

                state = if (state == .draw) .measure else .draw;
            } else if ((i + 1) == length) {
                end_line = @intCast(i);
                state = if (state == .draw) .measure else .draw;
            } else if (codepoint == '\n') {
                state = if (state == .draw) .measure else .draw;
            }

            if (state == .draw) {
                text_offset_x = 0;
                i = @intCast(start_line);
                glyph_width = 0;

                // Save character position when we switch states
                const tmp = last_char;
                last_char = k - 1;
                k = tmp;
            }
        } else {
            if (codepoint == '\n') {
                if (!word_wrap) {
                    const bS: f32 = @floatFromInt(font.baseSize);
                    text_offset_y += (bS + bS / 2) * scale_factor;
                    text_offset_x = 0;
                }
            } else {
                if (!word_wrap and ((text_offset_x + glyph_width) > rec.width)) {
                    const bS: f32 = @floatFromInt(font.baseSize);
                    text_offset_y += (bS + bS / 2) * scale_factor;
                    text_offset_x = 0;
                }

                // When text overflows rectangle height limit, just stop drawing
                if ((text_offset_y + @as(f32, @floatFromInt(font.baseSize)) * scale_factor) > rec.height) break;

                // Draw selection background
                var is_glyph_selected = false;
                if ((select_start >= 0) and (k >= select_start) and (k < (select_start + select_length))) {
                    rl.drawRectangleRec(.{
                        .x = rec.x + text_offset_x - 1,
                        .y = rec.y + text_offset_y,
                        .width = glyph_width,
                        .height = @as(f32, @floatFromInt(font.baseSize)) * scale_factor,
                    }, select_back_tint);
                    is_glyph_selected = true;
                }

                // Draw current character glyph
                if ((codepoint != ' ') and (codepoint != '\t')) {
                    rl.drawTextCodepoint(font, codepoint, .{
                        .x = rec.x + text_offset_x,
                        .y = rec.y + text_offset_y,
                    }, font_size, if (is_glyph_selected) select_tint else tint);
                }
            }

            if (word_wrap and (i == end_line)) {
                const bS: f32 = @floatFromInt(font.baseSize);
                text_offset_y += (bS + bS / 2) * scale_factor;
                text_offset_x = 0;
                start_line = end_line;
                end_line = -1;
                glyph_width = 0;
                select_start += last_char - k;
                k = last_char;

                state = if (state == .draw) .measure else .draw;
            }
        }

        if ((text_offset_x != 0) or (codepoint != ' ')) text_offset_x += glyph_width; // avoid leading spaces
    }
}
