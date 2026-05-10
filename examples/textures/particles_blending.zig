//!******************************************************************************************
//!
//!   raylib-zig port of the [textures] example - particles blending
//!   https://github.com/raysan5/raylib/blob/master/examples/textures/textures_particles_blending.c
//!
//!   Example complexity rating: [★☆☆☆] 1/4
//!
//!   Example originally created with raylib 1.7, last time updated with raylib 3.5
//!
//!   Translated to raylib-zig by Timothy Fiss (@TheFissk)
//!
//!   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//!   BSD-like license that allows static linking with closed source software
//!
//!   Copyright (c) 2017-2025 Ramon Santamaria (@raysan5)
//!
//!*******************************************************************************************

const rl = @import("raylib");

const MAX_PARTICLES = 200;

// Particle structure with basic data
const Particle = struct {
    position: rl.Vector2,
    color: rl.Color,
    alpha: f32,
    size: f32,
    rotation: f32,
    active: bool, // NOTE: Use it to activate/deactive particle
};

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    rl.initWindow(screen_width, screen_height, "raylib [textures] example - particles blending");
    defer rl.closeWindow();

    // Particles pool, reuse them!
    var mouse_tail: [MAX_PARTICLES]Particle = undefined;

    // Initialize particles
    for (&mouse_tail) |*tail| {
        tail.position = .{ .x = 0, .y = 0 };
        tail.color = .{
            .r = @intCast(rl.getRandomValue(0, 255)),
            .g = @intCast(rl.getRandomValue(0, 255)),
            .b = @intCast(rl.getRandomValue(0, 255)),
            .a = 255,
        };
        tail.alpha = 1.0;
        tail.size = @as(f32, @floatFromInt(rl.getRandomValue(1, 30))) / 20.0;
        tail.rotation = @floatFromInt(rl.getRandomValue(0, 360));
        tail.active = false;
    }

    const gravity = 3.0;

    const smoke = try rl.loadTexture("examples/textures/resources/spark_flame.png");
    defer smoke.unload();

    var blending = rl.BlendMode.alpha;

    rl.setTargetFPS(60);
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------

        // Activate one particle every frame and Update active particles
        // NOTE: Particles initial position should be mouse position when activated
        // NOTE: Particles fall down with gravity and rotation... and disappear after 2 seconds (alpha = 0)
        // NOTE: When a particle disappears, active = false and it can be reused.
        for (&mouse_tail) |*tail| {
            if (!tail.active) {
                tail.active = true;
                tail.alpha = 1.0;
                tail.position = rl.getMousePosition();
                break;
            }
        }

        for (&mouse_tail) |*tail| {
            if (tail.active) {
                tail.position.y += gravity / 2.0;
                tail.alpha -= 0.005;

                if (tail.alpha <= 0.0) tail.active = false;

                tail.rotation += 2.0;
            }
        }

        if (rl.isKeyPressed(.space)) {
            blending = if (blending == rl.BlendMode.alpha) rl.BlendMode.additive else rl.BlendMode.alpha;
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.dark_gray);

        rl.beginBlendMode(blending);
        {
            defer rl.endBlendMode();

            // Draw active particles
            for (&mouse_tail) |*tail| {
                if (tail.active) rl.drawTexturePro(
                    smoke,
                    .{
                        .x = 0.0,
                        .y = 0.0,
                        .width = @floatFromInt(smoke.width),
                        .height = @floatFromInt(smoke.height),
                    },
                    .{
                        .x = tail.position.x,
                        .y = tail.position.y,
                        .width = @as(f32, @floatFromInt(smoke.width)) * tail.size,
                        .height = @as(f32, @floatFromInt(smoke.height)) * tail.size,
                    },
                    .{
                        .x = (@as(f32, @floatFromInt(smoke.width)) * tail.size / 2.0),
                        .y = (@as(f32, @floatFromInt(smoke.height)) * tail.size / 2.0),
                    },
                    tail.rotation,
                    rl.fade(tail.color, tail.alpha),
                );
            }
        }

        rl.drawText("PRESS SPACE to CHANGE BLENDING MODE", 180, 20, 20, .black);

        if (blending == rl.BlendMode.alpha) {
            rl.drawText("ALPHA BLENDING", 290, screen_height - 40, 20, .black);
        } else {
            rl.drawText("ADDITIVE BLENDING", 280, screen_height - 40, 20, .ray_white);
        }

        //----------------------------------------------------------------------------------
    }
}
