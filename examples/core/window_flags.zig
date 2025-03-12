//! # raylib-zig [core] example - window flags
//!
//! Example originally created with raylib-zig 5.0, last time updated with
//! raylib-zig 5.0
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
    // -------------------------------------------------------------------------

    // Possible window flags
    // flag_vsync_hint
    // flag_fullscreen_mode    -> not working properly -> wrong scaling!
    // flag_window_resizable
    // flag_window_undecorated
    // flag_window_transparent
    // flag_window_hidden
    // flag_window_minimized   -> Not supported on window creation
    // flag_window_maximized   -> Not supported on window creation
    // flag_window_unfocused
    // flag_window_topmost
    // flag_window_highdpi     -> errors after minimize-resize, fb size is recalculated
    // flag_window_always_run
    // flag_msaa_4x_hint

    // Set configuration flags for window creation
    // rl.setConfigFlags(
    //     @enumFromInt(@intFromEnum(rl.ConfigFlags.flag_vsync_hint) | @intFromEnum(rl.ConfigFlags.flag_msaa_4x_hint) | @intFromEnum(rl.ConfigFlags.flag_window_highdpi)),
    // );
    rl.initWindow(
        screen_width,
        screen_height,
        "raylib-zig [core] example - window flags",
    );
    defer rl.closeWindow(); // Close window and OpenGL context

    var ball_position = rl.Vector2.init(
        @floatFromInt(@divFloor(rl.getScreenWidth(), 2)),
        @floatFromInt(@divFloor(rl.getScreenHeight(), 2)),
    );
    var ball_speed = rl.Vector2.init(5, 4);
    const ball_radius: f32 = 20;

    var frames_counter: i32 = 0;

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second

    while (!rl.windowShouldClose()) {
        // Update
        // ---------------------------------------------------------------------
        if (rl.isKeyPressed(.f)) rl.toggleFullscreen(); // Modifies window size when scaling!

        if (rl.isKeyPressed(.r)) {
            if (rl.isWindowState(rl.ConfigFlags { .window_resizable = true })) {
                rl.clearWindowState(rl.ConfigFlags { .window_resizable = true });
            } else {
                rl.setWindowState(rl.ConfigFlags { .window_resizable = true });
            }
        }

        if (rl.isKeyPressed(.d)) {
            if (rl.isWindowState(rl.ConfigFlags { .window_undecorated = true })) {
                rl.clearWindowState(rl.ConfigFlags { .window_undecorated = true });
            } else {
                rl.setWindowState(rl.ConfigFlags { .window_undecorated = true });
            }
        }

        if (rl.isKeyPressed(.h)) {
            if (!rl.isWindowState(rl.ConfigFlags { .window_hidden = true })) {
                rl.setWindowState(rl.ConfigFlags { .window_hidden = true });
            }
            frames_counter = 0;
        }

        if (rl.isWindowState(rl.ConfigFlags { .window_hidden = true })) {
            frames_counter += 1;
            if (frames_counter >= 240) rl.clearWindowState(rl.ConfigFlags { .window_hidden = true }); // Show window after 3 seconds
        }

        if (rl.isKeyPressed(.n)) {
            if (!rl.isWindowState(rl.ConfigFlags { .window_minimized = true })) {
                rl.minimizeWindow();
            }
            frames_counter = 0;
        }

        if (rl.isWindowState(rl.ConfigFlags { .window_minimized = true })) {
            frames_counter += 1;
            if (frames_counter >= 240) rl.restoreWindow(); // Restore window after 3 seconds
        }

        if (rl.isKeyPressed(.m)) {
            // NOTE: Requires `flag_window_resizable` enabled!
            if (rl.isWindowState(rl.ConfigFlags { .window_maximized = true })) {
                rl.restoreWindow();
            } else rl.maximizeWindow();
        }

        if (rl.isKeyPressed(.u)) {
            if (rl.isWindowState(rl.ConfigFlags { .window_unfocused = true })) {
                rl.clearWindowState(rl.ConfigFlags { .window_unfocused = true });
            } else rl.setWindowState(rl.ConfigFlags { .window_unfocused = true });
        }

        if (rl.isKeyPressed(.t)) {
            if (rl.isWindowState(rl.ConfigFlags { .window_topmost = true })) {
                rl.clearWindowState(rl.ConfigFlags { .window_topmost = true });
            } else rl.setWindowState(rl.ConfigFlags { .window_topmost = true });
        }

        if (rl.isKeyPressed(.a)) {
            if (rl.isWindowState(rl.ConfigFlags { .window_always_run = true })) {
                rl.clearWindowState(rl.ConfigFlags { .window_always_run = true });
            } else rl.setWindowState(rl.ConfigFlags { .window_always_run = true });
        }

        if (rl.isKeyPressed(.v)) {
            if (rl.isWindowState(rl.ConfigFlags { .vsync_hint = true })) {
                rl.clearWindowState(rl.ConfigFlags { .vsync_hint = true });
            } else rl.setWindowState(rl.ConfigFlags { .vsync_hint = true });
        }

        // Bouncing ball logic
        ball_position = ball_position.add(ball_speed);

        if (ball_position.x >= (@as(f32, @floatFromInt(rl.getScreenWidth())) - ball_radius) or ball_position.x <= ball_radius) {
            ball_speed.x *= -1;
        }
        if (ball_position.y >= (@as(f32, @floatFromInt(rl.getScreenHeight())) - ball_radius) or ball_position.y <= ball_radius) {
            ball_speed.y *= -1;
        }
        // ---------------------------------------------------------------------

        // Draw
        // ---------------------------------------------------------------------
        {
            rl.beginDrawing();
            defer rl.endDrawing();

            if (rl.isWindowState(rl.ConfigFlags { .window_transparent = true })) {
                rl.clearBackground(.blank);
            } else rl.clearBackground(.ray_white);

            rl.drawCircleV(ball_position, ball_radius, .maroon);
            rl.drawRectangleLinesEx(
                .init(0, 0, @floatFromInt(rl.getScreenWidth()), @floatFromInt(rl.getScreenHeight())),
                4,
                .ray_white,
            );

            rl.drawCircleV(rl.getMousePosition(), 10, .dark_blue);

            rl.drawFPS(10, 10);

            rl.drawText(
                rl.textFormat("Screen Size: [%i, %i]", .{ rl.getScreenWidth(), rl.getScreenHeight() }),
                10,
                40,
                10,
                .green,
            );

            // Draw window state info
            rl.drawText(
                "Following flags can be set after window creation:",
                10,
                60,
                10,
                .gray,
            );
            rl.drawText(
                rl.textFormat("[F] flag_fullscreen_mode: %d", .{
                    @as(i32, @intFromBool(rl.isWindowState(rl.ConfigFlags { .fullscreen_mode = true }))),
                }),
                10,
                80,
                10,
                .lime,
            );
            rl.drawText(
                rl.textFormat("[R] flag_window_resizable: %d", .{
                    @as(i32, @intFromBool(rl.isWindowState(rl.ConfigFlags { .window_resizable = true }))),
                }),
                10,
                100,
                10,
                .lime,
            );
            rl.drawText(
                rl.textFormat("[D] flag_window_undecorated: %d", .{
                    @as(i32, @intFromBool(rl.isWindowState(rl.ConfigFlags { .window_undecorated = true }))),
                }),
                10,
                120,
                10,
                .lime,
            );
            rl.drawText(
                rl.textFormat("[H] flag_window_hidden: %d", .{
                    @as(i32, @intFromBool(rl.isWindowState(rl.ConfigFlags { .window_hidden = true }))),
                }),
                10,
                140,
                10,
                .lime,
            );
            rl.drawText(
                rl.textFormat("[N] flag_window_minimized: %d", .{
                    @as(i32, @intFromBool(rl.isWindowState(rl.ConfigFlags { .window_minimized = true }))),
                }),
                10,
                160,
                10,
                .lime,
            );
            rl.drawText(
                rl.textFormat("[M] flag_window_maximized: %d", .{
                    @as(i32, @intFromBool(rl.isWindowState(rl.ConfigFlags { .window_maximized = true }))),
                }),
                10,
                180,
                10,
                .lime,
            );
            rl.drawText(
                rl.textFormat("[U] flag_window_unfocused: %d", .{
                    @as(i32, @intFromBool(rl.isWindowState(rl.ConfigFlags { .window_unfocused = true }))),
                }),
                10,
                200,
                10,
                .lime,
            );
            rl.drawText(
                rl.textFormat("[T] flag_window_topmost: %d", .{
                    @as(i32, @intFromBool(rl.isWindowState(rl.ConfigFlags { .window_topmost = true }))),
                }),
                10,
                220,
                10,
                .lime,
            );
            rl.drawText(
                rl.textFormat("[A] flag_window_always_run: %d", .{
                    @as(i32, @intFromBool(rl.isWindowState(rl.ConfigFlags { .window_always_run = true }))),
                }),
                10,
                240,
                10,
                .lime,
            );
            rl.drawText(
                rl.textFormat("[V] flag_vsync_hint: %d", .{
                    @as(i32, @intFromBool(rl.isWindowState(rl.ConfigFlags { .vsync_hint = true }))),
                }),
                10,
                260,
                10,
                .lime,
            );

            rl.drawText(
                "Following flags can only be set before window creation:",
                10,
                300,
                10,
                .gray,
            );
            rl.drawText(
                rl.textFormat("flag_window_highdpi: %d", .{
                    @as(i32, @intFromBool(rl.isWindowState(rl.ConfigFlags { .window_highdpi = true }))),
                }),
                10,
                320,
                10,
                .lime,
            );
            rl.drawText(
                rl.textFormat("flag_window_transparent: %d", .{
                    @as(i32, @intFromBool(rl.isWindowState(rl.ConfigFlags { .window_transparent = true }))),
                }),
                10,
                340,
                10,
                .lime,
            );
            rl.drawText(
                rl.textFormat("flag_msaa_4x_hint: %d", .{
                    @as(i32, @intFromBool(rl.isWindowState(rl.ConfigFlags { .msaa_4x_hint = true }))),
                }),
                10,
                360,
                10,
                .lime,
            );
        }
        // ---------------------------------------------------------------------
    }
}
