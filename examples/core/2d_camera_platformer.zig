// raylib-zig (c) Axel Magnuson 2025
//
// This is a fairly close 1-1 copy of the original example from raylib, and
// thus might not represent completely idiomatic or clean zig.

const rl = @import("raylib");
const rm = @import("raymath");

const Rect = rl.Rectangle;
const Vec2 = rl.Vector2;
const Color = rl.Color;
const Camera2D = rl.Camera2D;

const CameraUpdater = *const fn (
    camera: *Camera2D,
    player: *Player,
    env_items: []EnvItem,
    delta: f32,
    width: i32,
    height: i32,
) void;

const G: i32 = 400;
const PLAYER_JUMP_SPD: f32 = 350;
const PLAYER_HOR_SPD: f32 = 200;

const Player = struct {
    can_jump: bool,
    speed: f32,
    position: rl.Vector2,
};

const EnvItem = struct {
    blocking: bool,
    rect: rl.Rectangle,
    color: rl.Color,
};

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    rl.initWindow(screen_width, screen_height, "raylib [core] example - 2d camera");
    defer rl.closeWindow(); // Close window and OpenGL context

    var player: Player = .{ .can_jump = false, .speed = 0, .position = Vec2.init(400, 280) };
    var env_items = [_]EnvItem{
        .{ .rect = Rect.init(0, 0, 1000, 400), .blocking = false, .color = .light_gray },
        .{ .rect = Rect.init(0, 400, 1000, 200), .blocking = true, .color = .gray },
        .{ .rect = Rect.init(300, 200, 400, 10), .blocking = true, .color = .gray },
        .{ .rect = Rect.init(250, 300, 100, 10), .blocking = true, .color = .gray },
        .{ .rect = Rect.init(650, 300, 100, 10), .blocking = true, .color = .gray },
    };

    var camera: rl.Camera2D = .{
        .target = player.position,
        .offset = Vec2.init(screen_width / 2, screen_height / 2),
        .rotation = 0,
        .zoom = 1,
    };

    // store pointers to the multiple functions that could be used to update the camera
    const camera_updaters = [_]CameraUpdater{
        updateCameraCenter,
        updatecameraCenterInsideMap,
        updateCameraCenterSmoothFollow,
        updateCameraEvenOutOnLanding,
        updateCameraPlayerBoundsPush,
    };

    var camera_option: usize = 0;

    const camera_descriptions = [_][:0]const u8{
        "Follow player center",
        "Follow player center, but clamp to map edges",
        "Follow player center; smoothed",
        "Follow player center horizontally; update player center vertically after landing",
        "Player push camera on getting too close to screen edge",
    };

    rl.setTargetFPS(60); // Set our game to run at 60 frames per second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) {
        // Update
        //----------------------------------------------------------------------------------
        const delta_time = rl.getFrameTime();

        updatePlayer(&player, &env_items, delta_time);

        camera.zoom += rl.getMouseWheelMove() * 0.05;
        if (camera.zoom > 3) camera.zoom = 3;
        if (camera.zoom < 0.25) camera.zoom = 0.25;

        // input: reset
        if (rl.isKeyPressed(.r)) {
            camera.zoom = 1;
            player.position = Vec2.init(400, 280);
        }

        // input: cycle camera mode
        if (rl.isKeyPressed(.c)) {
            camera_option = (camera_option + 1) % camera_updaters.len;
        }

        // call update camera by pointer
        camera_updaters[camera_option](
            &camera,
            &player,
            &env_items,
            delta_time,
            screen_width,
            screen_height,
        );
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        {
            rl.beginDrawing();
            defer rl.endDrawing();

            rl.clearBackground(.light_gray);

            {
                rl.beginMode2D(camera);
                defer rl.endMode2D();

                for (env_items) |env_item| {
                    rl.drawRectangleRec(env_item.rect, env_item.color);
                }

                const player_rect = Rect.init(player.position.x - 20, player.position.y - 40, 40, 40);
                rl.drawRectangleRec(player_rect, .red);
                rl.drawCircleV(player.position, 5, .gold);
            }

            rl.drawText("Controls:", 20, 20, 10, .black);
            rl.drawText("- Right/Left to move", 40, 40, 10, .dark_gray);
            // todo: controls text
            rl.drawText("- Current camera mode:", 20, 120, 10, .black);
            rl.drawText(camera_descriptions[camera_option], 40, 140, 10, .dark_gray);
        }

        //----------------------------------------------------------------------------------
    }
}

//------------------------------------------------------------------------------------
// Player update function
//------------------------------------------------------------------------------------

fn updatePlayer(player: *Player, env_items: []EnvItem, delta: f32) void {
    if (rl.isKeyDown(.left)) player.position.x -= PLAYER_HOR_SPD * delta;
    if (rl.isKeyDown(.right)) player.position.x += PLAYER_HOR_SPD * delta;
    if (rl.isKeyDown(.space) and player.can_jump) {
        player.speed = -PLAYER_JUMP_SPD;
        player.can_jump = false;
    }

    var hit_obstacle = false;
    for (env_items) |ei| {
        var p: *Vec2 = &player.position;
        if (ei.blocking and
            ei.rect.x <= p.x and
            ei.rect.x + ei.rect.width >= p.x and
            ei.rect.y >= p.y and
            ei.rect.y <= p.y + player.speed * delta)
        {
            hit_obstacle = true;
            player.speed = 0;
            p.y = ei.rect.y;
            break;
        }
    }

    if (!hit_obstacle) {
        player.position.y += player.speed * delta;
        player.speed += G * delta;
        player.can_jump = false;
    } else player.can_jump = true;
}

//------------------------------------------------------------------------------------
// Selectable camera update functions
//------------------------------------------------------------------------------------

// Follow player center
fn updateCameraCenter(
    camera: *Camera2D,
    player: *Player,
    _: []EnvItem,
    _: f32,
    width: i32,
    height: i32,
) void {
    const widthf: f32 = @floatFromInt(width);
    const heightf: f32 = @floatFromInt(height);
    camera.offset = Vec2.init(widthf / 2, heightf / 2);
    camera.target = player.position;
}

// Follow player center, but clamp to map edges
fn updatecameraCenterInsideMap(
    camera: *Camera2D,
    player: *Player,
    env_items: []EnvItem,
    _: f32,
    width: i32,
    height: i32,
) void {
    const widthf: f32 = @floatFromInt(width);
    const heightf: f32 = @floatFromInt(height);
    camera.offset = Vec2.init(widthf / 2, heightf / 2);
    camera.target = player.position;

    var min_x: f32 = 1000;
    var min_y: f32 = 1000;
    var max_x: f32 = -1000;
    var max_y: f32 = -1000;

    for (env_items) |ei| {
        min_x = @min(ei.rect.x, min_x);
        min_y = @min(ei.rect.y, min_y);
        max_x = @max(ei.rect.x + ei.rect.width, max_x);
        max_y = @max(ei.rect.y + ei.rect.height, max_y);
    }

    const max = rl.getWorldToScreen2D(Vec2.init(max_x, max_y), camera.*);
    const min = rl.getWorldToScreen2D(Vec2.init(min_x, min_y), camera.*);

    if (max.x < widthf) camera.offset.x = widthf - (max.x - widthf / 2);
    if (max.y < heightf) camera.offset.y = heightf - (max.y - heightf / 2);
    if (min.x > 0) camera.offset.x = widthf / 2 - min.x;
    if (min.y > 0) camera.offset.y = heightf / 2 - min.y;
}

// Follow player center; smoothed
fn updateCameraCenterSmoothFollow(
    camera: *Camera2D,
    player: *Player,
    _: []EnvItem,
    delta: f32,
    width: i32,
    height: i32,
) void {
    const min_speed = 30;
    const min_effect_length = 10;
    const fraction_speed = 0.8;

    const widthf: f32 = @floatFromInt(width);
    const heightf: f32 = @floatFromInt(height);

    camera.offset = Vec2.init(widthf / 2, heightf / 2);
    const diff = player.position.subtract(camera.target);
    const length = diff.length();

    if (length > min_effect_length) {
        const speed = @max(fraction_speed * length, min_speed);
        camera.target = camera.target.add(diff.scale(speed * delta / length));
    }
}

var evening_out: bool = false;
var even_out_target: f32 = 0;

// Follow player center horizontally; update player center vertically after landing
fn updateCameraEvenOutOnLanding(
    camera: *Camera2D,
    player: *Player,
    _: []EnvItem,
    delta: f32,
    width: i32,
    height: i32,
) void {
    const even_out_speed = 700;

    const widthf: f32 = @floatFromInt(width);
    const heightf: f32 = @floatFromInt(height);

    camera.offset = Vec2.init(widthf / 2, heightf / 2);
    camera.target.x = player.position.x;

    if (evening_out) {
        if (even_out_target > camera.target.y) {
            camera.target.y += even_out_speed * delta;
            if (camera.target.y > even_out_target) {
                camera.target.y = even_out_target;
                evening_out = false;
            }
        } else {
            camera.target.y -= even_out_speed * delta;
            if (camera.target.y < even_out_target) {
                camera.target.y = even_out_target;
                evening_out = false;
            }
        }
    } else {
        if (player.can_jump and player.speed == 0 and player.position.y != camera.target.y) {
            evening_out = true;
            even_out_target = player.position.y;
        }
    }
}

// Player push camera on getting too close to screen edge
fn updateCameraPlayerBoundsPush(
    camera: *Camera2D,
    player: *Player,
    _: []EnvItem,
    _: f32,
    width: i32,
    height: i32,
) void {
    const bbox = Vec2.init(0.2, 0.2);

    const widthf: f32 = @floatFromInt(width);
    const heightf: f32 = @floatFromInt(height);

    const bbox_world_min = rl.getScreenToWorld2D(Vec2.init((1 - bbox.x) * 0.5 * widthf, (1 - bbox.y) * 0.5 * heightf), camera.*);
    const bbox_world_max = rl.getScreenToWorld2D(Vec2.init((1 + bbox.x) * 0.5 * widthf, (1 + bbox.y) * 0.5 * heightf), camera.*);
    camera.offset = Vec2.init((1 - bbox.x) * 0.5 * widthf, (1 - bbox.y) * 0.5 * heightf);

    if (player.position.x < bbox_world_min.x) camera.target.x = player.position.x;
    if (player.position.y < bbox_world_min.y) camera.target.y = player.position.y;
    if (player.position.x > bbox_world_max.x) camera.target.x = bbox_world_min.x + (player.position.x - bbox_world_max.x);
    if (player.position.y > bbox_world_max.y) camera.target.y = bbox_world_min.y + (player.position.y - bbox_world_max.y);
}
