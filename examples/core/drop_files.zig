// raylib-zig (c) Leonardo Kreienbuehl 2025

const rl = @import("raylib");
const std = @import("std");

const MAX_FILEPATH_RECORDED = 4096;
const MAX_FILEPATH_SIZE = 2048;

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [core] example - drop files");
    defer rl.closeWindow(); // Close window and OpenGL context

    var filePathCounter: usize = 0;
    var filePaths: [MAX_FILEPATH_RECORDED][MAX_FILEPATH_SIZE]u8 = std.mem.zeroes([MAX_FILEPATH_RECORDED][MAX_FILEPATH_SIZE]u8);

    rl.setTargetFPS(60);

    // Main game loop
    while (!rl.windowShouldClose()) {
        // Update
        //----------------------------------------------------------------------------------
        if (rl.isFileDropped()) {
            const droppedFiles: rl.FilePathList = rl.loadDroppedFiles();

            for (0..droppedFiles.count) |i| {
                const offset: usize = @as(usize, @intCast(filePathCounter));
                const droppedFilePathLength: usize = std.mem.len(droppedFiles.paths[i]);

                if (filePathCounter < (MAX_FILEPATH_RECORDED - 1)) {
                    _ = rl.textCopy(
                        @ptrCast(@constCast(&filePaths[offset])),
                        droppedFiles.paths[i][0..droppedFilePathLength :0],
                    );
                    filePathCounter += 1;
                }
            }

            rl.unloadDroppedFiles(droppedFiles);
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.ray_white);

        if (filePathCounter == 0) {
            rl.drawText(
                "Drop your files to this window!",
                100,
                40,
                20,
                rl.Color.dark_gray,
            );
        } else {
            rl.drawText(
                "Dropped files:",
                100,
                40,
                20,
                rl.Color.dark_gray,
            );

            for (0..filePathCounter) |i| {
                const castedI: i32 = @intCast(i);
                if (@mod(i, 2) == 0) {
                    rl.drawRectangle(
                        0,
                        85 + 40 * castedI,
                        screenWidth,
                        40,
                        rl.fade(rl.Color.light_gray, 0.5),
                    );
                } else {
                    rl.drawRectangle(
                        0,
                        85 + 40 * castedI,
                        screenWidth,
                        40,
                        rl.fade(rl.Color.light_gray, 0.3),
                    );
                }

                rl.drawText(
                    filePaths[i][0 .. MAX_FILEPATH_SIZE - 1 :0],
                    120,
                    100 + 40 * castedI,
                    10,
                    rl.Color.gray,
                );
            }
        }
        //----------------------------------------------------------------------------------
    }
}
