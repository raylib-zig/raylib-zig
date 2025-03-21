//! # raylib-zig [core] example - Input gestures detection
//!
//! raylib-zig (c) Nikolas Wipper 2025

const rl = @import("raylib");

const MAX_GESTURE_STRINGS = 20;

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    rl.initWindow(screen_width, screen_height, "raylib-zig [core] example - input gestures");

    var touch_position: rl.Vector2 = .zero();
    const touch_area: rl.Rectangle = .init(
        220,
        10,
        screen_width - 230,
        screen_height - 20,
    );

    var gestures_count: usize = 0;
    var gesture_strings: [MAX_GESTURE_STRINGS][:0]const u8 = undefined;

    var current_gesture: rl.Gesture = .none;
    var last_gesture: rl.Gesture = .none;

    //rl.setGesturesEnabled(.tap); // Enable only some gestures to be detected

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        last_gesture = current_gesture;
        current_gesture = rl.getGestureDetected();
        touch_position = rl.getTouchPosition(0);

        if (rl.checkCollisionPointRec(touch_position, touch_area) and (current_gesture != .none)) {
            if (current_gesture != last_gesture) {
                // Store gesture string
                gesture_strings[gestures_count] = switch (current_gesture) {
                    .tap => "GESTURE TAP",
                    .doubletap => "GESTURE DOUBLETAP",
                    .hold => "GESTURE HOLD",
                    .drag => "GESTURE DRAG",
                    .swipe_right => "GESTURE SWIPE RIGHT",
                    .swipe_left => "GESTURE SWIPE LEFT",
                    .swipe_up => "GESTURE SWIPE UP",
                    .swipe_down => "GESTURE SWIPE DOWN",
                    .pinch_in => "GESTURE PINCH IN",
                    .pinch_out => "GESTURE PINCH OUT",
                    else => break,
                };

                gestures_count += 1;

                // Reset gestures strings
                if (gestures_count >= MAX_GESTURE_STRINGS) {
                    for (0..MAX_GESTURE_STRINGS) |i| {
                        gesture_strings[i] = "";
                    }
                    gestures_count = 0;
                }
            }
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();

        rl.clearBackground(.white);

        rl.drawRectangleRec(touch_area, .gray);
        rl.drawRectangle(225, 15, screen_width - 240, screen_height - 30, .white);

        rl.drawText(
            "GESTURES TEST AREA",
            screen_width - 270,
            screen_height - 40,
            20,
            rl.fade(.gray, 0.5),
        );

        for (0..gestures_count) |i| {
            if (i % 2 == 0)
                rl.drawRectangle(10, 30 + @as(i32, @intCast(20 * i)), 200, 20, rl.fade(.light_gray, 0.5))
            else
                rl.drawRectangle(10, 30 + @as(i32, @intCast(20 * i)), 200, 20, rl.fade(.light_gray, 0.3));

            if (i < gestures_count - 1)
                rl.drawText(
                    gesture_strings[i],
                    35,
                    36 + @as(i32, @intCast(20 * i)),
                    10,
                    .dark_gray,
                )
            else
                rl.drawText(
                    gesture_strings[i],
                    35,
                    36 + @as(i32, @intCast(20 * i)),
                    10,
                    .maroon,
                );
        }

        rl.drawRectangleLines(10, 29, 200, screen_height - 50, .gray);
        rl.drawText("DETECTED GESTURES", 50, 15, 10, .gray);

        if (current_gesture != .none)
            rl.drawCircleV(touch_position, 30, .maroon);

        rl.endDrawing();
        //----------------------------------------------------------------------------------
    }
}
