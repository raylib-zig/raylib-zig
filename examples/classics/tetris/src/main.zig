const std = @import("std");
const rl = @import("raylib");

const SQUARE_SIZE = 20;
const GRID_HORIZONTAL_SIZE = 12;
const GRID_VERTICAL_SIZE = 20;
const LATERAL_SPEED = 10;
const TURNING_SPEED = 12;
const FAST_FALL_AWAIT_COUNTER = 30;
const FADING_TIME = 33;
const color = rl.Color;
const isKeyPressed = rl.isKeyPressed;
const IsKeyDown = rl.isKeyDown;
const drawLine = rl.drawLine;
const drawText = rl.drawText;
const drawRectangle = rl.drawRectangle;

// Enums and type definitions
const GridSquare = enum {
    empty,
    moving,
    full,
    block,
    fading,
};

// Global variable definitions
const screenWidth: i32 = 800;
const screenHeight: i32 = 600;

var gameOver: bool = false;
var pause: bool = false;

// Matrices
var grid: [GRID_HORIZONTAL_SIZE][GRID_VERTICAL_SIZE]GridSquare = undefined;
var piece: [4][4]GridSquare = undefined;
var incomingPiece: [4][4]GridSquare = undefined;

// Track active piece position
var piecePositionX: usize = 0;
var piecePositionY: usize = 0;

// Game params
var fadingColor: rl.Color = undefined;

var beginPlay: bool = true;
var pieceActive: bool = false;
var detection: bool = false;
var lineToDelete: bool = false;

var level: i32 = 1;
var lines: i32 = 0;

// Counters
var gravityMovementCounter: i32 = 0;
var lateralMovementCounter: i32 = 0;
var turnMovementCounter: i32 = 0;
var fastFallMovementCounter: i32 = 0;
var fadeLineCounter: i32 = 0;

// Based on level
var gravitySpeed: i32 = 30;

pub fn main() !void {
    rl.initWindow(screenWidth, screenHeight, "Classic Game: Tetris");
    try initGame();
    rl.setTargetFPS(60);

    while (!rl.windowShouldClose()) {
        try updateDrawFrame();
    }

    rl.closeWindow();
}

fn initGame() !void {
    level = 1;
    lines = 0;
    fadingColor = color.gray;
    piecePositionX = 0;
    piecePositionY = 0;
    pause = false;
    beginPlay = true;
    pieceActive = false;
    detection = false;
    lineToDelete = false;

    gravityMovementCounter = 0;
    lateralMovementCounter = 0;
    turnMovementCounter = 0;
    fastFallMovementCounter = 0;

    fadeLineCounter = 0;
    gravitySpeed = 30;

    // Initialize the grid
    for (0..GRID_HORIZONTAL_SIZE) |i| {
        for (0..GRID_VERTICAL_SIZE) |j| {
            if ((j == GRID_VERTICAL_SIZE - 1) or (i == 0) or (i == GRID_HORIZONTAL_SIZE - 1)) {
                grid[i][j] = GridSquare.block;
            } else {
                grid[i][j] = GridSquare.empty;
            }
        }
    }

    // Initialize the incoming piece
    for (0..4) |i| {
        for (0..4) |j| {
            incomingPiece[i][j] = GridSquare.empty;
        }
    }
}

fn updateGame() !void {
    if (!gameOver) {
        if (rl.isKeyPressed(.p)) pause = !pause;
        if (!pause) {
            if (!lineToDelete) {
                if (!pieceActive) {
                    pieceActive = CreatePiece();
                    fastFallMovementCounter = 0;
                } else {
                    fastFallMovementCounter += 1;
                    gravityMovementCounter += 1;
                    lateralMovementCounter += 1;
                    turnMovementCounter += 1;

                    if (rl.isKeyPressed(.left) or rl.isKeyPressed(.right)) lateralMovementCounter = LATERAL_SPEED;
                    if (rl.isKeyPressed(.up)) turnMovementCounter = TURNING_SPEED;

                    if (rl.isKeyDown(.down) and (fastFallMovementCounter >= FAST_FALL_AWAIT_COUNTER)) {
                        gravityMovementCounter += gravitySpeed;
                    }

                    if (gravityMovementCounter >= gravitySpeed) {
                        CheckDetection(&detection);
                        resolveFallingMovement(&detection, &pieceActive);
                        CheckCompletion(&lineToDelete);
                        gravityMovementCounter = 0;
                    }

                    if (lateralMovementCounter >= LATERAL_SPEED) {
                        if (!resolveLateralMovement()) lateralMovementCounter = 0;
                    }

                    if (turnMovementCounter >= TURNING_SPEED) {
                        if (resolveTurnMovement()) turnMovementCounter = 0;
                    }
                }
                for (0..2) |j| {
                    for (1..GRID_HORIZONTAL_SIZE) |i| {
                        if (grid[i][j] == GridSquare.full) {
                            gameOver = true;
                        }
                    }
                }
            } else {
                fadeLineCounter += 1;
                if (@mod(fadeLineCounter, 8) < 4) fadingColor = color{ .r = 255, .g = 49, .b = 49, .a = 255 } else fadingColor = color.gray;
                if (fadeLineCounter >= FADING_TIME) {
                    const deletedLines: i32 = deleteCompleteLines();
                    fadeLineCounter = 0;
                    lineToDelete = false;
                    lines += deletedLines;
                }
            }
        }
    } else {
        if (isKeyPressed(.enter)) {
            try initGame();
            gameOver = false;
        }
    }
}

fn drawGame() !void {
    rl.beginDrawing();
    defer rl.endDrawing();
    rl.clearBackground(color.ray_white);
    if (!gameOver) {
        var offset: rl.Vector2 = undefined;
        offset.x = @as(i32, (@as(i32, screenWidth) / 2 - @as(i32, (GRID_HORIZONTAL_SIZE * SQUARE_SIZE / 2)) - 50));
        offset.y = @as(i32, (@as(i32, screenHeight) / 2 - @as(i32, ((GRID_VERTICAL_SIZE - 1) * SQUARE_SIZE / 2)) + SQUARE_SIZE * 2));

        offset.y -= 50; // NOTE: Hardcoded position!
        const controller = offset.x;
        for (0..GRID_VERTICAL_SIZE) |j| {
            for (0..GRID_HORIZONTAL_SIZE) |i| {
                if (grid[i][j] == GridSquare.empty) {
                    drawLine(@as(i32, @intFromFloat(offset.x)), @as(i32, @intFromFloat(offset.y)), @as(i32, @intFromFloat(offset.x + SQUARE_SIZE)), @as(i32, @intFromFloat(offset.y)), color.light_gray);

                    drawLine(@as(i32, @intFromFloat(offset.x)), @as(i32, @intFromFloat(offset.y)), @as(i32, @intFromFloat(offset.x)), @as(i32, @intFromFloat(offset.y + SQUARE_SIZE)), color.light_gray);
                    drawLine(@as(i32, @intFromFloat(offset.x + SQUARE_SIZE)), @as(i32, @intFromFloat(offset.y)), @as(i32, @intFromFloat(offset.x + SQUARE_SIZE)), @as(i32, @intFromFloat(offset.y + SQUARE_SIZE)), color.light_gray);
                    drawLine(@as(i32, @intFromFloat(offset.x)), @as(i32, @intFromFloat(offset.y + SQUARE_SIZE)), @as(i32, @intFromFloat(offset.x + SQUARE_SIZE)), @as(i32, @intFromFloat(offset.y + SQUARE_SIZE)), color.light_gray);
                    offset.x += SQUARE_SIZE;
                } else if (grid[i][j] == GridSquare.full) {
                    drawRectangle(@as(i32, @intFromFloat(offset.x)), @as(i32, @intFromFloat(offset.y)), @as(i32, @intFromFloat(SQUARE_SIZE)), @as(i32, @intFromFloat(SQUARE_SIZE)), color.gray);
                    offset.x += SQUARE_SIZE;
                } else if (grid[i][j] == GridSquare.moving) {
                    drawRectangle(@as(i32, @intFromFloat(offset.x)), @as(i32, @intFromFloat(offset.y)), @as(i32, @intFromFloat(SQUARE_SIZE)), @as(i32, @intFromFloat(SQUARE_SIZE)), color.dark_gray);
                    offset.x += SQUARE_SIZE;
                } else if (grid[i][j] == GridSquare.block) {
                    drawRectangle(@as(i32, @intFromFloat(offset.x)), @as(i32, @intFromFloat(offset.y)), @as(i32, @intFromFloat(SQUARE_SIZE)), @as(i32, @intFromFloat(SQUARE_SIZE)), color.light_gray);
                    offset.x += SQUARE_SIZE;
                } else if (grid[i][j] == GridSquare.fading) {
                    drawRectangle(@as(i32, @intFromFloat(offset.x)), @as(i32, @intFromFloat(offset.y)), @as(i32, @intFromFloat(SQUARE_SIZE)), @as(i32, @intFromFloat(SQUARE_SIZE)), fadingColor);
                    offset.x += SQUARE_SIZE;
                }
            }
            offset.x = controller;
            offset.y += SQUARE_SIZE;
        }
        offset.x = 500;
        offset.y = 45;
        const controler = offset.x;
        for (0..4) |j| {
            for (0..4) |i| {
                if (incomingPiece[i][j] == GridSquare.empty) {
                    drawLine(@as(i32, @intFromFloat(offset.x)), @as(i32, @intFromFloat(offset.y)), @as(i32, @intFromFloat(offset.x + SQUARE_SIZE)), @as(i32, @intFromFloat(offset.y)), color.light_gray);
                    offset.x += SQUARE_SIZE;
                } else if (incomingPiece[i][j] == GridSquare.moving) {
                    drawRectangle(@as(i32, @intFromFloat(offset.x)), @as(i32, @intFromFloat(offset.y)), @as(i32, @intFromFloat(SQUARE_SIZE)), @as(i32, @intFromFloat(SQUARE_SIZE)), color.light_gray);
                    offset.x += SQUARE_SIZE;
                }
            }

            offset.x = controler;
            offset.y += SQUARE_SIZE;
        }

        drawText("INCOMING:", @as(i32, @intFromFloat(offset.x)), @as(i32, @intFromFloat(offset.y - 100)), 10, color.light_gray);
        drawText(rl.textFormat("LINES:  %08i", .{lines * 300}), @as(i32, @intFromFloat(offset.x)), @as(i32, @intFromFloat(offset.y + 20)), 10, color{ .r = 57, .g = 255, .b = 20, .a = 255 });

        if (pause) drawText("GAME PAUSED", screenWidth / 2 - @divTrunc(rl.measureText("GAME PAUSED", 40), 2), screenHeight / 2 - 40, 40, color{ .r = 57, .g = 255, .b = 20, .a = 255 });
    } else {
        drawText("GAME OVER :(", @divTrunc(rl.getScreenWidth(), 2) - @divTrunc(rl.measureText("PRESS [ENTER] TO PLAY AGAIN", 20), 2), @divTrunc(rl.getScreenHeight(), 2) - 80, 20, color.red);

        drawText("PRESS [ENTER] TO PLAY AGAIN", @divTrunc(rl.getScreenWidth(), 2) - @divTrunc(rl.measureText("PRESS [ENTER] TO PLAY AGAIN", 20), 2), @divTrunc(rl.getScreenHeight(), 2) - 50, 20, color.red);
    }
}

fn updateDrawFrame() !void {
    try updateGame();
    try drawGame();
}

fn CreatePiece() bool {
    piecePositionX = ((GRID_HORIZONTAL_SIZE - 4) / 2);
    piecePositionY = 0;

    // If the game is starting and you are going to create the first piece, we create an extra one
    if (beginPlay) {
        try GetRandomPiece();
        beginPlay = false;
    }

    // We assign the incoming piece to the actual piece
    for (0..4) |i| {
        for (0..4) |j| {
            piece[i][j] = incomingPiece[i][j];
        }
    }

    // We assign a random piece to the incoming one
    try GetRandomPiece();

    // Assign the piece to the grid
    for (piecePositionX..piecePositionX + 4) |i| {
        for (0..4) |j| {
            if (piece[i - @as(usize, piecePositionX)][j] == GridSquare.moving) {
                grid[i][j] = GridSquare.moving;
            }
        }
    }

    return true;
}

fn GetRandomPiece() !void {
    const random = rl.getRandomValue(0, 6);

    for (0..4) |i| {
        for (0..4) |j| {
            incomingPiece[i][j] = GridSquare.empty;
        }
    }

    switch (random) {
        0 => {
            incomingPiece[1][1] = GridSquare.moving;
            incomingPiece[2][1] = GridSquare.moving;
            incomingPiece[1][2] = GridSquare.moving;
            incomingPiece[2][2] = GridSquare.moving;
        }, // Cube
        1 => {
            incomingPiece[1][0] = GridSquare.moving;
            incomingPiece[1][1] = GridSquare.moving;
            incomingPiece[1][2] = GridSquare.moving;
            incomingPiece[2][2] = GridSquare.moving;
        }, // L
        2 => {
            incomingPiece[1][2] = GridSquare.moving;
            incomingPiece[2][0] = GridSquare.moving;
            incomingPiece[2][1] = GridSquare.moving;
            incomingPiece[2][2] = GridSquare.moving;
        }, // Inverted L
        3 => {
            incomingPiece[0][1] = GridSquare.moving;
            incomingPiece[1][1] = GridSquare.moving;
            incomingPiece[2][1] = GridSquare.moving;
            incomingPiece[3][1] = GridSquare.moving;
        }, // Straight line
        4 => {
            incomingPiece[1][0] = GridSquare.moving;
            incomingPiece[1][1] = GridSquare.moving;
            incomingPiece[1][2] = GridSquare.moving;
            incomingPiece[2][1] = GridSquare.moving;
        }, // T shape
        5 => {
            incomingPiece[1][1] = GridSquare.moving;
            incomingPiece[2][1] = GridSquare.moving;
            incomingPiece[2][2] = GridSquare.moving;
            incomingPiece[3][2] = GridSquare.moving;
        }, // S shape
        6 => {
            incomingPiece[1][2] = GridSquare.moving;
            incomingPiece[2][2] = GridSquare.moving;
            incomingPiece[2][1] = GridSquare.moving;
            incomingPiece[3][1] = GridSquare.moving;
        }, // Inverted S shape
        else => {
            std.debug.print("Found unknown piece value", .{});
        },
    }
}

fn resolveFallingMovement(detect: *bool, active: *bool) void {
    if (detect.*) {
        var j: usize = GRID_VERTICAL_SIZE - 2;
        while (true) {
            var i: usize = 1;
            while (i < GRID_HORIZONTAL_SIZE - 1) : (i += 1) {
                if (grid[i][j] == GridSquare.moving) {
                    grid[i][j] = GridSquare.full;
                    detect.* = false;
                    active.* = false;
                }
            }
            if (j == 0) break;
            j -= 1;
        }
    } else {
        // We move down the piece
        var j: usize = GRID_VERTICAL_SIZE - 2;
        while (true) {
            var i: usize = 1;
            while (i < GRID_HORIZONTAL_SIZE - 1) : (i += 1) {
                if (grid[i][j] == GridSquare.moving) {
                    grid[i][j + 1] = GridSquare.moving;
                    grid[i][j] = GridSquare.empty;
                }
            }
            if (j == 0) break;
            j -= 1;
        }
        piecePositionY += 1;
    }
}

fn resolveLateralMovement() bool {
    var collision: bool = false;

    // Check left movement
    if (rl.isKeyDown(.left)) {
        // Check if it's possible to move left.
        // Loop through rows (j) from GRID_VERTICAL_SIZE - 2 down to 0.
        var j: usize = GRID_VERTICAL_SIZE - 2;
        while (true) {
            // Loop columns (i) from 1 to GRID_HORIZONTAL_SIZE - 2.
            var i: usize = 1;
            while (i < GRID_HORIZONTAL_SIZE - 1) : (i += 1) {
                if (grid[i][j] == GridSquare.moving) {
                    // If we’re touching the left wall (i-1 == 0)
                    // or if the square to the left is FULL, flag a collision.
                    if ((i - 1 == 0) or (grid[i - 1][j] == GridSquare.full)) {
                        collision = true;
                    }
                }
            }
            if (j == 0) break;
            j -= 1;
        }

        // If no collision, perform the movement
        if (!collision) {
            // Loop again to move the piece left.
            j = GRID_VERTICAL_SIZE - 2;
            while (true) {
                var i: usize = 1;
                while (i < GRID_HORIZONTAL_SIZE - 1) : (i += 1) {
                    if (grid[i][j] == GridSquare.moving) {
                        grid[i - 1][j] = GridSquare.moving;
                        grid[i][j] = GridSquare.empty;
                    }
                }
                if (j == 0) break;
                j -= 1;
            }
            // Decrement the piece's x-position, ensuring no underflow.
            if (piecePositionX > 0) {
                piecePositionX -= 1;
            }
        }
    }
    // Check right movement
    else if (rl.isKeyDown(.right)) {
        // Check if it's possible to move right.
        var j: usize = GRID_VERTICAL_SIZE - 2;
        while (true) {
            var i: usize = 1;
            while (i < GRID_HORIZONTAL_SIZE - 1) : (i += 1) {
                if (grid[i][j] == GridSquare.moving) {
                    // Check if touching the right wall or if the right square is full.
                    if ((i + 1 == GRID_HORIZONTAL_SIZE - 1) or (grid[i + 1][j] == GridSquare.full)) {
                        collision = true;
                    }
                }
            }
            if (j == 0) break;
            j -= 1;
        }

        if (!collision) {
            // Move the piece right.
            j = GRID_VERTICAL_SIZE - 2;
            while (true) {
                // To avoid overwriting cells, iterate columns from rightmost (GRID_HORIZONTAL_SIZE - 1)
                // down to 1.
                var i: usize = GRID_HORIZONTAL_SIZE - 1;
                while (true) {
                    if (i < 1) break;
                    if (grid[i][j] == GridSquare.moving) {
                        grid[i + 1][j] = GridSquare.moving;
                        grid[i][j] = GridSquare.empty;
                    }
                    if (i == 1) break;
                    i -= 1;
                }
                if (j == 0) break;
                j -= 1;
            }
            piecePositionX += 1;
        }
    }
    return collision;
}

fn resolveTurnMovement() bool {
    // Only attempt to rotate if the up key is pressed.
    if (rl.isKeyDown(.up)) {
        var aux: GridSquare = undefined;
        var checker: bool = false;

        // Check all turning possibilities (translated directly from your C code)
        if (grid[piecePositionX + 3][piecePositionY] == GridSquare.moving and
            (grid[piecePositionX][piecePositionY] != GridSquare.empty and
                grid[piecePositionX][piecePositionY] != GridSquare.moving))
        {
            checker = true;
        }
        if (grid[piecePositionX + 3][piecePositionY + 3] == GridSquare.moving and
            (grid[piecePositionX + 3][piecePositionY] != GridSquare.empty and
                grid[piecePositionX + 3][piecePositionY] != GridSquare.moving))
        {
            checker = true;
        }
        if (grid[piecePositionX][piecePositionY + 3] == GridSquare.moving and
            (grid[piecePositionX + 3][piecePositionY + 3] != GridSquare.empty and
                grid[piecePositionX + 3][piecePositionY + 3] != GridSquare.moving))
        {
            checker = true;
        }
        if (grid[piecePositionX][piecePositionY] == GridSquare.moving and
            (grid[piecePositionX][piecePositionY + 3] != GridSquare.empty and
                grid[piecePositionX][piecePositionY + 3] != GridSquare.moving))
        {
            checker = true;
        }
        if (grid[piecePositionX + 1][piecePositionY] == GridSquare.moving and
            (grid[piecePositionX][piecePositionY + 2] != GridSquare.empty and
                grid[piecePositionX][piecePositionY + 2] != GridSquare.moving))
        {
            checker = true;
        }
        if (grid[piecePositionX + 3][piecePositionY + 1] == GridSquare.moving and
            (grid[piecePositionX + 1][piecePositionY] != GridSquare.empty and
                grid[piecePositionX + 1][piecePositionY] != GridSquare.moving))
        {
            checker = true;
        }
        if (grid[piecePositionX + 2][piecePositionY + 3] == GridSquare.moving and
            (grid[piecePositionX + 3][piecePositionY + 1] != GridSquare.empty and
                grid[piecePositionX + 3][piecePositionY + 1] != GridSquare.moving))
        {
            checker = true;
        }
        if (grid[piecePositionX][piecePositionY + 2] == GridSquare.moving and
            (grid[piecePositionX + 2][piecePositionY + 3] != GridSquare.empty and
                grid[piecePositionX + 2][piecePositionY + 3] != GridSquare.moving))
        {
            checker = true;
        }
        if (grid[piecePositionX + 2][piecePositionY] == GridSquare.moving and
            (grid[piecePositionX][piecePositionY + 1] != GridSquare.empty and
                grid[piecePositionX][piecePositionY + 1] != GridSquare.moving))
        {
            checker = true;
        }
        if (grid[piecePositionX + 3][piecePositionY + 2] == GridSquare.moving and
            (grid[piecePositionX + 2][piecePositionY] != GridSquare.empty and
                grid[piecePositionX + 2][piecePositionY] != GridSquare.moving))
        {
            checker = true;
        }
        if (grid[piecePositionX + 1][piecePositionY + 3] == GridSquare.moving and
            (grid[piecePositionX + 3][piecePositionY + 2] != GridSquare.empty and
                grid[piecePositionX + 3][piecePositionY + 2] != GridSquare.moving))
        {
            checker = true;
        }
        if (grid[piecePositionX][piecePositionY + 1] == GridSquare.moving and
            (grid[piecePositionX + 1][piecePositionY + 3] != GridSquare.empty and
                grid[piecePositionX + 1][piecePositionY + 3] != GridSquare.moving))
        {
            checker = true;
        }
        if (grid[piecePositionX + 1][piecePositionY + 1] == GridSquare.moving and
            (grid[piecePositionX + 1][piecePositionY + 2] != GridSquare.empty and
                grid[piecePositionX + 1][piecePositionY + 2] != GridSquare.moving))
        {
            checker = true;
        }
        if (grid[piecePositionX + 2][piecePositionY + 1] == GridSquare.moving and
            (grid[piecePositionX + 1][piecePositionY + 1] != GridSquare.empty and
                grid[piecePositionX + 1][piecePositionY + 1] != GridSquare.moving))
        {
            checker = true;
        }
        if (grid[piecePositionX + 2][piecePositionY + 2] == GridSquare.moving and
            (grid[piecePositionX + 2][piecePositionY + 1] != GridSquare.empty and
                grid[piecePositionX + 2][piecePositionY + 1] != GridSquare.moving))
        {
            checker = true;
        }
        if (grid[piecePositionX + 1][piecePositionY + 2] == GridSquare.moving and
            (grid[piecePositionX + 2][piecePositionY + 2] != GridSquare.empty and
                grid[piecePositionX + 2][piecePositionY + 2] != GridSquare.moving))
        {
            checker = true;
        }

        // If no collision is detected, rotate the piece.
        if (!checker) {
            aux = piece[0][0];
            piece[0][0] = piece[3][0];
            piece[3][0] = piece[3][3];
            piece[3][3] = piece[0][3];
            piece[0][3] = aux;

            aux = piece[1][0];
            piece[1][0] = piece[3][1];
            piece[3][1] = piece[2][3];
            piece[2][3] = piece[0][2];
            piece[0][2] = aux;

            aux = piece[2][0];
            piece[2][0] = piece[3][2];
            piece[3][2] = piece[1][3];
            piece[1][3] = piece[0][1];
            piece[0][1] = aux;

            aux = piece[1][1];
            piece[1][1] = piece[2][1];
            piece[2][1] = piece[2][2];
            piece[2][2] = piece[1][2];
            piece[1][2] = aux;
        }

        // Clear the current piece from the grid.
        var j: usize = GRID_VERTICAL_SIZE - 2;
        while (true) {
            var i: usize = 1;
            while (i < GRID_HORIZONTAL_SIZE - 1) : (i += 1) {
                if (grid[i][j] == GridSquare.moving) {
                    grid[i][j] = GridSquare.empty;
                }
            }
            if (j == 0) break;
            j -= 1;
        }

        // Place the rotated piece on the grid.
        for (piecePositionX..piecePositionX + 4) |i| {
            for (piecePositionY..piecePositionY + 4) |k| {
                if (piece[i - piecePositionX][k - piecePositionY] == GridSquare.moving) {
                    grid[i][k] = GridSquare.moving;
                }
            }
        }
        return true;
    }
    return false;
}

fn CheckDetection(detect: *bool) void {
    // Start from the second-to-last row
    var j: usize = GRID_VERTICAL_SIZE - 2;
    while (true) {
        for (1..(GRID_HORIZONTAL_SIZE - 1)) |i| {
            // Now j is already a usize so no cast is needed.
            if ((grid[i][j] == GridSquare.moving) and
                ((grid[i][j + 1] == GridSquare.full) or
                    (grid[i][j + 1] == GridSquare.block)))
            {
                detect.* = true;
            }
        }
        if (j == 0) break; // Prevent underflow when subtracting 1 from 0.
        j -= 1;
    }
}

fn CheckCompletion(toDelete: *bool) void {
    var calculator: i32 = 0;
    var j: usize = GRID_VERTICAL_SIZE - 2;
    while (true) {
        calculator = 0;
        for (0..GRID_HORIZONTAL_SIZE - 1) |i| {
            // Count each square of the line
            if (grid[i][j] == GridSquare.full) {
                calculator += 1;
            }

            // Check if we completed the whole line
            if (calculator == GRID_HORIZONTAL_SIZE - 2) {
                toDelete.* = true;
                calculator = 0;

                // Mark the completed line
                for (1..GRID_HORIZONTAL_SIZE - 1) |z| {
                    grid[z][j] = GridSquare.fading;
                }
            }
        }
        if (j == 0) break; // Break before decrementing 0 to avoid underflow.
        j -= 1;
    }
}

fn deleteCompleteLines() i32 {
    var deletedLines: i32 = 0;

    // Erase the completed line
    var j: usize = GRID_VERTICAL_SIZE - 2;
    while (true) {
        while (grid[1][j] == GridSquare.fading) {
            for (1..GRID_HORIZONTAL_SIZE - 1) |i| {
                grid[i][j] = GridSquare.empty;
            }

            var j2 = j - 1;
            while (true) {
                var k: usize = 1;
                while (k < GRID_HORIZONTAL_SIZE - 1) : (k += 1) {
                    if (grid[k][j2] == GridSquare.full) {
                        grid[k][j2 + 1] = GridSquare.full;
                        grid[k][j2] = GridSquare.empty;
                    } else if (grid[k][j2] == GridSquare.fading) {
                        grid[k][j2 + 1] = GridSquare.fading;
                        grid[k][j2] = GridSquare.empty;
                    }
                }
                if (j2 == 0) break;
                j2 -= 1;
            }

            deletedLines += 1;
        }
        if (j == 0) break;
        j -= 1;
    }

    return deletedLines;
}
