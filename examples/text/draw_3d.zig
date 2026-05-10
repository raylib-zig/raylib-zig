//!******************************************************************************************
//!
//!   raylib-zig port of the [text] example - Draw 3d
//!   https://github.com/raysan5/raylib/blob/master/examples/text/text_draw_3d.c
//!
//!   Example complexity rating: [★★★★] 4/4
//!
//!   NOTE: Draw a 2D text in 3D space, each letter is drawn in a quad (or 2 quads if backface is set)
//!   where the texture coodinates of each quad map to the texture coordinates of the glyphs
//!   inside the font texture.
//!
//!   A more efficient approach, i believe, would be to render the text in a render texture and
//!   map that texture to a plane and render that, or maybe a shader but my method allows more
//!   flexibility...for example to change position of each letter individually to make somethink
//!   like a wavy text effect.
//!
//!   Special thanks to:
//!        @Nighten for the DrawTextStyle() code https://github.com/NightenDushi/Raylib_DrawTextStyle
//!        Chris Camacho (codifies - http://bedroomcoders.co.uk/) for the alpha discard shader
//!
//!   Example originally created with raylib 3.5, last time updated with raylib 4.0
//!
//!   Example contributed by Vlad Adrian (@demizdor) and reviewed by Ramon Santamaria (@raysan5)
//!   Translated to raylib-zig by Timothy Fiss (@TheFissk)
//!
//!   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//!   BSD-like license that allows static linking with closed source software
//!
//!   Copyright (c) 2021-2025 Vlad Adrian (@demizdor)
//!
//!*******************************************************************************************

const std = @import("std");
const rl = @import("raylib");
const cl = @import("codepoints_loading.zig");

//--------------------------------------------------------------------------------------
// Globals
//--------------------------------------------------------------------------------------
const letter_boundry_size = 0.25;
const text_max_layers = 32;
const letter_boundry_color = rl.Color.violet;

var show_letter_boundry = false;
var show_text_boundry = false;

//--------------------------------------------------------------------------------------
// Data Types definition
//--------------------------------------------------------------------------------------

// Configuration structure for waving the text
const WaveTextConfig = struct {
    waveRange: rl.Vector3,
    waveSpeed: rl.Vector3,
    waveOffset: rl.Vector3,
};

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    rl.setConfigFlags(.{ .msaa_4x_hint = true, .vsync_hint = true });
    rl.initWindow(screen_width, screen_height, "raylib [text] example - draw 2D text in 3D");
    defer rl.closeWindow();

    var spin = true; // Spin the camera?
    var multicolor = false; // Multicolor mode

    // Define the camera to look into our 3d world
    var camera: rl.Camera3D = .{
        .position = .{ .x = -10, .y = 15, .z = -10 },
        .target = .{ .x = 0, .y = 0, .z = 0 },
        .up = .{ .x = 0, .y = 1, .z = 0 },
        .fovy = 45,
        .projection = .perspective,
    };
    var camera_mode = rl.CameraMode.orbital;

    const cube_postition = rl.Vector3{ .x = 0.0, .y = 1.0, .z = 0.0 };
    const cube_size = rl.Vector3{ .x = 2.0, .y = 2.0, .z = 2.0 };

    // Use the default font

    const default_font = try rl.getFontDefault();
    defer rl.unloadFont(default_font);
    var font = try rl.getFontDefault();
    defer rl.unloadFont(font);
    var font_size: f32 = 0.8;
    var fontSpacing: f32 = 0.05;
    var lineSpacing: f32 = -0.1;

    // var tbox = rl.Vector3{};
    var layers: usize = 1;
    var quads: usize = 0;
    var layerDistance: f32 = 0.01;

    const wcfg = WaveTextConfig{
        .waveSpeed = .{ .x = 3, .y = 3, .z = 0.5 },
        .waveOffset = .{ .x = 0.35, .y = 0.35, .z = 0.35 },
        .waveRange = .{ .x = 0.45, .y = 0.45, .z = 0.45 },
    };

    var time: f32 = 0.0;

    // Setup a light and dark color
    var light = rl.Color.maroon;
    var dark = rl.Color.red;

    // Load the alpha discard shader
    const alphaDiscard = try rl.loadShader(null, "examples/text/resources/shaders/glsl330/alpha_discard.fs");

    // Array filled with multiple random colors (when multicolor mode is set)
    var multi: [text_max_layers]rl.Color = undefined;

    // Set the text (using markdown!)
    var text = [_:0]u8{0} ** 64;
    var fw = std.Io.Writer.fixed(text[0..]);
    _ = try fw.writeAll("Hello ~~World~~ In 3D!");

    rl.disableCursor(); // Limit cursor to relative movement inside the window
    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        rl.updateCamera(&camera, camera_mode);

        // Handle font files dropped
        if (rl.isFileDropped()) {
            const droppedFiles: rl.FilePathList = rl.loadDroppedFiles();
            defer rl.unloadDroppedFiles(droppedFiles); // Unload filepaths from memory

            // NOTE: We only support first ttf file dropped
            const path: [:0]const u8 = std.mem.span(droppedFiles.paths[0]);
            if (rl.isFileExtension(path, ".ttf")) {
                rl.unloadFont(font);
                font = try rl.loadFontEx(path, @intFromFloat(font_size), null);
            } else if (rl.isFileExtension(path, ".fnt")) {
                rl.unloadFont(font);
                font = try rl.loadFont(path);
                font_size = @floatFromInt(font.baseSize);
            }
        }

        // Handle Events
        if (rl.isKeyPressed(.f1)) show_letter_boundry = !show_letter_boundry;
        if (rl.isKeyPressed(.f2)) show_text_boundry = !show_text_boundry;
        if (rl.isKeyPressed(.f3)) {
            // Handle camera change
            spin = !spin;
            // we need to reset the camera when changing modes
            camera = rl.Camera3D{
                .target = .{ .x = 0.0, .y = 0.0, .z = 0.0 }, // Camera looking at point
                .up = .{ .x = 0.0, .y = 1.0, .z = 0.0 }, // Camera up vector (rotation towards target)
                .fovy = 45.0, // Camera field-of-view Y
                .projection = .perspective, // Camera mode type
                .position = .{ .x = 10.0, .y = 10.0, .z = -10.0 }, // Camera position
            };
            camera_mode = .free;

            if (spin) {
                camera_mode = .orbital;
                camera.position = .{ .x = -10.0, .y = 15.0, .z = -10.0 }; // Camera position
            }
        }

        // Handle clicking the cube
        if (rl.isMouseButtonPressed(.left)) {
            const ray = rl.getScreenToWorldRay(rl.getMousePosition(), camera);

            // Check collision between ray and box
            const collision = rl.getRayCollisionBox(ray, .{ .max = .{ .x = cube_postition.x - cube_size.x / 2, .y = cube_postition.y - cube_size.y / 2, .z = cube_postition.z - cube_size.z / 2 }, .min = .{ .x = cube_postition.x + cube_size.x / 2, .y = cube_postition.y + cube_size.y / 2, .z = cube_postition.z + cube_size.z / 2 } });
            if (collision.hit) {
                // Generate new random colors
                light = generateRandomColor(0.5, 0.78);
                dark = generateRandomColor(0.4, 0.58);
            }
        }

        // Handle text layers changes
        if (rl.isKeyPressed(.home)) {
            if (layers > 1) layers -= 1;
        } else if (rl.isKeyPressed(.end)) {
            if (layers < text_max_layers) layers += 1;
        }

        // Handle text changes
        const key_pressed = rl.getKeyPressed();
        switch (key_pressed) {
            .left => font_size -= 0.5,
            .right => font_size += 0.5,
            .up => fontSpacing -= 0.1,
            .down => fontSpacing += 0.1,
            .page_up => lineSpacing -= 0.1,
            .page_down => lineSpacing += 0.1,
            .insert => layerDistance -= 0.001,
            .delete => layerDistance += 0.001,
            .tab => {
                multicolor = !multicolor; // Enable /disable multicolor mode

                if (multicolor) {
                    // Fill color array with random colors
                    for (0..text_max_layers) |i| {
                        multi[i] = generateRandomColor(0.5, 0.8);
                        multi[i].a = @intCast(rl.getRandomValue(0, 255));
                    }
                }
            },
            else => {},
        }

        // Handle text input
        const ch = rl.getCharPressed();
        switch (key_pressed) {
            .backspace => {
                const len = rl.textLength(&text);
                if (len > 0) text[len - 1] = 0;
            },
            .enter => {
                const len = rl.textLength(&text);
                if (len < text.len - 1) {
                    text[len] = '\n';
                    text[len + 1] = 0;
                }
            },
            else => {
                // append only printable chars
                const len = rl.textLength(&text);
                if (len < text.len) {
                    text[len] = @intCast(ch);
                    text[len + 1] = 0;
                }
            },
        }

        // Measure 3D text so we can center it
        const tbox = measureTextWave3D(font, &text, font_size, fontSpacing, lineSpacing);

        quads = 0; // Reset quad counter
        time += rl.getFrameTime(); // Update timer needed by `DrawTextWave3D()`
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);
        {
            rl.beginMode3D(camera);
            defer rl.endMode3D();
            rl.drawCubeV(cube_postition, cube_size, dark);
            rl.drawCubeWires(cube_postition, 2.1, 2.1, 2.1, light);

            rl.drawGrid(10, 2.0);

            // Use a shader to handle the depth buffer issue with transparent textures
            // NOTE: more info at https://bedroomcoders.co.uk/posts/198
            rl.beginShaderMode(alphaDiscard);
            defer rl.endShaderMode();

            // Draw the 3D text above the red cube
            {
                rl.gl.rlPushMatrix();
                defer rl.gl.rlPopMatrix();
                rl.gl.rlRotatef(90.0, 1.0, 0.0, 0.0);
                rl.gl.rlRotatef(90.0, 0.0, 0.0, -1.0);

                for (0..layers) |i| {
                    var clr = light;
                    if (multicolor) clr = multi[i];
                    drawTextWave3D(font, &text, .{
                        .x = -tbox.x / 2.0,
                        .y = layerDistance * @as(f32, @floatFromInt(i)),
                        .z = -4.5,
                    }, font_size, fontSpacing, lineSpacing, true, wcfg, time, clr);
                }

                // Draw the text boundry if set
                if (show_text_boundry) rl.drawCubeWiresV(.{ .x = 0.0, .y = 0.0, .z = -4.5 + tbox.z / 2 }, tbox, dark);
            }

            // Don't draw the letter boundries for the 3D text below
            const slb = show_letter_boundry;
            show_letter_boundry = false;
            defer show_letter_boundry = slb;

            // Draw 3D options (use default font)
            //-------------------------------------------------------------------------
            {
                rl.gl.rlPushMatrix();
                defer rl.gl.rlPopMatrix();
                rl.gl.rlRotatef(180.0, 0.0, 1.0, 0.0);

                // In the C version of this library we use rl.textFormat to format our text. This doesn't play nice Zig's slice strings.
                // You might be able to make it work but I switched to using the std.fmt interfaces which are more ergonomic in zig anyways.
                // I use an oversized fixed buffer, but you could use an allocator to get a more robust solution

                var text_buf = [_:0]u8{0} ** 64;

                var opt = try std.fmt.bufPrintZ(&text_buf, "< SIZE: {d} >", .{font_size});
                var m = rl.measureTextEx(default_font, opt, 0.8, 0.1);
                var pos = rl.Vector3{ .x = -m.x / 2.0, .y = 0.01, .z = 2.0 };
                drawText3D(default_font, opt, pos, 0.8, 0.1, 0.0, false, .blue);
                pos.z += 0.5 + m.y;

                opt = try std.fmt.bufPrintZ(&text_buf, "< SPACING: {d} >", .{fontSpacing});
                quads += std.mem.len(opt.ptr);
                m = rl.measureTextEx(default_font, opt, 0.8, 0.1);
                pos.x = -m.x / 2.0;
                drawText3D(default_font, opt, pos, 0.8, 0.1, 0.0, false, .blue);
                pos.z += 0.5 + m.y;

                opt = try std.fmt.bufPrintZ(&text_buf, "< LINE: {d} >", .{lineSpacing});
                quads += std.mem.len(opt.ptr);
                m = rl.measureTextEx(default_font, opt, 0.8, 0.1);
                pos.x = -m.x / 2.0;
                drawText3D(default_font, opt, pos, 0.8, 0.1, 0.0, false, .blue);
                pos.z += 0.5 + m.y;

                opt = try std.fmt.bufPrintZ(&text_buf, "< LBOX: {s} >", .{if (slb) "ON" else "OFF"});
                quads += std.mem.len(opt.ptr);
                m = rl.measureTextEx(default_font, opt, 0.8, 0.1);
                pos.x = -m.x / 2.0;
                drawText3D(default_font, opt, pos, 0.8, 0.1, 0.0, false, .red);
                pos.z += 0.5 + m.y;

                opt = try std.fmt.bufPrintZ(&text_buf, "< TBOX: {s} >", .{if (show_text_boundry) "ON" else "OFF"});
                quads += std.mem.len(opt.ptr);
                m = rl.measureTextEx(default_font, opt, 0.8, 0.1);
                pos.x = -m.x / 2.0;
                drawText3D(default_font, opt, pos, 0.8, 0.1, 0.0, false, .red);
                pos.z += 0.5 + m.y;

                opt = try std.fmt.bufPrintZ(&text_buf, "< LAYER DISTANCE: {d} >", .{layerDistance});
                quads += std.mem.len(opt.ptr);
                m = rl.measureTextEx(default_font, opt, 0.8, 0.1);
                pos.x = -m.x / 2.0;
                drawText3D(default_font, opt, pos, 0.8, 0.1, 0.0, false, .dark_purple);
            }
            //-------------------------------------------------------------------------

            // Draw 3D info text (use default font)
            //-------------------------------------------------------------------------
            const opt1 = "All the text displayed here is in 3D";
            quads += opt1.len;
            var m = rl.measureTextEx(default_font, opt1, 1.0, 0.05);
            var pos = rl.Vector3{ .x = -m.x / 2.0, .y = 0.01, .z = 2.0 };
            drawText3D(default_font, opt1, pos, 1.0, 0.05, 0.0, false, .dark_blue);
            pos.z += 1.5 + m.y;

            const opt2 = "press [Left]/[Right] to change the font size";
            quads += opt2.len;
            m = rl.measureTextEx(default_font, opt2, 0.6, 0.05);
            pos.x = -m.x / 2.0;
            drawText3D(default_font, opt2, pos, 0.6, 0.05, 0.0, false, .dark_blue);
            pos.z += 0.5 + m.y;

            const opt3 = "press [Up]/[Down] to change the font spacing";
            quads += opt3.len;
            m = rl.measureTextEx(default_font, opt3, 0.6, 0.05);
            pos.x = -m.x / 2.0;
            drawText3D(default_font, opt3, pos, 0.6, 0.05, 0.0, false, .dark_blue);
            pos.z += 0.5 + m.y;

            const opt4 = "press [PgUp]/[PgDown] to change the line spacing";
            quads += opt4.len;
            m = rl.measureTextEx(default_font, opt4, 0.6, 0.05);
            pos.x = -m.x / 2.0;
            drawText3D(default_font, opt4, pos, 0.6, 0.05, 0.0, false, .dark_blue);
            pos.z += 0.5 + m.y;

            const opt5 = "press [F1] to toggle the letter boundry";
            quads += opt5.len;
            m = rl.measureTextEx(default_font, opt5, 0.6, 0.05);
            pos.x = -m.x / 2.0;
            drawText3D(default_font, opt5, pos, 0.6, 0.05, 0.0, false, .dark_blue);
            pos.z += 0.5 + m.y;

            const opt6 = "press [F2] to toggle the text boundry";
            quads += opt6.len;
            m = rl.measureTextEx(default_font, opt6, 0.6, 0.05);
            pos.x = -m.x / 2.0;
            drawText3D(default_font, opt6, pos, 0.6, 0.05, 0.0, false, .dark_blue);
            //-------------------------------------------------------------------------

        }

        // Draw 2D info text & stats
        //-------------------------------------------------------------------------
        rl.drawText("Drag & drop a font file to change the font!\nType something, see what happens!\n\nPress [F3] to toggle the camera", 10, 35, 10, .black);

        quads += rl.textLength(&text) * 2 * layers;
        var buf = [_:0]u8{0} ** 70;
        const tmp = std.fmt.bufPrintZ(&buf, "{} layer(s) | {s} camera | {} quads ({} verts)", .{
            layers,
            if (spin) "ORBITAL" else "FREE",
            quads,
            quads * 4,
        }) catch unreachable;
        var width = rl.measureText(tmp, 10);
        rl.drawText(tmp, screen_width - 20 - width, 10, 10, .dark_green);

        const tmp2 = "[Home]/[End] to add/remove 3D text layers";
        width = rl.measureText(tmp2, 10);
        rl.drawText(tmp2, screen_width - 20 - width, 25, 10, .dark_gray);

        const tmp3 = "[Insert]/[Delete] to increase/decrease distance between layers";
        width = rl.measureText(tmp3, 10);
        rl.drawText(tmp3, screen_width - 20 - width, 40, 10, .dark_gray);

        const tmp4 = "click the [CUBE] for a random color";
        width = rl.measureText(tmp4, 10);
        rl.drawText(tmp4, screen_width - 20 - width, 55, 10, .dark_gray);

        const tmp5 = "[Tab] to toggle multicolor mode";
        width = rl.measureText(tmp5, 10);
        rl.drawText(tmp5, screen_width - 20 - width, 70, 10, .dark_gray);
        //-------------------------------------------------------------------------

        rl.drawFPS(10, 10);

        //----------------------------------------------------------------------------------
    }
}

//--------------------------------------------------------------------------------------
// Module Functions Definitions
//--------------------------------------------------------------------------------------
/// Draw codepoint at specified position in 3D space
fn drawTextCodepoint3D(font: rl.Font, codepoint: i32, start_position: rl.Vector3, fontSize: f32, backface: bool, tint: rl.Color) void {
    // Character index position in sprite font
    // NOTE: In case a codepoint is not available in the font, index returned points to '?'
    const index: usize = @intCast(rl.getGlyphIndex(font, codepoint));
    const scale: f32 = fontSize / @as(f32, @floatFromInt(font.baseSize));
    const glyphPadding: f32 = @floatFromInt(font.glyphPadding);

    // Character destination rectangle on screen
    // NOTE: We consider charsPadding on drawing
    const position = rl.Vector3{
        .x = start_position.x + @as(f32, @floatFromInt(font.glyphs[index].offsetX - font.glyphPadding)) * scale,
        .y = start_position.y,
        .z = start_position.z + @as(f32, @floatFromInt(font.glyphs[index].offsetY - font.glyphPadding)) * scale,
    };

    // Character source rectangle from font texture atlas
    // NOTE: We consider chars padding when drawing, it could be required for outline/glow shader effects
    const srcRec = rl.Rectangle{
        .x = font.recs[index].x - glyphPadding,
        .y = font.recs[index].y - glyphPadding,
        .width = font.recs[index].width + 2.0 * glyphPadding,
        .height = font.recs[index].height + 2.0 * glyphPadding,
    };

    const width: f32 = (font.recs[index].width + 2.0 * glyphPadding) * scale;
    const height: f32 = (font.recs[index].height + 2.0 * glyphPadding) * scale;

    if (font.texture.id > 0) {
        const x = 0.0;
        const y = 0.0;
        const z = 0.0;

        // normalized texture coordinates of the glyph inside the font texture (0.0f -> 1.0f)
        const tx: f32 = srcRec.x / @as(f32, @floatFromInt(font.texture.width));
        const ty: f32 = srcRec.y / @as(f32, @floatFromInt(font.texture.height));
        const tw: f32 = (srcRec.x + srcRec.width) / @as(f32, @floatFromInt(font.texture.width));
        const th: f32 = (srcRec.y + srcRec.height) / @as(f32, @floatFromInt(font.texture.height));

        if (show_letter_boundry) rl.drawCubeWiresV(.{ .x = position.x + width / 2, .y = position.y, .z = position.z + height / 2 }, .{ .x = width, .y = letter_boundry_size, .z = height }, letter_boundry_color);

        //not entirely sure if this has a side effect, its in the original, so I'm not touching it
        _ = rl.gl.rlCheckRenderBatchLimit(if (backface) 8 else 4);
        rl.gl.rlSetTexture(font.texture.id);
        defer rl.gl.rlSetTexture(0);

        rl.gl.rlPushMatrix();
        defer rl.gl.rlPopMatrix();
        rl.gl.rlTranslatef(position.x, position.y, position.z);

        rl.gl.rlBegin(rl.gl.rl_quads);
        defer rl.gl.rlEnd();
        rl.gl.rlColor4ub(tint.r, tint.g, tint.b, tint.a);

        // Front Face
        rl.gl.rlNormal3f(0.0, 1.0, 0.0); // Normal Pointing Up
        rl.gl.rlTexCoord2f(tx, ty);
        rl.gl.rlVertex3f(x, y, z); // Top Left Of The Texture and Quad
        rl.gl.rlTexCoord2f(tx, th);
        rl.gl.rlVertex3f(x, y, z + height); // Bottom Left Of The Texture and Quad
        rl.gl.rlTexCoord2f(tw, th);
        rl.gl.rlVertex3f(x + width, y, z + height); // Bottom Right Of The Texture and Quad
        rl.gl.rlTexCoord2f(tw, ty);
        rl.gl.rlVertex3f(x + width, y, z); // Top Right Of The Texture and Quad

        if (backface) {
            // Back Face
            rl.gl.rlNormal3f(0.0, -1.0, 0.0); // Normal Pointing Down
            rl.gl.rlTexCoord2f(tx, ty);
            rl.gl.rlVertex3f(x, y, z); // Top Right Of The Texture and Quad
            rl.gl.rlTexCoord2f(tw, ty);
            rl.gl.rlVertex3f(x + width, y, z); // Top Left Of The Texture and Quad
            rl.gl.rlTexCoord2f(tw, th);
            rl.gl.rlVertex3f(x + width, y, z + height); // Bottom Left Of The Texture and Quad
            rl.gl.rlTexCoord2f(tx, th);
            rl.gl.rlVertex3f(x, y, z + height); // Bottom Right Of The Texture and Quad
        }
    }
}

/// Draw a 2D text in 3D space
fn drawText3D(font: rl.Font, text: [:0]const u8, position: rl.Vector3, font_size: f32, font_spacing: f32, line_spacing: f32, backface: bool, tint: rl.Color) void {
    const length = rl.textLength(text); // Total length in bytes of the text, scanned by codepoints in loop

    var text_offset_y: f32 = 0.0; // Offset between lines (on line break '\n')
    var text_offset_x: f32 = 0.0; // Offset X to next character to draw

    const scale = font_size / @as(f32, @floatFromInt(font.baseSize));

    var i: usize = 0;
    while (i < length) {
        // Get next codepoint from byte string and glyph index in font
        var codepoint_byte_count: i32 = 0;
        const codepoint = rl.getCodepoint(text[i..], &codepoint_byte_count);
        const index: usize = @intCast(rl.getGlyphIndex(font, codepoint));

        // NOTE: Normally we exit the decoding sequence as soon as a bad byte is found (and return 0x3f)
        // but we need to draw all of the bad bytes using the '?' symbol moving one byte
        if (codepoint == 0x3f) codepoint_byte_count = 1;

        if (codepoint == '\n') {
            // NOTE: Fixed line spacing of 1.5 line-height
            // TODO: Support custom line spacing defined by user
            text_offset_y += font_size + line_spacing;
            text_offset_x = 0.0;
        } else {
            if ((codepoint != ' ') and (codepoint != '\t')) {
                drawTextCodepoint3D(font, codepoint, .{
                    .x = position.x + text_offset_x,
                    .y = position.y,
                    .z = position.z + text_offset_y,
                }, font_size, backface, tint);
            }

            if (font.glyphs[index].advanceX == 0) {
                text_offset_x += font.recs[index].width * scale + font_spacing;
            } else {
                text_offset_x += @as(f32, @floatFromInt(font.glyphs[index].advanceX)) * scale + font_spacing;
            }
        }

        i += @intCast(codepoint_byte_count); // Move text bytes counter to next codepoint
    }
}

/// Draw a 2D text in 3D space and wave the parts that start with `~~` and end with `~~`.
/// This is a modified version of the original code by @Nighten found here https://github.com/NightenDushi/Raylib_DrawTextStyle
fn drawTextWave3D(font: rl.Font, text: [:0]const u8, position: rl.Vector3, fontSize: f32, fontSpacing: f32, lineSpacing: f32, backface: bool, config: WaveTextConfig, time: f32, tint: rl.Color) void {
    const length = rl.textLength(text); // Total length in bytes of the text, scanned by codepoints in loop

    var text_offset_x: f32 = 0.0; // Offset X to next character to draw
    var text_offset_y: f32 = 0.0; // Offset between lines (on line break '\n')

    const scale = fontSize / @as(f32, @floatFromInt(font.baseSize));

    var wave = false;

    var i: usize = 0;
    var k: usize = 0;
    while (i < length) : (k += 1) {

        // Get next codepoint from byte string and glyph index in font
        var codepointByteCount: i32 = 0;
        const codepoint = rl.getCodepoint(text[i..], &codepointByteCount);
        const index: usize = @intCast(rl.getGlyphIndex(font, codepoint));

        // NOTE: Normally we exit the decoding sequence as soon as a bad byte is found (and return 0x3f)
        // but we need to draw all of the bad bytes using the '?' symbol moving one byte
        if (codepoint == 0x3f) codepointByteCount = 1;

        switch (codepoint) {
            '\n' => {
                // NOTE: Fixed line spacing of 1.5 line-height
                // TODO: Support custom line spacing defined by user
                text_offset_y += fontSize + lineSpacing;
                text_offset_x = 0.0;
                k = 0;
            },
            '~' => {
                if (rl.getCodepoint(text[i + 1 ..], &codepointByteCount) == '~') {
                    codepointByteCount += 1;
                    wave = !wave;
                }
            },
            else => {
                if ((codepoint != ' ') and (codepoint != '\t')) {
                    var pos = position;
                    if (wave) // Apply the wave effect
                    {
                        const kF: f32 = @floatFromInt(k);
                        pos.x += std.math.sin(time * config.waveSpeed.x - kF * config.waveOffset.x) * config.waveRange.x;
                        pos.y += std.math.sin(time * config.waveSpeed.y - kF * config.waveOffset.y) * config.waveRange.y;
                        pos.z += std.math.sin(time * config.waveSpeed.z - kF * config.waveOffset.z) * config.waveRange.z;
                    }

                    drawTextCodepoint3D(font, codepoint, .{
                        .x = pos.x + text_offset_x,
                        .y = pos.y,
                        .z = pos.z + text_offset_y,
                    }, fontSize, backface, tint);
                }

                if (font.glyphs[index].advanceX == 0) {
                    text_offset_x += font.recs[index].width * scale + fontSpacing;
                } else {
                    text_offset_x += @as(f32, @floatFromInt(font.glyphs[index].advanceX)) * scale + fontSpacing;
                }
            },
        }

        i += @intCast(codepointByteCount); // Move text bytes counter to next codepoint
    }
}

/// Measure a text in 3D ignoring the `~~` chars.
fn measureTextWave3D(font: rl.Font, text: [:0]const u8, fontSize: f32, fontSpacing: f32, lineSpacing: f32) rl.Vector3 {
    const len = rl.textLength(text);
    var temp_len: usize = 0; // Used to count longer text line num chars
    var len_counter: usize = 0;

    var temp_text_width: f32 = 0.0; // Used to count longer text line width

    const scale = fontSize / @as(f32, @floatFromInt(font.baseSize));
    var text_height = scale;
    var text_width: f32 = 0.0;

    var letter: i32 = 0; // Current character
    var index: usize = 0; // Index position in sprite font

    var i: usize = 0;
    while (i < len) {
        var next: i32 = 0;
        letter = rl.getCodepoint(text[i..], &next);
        index = @intCast(rl.getGlyphIndex(font, letter));

        // NOTE: normally we exit the decoding sequence as soon as a bad byte is found (and return 0x3f)
        // but we need to draw all of the bad bytes using the '?' symbol so to not skip any we set next = 1
        if (letter == 0x3f) next = 1;
        i += @intCast(next);

        if (letter != '\n') {
            if (letter == '~' and rl.getCodepoint(text[i + 1 ..], &next) == '~') {
                i += 1;
            } else {
                len_counter += 1;
                if (font.glyphs[index].advanceX != 0) {
                    text_width += @as(f32, @floatFromInt(font.glyphs[index].advanceX)) * scale;
                } else text_width += (font.recs[index].width + @as(f32, @floatFromInt(font.glyphs[index].offsetX))) * scale;
            }
        } else {
            if (temp_text_width < text_width) temp_text_width = text_width;
            len_counter = 0;
            text_width = 0.0;
            text_height += fontSize + lineSpacing;
        }

        if (temp_len < len_counter) temp_len = len_counter;
    }

    if (temp_text_width < text_width) temp_text_width = text_width;

    const vec = rl.Vector3{
        .x = temp_text_width + (@as(f32, @floatFromInt(temp_len - 1)) * fontSpacing), // Adds chars spacing to measure
        .y = 0.25,
        .z = text_height,
    };

    return vec;
}

/// Generates a nice color with a random hue
fn generateRandomColor(s: f32, v: f32) rl.Color {
    const Phi: f32 = 0.618033988749895; // Golden ratio conjugate
    var h: f32 = @floatFromInt(rl.getRandomValue(0, 360));
    h = std.math.mod(f32, (h + h * Phi), 360.0) catch 0;
    return rl.colorFromHSV(h, s, v);
}
