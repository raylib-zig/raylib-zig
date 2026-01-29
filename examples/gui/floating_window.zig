const std = @import("std");
const rl = @import("raylib");
const rg  = @import("raygui");

const WINDOW_STATUS_BAR_HEIGHT = 24;
const WINDOW_CLOSE_BUTTON_SIZE = 18;
const CLOSE_TITLE_SIZE_DELTA_HALF = (WINDOW_STATUS_BAR_HEIGHT - WINDOW_CLOSE_BUTTON_SIZE) / 2;

const DrawContentFn = *const fn(rl.Vector2, rl.Vector2) void;

fn floatingWindow(
    position: *rl.Vector2,
    size: *rl.Vector2,
    minimized: *bool,
    moving: *bool,
    resizing: *bool,
    draw_content: DrawContentFn,
    content_size: rl.Vector2,
    scroll: *rl.Vector2,
    title: []const u8
) void {
    var title_buf: [64]u8 = undefined;
    const title_text = std.fmt.bufPrintZ(&title_buf, "{s}", .{ title }) catch "";
    const mouse_position = rl.getMousePosition();

    const is_left_pressed = rl.isMouseButtonPressed(rl.MouseButton.left);
    if(is_left_pressed and !(moving.*) and !(resizing.*)) {

        const title_collsion_rect = rl.Rectangle{.x = position.x, .y = position.y, .width = size.x - WINDOW_CLOSE_BUTTON_SIZE - CLOSE_TITLE_SIZE_DELTA_HALF, .height = WINDOW_STATUS_BAR_HEIGHT};
        const resize_collision_rect = rl.Rectangle{.x = position.x + size.x - 20, .y = position.y + size.y - 20, .width = 20, .height = 20};

        _ = rl.drawRectangleLinesEx(title_collsion_rect, 15, rl.Color.red);
        _ = rl.drawRectangleLinesEx(resize_collision_rect, 15, rl.Color.green);
        if(rl.checkCollisionPointRec(mouse_position, title_collsion_rect)) {
            moving.* = true;
        } else if(!(minimized.*) and rl.checkCollisionPointRec(mouse_position, resize_collision_rect)) {
            resizing.* = true;
        }
    }

    const screen_width = rl.getScreenWidth();
    const screen_width_f32 = @as(f32, @floatFromInt(screen_width));
    const screen_height = rl.getScreenHeight();
    const screen_height_f32 = @as(f32, @floatFromInt(screen_height));
    // window movement and resize update
    if(moving.*) {
        const mouse_delta = rl.getMouseDelta();
        position.x += mouse_delta.x;
        position.y += mouse_delta.y;

        if(rl.isMouseButtonReleased(rl.MouseButton.left)) {
            moving.* = false;

            if(position.x < 0) {
                position.x = 0;
            } else if(position.x > screen_width_f32 - size.x) {
                position.x = screen_width_f32 - size.x;
            }
            if(position.y < 0) {
                position.x = 0;
            } else if(position.y > screen_height_f32) {
                position.y = screen_height_f32 - WINDOW_STATUS_BAR_HEIGHT;
            }
        }
    } else if(resizing.*) {
        if (mouse_position.x > position.x) {
            size.x = mouse_position.x - position.x;
        }
        if (mouse_position.y > position.y) {
            size.y = mouse_position.y - position.y;
        }
        // clamp window size to an arbitrary minimum value and the window size as the maximum
        const min_window_size = 100;
        if(size.x < min_window_size) {
            size.x = min_window_size;
        } else if(size.x > screen_width_f32) {
            size.x = screen_width_f32;
        }
        if(size.y < min_window_size) {
            size.y = min_window_size;
        } else if(size.y > screen_height_f32) {
            size.y = screen_height_f32;
        }

        if (rl.isMouseButtonReleased(rl.MouseButton.left)) {
            resizing.* = false;
        }
    }
    // window and content drawing with scissor and scroll area
    if(minimized.*) {
        _ = rg.statusBar(rl.Rectangle{ .x = position.x, .y = position.y, .width = size.x, .height = WINDOW_STATUS_BAR_HEIGHT}, title_text);

        if (rg.button(rl.Rectangle{ .x = position.x + size.x - WINDOW_CLOSE_BUTTON_SIZE - CLOSE_TITLE_SIZE_DELTA_HALF,
            .y = position.y + CLOSE_TITLE_SIZE_DELTA_HALF,
            .width = WINDOW_CLOSE_BUTTON_SIZE,
            .height = WINDOW_CLOSE_BUTTON_SIZE},
            "#120#")) {
            minimized.* = false;
        }

    } else {
        minimized.* = rg.windowBox(rl.Rectangle{ .x = position.x, .y = position.y, .width = size.x, .height = size.y}, title_text) > 0;

        // scissor and draw content within a scroll panel
        var scissor: rl.Rectangle = undefined;
        _ = rg.scrollPanel(rl.Rectangle{ .x = position.x, .y = position.y + WINDOW_STATUS_BAR_HEIGHT, .width = size.x, .height = size.y - WINDOW_STATUS_BAR_HEIGHT},
            null,
            rl.Rectangle{ .x = position.x, .y = position.y, .width = content_size.x, .height = content_size.y },
            scroll,
            &scissor);

        _ = rl.drawRectangleRec(scissor, rl.Color.gold);

        const require_scissor = size.x < content_size.x or size.y < content_size.y;

        if(require_scissor) {
            rl.beginScissorMode(@intFromFloat(scissor.x), @intFromFloat(scissor.y), @intFromFloat(scissor.width), @intFromFloat(scissor.height));
        }

        draw_content(position.*, scroll.*);

        if(require_scissor) {
            rl.endScissorMode();
        }

        // draw the resize button/icon
        _ = rg.drawIcon(71, @intFromFloat(position.x + size.x - 20), @intFromFloat(position.y + size.y - 20), 1, rl.Color.gray);

    }
}

fn drawContent(position: rl.Vector2, window_scroll: rl.Vector2) void {
    _ = rg.button(rl.Rectangle{ .x = position.x + 20 + window_scroll.x, .y = position.y + 50 + window_scroll.y, .width = 100, .height = 25 }, "Button 1");
    _ = rg.button(rl.Rectangle{ .x = position.x + 20 + window_scroll.x, .y = position.y + 100 + window_scroll.y, .width = 100, .height = 25 }, "Button 2");
    _ = rg.button(rl.Rectangle{ .x = position.x + 20 + window_scroll.x, .y = position.y + 150  + window_scroll.y, .width = 100, .height = 25 }, "Button 3");
    _ = rg.label(rl.Rectangle{ .x = position.x + 20 + window_scroll.x, .y = position.y + 200 + window_scroll.y, .width = 250, .height = 25 }, "A Label");
    _ = rg.label(rl.Rectangle{ .x = position.x + 20 + window_scroll.x, .y = position.y + 250 + window_scroll.y, .width = 250, .height = 25 }, "Another Label");
    _ = rg.label(rl.Rectangle{ .x = position.x + 20 + window_scroll.x, .y = position.y + 300 + window_scroll.y, .width = 250, .height = 25 }, "Yet Another Label");
}

pub fn main() !void {
    var window_position = rl.Vector2{ .x = 10, .y = 10};
    var window2_position = rl.Vector2{ .x = 250, .y = 10};
    var window_size = rl.Vector2{ .x = 200, .y = 400};
    var window2_size = rl.Vector2{ .x = 200, .y = 400};
    var minimized = false;
    var minimized2 = false;
    var moving = false;
    var moving2 = false;
    var resizing = false;
    var resizing2 = false;
    var scroll: rl.Vector2 = rl.Vector2{ .x = -1, .y = -1};
    var scroll2: rl.Vector2 = rl.Vector2{ .x = -1, .y = -1};

    rl.initWindow(960, 560, "raygui - floating window example");
    rl.setTargetFPS(60);

    while(!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();
        floatingWindow(&window_position, &window_size, &minimized, &moving, &resizing, &drawContent, rl.Vector2{ .x = 140, .y = 320 }, &scroll, "Movable & Scalable Window");
        floatingWindow(&window2_position, &window2_size, &minimized2, &moving2, &resizing2, &drawContent, rl.Vector2{ .x = 140, .y = 320 }, &scroll2, "Another window");
        rl.clearBackground(rl.Color.ray_white);
    }

    rl.closeWindow();
}