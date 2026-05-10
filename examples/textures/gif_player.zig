//!******************************************************************************************
//!
//!   raylib-zig port of the [textures] example - gif playing
//!   https://github.com/raysan5/raylib/blob/master/examples/textures/textures_gif_player.c
//!
//!   Example complexity rating: [★★★☆] 3/4
//!
//!   Example originally created with raylib 4.2, last time updated with raylib 4.2
//!
//!   Translated to raylib-zig by Timothy Fiss (@TheFissk)
//!
//!   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//!   BSD-like license that allows static linking with closed source software
//!
//!   Copyright (c) 2021-2025 Ramon Santamaria (@raysan5)
//!
//!*******************************************************************************************

const rl = @import("raylib");

const max_frame_delay = 20;
const min_frame_delay = 1;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    rl.initWindow(screen_width, screen_height, "raylib [textures] example - gif playing");
    defer rl.closeWindow();

    var anim_frames: i32 = 0;

    // Load all GIF animation frames into a single Image
    // NOTE: GIF data is always loaded as RGBA (32bit) by default
    // NOTE: Frames are just appended one after another in image.data memory
    const im_scarfy_anim = try rl.loadImageAnim("examples/textures/resources/scarfy_run.gif", &anim_frames);
    defer rl.unloadImage(im_scarfy_anim);

    // Load texture from image
    // NOTE: We will update this texture when required with next frame data
    // WARNING: It's not recommended to use this technique for sprites animation,
    // use spritesheets instead, like illustrated in textures_sprite_anim example
    const tex_scarfy_anim = try rl.loadTextureFromImage(im_scarfy_anim);
    defer rl.unloadTexture(tex_scarfy_anim);

    var next_frame_data_offset: usize = 0; // Current byte offset to next frame in image.data

    var current_anim_frame: i32 = 0; // Current animation frame to load and draw
    var frame_delay: i32 = 8; // Frame delay to switch between animation frames
    var frame_counter: i32 = 0; // General frames counter

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        frame_counter += 1;
        if (frame_counter >= frame_delay) {
            // Move to next frame
            // NOTE: If final frame is reached we return to first frame
            current_anim_frame += 1;
            if (current_anim_frame >= anim_frames) current_anim_frame = 0;

            // Get memory offset position for next frame data in image.data
            next_frame_data_offset = @as(usize, @intCast(im_scarfy_anim.width * im_scarfy_anim.height * 4 * current_anim_frame));

            // Update GPU texture data with next frame image data
            // WARNING: Data size (frame size) and pixel format must match already created texture
            rl.updateTexture(tex_scarfy_anim, @as([*]u8, @ptrCast(im_scarfy_anim.data)) + next_frame_data_offset);

            frame_counter = 0;
        }

        // Control frames delay
        if (rl.isKeyPressed(.right)) {
            frame_delay += 1;
        } else if (rl.isKeyPressed(.left)) {
            frame_delay -= 1;
        }

        if (frame_delay > max_frame_delay) {
            frame_delay = max_frame_delay;
        } else if (frame_delay < min_frame_delay) {
            frame_delay = min_frame_delay;
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        rl.drawText(rl.textFormat("TOTAL GIF FRAMES:  %02i", .{anim_frames}), 50, 30, 20, .light_gray);
        rl.drawText(rl.textFormat("CURRENT FRAME: %02i", .{current_anim_frame}), 50, 60, 20, .gray);
        rl.drawText(rl.textFormat("CURRENT FRAME IMAGE.DATA OFFSET: %02i", .{next_frame_data_offset}), 50, 90, 20, .gray);

        rl.drawText("FRAMES DELAY: ", 100, 305, 10, .dark_gray);
        rl.drawText(rl.textFormat("%02i frames", .{frame_delay}), 620, 305, 10, .dark_gray);
        rl.drawText("PRESS RIGHT/LEFT KEYS to CHANGE SPEED!", 290, 350, 10, .dark_gray);

        for (0..max_frame_delay) |i| {
            if (i < frame_delay) rl.drawRectangle(@intCast(190 + 21 * i), 300, 20, 20, .red);
            rl.drawRectangleLines(@intCast(190 + 21 * i), 300, 20, 20, .maroon);
        }

        rl.drawTexture(tex_scarfy_anim, screen_width / 2 - @divFloor(tex_scarfy_anim.width, 2), 140, .white);

        rl.drawText("(c) Scarfy sprite by Eiden Marsal", screen_width - 200, screen_height - 20, 10, .gray);

        //----------------------------------------------------------------------------------
    }
}
