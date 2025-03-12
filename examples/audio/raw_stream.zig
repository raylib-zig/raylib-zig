// raylib-zig (c) Nikolas Wipper 2023

const rl = @import("raylib");

const MAX_SAMPLES = 512;
const MAX_SAMPLES_PER_UPDATE = 4096;

const pi = @import("std").math.pi;
var frequency: f32 = 440;
var audioFrequency: f32 = 440;
var oldFrequency: f32 = 1;
var sineIdx: f32 = 0;

fn audioInputCallback(buffer: ?*anyopaque, frames: c_uint) callconv(.C) void {
    audioFrequency = frequency + (audioFrequency - frequency) * 0.95;

    const incr = audioFrequency / 44100;
    const d: [*]i16 = @alignCast(@ptrCast(buffer orelse return));

    for (0..frames) |i| {
        d[i] = @intFromFloat(32000 * @sin(2 * pi * sineIdx));
        sineIdx += incr;
        if (sineIdx > 1) {
            sineIdx -= 1;
        }
    }
}

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [core] example - raw audio streaming");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.initAudioDevice();        // Initialize audio device
    defer rl.closeAudioDevice(); // Close audio device (music streaming is automatically stopped)

    rl.setAudioStreamBufferSizeDefault(MAX_SAMPLES_PER_UPDATE);

    // Init raw audio stream (sample rate: 44100, sample size: 16bit-short, channels: 1-mono)
    const stream = try rl.loadAudioStream(44100, 16, 1);
    defer rl.unloadAudioStream(stream); // Close raw audio stream and delete buffers from RAM

    rl.setAudioStreamCallback(stream, &audioInputCallback);

    // Buffer for the single cycle waveform we are synthesizing
    const data = try rl.mem.alloc(i16, MAX_SAMPLES);
    defer rl.mem.free(data); // Unload sine wave data

    // Frame buffer, describing the waveform when repeated over the course of a frame
    const writeBuf = try rl.mem.alloc(i16, MAX_SAMPLES_PER_UPDATE);
    defer rl.mem.free(writeBuf); // Unload write buffer

    rl.playAudioStream(stream); // Start processing stream buffer (no data loaded currently)

    // Computed size in samples of the sine wave
    var waveLength: i32 = 1;

    var position = rl.Vector2{ .x = 0, .y = 0 };

    rl.setTargetFPS(30); // Set our game to run at 30 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------

        if (rl.isMouseButtonDown(.left)) {
            // Sample mouse input.
            const mousePosition = rl.getMousePosition();

            const fp = (screenHeight - mousePosition.y);
            frequency = 40 + fp;

            const pan = (screenWidth - mousePosition.x) / screenWidth;
            rl.setAudioStreamPan(stream, pan);
        }

        // Rewrite the sine wave
        // Compute two cycles to allow buffer padding, simplifying any modulation, resampling, etc.
        if (frequency != oldFrequency) {
            // Compute wavelength. Limit size in both directions.
            //int oldWavelength = waveLength;
            waveLength = @intFromFloat(22050 / frequency);
            waveLength = @min(@max(1, waveLength), MAX_SAMPLES / 2);

            // Write sine wave
            const n: u32 = @intCast(waveLength * 2);
            for (0..n) |i| {
                const wlen: f32 = @floatFromInt(waveLength);
                const idx: f32 = @floatFromInt(i);
                data[i] = @intFromFloat(@sin((2 * pi * idx / wlen)) * 32000);
            }
            // Make sure the rest of the line is flat
            for (n..MAX_SAMPLES) |i| {
                data[i] = 0;
            }

            // Scale read cursor's position to minimize transition artifacts
            //readCursor = (int)(readCursor * ((float)waveLength / (float)oldWavelength));
            oldFrequency = frequency;
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        rl.drawText(rl.textFormat("sine frequency: %i", .{@as(i32, @intFromFloat(frequency))}),
            rl.getScreenWidth() - 220, 10, 20, .red);
        rl.drawText("click mouse button to change frequency or pan",
            10, 10, 20, .dark_gray);

        // Draw the current buffer state proportionate to the screen
        for (0..screenWidth) |i| {
            position.x = @floatFromInt(i);
            const y: f32 = @floatFromInt(data[@divFloor(i * MAX_SAMPLES, screenWidth)]);
            position.y = 250 + 50 * y / 32000;

            rl.drawPixelV(position, .red);
        }
        //----------------------------------------------------------------------------------
    }
}
