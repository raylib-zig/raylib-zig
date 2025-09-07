//!******************************************************************************************
//!
//!   raylib-zig port of the [textures] example - sprite explosion
//!   https://github.com/raysan5/raylib/blob/master/examples/textures/textures_sprite_explosion.c
//!
//!   Example complexity rating: [★★☆☆] 2/4
//!
//!   Example originally created with raylib 2.5, last time updated with raylib 3.5
//!
//!   Translated to raylib-zig by Timothy Fiss (@TheFissk)
//!
//!   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//!   BSD-like license that allows static linking with closed source software
//!
//!   Copyright (c) 2019-2025 Ramon Santamaria (@raysan5)
//!
//!*******************************************************************************************/

const rl = @import("raylib");

const NUM_FRAMES_PER_LINE = 5;
const NUM_LINES = 5;

//------------------------------------------------------------------------------------
// Program main entry point
//-----------------------------------------------------------------------------------
pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    rl.initWindow(screen_width, screen_height, "raylib [textures] example - sprite explosion");
    defer rl.closeWindow();

    rl.initAudioDevice();
    defer rl.closeAudioDevice();

    // Load explosion sound
    const fx_boom = try rl.loadSound("examples/textures/resources/boom.wav");
    defer fx_boom.unload();

    // Load explosion texture
    const explosion = try rl.loadTexture("examples/textures/resources/explosion.png");
    defer explosion.unload();

    // Init variables for animation
    const frame_width: f32 = @as(f32, @floatFromInt(explosion.width)) / NUM_FRAMES_PER_LINE; // Sprite one frame rectangle width
    const frame_height: f32 = @as(f32, @floatFromInt(explosion.height)) / NUM_LINES; // Sprite one frame rectangle height
    var current_frame: i32 = 0;
    var current_line: i32 = 0;

    var frame_rec = rl.Rectangle{ .x = 0, .y = 0, .width = frame_width, .height = frame_height };
    var position = rl.Vector2{ .x = 0.0, .y = 0.0 };

    var active = false;
    var frame_counter: i32 = 0;

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //---------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------

        // Check for mouse button pressed and activate explosion (if not active)
        if (rl.isMouseButtonPressed(.left) and !active) {
            position = rl.getMousePosition();
            active = true;

            position.x -= frame_width / 2.0;
            position.y -= frame_height / 2.0;

            rl.playSound(fx_boom);
        }

        // Compute explosion animation frames
        if (active) {
            frame_counter += 1;

            if (frame_counter > 2) {
                current_frame += 1;

                if (current_frame >= NUM_FRAMES_PER_LINE) {
                    current_frame = 0;
                    current_line += 1;

                    if (current_line >= NUM_LINES) {
                        current_line = 0;
                        active = false;
                    }
                }

                frame_counter = 0;
            }
        }

        frame_rec.x = frame_width * @as(f32, @floatFromInt(current_frame));
        frame_rec.y = frame_height * @as(f32, @floatFromInt(current_line));
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        // Draw explosion required frame rectangle
        if (active) rl.drawTextureRec(explosion, frame_rec, position, .white);

        //----------------------------------------------------------------------------------
    }
}
