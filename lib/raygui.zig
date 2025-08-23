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

pub const StyleProp = extern struct {
    controlId: c_ushort,
    propertyId: c_ushort,
    propertyValue: c_int,
};

pub const State = enum(c_int) {
    normal = 0,
    focused,
    pressed,
    disabled,
};

pub const TextAlignment = enum(c_int) {
    left = 0,
    center,
    right,
};

pub const TextAlignmentVertical = enum(c_int) {
    top = 0,
    middle,
    bottom,
};

pub const TextWrapMode = enum(c_int) {
    none = 0,
    char,
    word,
};

pub const Control = enum(c_int) {
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
    control11,
    listview,
    colorpicker,
    scrollbar,
    statusbar,
};

pub const ControlProperty = enum(c_int) {
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

pub const DefaultProperty = enum(c_int) {
    text_size = 16,
    text_spacing,
    line_color,
    background_color,
    text_line_spacing,
    text_alignment_vertical,
    text_wrap_mode,
};

pub const ControlOrDefaultProperty = union(enum) {
    control: ControlProperty,
    default: DefaultProperty,
};

pub const ToggleProperty = enum(c_int) {
    group_padding = 16,
};

pub const SliderProperty = enum(c_int) {
    slider_width = 16,
    slider_padding,
};

pub const ProgressBarProperty = enum(c_int) {
    progress_padding = 16,
};

pub const ScrollBarProperty = enum(c_int) {
    arrows_size = 16,
    arrows_visible,
    scroll_slider_padding,
    scroll_slider_size,
    scroll_padding,
    scroll_speed,
};

pub const CheckBoxProperty = enum(c_int) {
    check_padding = 16,
};

pub const ComboBoxProperty = enum(c_int) {
    combo_button_width = 16,
    combo_button_spacing,
};

pub const DropdownBoxProperty = enum(c_int) {
    arrow_padding = 16,
    dropdown_items_spacing,
    dropdown_arrow_hidden,
    dropdown_roll_up,
};

pub const TextBoxProperty = enum(c_int) {
    text_readonly = 16,
};

pub const ValueBoxProperty = enum(c_int) {
    spin_button_width = 16,
    spin_button_spacing,
};

pub const ListViewProperty = enum(c_int) {
    list_items_height = 16,
    list_items_spacing,
    scrollbar_width,
    scrollbar_side,
    list_items_border_normal,
    list_items_border_width,
};

pub const ColorPickerProperty = enum(c_int) {
    color_selector_size = 16,
    huebar_width,
    huebar_padding,
    huebar_selector_height,
    huebar_selector_overflow,
};

pub const scrollbar_left_side: c_int = 0;
pub const scrollbar_right_side: c_int = 1;

pub const IconName = enum(c_int) {
    none = 0,
    folder_file_open = 1,
    file_save_classic = 2,
    folder_open = 3,
    folder_save = 4,
    file_open = 5,
    file_save = 6,
    file_export = 7,
    file_add = 8,
    file_delete = 9,
    filetype_text = 10,
    filetype_audio = 11,
    filetype_image = 12,
    filetype_play = 13,
    filetype_video = 14,
    filetype_info = 15,
    file_copy = 16,
    file_cut = 17,
    file_paste = 18,
    cursor_hand = 19,
    cursor_pointer = 20,
    cursor_classic = 21,
    pencil = 22,
    pencil_big = 23,
    brush_classic = 24,
    brush_painter = 25,
    water_drop = 26,
    color_picker = 27,
    rubber = 28,
    color_bucket = 29,
    text_t = 30,
    text_a = 31,
    scale = 32,
    resize = 33,
    filter_point = 34,
    filter_bilinear = 35,
    crop = 36,
    crop_alpha = 37,
    square_toggle = 38,
    symmetry = 39,
    symmetry_horizontal = 40,
    symmetry_vertical = 41,
    lens = 42,
    lens_big = 43,
    eye_on = 44,
    eye_off = 45,
    filter_top = 46,
    filter = 47,
    target_point = 48,
    target_small = 49,
    target_big = 50,
    target_move = 51,
    cursor_move = 52,
    cursor_scale = 53,
    cursor_scale_right = 54,
    cursor_scale_left = 55,
    undo = 56,
    redo = 57,
    reredo = 58,
    mutate = 59,
    rotate = 60,
    repeat = 61,
    shuffle = 62,
    emptybox = 63,
    target = 64,
    target_small_fill = 65,
    target_big_fill = 66,
    target_move_fill = 67,
    cursor_move_fill = 68,
    cursor_scale_fill = 69,
    cursor_scale_right_fill = 70,
    cursor_scale_left_fill = 71,
    undo_fill = 72,
    redo_fill = 73,
    reredo_fill = 74,
    mutate_fill = 75,
    rotate_fill = 76,
    repeat_fill = 77,
    shuffle_fill = 78,
    emptybox_small = 79,
    box = 80,
    box_top = 81,
    box_top_right = 82,
    box_right = 83,
    box_bottom_right = 84,
    box_bottom = 85,
    box_bottom_left = 86,
    box_left = 87,
    box_top_left = 88,
    box_center = 89,
    box_circle_mask = 90,
    pot = 91,
    alpha_multiply = 92,
    alpha_clear = 93,
    dithering = 94,
    mipmaps = 95,
    box_grid = 96,
    grid = 97,
    box_corners_small = 98,
    box_corners_big = 99,
    four_boxes = 100,
    grid_fill = 101,
    box_multisize = 102,
    zoom_small = 103,
    zoom_medium = 104,
    zoom_big = 105,
    zoom_all = 106,
    zoom_center = 107,
    box_dots_small = 108,
    box_dots_big = 109,
    box_concentric = 110,
    box_grid_big = 111,
    ok_tick = 112,
    cross = 113,
    arrow_left = 114,
    arrow_right = 115,
    arrow_down = 116,
    arrow_up = 117,
    arrow_left_fill = 118,
    arrow_right_fill = 119,
    arrow_down_fill = 120,
    arrow_up_fill = 121,
    audio = 122,
    fx = 123,
    wave = 124,
    wave_sinus = 125,
    wave_square = 126,
    wave_triangular = 127,
    cross_small = 128,
    player_previous = 129,
    player_play_back = 130,
    player_play = 131,
    player_pause = 132,
    player_stop = 133,
    player_next = 134,
    player_record = 135,
    magnet = 136,
    lock_close = 137,
    lock_open = 138,
    clock = 139,
    tools = 140,
    gear = 141,
    gear_big = 142,
    bin = 143,
    hand_pointer = 144,
    laser = 145,
    coin = 146,
    explosion = 147,
    @"1up" = 148,
    player = 149,
    player_jump = 150,
    key = 151,
    demon = 152,
    text_popup = 153,
    gear_ex = 154,
    crack = 155,
    crack_points = 156,
    star = 157,
    door = 158,
    exit = 159,
    mode_2d = 160,
    mode_3d = 161,
    cube = 162,
    cube_face_top = 163,
    cube_face_left = 164,
    cube_face_front = 165,
    cube_face_bottom = 166,
    cube_face_right = 167,
    cube_face_back = 168,
    camera = 169,
    special = 170,
    link_net = 171,
    link_boxes = 172,
    link_multi = 173,
    link = 174,
    link_broke = 175,
    text_notes = 176,
    notebook = 177,
    suitcase = 178,
    suitcase_zip = 179,
    mailbox = 180,
    monitor = 181,
    printer = 182,
    photo_camera = 183,
    photo_camera_flash = 184,
    house = 185,
    heart = 186,
    corner = 187,
    vertical_bars = 188,
    vertical_bars_fill = 189,
    life_bars = 190,
    info = 191,
    crossline = 192,
    help = 193,
    filetype_alpha = 194,
    filetype_home = 195,
    layers_visible = 196,
    layers = 197,
    window = 198,
    hidpi = 199,
    filetype_binary = 200,
    hex = 201,
    shield = 202,
    file_new = 203,
    folder_add = 204,
    alarm = 205,
    cpu = 206,
    rom = 207,
    step_over = 208,
    step_into = 209,
    step_out = 210,
    restart = 211,
    breakpoint_on = 212,
    breakpoint_off = 213,
    burger_menu = 214,
    case_sensitive = 215,
    reg_exp = 216,
    folder = 217,
    file = 218,
    sand_timer = 219,
    warning = 220,
    help_box = 221,
    info_box = 222,
    priority = 223,
    layers_iso = 224,
    layers2 = 225,
    mlayers = 226,
    maps = 227,
    hot = 228,
    label = 229,
    name_id = 230,
    slicing = 231,
    manual_control = 232,
    collision = 233,
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
pub fn setStyle(control: Control, comptime property: ControlOrDefaultProperty, value: i32) void {
    const property_int: c_int = switch (property) {
        inline else => |val| @intCast(@intFromEnum(val)),
    };

    cdef.GuiSetStyle(control, property_int, @as(c_int, value));
}

/// Get one style property
pub fn getStyle(control: Control, comptime property: ControlOrDefaultProperty) i32 {
    const property_int: c_int = switch (property) {
        inline else => |val| @intCast(@intFromEnum(val)),
    };

    return @as(i32, cdef.GuiGetStyle(control, property_int));
}

/// Get raygui icons data pointer
pub fn getIcons() RayguiError![]u32 {
    var res: []u32 = undefined;

    const ptr = cdef.GuiGetIcons();
    if (ptr == 0) return RayguiError.GetIcons;

    res.ptr = @as([*]u32, @ptrCast(ptr));
    res.len = @as(usize, @intCast(256 * 256)); // RAYGUI_ICON_MAX_ICONS * RAYGUI_ICON_MAX_ICONS
    return res;
}

// If you REALLY need the return value of the function, you'll know what to do with it and its size yourself
/// Load raygui icons file (.rgi) into internal icons data
pub fn loadIcons(fileName: [*c]const u8, loadIconsName: bool) [*c][*c]u8 {
    return cdef.GuiLoadIcons(fileName, loadIconsName);
}

/// Tab Bar control, returns TAB to be closed or -1
pub fn tabBar(bounds: Rectangle, text: [][*:0]const u8, active: *i32) i32 {
    return @as(i32, cdef.GuiTabBar(bounds, @as([*c][*c]const u8, @ptrCast(text)), @as(c_int, @intCast(text.len)), @as([*c]c_int, @ptrCast(active))));
}

/// List View with extended parameters
pub fn listViewEx(bounds: Rectangle, text: [][*:0]const u8, scrollIndex: *i32, active: *i32, focus: *i32) i32 {
    return @as(i32, cdef.GuiListViewEx(bounds, @as([*c][*c]const u8, @ptrCast(text)), @as(c_int, @intCast(text.len)), @as([*c]c_int, @ptrCast(scrollIndex)), @as([*c]c_int, @ptrCast(active)), @as([*c]c_int, @ptrCast(focus))));
}

/// Panel control, useful to group controls
pub fn panel(bounds: Rectangle, text: ?[*:0]const u8) i32 {
    var textFinal = @as([*c]const u8, 0);
    if (text) |textSure| {
        textFinal = @as([*c]const u8, @ptrCast(textSure));
    }
    return @as(i32, cdef.GuiPanel(bounds, textFinal));
}

/// Scroll Panel control
pub fn scrollPanel(bounds: Rectangle, text: ?[*:0]const u8, content: Rectangle, scroll: *Vector2, view: *Rectangle) i32 {
    var textFinal = @as([*c]const u8, 0);
    if (text) |textSure| {
        textFinal = @as([*c]const u8, @ptrCast(textSure));
    }
    return @as(i32, cdef.GuiScrollPanel(bounds, textFinal, content, @as([*c]Vector2, @ptrCast(scroll)), @as([*c]Rectangle, @ptrCast(view))));
}

/// Button control, returns true when clicked
pub fn button(bounds: Rectangle, text: [:0]const u8) bool {
    return @as(i32, cdef.GuiButton(bounds, @as([*c]const u8, @ptrCast(text)))) > 0;
}

/// Label button control, returns true when clicked
pub fn labelButton(bounds: Rectangle, text: [:0]const u8) bool {
    return @as(i32, cdef.GuiLabelButton(bounds, @as([*c]const u8, @ptrCast(text)))) > 0;
}

/// Check Box control, returns true when active
pub fn checkBox(bounds: Rectangle, text: [:0]const u8, checked: *bool) bool {
    return @as(i32, cdef.GuiCheckBox(bounds, @as([*c]const u8, @ptrCast(text)), @as([*c]bool, @ptrCast(checked)))) > 0;
}

/// Text Box control, updates input text
/// Returns true on ENTER pressed (useful for data validation)
pub fn textBox(bounds: Rectangle, text: [:0]u8, textSize: i32, editMode: bool) bool {
    return @as(i32, cdef.GuiTextBox(bounds, @as([*c]u8, @ptrCast(text)), @as(c_int, textSize), editMode)) > 0;
}

/// Enable gui controls (global state)
pub fn enable() void {
    cdef.GuiEnable();
}

/// Disable gui controls (global state)
pub fn disable() void {
    cdef.GuiDisable();
}

/// Lock gui controls (global state)
pub fn lock() void {
    cdef.GuiLock();
}

/// Unlock gui controls (global state)
pub fn unlock() void {
    cdef.GuiUnlock();
}

/// Check if gui is locked (global state)
pub fn isLocked() bool {
    return cdef.GuiIsLocked();
}

/// Set gui controls alpha (global state), alpha goes from 0.0f to 1.0f
pub fn setAlpha(alpha: f32) void {
    cdef.GuiSetAlpha(alpha);
}

/// Set gui state (global state)
pub fn setState(state: i32) void {
    cdef.GuiSetState(@as(c_int, state));
}

/// Get gui state (global state)
pub fn getState() i32 {
    return @as(i32, cdef.GuiGetState());
}

/// Set gui custom font (global state)
pub fn setFont(font: Font) void {
    cdef.GuiSetFont(font);
}

/// Get gui custom font (global state)
pub fn getFont() Font {
    return cdef.GuiGetFont();
}

/// Load style file over global style variable (.rgs)
pub fn loadStyle(fileName: [:0]const u8) void {
    cdef.GuiLoadStyle(@as([*c]const u8, @ptrCast(fileName)));
}

/// Load style default over global style
pub fn loadStyleDefault() void {
    cdef.GuiLoadStyleDefault();
}

/// Enable gui tooltips (global state)
pub fn enableTooltip() void {
    cdef.GuiEnableTooltip();
}

/// Disable gui tooltips (global state)
pub fn disableTooltip() void {
    cdef.GuiDisableTooltip();
}

/// Set tooltip string
pub fn setTooltip(tooltip: [:0]const u8) void {
    cdef.GuiSetTooltip(@as([*c]const u8, @ptrCast(tooltip)));
}

/// Get text with icon id prepended (if supported)
pub fn iconText(iconId: i32, text: [:0]const u8) [:0]const u8 {
    return std.mem.span(cdef.GuiIconText(@as(c_int, iconId), @as([*c]const u8, @ptrCast(text))));
}

/// Set default icon drawing size
pub fn setIconScale(scale: i32) void {
    cdef.GuiSetIconScale(@as(c_int, scale));
}

/// Draw icon using pixel size at specified position
pub fn drawIcon(iconId: i32, posX: i32, posY: i32, pixelSize: i32, color: Color) void {
    cdef.GuiDrawIcon(@as(c_int, iconId), @as(c_int, posX), @as(c_int, posY), @as(c_int, pixelSize), color);
}

/// Get text width considering gui style and icon size (if required)
pub fn getTextWidth(text: [:0]const u8) i32 {
    return @as(i32, cdef.GuiGetTextWidth(@as([*c]const u8, @ptrCast(text))));
}

/// Window Box control, shows a window that can be closed
pub fn windowBox(bounds: Rectangle, title: [:0]const u8) i32 {
    return @as(i32, cdef.GuiWindowBox(bounds, @as([*c]const u8, @ptrCast(title))));
}

/// Group Box control with text name
pub fn groupBox(bounds: Rectangle, text: [:0]const u8) i32 {
    return @as(i32, cdef.GuiGroupBox(bounds, @as([*c]const u8, @ptrCast(text))));
}

/// Line separator control, could contain text
pub fn line(bounds: Rectangle, text: [:0]const u8) i32 {
    return @as(i32, cdef.GuiLine(bounds, @as([*c]const u8, @ptrCast(text))));
}

/// Label control
pub fn label(bounds: Rectangle, text: [:0]const u8) i32 {
    return @as(i32, cdef.GuiLabel(bounds, @as([*c]const u8, @ptrCast(text))));
}

/// Toggle Button control
pub fn toggle(bounds: Rectangle, text: [:0]const u8, active: *bool) i32 {
    return @as(i32, cdef.GuiToggle(bounds, @as([*c]const u8, @ptrCast(text)), @as([*c]bool, @ptrCast(active))));
}

/// Toggle Group control
pub fn toggleGroup(bounds: Rectangle, text: [:0]const u8, active: *i32) i32 {
    return @as(i32, cdef.GuiToggleGroup(bounds, @as([*c]const u8, @ptrCast(text)), @as([*c]c_int, @ptrCast(active))));
}

/// Toggle Slider control
pub fn toggleSlider(bounds: Rectangle, text: [:0]const u8, active: *i32) i32 {
    return @as(i32, cdef.GuiToggleSlider(bounds, @as([*c]const u8, @ptrCast(text)), @as([*c]c_int, @ptrCast(active))));
}

/// Combo Box control
pub fn comboBox(bounds: Rectangle, text: [:0]const u8, active: *i32) i32 {
    return @as(i32, cdef.GuiComboBox(bounds, @as([*c]const u8, @ptrCast(text)), @as([*c]c_int, @ptrCast(active))));
}

/// Dropdown Box control
pub fn dropdownBox(bounds: Rectangle, text: [:0]const u8, active: *i32, editMode: bool) i32 {
    return @as(i32, cdef.GuiDropdownBox(bounds, @as([*c]const u8, @ptrCast(text)), @as([*c]c_int, @ptrCast(active)), editMode));
}

/// Spinner control
pub fn spinner(bounds: Rectangle, text: [:0]const u8, value: *i32, minValue: i32, maxValue: i32, editMode: bool) i32 {
    return @as(i32, cdef.GuiSpinner(bounds, @as([*c]const u8, @ptrCast(text)), @as([*c]c_int, @ptrCast(value)), @as(c_int, minValue), @as(c_int, maxValue), editMode));
}

/// Value Box control, updates input text with numbers
pub fn valueBox(bounds: Rectangle, text: [:0]const u8, value: *i32, minValue: i32, maxValue: i32, editMode: bool) i32 {
    return @as(i32, cdef.GuiValueBox(bounds, @as([*c]const u8, @ptrCast(text)), @as([*c]c_int, @ptrCast(value)), @as(c_int, minValue), @as(c_int, maxValue), editMode));
}

/// Value box control for float values
pub fn valueBoxFloat(bounds: Rectangle, text: [:0]const u8, textValue: [:0]u8, value: *f32, editMode: bool) i32 {
    return @as(i32, cdef.GuiValueBoxFloat(bounds, @as([*c]const u8, @ptrCast(text)), @as([*c]u8, @ptrCast(textValue)), @as([*c]f32, @ptrCast(value)), editMode));
}

/// Slider control
pub fn slider(bounds: Rectangle, textLeft: [:0]const u8, textRight: [:0]const u8, value: *f32, minValue: f32, maxValue: f32) i32 {
    return @as(i32, cdef.GuiSlider(bounds, @as([*c]const u8, @ptrCast(textLeft)), @as([*c]const u8, @ptrCast(textRight)), @as([*c]f32, @ptrCast(value)), minValue, maxValue));
}

/// Slider Bar control
pub fn sliderBar(bounds: Rectangle, textLeft: [:0]const u8, textRight: [:0]const u8, value: *f32, minValue: f32, maxValue: f32) i32 {
    return @as(i32, cdef.GuiSliderBar(bounds, @as([*c]const u8, @ptrCast(textLeft)), @as([*c]const u8, @ptrCast(textRight)), @as([*c]f32, @ptrCast(value)), minValue, maxValue));
}

/// Progress Bar control
pub fn progressBar(bounds: Rectangle, textLeft: [:0]const u8, textRight: [:0]const u8, value: *f32, minValue: f32, maxValue: f32) i32 {
    return @as(i32, cdef.GuiProgressBar(bounds, @as([*c]const u8, @ptrCast(textLeft)), @as([*c]const u8, @ptrCast(textRight)), @as([*c]f32, @ptrCast(value)), minValue, maxValue));
}

/// Status Bar control, shows info text
pub fn statusBar(bounds: Rectangle, text: [:0]const u8) i32 {
    return @as(i32, cdef.GuiStatusBar(bounds, @as([*c]const u8, @ptrCast(text))));
}

/// Dummy control for placeholders
pub fn dummyRec(bounds: Rectangle, text: [:0]const u8) i32 {
    return @as(i32, cdef.GuiDummyRec(bounds, @as([*c]const u8, @ptrCast(text))));
}

/// Grid control
pub fn grid(bounds: Rectangle, text: [:0]const u8, spacing: f32, subdivs: i32, mouseCell: *Vector2) i32 {
    return @as(i32, cdef.GuiGrid(bounds, @as([*c]const u8, @ptrCast(text)), spacing, @as(c_int, subdivs), @as([*c]Vector2, @ptrCast(mouseCell))));
}

/// List View control
pub fn listView(bounds: Rectangle, text: [:0]const u8, scrollIndex: *i32, active: *i32) i32 {
    return @as(i32, cdef.GuiListView(bounds, @as([*c]const u8, @ptrCast(text)), @as([*c]c_int, @ptrCast(scrollIndex)), @as([*c]c_int, @ptrCast(active))));
}

/// Message Box control, displays a message
pub fn messageBox(bounds: Rectangle, title: [:0]const u8, message: [:0]const u8, buttons: [:0]const u8) i32 {
    return @as(i32, cdef.GuiMessageBox(bounds, @as([*c]const u8, @ptrCast(title)), @as([*c]const u8, @ptrCast(message)), @as([*c]const u8, @ptrCast(buttons))));
}

/// Text Input Box control, ask for text, supports secret
pub fn textInputBox(bounds: Rectangle, title: [:0]const u8, message: [:0]const u8, buttons: [:0]const u8, text: [:0]u8, textMaxSize: i32, secretViewActive: ?*bool) i32 {
    return @as(i32, cdef.GuiTextInputBox(bounds, @as([*c]const u8, @ptrCast(title)), @as([*c]const u8, @ptrCast(message)), @as([*c]const u8, @ptrCast(buttons)), @as([*c]u8, @ptrCast(text)), @as(c_int, textMaxSize), @as([*c]bool, @ptrCast(secretViewActive))));
}

/// Color Picker control (multiple color controls)
pub fn colorPicker(bounds: Rectangle, text: [:0]const u8, color: *Color) i32 {
    return @as(i32, cdef.GuiColorPicker(bounds, @as([*c]const u8, @ptrCast(text)), @as([*c]Color, @ptrCast(color))));
}

/// Color Panel control
pub fn colorPanel(bounds: Rectangle, text: [:0]const u8, color: *Color) i32 {
    return @as(i32, cdef.GuiColorPanel(bounds, @as([*c]const u8, @ptrCast(text)), @as([*c]Color, @ptrCast(color))));
}

/// Color Bar Alpha control
pub fn colorBarAlpha(bounds: Rectangle, text: [:0]const u8, alpha: *f32) i32 {
    return @as(i32, cdef.GuiColorBarAlpha(bounds, @as([*c]const u8, @ptrCast(text)), @as([*c]f32, @ptrCast(alpha))));
}

/// Color Bar Hue control
pub fn colorBarHue(bounds: Rectangle, text: [:0]const u8, value: *f32) i32 {
    return @as(i32, cdef.GuiColorBarHue(bounds, @as([*c]const u8, @ptrCast(text)), @as([*c]f32, @ptrCast(value))));
}

/// Color Picker control that avoids conversion to RGB on each call (multiple color controls)
pub fn colorPickerHSV(bounds: Rectangle, text: [:0]const u8, colorHsv: *Vector3) i32 {
    return @as(i32, cdef.GuiColorPickerHSV(bounds, @as([*c]const u8, @ptrCast(text)), @as([*c]Vector3, @ptrCast(colorHsv))));
}

/// Color Panel control that updates Hue-Saturation-Value color value, used by GuiColorPickerHSV()
pub fn colorPanelHSV(bounds: Rectangle, text: [:0]const u8, colorHsv: *Vector3) i32 {
    return @as(i32, cdef.GuiColorPanelHSV(bounds, @as([*c]const u8, @ptrCast(text)), @as([*c]Vector3, @ptrCast(colorHsv))));
}
