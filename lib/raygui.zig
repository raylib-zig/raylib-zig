const rl = @import("raylib-zig");
const std = @import("std");

pub const cdef = @import("raygui-ext.zig");

test {
    std.testing.refAllDeclsRecursive(@This());
}

pub const RayguiError = error{GetIcons};

const Vector2 = rl.Vector2;
const Vector3 = rl.Vector3;
const Color = rl.Color;
const Rectangle = rl.Rectangle;
const Font = rl.Font;

pub const GuiStyleProp = extern struct {
    controlId: c_ushort,
    propertyId: c_ushort,
    propertyValue: c_int,
};

pub const GuiState = enum(c_int) {
    state_normal = 0,
    state_focused,
    state_pressed,
    state_disabled,
};

pub const GuiTextAlignment = enum(c_int) {
    text_align_left = 0,
    text_align_center,
    text_align_right,
};

pub const GuiTextAlignmentVertical = enum(c_int) {
    text_align_top = 0,
    text_align_middle,
    text_align_bottom,
};

pub const GuiTextWrapMode = enum(c_int) {
    text_wrap_none = 0,
    text_wrap_char,
    text_wrap_word,
};

pub const GuiControl = enum(c_int) {
    default = 0,
    label,
    button,
    toggle,
    slider,
    progressbar,
    checkbox,
    combobox,
    dropdownbox,
    textbox,
    valuebox,
    spinner,
    listview,
    colorpicker,
    scrollbar,
    statusbar,
};

pub const GuiControlProperty = enum(c_int) {
    border_color_normal = 0,
    base_color_normal,
    text_color_normal,
    border_color_focused,
    base_color_focused,
    text_color_focused,
    border_color_pressed,
    base_color_pressed,
    text_color_pressed,
    border_color_disabled,
    base_color_disabled,
    text_color_disabled,
    border_width,
    text_padding,
    text_alignment,
};

pub const GuiDefaultProperty = enum(c_int) {
    text_size = 16,
    text_spacing,
    line_color,
    background_color,
    text_line_spacing,
    text_alignment_vertical,
    text_wrap_mode,
};

pub const GuiToggleProperty = enum(c_int) {
    group_padding = 16,
};

pub const GuiSliderProperty = enum(c_int) {
    slider_width = 16,
    slider_padding,
};

pub const GuiProgressBarProperty = enum(c_int) {
    progress_padding = 16,
};

pub const GuiScrollBarProperty = enum(c_int) {
    arrows_size = 16,
    arrows_visible,
    scroll_slider_padding,
    scroll_slider_size,
    scroll_padding,
    scroll_speed,
};

pub const GuiCheckBoxProperty = enum(c_int) {
    check_padding = 16,
};

pub const GuiComboBoxProperty = enum(c_int) {
    combo_button_width = 16,
    combo_button_spacing,
};

pub const GuiDropdownBoxProperty = enum(c_int) {
    arrow_padding = 16,
    dropdown_items_spacing,
    dropdown_arrow_hidden,
    dropdown_roll_up,
};

pub const GuiTextBoxProperty = enum(c_int) {
    text_readonly = 16,
};

pub const GuiSpinnerProperty = enum(c_int) {
    spin_button_width = 16,
    spin_button_spacing,
};

pub const GuiListViewProperty = enum(c_int) {
    list_items_height = 16,
    list_items_spacing,
    scrollbar_width,
    scrollbar_side,
    list_items_border_width,
};

pub const GuiColorPickerProperty = enum(c_int) {
    color_selector_size = 16,
    huebar_width,
    huebar_padding,
    huebar_selector_height,
    huebar_selector_overflow,
};

pub const scrollbar_left_side: c_int = 0;
pub const scrollbar_right_side: c_int = 1;

pub const GuiIconName = enum(c_int) {
    icon_none = 0,
    icon_folder_file_open = 1,
    icon_file_save_classic = 2,
    icon_folder_open = 3,
    icon_folder_save = 4,
    icon_file_open = 5,
    icon_file_save = 6,
    icon_file_export = 7,
    icon_file_add = 8,
    icon_file_delete = 9,
    icon_filetype_text = 10,
    icon_filetype_audio = 11,
    icon_filetype_image = 12,
    icon_filetype_play = 13,
    icon_filetype_video = 14,
    icon_filetype_info = 15,
    icon_file_copy = 16,
    icon_file_cut = 17,
    icon_file_paste = 18,
    icon_cursor_hand = 19,
    icon_cursor_pointer = 20,
    icon_cursor_classic = 21,
    icon_pencil = 22,
    icon_pencil_big = 23,
    icon_brush_classic = 24,
    icon_brush_painter = 25,
    icon_water_drop = 26,
    icon_color_picker = 27,
    icon_rubber = 28,
    icon_color_bucket = 29,
    icon_text_t = 30,
    icon_text_a = 31,
    icon_scale = 32,
    icon_resize = 33,
    icon_filter_point = 34,
    icon_filter_bilinear = 35,
    icon_crop = 36,
    icon_crop_alpha = 37,
    icon_square_toggle = 38,
    icon_symmetry = 39,
    icon_symmetry_horizontal = 40,
    icon_symmetry_vertical = 41,
    icon_lens = 42,
    icon_lens_big = 43,
    icon_eye_on = 44,
    icon_eye_off = 45,
    icon_filter_top = 46,
    icon_filter = 47,
    icon_target_point = 48,
    icon_target_small = 49,
    icon_target_big = 50,
    icon_target_move = 51,
    icon_cursor_move = 52,
    icon_cursor_scale = 53,
    icon_cursor_scale_right = 54,
    icon_cursor_scale_left = 55,
    icon_undo = 56,
    icon_redo = 57,
    icon_reredo = 58,
    icon_mutate = 59,
    icon_rotate = 60,
    icon_repeat = 61,
    icon_shuffle = 62,
    icon_emptybox = 63,
    icon_target = 64,
    icon_target_small_fill = 65,
    icon_target_big_fill = 66,
    icon_target_move_fill = 67,
    icon_cursor_move_fill = 68,
    icon_cursor_scale_fill = 69,
    icon_cursor_scale_right_fill = 70,
    icon_cursor_scale_left_fill = 71,
    icon_undo_fill = 72,
    icon_redo_fill = 73,
    icon_reredo_fill = 74,
    icon_mutate_fill = 75,
    icon_rotate_fill = 76,
    icon_repeat_fill = 77,
    icon_shuffle_fill = 78,
    icon_emptybox_small = 79,
    icon_box = 80,
    icon_box_top = 81,
    icon_box_top_right = 82,
    icon_box_right = 83,
    icon_box_bottom_right = 84,
    icon_box_bottom = 85,
    icon_box_bottom_left = 86,
    icon_box_left = 87,
    icon_box_top_left = 88,
    icon_box_center = 89,
    icon_box_circle_mask = 90,
    icon_pot = 91,
    icon_alpha_multiply = 92,
    icon_alpha_clear = 93,
    icon_dithering = 94,
    icon_mipmaps = 95,
    icon_box_grid = 96,
    icon_grid = 97,
    icon_box_corners_small = 98,
    icon_box_corners_big = 99,
    icon_four_boxes = 100,
    icon_grid_fill = 101,
    icon_box_multisize = 102,
    icon_zoom_small = 103,
    icon_zoom_medium = 104,
    icon_zoom_big = 105,
    icon_zoom_all = 106,
    icon_zoom_center = 107,
    icon_box_dots_small = 108,
    icon_box_dots_big = 109,
    icon_box_concentric = 110,
    icon_box_grid_big = 111,
    icon_ok_tick = 112,
    icon_cross = 113,
    icon_arrow_left = 114,
    icon_arrow_right = 115,
    icon_arrow_down = 116,
    icon_arrow_up = 117,
    icon_arrow_left_fill = 118,
    icon_arrow_right_fill = 119,
    icon_arrow_down_fill = 120,
    icon_arrow_up_fill = 121,
    icon_audio = 122,
    icon_fx = 123,
    icon_wave = 124,
    icon_wave_sinus = 125,
    icon_wave_square = 126,
    icon_wave_triangular = 127,
    icon_cross_small = 128,
    icon_player_previous = 129,
    icon_player_play_back = 130,
    icon_player_play = 131,
    icon_player_pause = 132,
    icon_player_stop = 133,
    icon_player_next = 134,
    icon_player_record = 135,
    icon_magnet = 136,
    icon_lock_close = 137,
    icon_lock_open = 138,
    icon_clock = 139,
    icon_tools = 140,
    icon_gear = 141,
    icon_gear_big = 142,
    icon_bin = 143,
    icon_hand_pointer = 144,
    icon_laser = 145,
    icon_coin = 146,
    icon_explosion = 147,
    icon_1up = 148,
    icon_player = 149,
    icon_player_jump = 150,
    icon_key = 151,
    icon_demon = 152,
    icon_text_popup = 153,
    icon_gear_ex = 154,
    icon_crack = 155,
    icon_crack_points = 156,
    icon_star = 157,
    icon_door = 158,
    icon_exit = 159,
    icon_mode_2d = 160,
    icon_mode_3d = 161,
    icon_cube = 162,
    icon_cube_face_top = 163,
    icon_cube_face_left = 164,
    icon_cube_face_front = 165,
    icon_cube_face_bottom = 166,
    icon_cube_face_right = 167,
    icon_cube_face_back = 168,
    icon_camera = 169,
    icon_special = 170,
    icon_link_net = 171,
    icon_link_boxes = 172,
    icon_link_multi = 173,
    icon_link = 174,
    icon_link_broke = 175,
    icon_text_notes = 176,
    icon_notebook = 177,
    icon_suitcase = 178,
    icon_suitcase_zip = 179,
    icon_mailbox = 180,
    icon_monitor = 181,
    icon_printer = 182,
    icon_photo_camera = 183,
    icon_photo_camera_flash = 184,
    icon_house = 185,
    icon_heart = 186,
    icon_corner = 187,
    icon_vertical_bars = 188,
    icon_vertical_bars_fill = 189,
    icon_life_bars = 190,
    icon_info = 191,
    icon_crossline = 192,
    icon_help = 193,
    icon_filetype_alpha = 194,
    icon_filetype_home = 195,
    icon_layers_visible = 196,
    icon_layers = 197,
    icon_window = 198,
    icon_hidpi = 199,
    icon_filetype_binary = 200,
    icon_hex = 201,
    icon_shield = 202,
    icon_file_new = 203,
    icon_folder_add = 204,
    icon_alarm = 205,
    icon_cpu = 206,
    icon_rom = 207,
    icon_step_over = 208,
    icon_step_into = 209,
    icon_step_out = 210,
    icon_restart = 211,
    icon_breakpoint_on = 212,
    icon_breakpoint_off = 213,
    icon_burger_menu = 214,
    icon_case_sensitive = 215,
    icon_reg_exp = 216,
    icon_folder = 217,
    icon_file = 218,
    icon_sand_timer = 219,
    icon_warning = 220,
    icon_help_box = 221,
    icon_info_box = 222,
    icon_223 = 223,
    icon_224 = 224,
    icon_225 = 225,
    icon_226 = 226,
    icon_227 = 227,
    icon_228 = 228,
    icon_229 = 229,
    icon_230 = 230,
    icon_231 = 231,
    icon_232 = 232,
    icon_233 = 233,
    icon_234 = 234,
    icon_235 = 235,
    icon_236 = 236,
    icon_237 = 237,
    icon_238 = 238,
    icon_239 = 239,
    icon_240 = 240,
    icon_241 = 241,
    icon_242 = 242,
    icon_243 = 243,
    icon_244 = 244,
    icon_245 = 245,
    icon_246 = 246,
    icon_247 = 247,
    icon_248 = 248,
    icon_249 = 249,
    icon_250 = 250,
    icon_251 = 251,
    icon_252 = 252,
    icon_253 = 253,
    icon_254 = 254,
    icon_255 = 255,
};

/// Set one style property
pub fn guiSetStyle(control: GuiControl, comptime property: anytype, value: i32) void {
    comptime var property_int: c_int = undefined;

    comptime {
        if (@TypeOf(property) == GuiControlProperty) {
            property_int = @intCast(@intFromEnum(property));
        } else if (@TypeOf(property) == GuiDefaultProperty) { // comparison can't be chained :(
            property_int = @intCast(@intFromEnum(property));
        } else {
            @compileError("Invalid property type for guiSetStyle");
        }
    }

    cdef.GuiSetStyle(control, property_int, @as(c_int, value));
}

/// Get one style property
pub fn guiGetStyle(control: GuiControl, comptime property: anytype) i32 {
    comptime var property_int: c_int = undefined;

    comptime {
        if (@TypeOf(property) == GuiControlProperty) {
            property_int = @intCast(@intFromEnum(property));
        } else if (@TypeOf(property) == GuiDefaultProperty) { // comparison can't be chained :(
            property_int = @intCast(@intFromEnum(property));
        } else {
            @compileError("Invalid property type for guiGetStyle");
        }
    }

    return @as(i32, cdef.GuiGetStyle(control, property_int));
}

/// Get raygui icons data pointer
pub fn guiGetIcons() RayguiError![]u32 {
    var res: []u32 = undefined;

    const ptr = cdef.GuiGetIcons();
    if (ptr == 0) return RayguiError.GetIcons;

    res.ptr = @as([*]u32, @ptrCast(ptr));
    res.len = @as(usize, @intCast(256 * 256)); // RAYGUI_ICON_MAX_ICONS * RAYGUI_ICON_MAX_ICONS
    return res;
}

// If you REALLY need the return value of the function, you'll know what to do with it and its size yourself
/// Load raygui icons file (.rgi) into internal icons data
pub fn guiLoadIcons(fileName: [*c]const u8, loadIconsName: bool) [*c][*c]u8 {
    return cdef.GuiLoadIcons(fileName, loadIconsName);
}

/// Tab Bar control, returns TAB to be closed or -1
pub fn guiTabBar(bounds: Rectangle, text: [][*:0]const u8, active: *i32) i32 {
    return @as(i32, cdef.GuiTabBar(bounds, @as([*c][*c]const u8, @ptrCast(text)), @as(c_int, @intCast(text.len)), @as([*c]c_int, @ptrCast(active))));
}

/// List View with extended parameters
pub fn guiListViewEx(bounds: Rectangle, text: [][*:0]const u8, scrollIndex: *i32, active: *i32, focus: *i32) i32 {
    return @as(i32, cdef.GuiListViewEx(bounds, @as([*c][*c]const u8, @ptrCast(text)), @as(c_int, @intCast(text.len)), @as([*c]c_int, @ptrCast(scrollIndex)), @as([*c]c_int, @ptrCast(active)), @as([*c]c_int, @ptrCast(focus))));
}

/// Panel control, useful to group controls
pub fn guiPanel(bounds: Rectangle, text: ?[*:0]const u8) i32 {
    var textFinal = @as([*c]const u8, 0);
    if (text) |textSure| {
        textFinal = @as([*c]const u8, @ptrCast(textSure));
    }
    return @as(i32, cdef.GuiPanel(bounds, textFinal));
}

/// Scroll Panel control
pub fn guiScrollPanel(bounds: Rectangle, text: ?[*:0]const u8, content: Rectangle, scroll: *Vector2, view: *Rectangle) i32 {
    var textFinal = @as([*c]const u8, 0);
    if (text) |textSure| {
        textFinal = @as([*c]const u8, @ptrCast(textSure));
    }
    return @as(i32, cdef.GuiScrollPanel(bounds, textFinal, content, @as([*c]Vector2, @ptrCast(scroll)), @as([*c]Rectangle, @ptrCast(view))));
}

/// Enable gui controls (global state)
pub fn guiEnable() void {
    cdef.GuiEnable();
}

/// Disable gui controls (global state)
pub fn guiDisable() void {
    cdef.GuiDisable();
}

/// Lock gui controls (global state)
pub fn guiLock() void {
    cdef.GuiLock();
}

/// Unlock gui controls (global state)
pub fn guiUnlock() void {
    cdef.GuiUnlock();
}

/// Check if gui is locked (global state)
pub fn guiIsLocked() bool {
    return cdef.GuiIsLocked();
}

/// Set gui controls alpha (global state), alpha goes from 0.0f to 1.0f
pub fn guiSetAlpha(alpha: f32) void {
    cdef.GuiSetAlpha(alpha);
}

/// Set gui state (global state)
pub fn guiSetState(state: i32) void {
    cdef.GuiSetState(@as(c_int, state));
}

/// Get gui state (global state)
pub fn guiGetState() i32 {
    return @as(i32, cdef.GuiGetState());
}

/// Set gui custom font (global state)
pub fn guiSetFont(font: Font) void {
    cdef.GuiSetFont(font);
}

/// Get gui custom font (global state)
pub fn guiGetFont() Font {
    return cdef.GuiGetFont();
}

/// Load style file over global style variable (.rgs)
pub fn guiLoadStyle(fileName: [:0]const u8) void {
    cdef.GuiLoadStyle(@as([*c]const u8, @ptrCast(fileName)));
}

/// Load style default over global style
pub fn guiLoadStyleDefault() void {
    cdef.GuiLoadStyleDefault();
}

/// Enable gui tooltips (global state)
pub fn guiEnableTooltip() void {
    cdef.GuiEnableTooltip();
}

/// Disable gui tooltips (global state)
pub fn guiDisableTooltip() void {
    cdef.GuiDisableTooltip();
}

/// Set tooltip string
pub fn guiSetTooltip(tooltip: [:0]const u8) void {
    cdef.GuiSetTooltip(@as([*c]const u8, @ptrCast(tooltip)));
}

/// Get text with icon id prepended (if supported)
pub fn guiIconText(iconId: i32, text: [:0]const u8) [:0]const u8 {
    return std.mem.span(cdef.GuiIconText(@as(c_int, iconId), @as([*c]const u8, @ptrCast(text))));
}

/// Set default icon drawing size
pub fn guiSetIconScale(scale: i32) void {
    cdef.GuiSetIconScale(@as(c_int, scale));
}

/// Draw icon using pixel size at specified position
pub fn guiDrawIcon(iconId: i32, posX: i32, posY: i32, pixelSize: i32, color: Color) void {
    cdef.GuiDrawIcon(@as(c_int, iconId), @as(c_int, posX), @as(c_int, posY), @as(c_int, pixelSize), color);
}

/// Window Box control, shows a window that can be closed
pub fn guiWindowBox(bounds: Rectangle, title: [:0]const u8) i32 {
    return @as(i32, cdef.GuiWindowBox(bounds, @as([*c]const u8, @ptrCast(title))));
}

/// Group Box control with text name
pub fn guiGroupBox(bounds: Rectangle, text: [:0]const u8) i32 {
    return @as(i32, cdef.GuiGroupBox(bounds, @as([*c]const u8, @ptrCast(text))));
}

/// Line separator control, could contain text
pub fn guiLine(bounds: Rectangle, text: [:0]const u8) i32 {
    return @as(i32, cdef.GuiLine(bounds, @as([*c]const u8, @ptrCast(text))));
}

/// Label control
pub fn guiLabel(bounds: Rectangle, text: [:0]const u8) i32 {
    return @as(i32, cdef.GuiLabel(bounds, @as([*c]const u8, @ptrCast(text))));
}

/// Button control, returns true when clicked
pub fn guiButton(bounds: Rectangle, text: [:0]const u8) i32 {
    return @as(i32, cdef.GuiButton(bounds, @as([*c]const u8, @ptrCast(text))));
}

/// Label button control, returns true when clicked
pub fn guiLabelButton(bounds: Rectangle, text: [:0]const u8) i32 {
    return @as(i32, cdef.GuiLabelButton(bounds, @as([*c]const u8, @ptrCast(text))));
}

/// Toggle Button control
pub fn guiToggle(bounds: Rectangle, text: [:0]const u8, active: *bool) i32 {
    return @as(i32, cdef.GuiToggle(bounds, @as([*c]const u8, @ptrCast(text)), @as([*c]bool, @ptrCast(active))));
}

/// Toggle Group control
pub fn guiToggleGroup(bounds: Rectangle, text: [:0]const u8, active: *i32) i32 {
    return @as(i32, cdef.GuiToggleGroup(bounds, @as([*c]const u8, @ptrCast(text)), @as([*c]c_int, @ptrCast(active))));
}

/// Toggle Slider control
pub fn guiToggleSlider(bounds: Rectangle, text: [:0]const u8, active: *i32) i32 {
    return @as(i32, cdef.GuiToggleSlider(bounds, @as([*c]const u8, @ptrCast(text)), @as([*c]c_int, @ptrCast(active))));
}

/// Check Box control, returns true when active
pub fn guiCheckBox(bounds: Rectangle, text: [:0]const u8, checked: *bool) i32 {
    return @as(i32, cdef.GuiCheckBox(bounds, @as([*c]const u8, @ptrCast(text)), @as([*c]bool, @ptrCast(checked))));
}

/// Combo Box control
pub fn guiComboBox(bounds: Rectangle, text: [:0]const u8, active: *i32) i32 {
    return @as(i32, cdef.GuiComboBox(bounds, @as([*c]const u8, @ptrCast(text)), @as([*c]c_int, @ptrCast(active))));
}

/// Dropdown Box control
pub fn guiDropdownBox(bounds: Rectangle, text: [:0]const u8, active: *i32, editMode: bool) i32 {
    return @as(i32, cdef.GuiDropdownBox(bounds, @as([*c]const u8, @ptrCast(text)), @as([*c]c_int, @ptrCast(active)), editMode));
}

/// Spinner control
pub fn guiSpinner(bounds: Rectangle, text: [:0]const u8, value: *i32, minValue: i32, maxValue: i32, editMode: bool) i32 {
    return @as(i32, cdef.GuiSpinner(bounds, @as([*c]const u8, @ptrCast(text)), @as([*c]c_int, @ptrCast(value)), @as(c_int, minValue), @as(c_int, maxValue), editMode));
}

/// Value Box control, updates input text with numbers
pub fn guiValueBox(bounds: Rectangle, text: [:0]const u8, value: *i32, minValue: i32, maxValue: i32, editMode: bool) i32 {
    return @as(i32, cdef.GuiValueBox(bounds, @as([*c]const u8, @ptrCast(text)), @as([*c]c_int, @ptrCast(value)), @as(c_int, minValue), @as(c_int, maxValue), editMode));
}

/// Value box control for float values
pub fn guiValueBoxFloat(bounds: Rectangle, text: [:0]const u8, textValue: [:0]u8, value: *f32, editMode: bool) i32 {
    return @as(i32, cdef.GuiValueBoxFloat(bounds, @as([*c]const u8, @ptrCast(text)), @as([*c]u8, @ptrCast(textValue)), @as([*c]f32, @ptrCast(value)), editMode));
}

/// Text Box control, updates input text
pub fn guiTextBox(bounds: Rectangle, text: [:0]u8, textSize: i32, editMode: bool) i32 {
    return @as(i32, cdef.GuiTextBox(bounds, @as([*c]u8, @ptrCast(text)), @as(c_int, textSize), editMode));
}

/// Slider control
pub fn guiSlider(bounds: Rectangle, textLeft: [:0]const u8, textRight: [:0]const u8, value: *f32, minValue: f32, maxValue: f32) i32 {
    return @as(i32, cdef.GuiSlider(bounds, @as([*c]const u8, @ptrCast(textLeft)), @as([*c]const u8, @ptrCast(textRight)), @as([*c]f32, @ptrCast(value)), minValue, maxValue));
}

/// Slider Bar control
pub fn guiSliderBar(bounds: Rectangle, textLeft: [:0]const u8, textRight: [:0]const u8, value: *f32, minValue: f32, maxValue: f32) i32 {
    return @as(i32, cdef.GuiSliderBar(bounds, @as([*c]const u8, @ptrCast(textLeft)), @as([*c]const u8, @ptrCast(textRight)), @as([*c]f32, @ptrCast(value)), minValue, maxValue));
}

/// Progress Bar control
pub fn guiProgressBar(bounds: Rectangle, textLeft: [:0]const u8, textRight: [:0]const u8, value: *f32, minValue: f32, maxValue: f32) i32 {
    return @as(i32, cdef.GuiProgressBar(bounds, @as([*c]const u8, @ptrCast(textLeft)), @as([*c]const u8, @ptrCast(textRight)), @as([*c]f32, @ptrCast(value)), minValue, maxValue));
}

/// Status Bar control, shows info text
pub fn guiStatusBar(bounds: Rectangle, text: [:0]const u8) i32 {
    return @as(i32, cdef.GuiStatusBar(bounds, @as([*c]const u8, @ptrCast(text))));
}

/// Dummy control for placeholders
pub fn guiDummyRec(bounds: Rectangle, text: [:0]const u8) i32 {
    return @as(i32, cdef.GuiDummyRec(bounds, @as([*c]const u8, @ptrCast(text))));
}

/// Grid control
pub fn guiGrid(bounds: Rectangle, text: [:0]const u8, spacing: f32, subdivs: i32, mouseCell: *Vector2) i32 {
    return @as(i32, cdef.GuiGrid(bounds, @as([*c]const u8, @ptrCast(text)), spacing, @as(c_int, subdivs), @as([*c]Vector2, @ptrCast(mouseCell))));
}

/// List View control
pub fn guiListView(bounds: Rectangle, text: [:0]const u8, scrollIndex: *i32, active: *i32) i32 {
    return @as(i32, cdef.GuiListView(bounds, @as([*c]const u8, @ptrCast(text)), @as([*c]c_int, @ptrCast(scrollIndex)), @as([*c]c_int, @ptrCast(active))));
}

/// Message Box control, displays a message
pub fn guiMessageBox(bounds: Rectangle, title: [:0]const u8, message: [:0]const u8, buttons: [:0]const u8) i32 {
    return @as(i32, cdef.GuiMessageBox(bounds, @as([*c]const u8, @ptrCast(title)), @as([*c]const u8, @ptrCast(message)), @as([*c]const u8, @ptrCast(buttons))));
}

/// Text Input Box control, ask for text, supports secret
pub fn guiTextInputBox(bounds: Rectangle, title: [:0]const u8, message: [:0]const u8, buttons: [:0]const u8, text: [:0]u8, textMaxSize: i32, secretViewActive: *bool) i32 {
    return @as(i32, cdef.GuiTextInputBox(bounds, @as([*c]const u8, @ptrCast(title)), @as([*c]const u8, @ptrCast(message)), @as([*c]const u8, @ptrCast(buttons)), @as([*c]u8, @ptrCast(text)), @as(c_int, textMaxSize), @as([*c]bool, @ptrCast(secretViewActive))));
}

/// Color Picker control (multiple color controls)
pub fn guiColorPicker(bounds: Rectangle, text: [:0]const u8, color: *Color) i32 {
    return @as(i32, cdef.GuiColorPicker(bounds, @as([*c]const u8, @ptrCast(text)), @as([*c]Color, @ptrCast(color))));
}

/// Color Panel control
pub fn guiColorPanel(bounds: Rectangle, text: [:0]const u8, color: *Color) i32 {
    return @as(i32, cdef.GuiColorPanel(bounds, @as([*c]const u8, @ptrCast(text)), @as([*c]Color, @ptrCast(color))));
}

/// Color Bar Alpha control
pub fn guiColorBarAlpha(bounds: Rectangle, text: [:0]const u8, alpha: *f32) i32 {
    return @as(i32, cdef.GuiColorBarAlpha(bounds, @as([*c]const u8, @ptrCast(text)), @as([*c]f32, @ptrCast(alpha))));
}

/// Color Bar Hue control
pub fn guiColorBarHue(bounds: Rectangle, text: [:0]const u8, value: *f32) i32 {
    return @as(i32, cdef.GuiColorBarHue(bounds, @as([*c]const u8, @ptrCast(text)), @as([*c]f32, @ptrCast(value))));
}

/// Color Picker control that avoids conversion to RGB on each call (multiple color controls)
pub fn guiColorPickerHSV(bounds: Rectangle, text: [:0]const u8, colorHsv: *Vector3) i32 {
    return @as(i32, cdef.GuiColorPickerHSV(bounds, @as([*c]const u8, @ptrCast(text)), @as([*c]Vector3, @ptrCast(colorHsv))));
}

/// Color Panel control that updates Hue-Saturation-Value color value, used by GuiColorPickerHSV()
pub fn guiColorPanelHSV(bounds: Rectangle, text: [:0]const u8, colorHsv: *Vector3) i32 {
    return @as(i32, cdef.GuiColorPanelHSV(bounds, @as([*c]const u8, @ptrCast(text)), @as([*c]Vector3, @ptrCast(colorHsv))));
}
