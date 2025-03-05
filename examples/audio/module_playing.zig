const rl = @import("raylib");

const MAX_CIRCLES = 64;

const CircleWave = struct {
    position: rl.Vector2,
    radius: f32,
    alpha: f32,
    speed: f32,
    color: rl.Color,
};

const screenWidth = 800;
const screenHeight = 450;

const colors = [14]rl.Color{ rl.Color.orange, rl.Color.red, rl.Color.gold, rl.Color.lime, rl.Color.blue, rl.Color.violet, rl.Color.brown, rl.Color.light_gray, rl.Color.pink, rl.Color.yellow, rl.Color.green, rl.Color.sky_blue, rl.Color.purple, rl.Color.beige };

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() !void {
    // Initialization
    //--------------------------------------------------------------------------------------
    rl.setConfigFlags(rl.ConfigFlags{ .msaa_4x_hint = true }); // NOTE: Try to enable MSAA 4X

    rl.initWindow(screenWidth, screenHeight, "raylib [audio] example - module playing (streaming)");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.initAudioDevice(); // Initialize audio device
    defer rl.closeAudioDevice(); // Close audio device (music streaming is automatically stopped)

    // Creates some circles for visual effect
    var circles: [MAX_CIRCLES]CircleWave = undefined;

    for (&circles) |*circle| {
        initCircle(circle);
    }

    var music: rl.Music = try rl.loadMusicStream("resources/audio/mini1111.xm");
    defer rl.unloadMusicStream(music); // Unload music stream buffers from RAM

    music.looping = false;
    var pitch: f32 = 1;

    rl.playMusicStream(music);

    var timePlayed: f32 = 0;
    var pause: bool = false;

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        rl.updateMusicStream(music); // Update music buffer with new stream data

        // Restart music playing (stop and play)
        if (rl.isKeyPressed(rl.KeyboardKey.space)) {
            rl.stopMusicStream(music);
            rl.playMusicStream(music);
            pause = false;
        }

        // Pause/Resume music playing
        if (rl.isKeyPressed(rl.KeyboardKey.p)) {
            pause = !pause;

            if (pause) {
                rl.pauseMusicStream(music);
            } else {
                rl.resumeMusicStream(music);
            }
        }

        if (rl.isKeyDown(rl.KeyboardKey.down)) {
            pitch -= 0.01;
        } else if (rl.isKeyDown(rl.KeyboardKey.up)) {
            pitch += 0.01;
        }

        rl.setMusicPitch(music, pitch);

        // Get timePlayed scaled to bar dimensions
        timePlayed = rl.getMusicTimePlayed(music) / rl.getMusicTimeLength(music) * (screenWidth - 40);

        if (!pause) {
            for (&circles) |*circle| {
                circle.alpha += circle.speed;
                circle.radius += circle.speed * 10.0;

                if (circle.alpha > 1.0) circle.speed *= -1;

                if (circle.alpha <= 0.0) {
                    initCircle(circle);
                }
            }
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();

        rl.clearBackground(rl.Color.white);

        for (circles) |circle| {
            rl.drawCircleV(circle.position, circle.radius, rl.fade(circle.color, circle.alpha));
        }

        // Draw time bar
        rl.drawRectangle(20, screenHeight - 20 - 12, screenWidth - 40, 12, rl.Color.light_gray);
        rl.drawRectangle(20, screenHeight - 20 - 12, @intFromFloat(timePlayed), 12, rl.Color.maroon);
        rl.drawRectangleLines(20, screenHeight - 20 - 12, screenWidth - 40, 12, rl.Color.gray);

        // Draw help instructions
        rl.drawRectangle(20, 20, 425, 145, rl.Color.white);
        rl.drawRectangleLines(20, 20, 425, 145, rl.Color.gray);
        rl.drawText("PRESS SPACE TO RESTART MUSIC", 40, 40, 20, rl.Color.black);
        rl.drawText("PRESS P TO PAUSE/RESUME", 40, 70, 20, rl.Color.black);
        rl.drawText("PRESS UP/DOWN TO CHANGE SPEED", 40, 100, 20, rl.Color.black);
        rl.drawText(rl.textFormat("SPEED: %f", .{pitch}), 40, 130, 20, rl.Color.maroon);

        rl.endDrawing();
        //----------------------------------------------------------------------------------
    }
}

fn initCircle(circle: *CircleWave) void {
    circle.alpha = 0.0;
    circle.radius = getRandomValuef32(10, 40);
    circle.position.x = getRandomValuef32(@intFromFloat(circle.radius), @intFromFloat(screenWidth - circle.radius));
    circle.position.y = getRandomValuef32(@intFromFloat(circle.radius), @intFromFloat(screenHeight - circle.radius));
    circle.speed = getRandomValuef32(1, 100) / 2000.0;
    circle.color = colors[@intCast(rl.getRandomValue(0, 13))];
}

fn getRandomValuef32(min: i32, max: i32) f32 {
    return @as(f32, @floatFromInt(rl.getRandomValue(min, max)));
}
