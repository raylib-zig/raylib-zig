// raylib-zig (c) Nikolas Wipper 2023

const rl = @This();
const std = @import("std");

pub const cdef = @import("raylib-ext.zig");

pub const gl = @import("rlgl.zig");
pub const math = @import("raymath.zig");

const C = std.builtin.CallingConvention.c;

test {
    std.testing.refAllDeclsRecursive(@This());
}

pub const RaylibError = error{
    LoadFileData,
    CompressData,
    DecompressData,
    EncodeDataBase64,
    DecodeDataBase64,
    ExportImageToMemory,
    LoadImageColors,
    LoadImagePalette,
    LoadFont,
    LoadFontData,
    LoadCodepoints,
    LoadTextLines,
    TextSplit,
    LoadMaterial,
    LoadMaterials,
    LoadModelAnimations,
    LoadShader,
    LoadImage,
    LoadModel,
    LoadTexture,
    LoadRenderTexture,
    LoadWave,
    LoadSound,
    LoadMusic,
    LoadAudioStream,
    GenImageFontAtlas,
};

pub const Vector2 = extern struct {
    x: f32,
    y: f32,

    pub fn init(x: f32, y: f32) Vector2 {
        return Vector2{ .x = x, .y = y };
    }

    /// Vector with components value 0.0
    pub fn zero() Vector2 {
        return math.vector2Zero();
    }

    /// Vector with components value 1.0
    pub fn one() Vector2 {
        return math.vector2One();
    }

    /// Add two vectors (v1 + v2)
    pub fn add(self: Vector2, v: Vector2) Vector2 {
        return math.vector2Add(self, v);
    }

    /// Add vector and float value
    pub fn addValue(self: Vector2, v: f32) Vector2 {
        return math.vector2AddValue(self, v);
    }

    /// Subtract two vectors (v1 - v2)
    pub fn subtract(self: Vector2, v: Vector2) Vector2 {
        return math.vector2Subtract(self, v);
    }

    /// Subtract vector by float value
    pub fn subtractValue(self: Vector2, v: f32) Vector2 {
        return math.vector2SubtractValue(self, v);
    }

    /// Calculate vector length
    pub fn length(self: Vector2) f32 {
        return math.vector2Length(self);
    }

    /// Calculate vector square length
    pub fn lengthSqr(self: Vector2) f32 {
        return math.vector2LengthSqr(self);
    }

    /// Calculate two vectors dot product
    pub fn dotProduct(self: Vector2, v: Vector2) f32 {
        return math.vector2DotProduct(self, v);
    }

    /// Calculate distance between two vectors
    pub fn distance(self: Vector2, v: Vector2) f32 {
        return math.vector2Distance(self, v);
    }

    /// Calculate square distance between two vectors
    pub fn distanceSqr(self: Vector2, v: Vector2) f32 {
        return math.vector2DistanceSqr(self, v);
    }

    /// Calculate angle from two vectors
    pub fn angle(self: Vector2, v: Vector2) f32 {
        return math.vector2Angle(self, v);
    }

    /// Calculate angle defined by a two vectors line
    pub fn lineAngle(self: Vector2, end: Vector2) f32 {
        return math.vector2LineAngle(self, end);
    }

    /// Scale vector (multiply by value)
    pub fn scale(self: Vector2, scale_: f32) Vector2 {
        return math.vector2Scale(self, scale_);
    }

    /// Multiply vector by vector
    pub fn multiply(self: Vector2, v2: Vector2) Vector2 {
        return math.vector2Multiply(self, v2);
    }

    /// Negate vector
    pub fn negate(self: Vector2) Vector2 {
        return math.vector2Negate(self);
    }

    /// Divide vector by vector
    pub fn divide(self: Vector2, v2: Vector2) Vector2 {
        return math.vector2Divide(self, v2);
    }

    /// Normalize provided vector
    pub fn normalize(self: Vector2) Vector2 {
        return math.vector2Normalize(self);
    }

    /// Transforms a Vector2 by a given Matrix
    pub fn transform(self: Vector2, mat: Matrix) Vector2 {
        return math.vector2Transform(self, mat);
    }

    /// Calculate linear interpolation between two vectors
    pub fn lerp(self: Vector2, v2: Vector2, amount: f32) Vector2 {
        return math.vector2Lerp(self, v2, amount);
    }

    /// Calculate reflected vector to normal
    pub fn reflect(self: Vector2, normal: Vector2) Vector2 {
        return math.vector2Reflect(self, normal);
    }

    /// Get min value for each pair of components
    pub fn min(self: Vector2, v2: Vector2) Vector2 {
        return math.vector2Min(self, v2);
    }

    /// Get max value for each pair of components
    pub fn max(self: Vector2, v2: Vector2) Vector2 {
        return math.vector2Max(self, v2);
    }

    /// Rotate vector by angle
    pub fn rotate(self: Vector2, angle_: f32) Vector2 {
        return math.vector2Rotate(self, angle_);
    }

    /// Move Vector towards target
    pub fn moveTowards(self: Vector2, target: Vector2, maxDistance: f32) Vector2 {
        return math.vector2MoveTowards(self, target, maxDistance);
    }

    /// Invert the given vector
    pub fn invert(self: Vector2) Vector2 {
        return math.vector2Invert(self);
    }

    /// Clamp the components of the vector between min and max values specified by the given vectors
    pub fn clamp(self: Vector2, min_: Vector2, max_: Vector2) Vector2 {
        return math.vector2Clamp(self, min_, max_);
    }

    /// Clamp the magnitude of the vector between two min and max values
    pub fn clampValue(self: Vector2, min_: f32, max_: f32) Vector2 {
        return math.vector2ClampValue(self, min_, max_);
    }

    /// Check whether two given vectors are almost equal
    pub fn equals(self: Vector2, q: Vector2) i32 {
        return math.vector2Equals(self, q);
    }

    /// Compute the direction of a refracted ray
    /// v: normalized direction of the incoming ray
    /// n: normalized normal vector of the interface of two optical media
    /// r: ratio of the refractive index of the medium from where the ray comes
    ///    to the refractive index of the medium on the other side of the surface
    pub fn refract(self: Vector2, n: Vector2, r: f32) Vector2 {
        return math.vector2Refract(self, n, r);
    }
};

pub const Vector3 = extern struct {
    x: f32,
    y: f32,
    z: f32,

    pub fn init(x: f32, y: f32, z: f32) Vector3 {
        return Vector3{ .x = x, .y = y, .z = z };
    }

    // Vector with components value 0.0
    pub fn zero() Vector3 {
        return math.vector3Zero();
    }

    /// Vector with components value 1.0
    pub fn one() Vector3 {
        return math.vector3One();
    }

    /// Add two vectors
    pub fn add(self: Vector3, v: Vector3) Vector3 {
        return math.vector3Add(self, v);
    }

    /// Add vector and float value
    pub fn addValue(self: Vector3, add_: f32) Vector3 {
        return math.vector3AddValue(self, add_);
    }

    /// Subtract two vectors
    pub fn subtract(self: Vector3, v: Vector3) Vector3 {
        return math.vector3Subtract(self, v);
    }

    /// Subtract vector by float value
    pub fn subtractValue(self: Vector3, sub: f32) Vector3 {
        return math.vector3SubtractValue(self, sub);
    }

    /// Multiply vector by scalar
    pub fn scale(self: Vector3, scalar: f32) Vector3 {
        return math.vector3Scale(self, scalar);
    }

    /// Multiply vector by vector
    pub fn multiply(self: Vector3, v: Vector3) Vector3 {
        return math.vector3Multiply(self, v);
    }

    /// Calculate two vectors cross product
    pub fn crossProduct(self: Vector3, v: Vector3) Vector3 {
        return math.vector3CrossProduct(self, v);
    }

    /// Calculate one vector perpendicular vector
    pub fn perpendicular(self: Vector3) Vector3 {
        return math.vector3Perpendicular(self);
    }

    /// Calculate vector length
    pub fn length(self: Vector3) f32 {
        return math.vector3Length(self);
    }

    /// Calculate vector square length
    pub fn lengthSqr(self: Vector3) f32 {
        return math.vector3LengthSqr(self);
    }

    /// Calculate two vectors dot product
    pub fn dotProduct(self: Vector3, v: Vector3) f32 {
        return math.vector3DotProduct(self, v);
    }

    /// Calculate distance between two vectors
    pub fn distance(self: Vector3, v: Vector3) f32 {
        return math.vector3Distance(self, v);
    }

    /// Calculate square distance between two vectors
    pub fn distanceSqr(self: Vector3, v: Vector3) f32 {
        return math.vector3DistanceSqr(self, v);
    }

    /// Calculate angle between two vectors
    pub fn angle(self: Vector3, v: Vector3) f32 {
        return math.vector3Angle(self, v);
    }

    /// Negate vector (invert direction)
    pub fn negate(self: Vector3) Vector3 {
        return math.vector3Negate(self);
    }

    /// Divide vector by vector
    pub fn divide(self: Vector3, v: Vector3) Vector3 {
        return math.vector3Divide(self, v);
    }

    /// Normalize provided vector
    pub fn normalize(self: Vector3) Vector3 {
        return math.vector3Normalize(self);
    }

    /// Calculate the projection of the vector v1 on to v2
    pub fn project(self: Vector3, v: Vector3) Vector3 {
        return math.vector3Project(self, v);
    }

    /// Calculate the rejection of the vector v1 on to v2
    pub fn reject(self: Vector3, v: Vector3) Vector3 {
        return math.vector3Reject(self, v);
    }

    /// Orthonormalize provided vectors Makes vectors normalized and orthogonal
    /// to each other Gram-Schmidt function implementation
    pub fn orthoNormalize(self: *Vector3, v: *Vector3) void {
        math.vector3OrthoNormalize(self, v);
    }

    /// Transforms a Vector3 by a given Matrix
    pub fn transform(self: Vector3, mat: Matrix) Vector3 {
        return math.vector3Transform(self, mat);
    }

    /// Transform a vector by quaternion rotation
    pub fn rotateByQuaternion(self: Vector3, q: Quaternion) Vector3 {
        return math.vector3RotateByQuaternion(self, q);
    }

    /// Rotates a vector around an axis
    pub fn rotateByAxisAngle(self: Vector3, axis: Vector3, angle_: f32) Vector3 {
        return math.vector3RotateByAxisAngle(self, axis, angle_);
    }

    /// Move Vector towards target
    pub fn moveTowards(self: Vector3, target: Vector3, maxDistance: f32) Vector3 {
        return math.vector3MoveTowards(self, target, maxDistance);
    }

    /// Calculate linear interpolation between two vectors
    pub fn lerp(self: Vector3, v2: Vector3, amount: f32) Vector3 {
        return math.vector3Lerp(self, v2, amount);
    }

    /// Calculate cubic hermite interpolation between two vectors and their tangents
    /// as described in the GLTF 2.0 specification
    pub fn cubicHermite(self: Vector3, tangent1: Vector3, v: Vector3, tangent2: Vector3, amount: f32) Vector3 {
        return math.vector3CubicHermite(self, tangent1, v, tangent2, amount);
    }

    /// Calculate reflected vector to normal
    pub fn reflect(self: Vector3, normal: Vector3) Vector3 {
        return math.vector3Reflect(self, normal);
    }

    /// Get min value for each pair of components
    pub fn min(self: Vector3, v: Vector3) Vector3 {
        return math.vector3Min(self, v);
    }

    /// Get max value for each pair of components
    pub fn max(self: Vector3, v: Vector3) Vector3 {
        return math.vector3Max(self, v);
    }

    /// Compute barycenter coordinates (u, v, w) for point p with respect to triangle
    /// (a, b, c) NOTE: Assumes P is on the plane of the triangle
    pub fn barycenter(p: Vector3, a: Vector3, b: Vector3, c: Vector3) Vector3 {
        return math.vector3Barycenter(p, a, b, c);
    }

    /// Projects a Vector3 from screen space into object space
    /// NOTE: We are avoiding calling other raymath functions despite available
    pub fn unproject(source: Vector3, projection: Matrix, view: Matrix) Vector3 {
        return math.vector3Unproject(source, projection, view);
    }

    /// Get Vector3 as float array
    pub fn toFloatV(self: Vector3) math.float3 {
        return math.vector3ToFloatV(self);
    }

    /// Invert the given vector
    pub fn invert(self: Vector3) Vector3 {
        return math.vector3Invert(self);
    }

    /// Clamp the components of the vector between min and max values specified by the given vectors
    pub fn clamp(self: Vector3, min_: Vector3, max_: Vector3) Vector3 {
        return math.vector3Clamp(self, min_, max_);
    }

    /// Clamp the magnitude of the vector between two values
    pub fn clampValue(self: Vector3, min_: f32, max_: f32) Vector3 {
        return math.vector3ClampValue(self, min_, max_);
    }

    /// Check whether two given vectors are almost equal
    pub fn equals(p: Vector3, q: Vector3) i32 {
        return math.vector3Equals(p, q);
    }

    /// Compute the direction of a refracted ray
    /// v: normalized direction of the incoming ray
    /// n: normalized normal vector of the interface of two optical media
    /// r: ratio of the refractive index of the medium from where the ray comes
    ///    to the refractive index of the medium on the other side of the surface
    pub fn refract(self: Vector3, n: Vector3, r: f32) Vector3 {
        return math.vector3Refract(self, n, r);
    }
};

pub const Vector4 = extern struct {
    x: f32,
    y: f32,
    z: f32,
    w: f32,

    pub fn init(x: f32, y: f32, z: f32, w: f32) Vector4 {
        return Vector4{ .x = x, .y = y, .z = z, .w = w };
    }

    /// Vector with components value 0.0
    pub fn zero() Vector4 {
        return math.vector4Zero();
    }

    /// Vector with components value 1.0
    pub fn one() Vector4 {
        return math.vector4One();
    }

    /// Add two vectors
    pub fn add(self: Vector4, v: Vector4) Vector4 {
        return math.vector4Add(self, v);
    }

    /// Add vector and float value
    pub fn addValue(self: Vector4, add_: f32) Vector4 {
        return math.vector4AddValue(self, add_);
    }

    /// Subtract two vectors
    pub fn subtract(self: Vector4, v: Vector4) Vector4 {
        return math.vector4Subtract(self, v);
    }

    /// Subtract vector and float value
    pub fn subtractValue(self: Vector4, add_: f32) Vector4 {
        return math.vector4SubtractValue(self, add_);
    }

    /// Computes the length of a vector
    pub fn length(self: Vector4) f32 {
        return math.vector4Length(self);
    }

    /// Calculate vector square length
    pub fn lengthSqr(self: Vector4) f32 {
        return math.vector4LengthSqr(self);
    }

    /// Calculate two vectors dot product
    pub fn dotProduct(self: Vector4, v: Vector4) f32 {
        return math.vector4DotProduct(self, v);
    }

    /// Calculate distance between two vectors
    pub fn distance(self: Vector4, v: Vector4) f32 {
        return math.vector4Distance(self, v);
    }

    /// Calculate square distance between two vectors
    pub fn distanceSqr(self: Vector4, v: Vector4) f32 {
        return math.vector4DistanceSqr(self, v);
    }

    /// Scale vector by float value
    pub fn scale(self: Vector4, scale_: f32) Vector4 {
        return math.vector4Scale(self, scale_);
    }

    /// Multiply vector by vector
    pub fn multiply(self: Vector4, v: Vector4) Vector4 {
        return math.vector4Multiply(self, v);
    }

    /// Negate vector
    pub fn negate(self: Vector4) Vector4 {
        return math.vector4Negate(self);
    }

    /// Divide two vectors
    pub fn divide(self: Vector4, v: Vector4) Vector4 {
        return math.vector4Divide(self, v);
    }

    /// Normalize vector
    pub fn normalize(self: Vector4) Vector4 {
        return math.vector4Normalize(self);
    }

    /// Get min value for each pair of components
    pub fn min(self: Vector4, v: Vector4) Vector4 {
        return math.vector4Min(self, v);
    }

    /// Get max value for each pair of components
    pub fn max(self: Vector4, v: Vector4) Vector4 {
        return math.vector4Max(self, v);
    }

    /// Calculate linear interpolation between two vectors
    pub fn lerp(self: Vector4, v: Vector4, amount: f32) Vector4 {
        return math.vector4Lerp(self, v, amount);
    }

    /// Move Vector towards target
    pub fn moveTowards(self: Vector4, target: Vector4, maxDistance: f32) Vector4 {
        return math.vector4MoveTowards(self, target, maxDistance);
    }

    /// Invert provided quaternion
    pub fn invert(self: Vector4) Vector4 {
        return math.vector4Invert(self);
    }

    /// Check whether two given quaternions are almost equal
    pub fn equals(p: Vector4, q: Vector4) i32 {
        return math.vector4Equals(p, q);
    }

    /// Get identity quaternion
    pub fn identity() Quaternion {
        return math.quaternionIdentity();
    }

    /// Calculate slerp-optimized interpolation between two quaternions
    pub fn nlerp(self: Quaternion, q: Quaternion, amount: f32) Quaternion {
        return math.quaternionNlerp(self, q, amount);
    }

    /// Calculates spherical linear interpolation between two quaternions
    pub fn slerp(self: Quaternion, q: Quaternion, amount: f32) Quaternion {
        return math.quaternionSlerp(self, q, amount);
    }

    /// Calculate quaternion cubic spline interpolation using Cubic Hermite Spline
    /// algorithm as described in the GLTF 2.0 specification
    pub fn cubicHermiteSpline(self: Quaternion, outTangent1: Quaternion, q: Quaternion, inTangent2: Quaternion, t: f32) Quaternion {
        return math.quaternionCubicHermiteSpline(self, outTangent1, q, inTangent2, t);
    }

    // Calculate quaternion based on the rotation from one vector to another
    pub fn fromVector3ToVector3(from: Vector3, to: Vector3) Quaternion {
        return math.quaternionFromVector3ToVector3(from, to);
    }

    /// Get a quaternion for a given rotation matrix
    pub fn fromMatrix(mat: Matrix) Quaternion {
        return math.quaternionFromMatrix(mat);
    }

    /// Get a matrix for a given quaternion
    pub fn toMatrix(self: Quaternion) Matrix {
        return math.quaternionToMatrix(self);
    }

    /// Get rotation quaternion for an angle and axis
    /// NOTE: Angle must be provided in radians
    pub fn fromAxisAngle(axis: Vector3, angle: f32) Quaternion {
        return math.quaternionFromAxisAngle(axis, angle);
    }

    /// Get the rotation angle and axis for a given quaternion
    pub fn toAxisAngle(self: Quaternion, outAxis: *Vector3, outAngle: *f32) void {
        math.quaternionToAxisAngle(self, outAxis, outAngle);
    }

    /// Get the quaternion equivalent to Euler angles
    /// NOTE: Rotation order is ZYX
    pub fn fromEuler(pitch: f32, yaw: f32, roll: f32) Quaternion {
        return math.quaternionFromEuler(pitch, yaw, roll);
    }

    /// Get the Euler angles equivalent to quaternion (roll, pitch, yaw)
    /// NOTE: Angles are returned in a Vector3 struct in radians
    pub fn toEuler(self: Quaternion) Vector3 {
        return math.quaternionToEuler(self);
    }

    /// Transform a quaternion given a transformation matrix
    pub fn transform(self: Quaternion, mat: Matrix) Quaternion {
        return math.quaternionTransform(self, mat);
    }
};
pub const Quaternion = Vector4;

pub const Matrix = extern struct {
    m0: f32,
    m4: f32,
    m8: f32,
    m12: f32,
    m1: f32,
    m5: f32,
    m9: f32,
    m13: f32,
    m2: f32,
    m6: f32,
    m10: f32,
    m14: f32,
    m3: f32,
    m7: f32,
    m11: f32,
    m15: f32,

    /// Compute matrix determinant
    pub fn determinant(self: Matrix) f32 {
        return math.matrixDeterminant(self);
    }

    /// Get the trace of the matrix (sum of the values along the diagonal)
    pub fn trace(self: Matrix) f32 {
        return math.matrixTrace(self);
    }

    /// Transposes provided matrix
    pub fn transpose(self: Matrix) Matrix {
        return math.matrixTranspose(self);
    }

    /// Invert provided matrix
    pub fn invert(self: Matrix) Matrix {
        return math.matrixInvert(self);
    }

    /// Get identity matrix
    pub fn identity() Matrix {
        return math.matrixIdentity();
    }

    /// Add two matrices
    pub fn add(self: Matrix, right: Matrix) Matrix {
        return math.matrixAdd(self, right);
    }

    /// Subtract two matrices (left - right)
    pub fn subtract(self: Matrix, right: Matrix) Matrix {
        return math.matrixSubtract(self, right);
    }

    /// Get two matrix multiplication
    /// NOTE: When multiplying matrices... the order matters!
    pub fn multiply(self: Matrix, right: Matrix) Matrix {
        return math.matrixMultiply(self, right);
    }

    /// Get translation matrix
    pub fn translate(x: f32, y: f32, z: f32) Matrix {
        return math.matrixTranslate(x, y, z);
    }

    /// Create rotation matrix from axis and angle
    /// NOTE: Angle should be provided in radians
    pub fn rotate(axis: Vector3, angle: f32) Matrix {
        return math.matrixRotate(axis, angle);
    }

    /// Get x-rotation matrix
    /// NOTE: Angle must be provided in radians
    pub fn rotateX(angle: f32) Matrix {
        return math.matrixRotateX(angle);
    }

    /// Get y-rotation matrix
    /// NOTE: Angle must be provided in radians
    pub fn rotateY(angle: f32) Matrix {
        return math.matrixRotateY(angle);
    }

    /// Get z-rotation matrix
    /// NOTE: Angle must be provided in radians
    pub fn rotateZ(angle: f32) Matrix {
        return math.matrixRotateZ(angle);
    }

    /// Get xyz-rotation matrix
    /// NOTE: Angle must be provided in radians
    pub fn rotateXYZ(angle: Vector3) Matrix {
        return math.matrixRotateXYZ(angle);
    }

    /// Get zyx-rotation matrix
    /// NOTE: Angle must be provided in radians
    pub fn rotateZYX(angle: Vector3) Matrix {
        return math.matrixRotateZYX(angle);
    }

    /// Get scaling matrix
    pub fn scale(x: f32, y: f32, z: f32) Matrix {
        return math.matrixScale(x, y, z);
    }

    /// Get perspective projection matrix
    pub fn frustum(left: f64, right: f64, bottom: f64, top: f64, near: f64, far: f64) Matrix {
        return math.matrixFrustum(left, right, bottom, top, near, far);
    }

    /// Get perspective projection matrix
    /// NOTE: Fovy angle must be provided in radians
    pub fn perspective(fovY: f64, aspect: f64, nearPlane: f64, farPlane: f64) Matrix {
        return math.matrixPerspective(fovY, aspect, nearPlane, farPlane);
    }

    /// Get orthographic projection matrix
    pub fn ortho(left: f64, right: f64, bottom: f64, top: f64, nearPlane: f64, farPlane: f64) Matrix {
        return math.matrixOrtho(left, right, bottom, top, nearPlane, farPlane);
    }

    /// Get camera look-at matrix (view matrix)
    pub fn lookAt(eye: Vector3, target: Vector3, up: Vector3) Matrix {
        return math.matrixLookAt(eye, target, up);
    }

    /// Get float array of matrix data
    pub fn toFloatV(self: Matrix) math.float16 {
        return math.matrixToFloatV(self);
    }
};

pub const Color = extern struct {
    r: u8,
    g: u8,
    b: u8,
    a: u8,

    pub const light_gray = Color.init(200, 200, 200, 255);
    pub const gray = Color.init(130, 130, 130, 255);
    pub const dark_gray = Color.init(80, 80, 80, 255);
    pub const yellow = Color.init(253, 249, 0, 255);
    pub const gold = Color.init(255, 203, 0, 255);
    pub const orange = Color.init(255, 161, 0, 255);
    pub const pink = Color.init(255, 109, 194, 255);
    pub const red = Color.init(230, 41, 55, 255);
    pub const maroon = Color.init(190, 33, 55, 255);
    pub const green = Color.init(0, 228, 48, 255);
    pub const lime = Color.init(0, 158, 47, 255);
    pub const dark_green = Color.init(0, 117, 44, 255);
    pub const sky_blue = Color.init(102, 191, 255, 255);
    pub const blue = Color.init(0, 121, 241, 255);
    pub const dark_blue = Color.init(0, 82, 172, 255);
    pub const purple = Color.init(200, 122, 255, 255);
    pub const violet = Color.init(135, 60, 190, 255);
    pub const dark_purple = Color.init(112, 31, 126, 255);
    pub const beige = Color.init(211, 176, 131, 255);
    pub const brown = Color.init(127, 106, 79, 255);
    pub const dark_brown = Color.init(76, 63, 47, 255);

    pub const white = Color.init(255, 255, 255, 255);
    pub const black = Color.init(0, 0, 0, 255);
    pub const blank = Color.init(0, 0, 0, 0);
    pub const magenta = Color.init(255, 0, 255, 255);
    pub const ray_white = Color.init(245, 245, 245, 255);

    pub fn init(r: u8, g: u8, b: u8, a: u8) Color {
        return Color{ .r = r, .g = g, .b = b, .a = a };
    }

    /// Get Color from normalized values [0..1]
    pub fn fromNormalized(normalized: Vector4) Color {
        return rl.colorFromNormalized(normalized);
    }

    /// Get a Color from HSV values, hue [0..360], saturation/value [0..1]
    pub fn fromHSV(hue: f32, saturation: f32, value: f32) Color {
        return rl.colorFromHSV(hue, saturation, value);
    }

    /// Get a Color from hexadecimal value
    pub fn fromInt(hexValue: u32) Color {
        return rl.getColor(hexValue);
    }

    /// Get color with alpha applied, alpha goes from 0.0 to 1.0
    pub fn fade(self: Color, a: f32) Color {
        return rl.fade(self, a);
    }

    /// Get color multiplied with another color
    pub fn tint(self: Color, t: Color) Color {
        return rl.colorTint(self, t);
    }

    /// Get Color normalized as float [0..1]
    pub fn normalize(self: Color) Vector4 {
        return rl.colorNormalize(self);
    }

    /// Get color with brightness correction, brightness factor goes from -1.0 to 1.0
    pub fn brightness(self: Color, factor: f32) Color {
        return rl.colorBrightness(self, factor);
    }

    /// Get color with contrast correction, contrast values between -1.0 and 1.0
    pub fn contrast(self: Color, c: f32) Color {
        return rl.colorContrast(self, c);
    }

    /// Get color with alpha applied, alpha goes from 0.0 to 1.0
    pub fn alpha(self: Color, a: f32) Color {
        return rl.colorAlpha(self, a);
    }

    /// Get hexadecimal value for a Color
    pub fn toInt(self: Color) i32 {
        return rl.colorToInt(self);
    }

    /// Get HSV values for a Color, hue [0..360], saturation/value [0..1]
    pub fn toHSV(self: Color) Vector3 {
        return rl.colorToHSV(self);
    }
};

pub const Rectangle = extern struct {
    x: f32,
    y: f32,
    width: f32,
    height: f32,

    pub fn init(x: f32, y: f32, width: f32, height: f32) Rectangle {
        return Rectangle{ .x = x, .y = y, .width = width, .height = height };
    }

    /// Check collision between two rectangles
    pub fn checkCollision(self: Rectangle, rec2: Rectangle) bool {
        return rl.checkCollisionRecs(self, rec2);
    }

    /// Get collision rectangle for two rectangles collision
    pub fn getCollision(self: Rectangle, rec2: Rectangle) Rectangle {
        return rl.getCollisionRec(self, rec2);
    }
};

pub const Image = extern struct {
    data: *anyopaque,
    width: c_int,
    height: c_int,
    mipmaps: c_int,
    format: PixelFormat,

    /// Load image from file into CPU memory (RAM)
    pub fn init(fileName: [:0]const u8) RaylibError!Image {
        return rl.loadImage(fileName);
    }

    /// Load image from RAW file data
    pub fn initRaw(fileName: [:0]const u8, width: i32, height: i32, format: PixelFormat, headerSize: i32) RaylibError!Image {
        return rl.loadImageRaw(fileName, width, height, format, headerSize);
    }

    /// Load image sequence from file (frames appended to image.data)
    pub fn initAnim(fileName: [:0]const u8, frames: *i32) RaylibError!Image {
        return rl.loadImageAnim(fileName, frames);
    }

    /// Load image from GPU texture data
    pub fn fromTexture(texture: Texture) RaylibError!Image {
        return rl.loadImageFromTexture(texture);
    }

    /// Load image from screen buffer and (screenshot)
    pub fn fromScreen() RaylibError!Image {
        return rl.loadImageFromScreen();
    }

    /// Unload image from CPU memory (RAM)
    pub fn unload(self: Image) void {
        rl.unloadImage(self);
    }

    /// Create an image from text (default font)
    pub fn initText(text: [:0]const u8, fontSize: i32, color: Color) RaylibError!Image {
        return rl.imageText(text, fontSize, color);
    }

    /// Create an image from text (custom sprite font)
    pub fn initTextEx(font: Font, text: [:0]const u8, fontSize: f32, spacing: f32, t: Color) RaylibError!Image {
        return rl.imageTextEx(font, text, fontSize, spacing, t);
    }

    /// Generate image: plain color
    pub fn genColor(width: i32, height: i32, color: Color) Image {
        return rl.genImageColor(width, height, color);
    }

    /// Generate image: linear gradient, direction in degrees [0..360], 0=Vertical gradient
    pub fn genGradientLinear(width: i32, height: i32, direction: i32, start: Color, end: Color) Image {
        return rl.genImageGradientLinear(width, height, direction, start, end);
    }

    /// Generate image: radial gradient
    pub fn genGradientRadial(width: i32, height: i32, density: f32, inner: Color, outer: Color) Image {
        return rl.genImageGradientRadial(width, height, density, inner, outer);
    }

    /// Generate image: square gradient
    pub fn genGradientSquare(width: i32, height: i32, density: f32, inner: Color, outer: Color) Image {
        return rl.genImageGradientSquare(width, height, density, inner, outer);
    }

    /// Generate image: checked
    pub fn genChecked(width: i32, height: i32, checksX: i32, checksY: i32, col1: Color, col2: Color) Image {
        return rl.genImageChecked(width, height, checksX, checksY, col1, col2);
    }

    /// Generate image: white noise
    pub fn genWhiteNoise(width: i32, height: i32, factor: f32) Image {
        return rl.genImageWhiteNoise(width, height, factor);
    }

    /// Generate image: perlin noise
    pub fn genPerlinNoise(width: i32, height: i32, offsetX: i32, offsetY: i32, scale: f32) Image {
        return rl.genImagePerlinNoise(width, height, offsetX, offsetY, scale);
    }

    /// Generate image: cellular algorithm, bigger tileSize means bigger cells
    pub fn genCellular(width: i32, height: i32, tileSize: i32) Image {
        return rl.genImageCellular(width, height, tileSize);
    }

    /// Generate image: grayscale image from text data
    pub fn genText(width: i32, height: i32, text: [:0]const u8) Image {
        return rl.genImageText(width, height, text);
    }

    /// Create an image duplicate (useful for transformations)
    pub fn copy(self: Image) Image {
        return rl.imageCopy(self);
    }

    /// Create an image from another image piece
    pub fn copyRec(self: Image, rec: Rectangle) Image {
        return rl.imageFromImage(self, rec);
    }

    /// Convert image data to desired format
    pub fn setFormat(self: *Image, newFormat: PixelFormat) void {
        return rl.imageFormat(self, newFormat);
    }

    /// Convert image to POT (power-of-two)
    pub fn toPOT(self: *Image, fill: Color) void {
        rl.imageToPOT(self, fill);
    }

    /// Crop an image to a defined rectangle
    pub fn crop(self: *Image, c: Rectangle) void {
        rl.imageCrop(self, c);
    }

    /// Crop image depending on alpha value
    pub fn alphaCrop(self: *Image, threshold: f32) void {
        rl.imageAlphaCrop(self, threshold);
    }

    /// Clear alpha channel to desired color
    pub fn alphaClear(self: *Image, color: Color, threshold: f32) void {
        rl.imageAlphaClear(self, color, threshold);
    }

    /// Apply alpha mask to image
    pub fn alphaMask(self: *Image, am: Image) void {
        rl.imageAlphaMask(self, am);
    }

    /// Premultiply alpha channel
    pub fn alphaPremultiply(self: *Image) void {
        rl.imageAlphaPremultiply(self);
    }

    /// Apply Gaussian blur using a box blur approximation
    pub fn blurGaussian(self: *Image, blurSize: i32) void {
        rl.imageBlurGaussian(self, blurSize);
    }

    /// Resize image (Bicubic scaling algorithm)
    pub fn resize(self: *Image, newWidth: i32, newHeight: i32) void {
        rl.imageResize(self, newWidth, newHeight);
    }

    /// Resize image (Nearest-Neighbor scaling algorithm)
    pub fn resizeNN(self: *Image, newWidth: i32, newHeight: i32) void {
        rl.imageResizeNN(self, newWidth, newHeight);
    }

    /// Resize canvas and fill with color
    pub fn resizeCanvas(self: *Image, newWidth: i32, newHeight: i32, offsetX: i32, offsetY: i32, fill: Color) void {
        rl.imageResizeCanvas(self, newWidth, newHeight, offsetX, offsetY, fill);
    }

    /// Compute all mipmap levels for a provided image
    pub fn mimaps(self: *Image) void {
        rl.imageMipmaps(self);
    }

    /// Dither image data to 16bpp or lower (Floyd-Steinberg dithering)
    pub fn dither(self: *Image, rBpp: i32, gBpp: i32, bBpp: i32, aBpp: i32) void {
        rl.imageDither(self, rBpp, gBpp, bBpp, aBpp);
    }

    /// Flip image vertically
    pub fn flipVertical(self: *Image) void {
        rl.imageFlipVertical(self);
    }

    /// Flip image horizontally
    pub fn flipHorizontal(self: *Image) void {
        rl.imageFlipHorizontal(self);
    }

    /// Rotate image by input angle in degrees (-359 to 359)
    pub fn rotate(self: *Image, degrees: i32) void {
        rl.imageRotate(self, degrees);
    }

    /// Rotate image clockwise 90deg
    pub fn rotateCW(self: *Image) void {
        rl.imageRotateCW(self);
    }

    /// Rotate image counter-clockwise 90deg
    pub fn rotateCCW(self: *Image) void {
        rl.imageRotateCCW(self);
    }

    /// Modify image color: tint
    pub fn tint(self: *Image, color: Color) void {
        rl.imageColorTint(self, color);
    }

    /// Modify image color: invert
    pub fn invert(self: *Image) void {
        rl.imageColorInvert(self);
    }

    /// Modify image color: grayscale
    pub fn grayscale(self: *Image) void {
        rl.imageColorGrayscale(self);
    }

    /// Modify image color: contrast (-100 to 100)
    pub fn contrast(self: *Image, c: f32) void {
        rl.imageColorContrast(self, c);
    }

    /// Modify image color: brightness (-255 to 255)
    pub fn brightness(self: *Image, b: i32) void {
        rl.imageColorBrightness(self, b);
    }

    /// Modify image color: replace color
    pub fn replaceColor(self: *Image, color: Color, replace: Color) void {
        rl.imageColorReplace(self, color, replace);
    }

    /// Get image alpha border rectangle
    pub fn getAlphaBorder(self: Image, threshold: f32) Rectangle {
        return rl.getImageAlphaBorder(self, threshold);
    }

    /// Get image pixel color at (x, y) position
    pub fn getColor(self: Image, x: i32, y: i32) Color {
        return rl.getImageColor(self, x, y);
    }

    /// Clear image background with given color
    pub fn clearBackground(self: *Image, color: Color) void {
        rl.imageClearBackground(self, color);
    }

    /// Draw pixel within an image
    pub fn drawPixel(self: *Image, posX: i32, posY: i32, color: Color) void {
        rl.imageDrawPixel(self, posX, posY, color);
    }

    /// Draw pixel within an image (Vector version)
    pub fn drawPixelV(self: *Image, position: Vector2, color: Color) void {
        rl.imageDrawPixelV(self, position, color);
    }

    /// Draw line within an image
    pub fn drawLine(self: *Image, startPosX: i32, startPosY: i32, endPosX: i32, endPosY: i32, color: Color) void {
        rl.imageDrawLine(self, startPosX, startPosY, endPosX, endPosY, color);
    }

    /// Draw line within an image (Vector version)
    pub fn drawLineV(self: *Image, start: Vector2, end: Vector2, color: Color) void {
        rl.imageDrawLineV(self, start, end, color);
    }

    /// Draw a filled circle within an image
    pub fn drawCircle(self: *Image, centerX: i32, centerY: i32, radius: i32, color: Color) void {
        rl.imageDrawCircle(self, centerX, centerY, radius, color);
    }

    /// Draw a filled circle within an image (Vector version)
    pub fn drawCircleV(self: *Image, center: Vector2, radius: i32, color: Color) void {
        rl.imageDrawCircleV(self, center, radius, color);
    }

    /// Draw circle outline within an image
    pub fn drawCircleLines(self: *Image, centerX: i32, centerY: i32, radius: i32, color: Color) void {
        rl.imageDrawCircleLines(self, centerX, centerY, radius, color);
    }

    /// Draw circle outline within an image (Vector version)
    pub fn drawCircleLinesV(self: *Image, center: Vector2, radius: i32, color: Color) void {
        rl.imageDrawCircleLinesV(self, center, radius, color);
    }

    /// Draw rectangle within an image
    pub fn drawRectangle(self: *Image, posX: i32, posY: i32, width: i32, height: i32, color: Color) void {
        rl.imageDrawRectangle(self, posX, posY, width, height, color);
    }

    /// Draw rectangle within an image (Vector version)
    pub fn drawRectangleV(self: *Image, position: Vector2, size: Vector2, color: Color) void {
        rl.imageDrawRectangleV(self, position, size, color);
    }

    /// Draw rectangle within an image
    pub fn drawRectangleRec(self: *Image, rec: Rectangle, color: Color) void {
        rl.imageDrawRectangleRec(self, rec, color);
    }

    /// Draw rectangle lines within an image
    pub fn drawRectangleLines(self: *Image, rec: Rectangle, thick: i32, color: Color) void {
        rl.imageDrawRectangleLines(self, rec, thick, color);
    }

    /// Draw a source image within a destination image (tint applied to source)
    pub fn drawImage(self: *Image, src: Image, srcRec: Rectangle, dstRec: Rectangle, t: Color) void {
        rl.imageDraw(self, src, srcRec, dstRec, t);
    }

    /// Draw text (using default font) within an image (destination)
    pub fn drawText(self: *Image, text: [:0]const u8, posX: i32, posY: i32, fontSize: i32, color: Color) void {
        rl.imageDrawText(self, text, posX, posY, fontSize, color);
    }

    /// Draw text (custom sprite font) within an image (destination)
    pub fn drawTextEx(self: *Image, font: Font, text: [:0]const u8, position: Vector2, fontSize: f32, spacing: f32, t: Color) void {
        rl.imageDrawTextEx(self, font, text, position, fontSize, spacing, t);
    }

    /// Export image data to file, returns true on success
    pub fn exportToFile(self: Image, fileName: [:0]const u8) bool {
        return rl.exportImage(self, fileName);
    }

    /// Export image as code file defining an array of bytes, returns true on success
    pub fn exportAsCode(self: Image, fileName: [:0]const u8) bool {
        return rl.exportImageAsCode(self, fileName);
    }

    /// Set icon for window (single image, RGBA 32bit, only PLATFORM_DESKTOP)
    pub fn useAsWindowIcon(self: Image) void {
        rl.setWindowIcon(self);
    }

    /// Load texture from image data
    pub fn toTexture(self: Image) RaylibError!Texture {
        return Texture.fromImage(self);
    }

    pub fn asCubemap(self: Image, layout: CubemapLayout) RaylibError!Texture {
        return Texture.fromCubemap(self, layout);
    }
};

pub const Texture = extern struct {
    id: c_uint,
    width: c_int,
    height: c_int,
    mipmaps: c_int,
    format: PixelFormat,

    pub fn init(fileName: [:0]const u8) RaylibError!Texture {
        return rl.loadTexture(fileName);
    }

    /// Load texture from image data
    pub fn fromImage(image: Image) RaylibError!Texture {
        return rl.loadTextureFromImage(image);
    }

    /// Load cubemap from image, multiple image cubemap layouts supported
    pub fn fromCubemap(image: Image, layout: CubemapLayout) RaylibError!Texture {
        return rl.loadTextureCubemap(image, layout);
    }

    /// Unload texture from GPU memory (VRAM)
    pub fn unload(self: Texture) void {
        rl.unloadTexture(self);
    }

    /// Draw a Texture2D
    pub fn draw(self: Texture, posX: i32, posY: i32, tint: Color) void {
        rl.drawTexture(self, posX, posY, tint);
    }

    /// Draw a Texture2D with position defined as Vector2
    pub fn drawV(self: Texture, position: Vector2, tint: Color) void {
        rl.drawTextureV(self, position, tint);
    }

    /// Draw a Texture2D with extended parameters
    pub fn drawEx(self: Texture, position: Vector2, rotation: f32, scale: f32, tint: Color) void {
        rl.drawTextureEx(self, position, rotation, scale, tint);
    }

    /// Draw a part of a texture defined by a rectangle
    pub fn drawRec(self: Texture, source: Rectangle, position: Vector2, tint: Color) void {
        rl.drawTextureRec(self, source, position, tint);
    }

    /// Draw a part of a texture defined by a rectangle with 'pro' parameters
    pub fn drawPro(self: Texture, source: Rectangle, dest: Rectangle, origin: Vector2, rotation: f32, tint: Color) void {
        rl.drawTexturePro(self, source, dest, origin, rotation, tint);
    }

    /// Draws a texture (or part of it) that stretches or shrinks nicely
    pub fn drawNPatch(self: Texture, nPatchInfo: NPatchInfo, dest: Rectangle, origin: Vector2, rotation: f32, tint: Color) void {
        rl.drawTextureNPatch(self, nPatchInfo, dest, origin, rotation, tint);
    }
};
pub const Texture2D = Texture;
pub const TextureCubemap = Texture;

pub const RenderTexture = extern struct {
    id: c_uint,
    texture: Texture,
    depth: Texture,

    pub fn init(width: i32, height: i32) RaylibError!RenderTexture {
        return rl.loadRenderTexture(width, height);
    }

    /// Unload render texture from GPU memory (VRAM)
    pub fn unload(self: RenderTexture) void {
        rl.unloadRenderTexture(self);
    }

    /// Begin drawing to render texture
    pub fn begin(self: RenderTexture2D) void {
        rl.beginTextureMode(self);
    }

    /// Ends drawing to render texture
    pub fn end(_: RenderTexture2D) void {
        rl.endTextureMode();
    }
};
pub const RenderTexture2D = RenderTexture;

pub const NPatchInfo = extern struct {
    source: Rectangle,
    left: c_int,
    top: c_int,
    right: c_int,
    bottom: c_int,
    layout: NPatchType,
};

pub const GlyphInfo = extern struct {
    value: c_int,
    offsetX: c_int,
    offsetY: c_int,
    advanceX: c_int,
    image: Image,
};

pub const Font = extern struct {
    baseSize: c_int,
    glyphCount: c_int,
    glyphPadding: c_int,
    texture: Texture2D,
    recs: [*c]Rectangle,
    glyphs: [*c]GlyphInfo,

    /// Load font from file into GPU memory (VRAM)
    pub fn init(fileName: [:0]const u8) RaylibError!Font {
        return rl.loadFont(fileName);
    }

    /// Load font from file with extended parameters, use null for fontChars to load the default character set
    pub fn initEx(fileName: [:0]const u8, fontSize: i32, fontChars: ?[]i32) RaylibError!Font {
        return rl.loadFontEx(fileName, fontSize, fontChars);
    }

    /// Load font from Image (XNA style)
    pub fn fromImage(image: Image, key: Color, firstChar: i32) RaylibError!Font {
        return rl.loadFontFromImage(image, key, firstChar);
    }

    /// Load font from memory buffer, fileType refers to extension: i.e. '.ttf'
    pub fn fromMemory(fileType: [:0]const u8, fileData: ?[]const u8, fontSize: i32, fontChars: ?[]i32) RaylibError!Font {
        return rl.loadFontFromMemory(fileType, fileData, fontSize, fontChars);
    }

    /// Unload font from GPU memory (VRAM)
    pub fn unload(self: Font) void {
        rl.unloadFont(self);
    }

    /// Check if a font is ready
    pub fn isReady(self: Font) bool {
        return rl.isFontValid(self);
    }

    /// Export font as code file, returns true on success
    pub fn exportAsCode(self: Font, fileName: [:0]const u8) bool {
        return rl.exportFontAsCode(self, fileName);
    }
};

pub const Camera3D = extern struct {
    position: Vector3,
    target: Vector3,
    up: Vector3,
    fovy: f32,
    projection: CameraProjection,

    /// Begin 3D mode with camera
    pub fn begin(self: Camera3D) void {
        rl.beginMode3D(self);
    }

    /// Update camera position for selected mode
    pub fn update(self: *Camera3D, mode: CameraMode) void {
        rl.updateCamera(self, mode);
    }

    /// Get camera transform matrix (view matrix)
    pub fn getMatrix(self: Camera3D) Matrix {
        return rl.getCameraMatrix(self);
    }

    /// Ends 3D mode and returns to default 2D orthographic mode
    pub fn end(_: Camera3D) void {
        rl.endMode3D();
    }
};
pub const Camera = Camera3D;

pub const Camera2D = extern struct {
    offset: Vector2,
    target: Vector2,
    rotation: f32,
    zoom: f32,

    /// Begin 2D mode with camera
    pub fn begin(self: Camera2D) void {
        rl.beginMode2D(self);
    }

    /// Get camera 2d transform matrix
    pub fn getMatrix(self: Camera2D) Matrix {
        return rl.getCameraMatrix2D(self);
    }

    /// Ends 2D mode with camera
    pub fn end(_: Camera2D) void {
        rl.endMode2D();
    }
};

pub const Mesh = extern struct {
    vertexCount: c_int,
    triangleCount: c_int,
    vertices: [*c]f32,
    texcoords: [*c]f32,
    texcoords2: [*c]f32,
    normals: [*c]f32,
    tangents: [*c]f32,
    colors: [*c]u8,
    indices: [*c]c_ushort,
    animVertices: [*c]f32,
    animNormals: [*c]f32,
    boneIds: [*c]u8,
    boneWeights: [*c]f32,
    boneMatrices: [*c]Matrix,
    boneCount: c_int,
    vaoId: c_int,
    vboId: [*c]c_int,

    /// Draw a 3d mesh with material and transform
    pub fn draw(self: Mesh, material: Material, transform: Matrix) void {
        rl.drawMesh(self, material, transform);
    }

    /// Draw multiple mesh instances with material and different transforms
    pub fn drawInstanced(self: Mesh, material: Material, transforms: []const Matrix) void {
        rl.drawMeshInstanced(self, material, transforms);
    }

    /// Unload mesh data from CPU and GPU
    pub fn unload(self: Mesh) void {
        rl.unloadMesh(self);
    }
};

pub const Shader = extern struct {
    id: c_uint,
    locs: [*c]c_int,

    /// Begin custom shader drawing
    pub fn activate(self: Shader) void {
        rl.beginShaderMode(self);
    }

    /// End custom shader drawing (use default shader)
    pub fn deactivate(_: Shader) void {
        rl.endShaderMode();
    }

    /// Unload shader from GPU memory (VRAM)
    pub fn unload(self: Shader) void {
        rl.unloadShader(self);
    }
};

pub const MaterialMap = extern struct {
    texture: Texture2D,
    color: Color,
    value: f32,
};

pub const Material = extern struct {
    shader: Shader,
    maps: [*c]MaterialMap,
    params: [4]f32,

    /// Unload material from GPU memory (VRAM)
    pub fn unload(self: Material) void {
        rl.unloadMaterial(self);
    }
};

pub const Transform = extern struct {
    translation: Vector3,
    rotation: Quaternion,
    scale: Vector3,
};

pub const BoneInfo = extern struct {
    name: [32]u8,
    parent: c_int,
};

pub const Model = extern struct {
    transform: Matrix,
    meshCount: c_int,
    materialCount: c_int,
    meshes: [*c]Mesh,
    materials: [*c]Material,
    meshMaterial: [*c]c_int,
    boneCount: c_int,
    bones: [*c]BoneInfo,
    bindPose: [*c]Transform,

    /// Load model from file (meshes and materials)
    pub fn init(fileName: [:0]const u8) RaylibError!Model {
        return rl.loadModel(fileName);
    }

    /// Load model from generated mesh (default material)
    pub fn fromMesh(mesh: Mesh) RaylibError!Model {
        return rl.loadModelFromMesh(mesh);
    }

    /// Unload model (including meshes) from memory (RAM and/or VRAM)
    pub fn unload(self: Model) void {
        rl.unloadModel(self);
    }

    /// Draw a model (with texture if set)
    pub fn draw(self: Model, position: Vector3, scale: f32, tint: Color) void {
        return rl.drawModel(self, position, scale, tint);
    }

    /// Draw a model with extended parameters
    pub fn drawEx(self: Model, position: Vector3, rotationAxis: Vector3, rotationAngle: f32, scale: Vector3, tint: Color) void {
        return rl.drawModelEx(self, position, rotationAxis, rotationAngle, scale, tint);
    }

    /// Draw a model wires (with texture if set)
    pub fn drawWires(self: Model, position: Vector3, scale: f32, tint: Color) void {
        return rl.drawModelWires(self, position, scale, tint);
    }

    /// Draw a model wires (with texture if set) with extended parameters
    pub fn drawWiresEx(self: Model, position: Vector3, rotationAxis: Vector3, rotationAngle: f32, scale: Vector3, tint: Color) void {
        return rl.drawModelWiresEx(self, position, rotationAxis, rotationAngle, scale, tint);
    }
};

pub const ModelAnimation = extern struct {
    boneCount: c_int,
    frameCount: c_int,
    bones: [*c]BoneInfo,
    framePoses: [*c][*c]Transform,
    name: [32]u8,

    /// Unload animation data
    pub fn unload(self: ModelAnimation) void {
        rl.unloadModelAnimation(self);
    }
};

pub const Ray = extern struct {
    position: Vector3,
    direction: Vector3,
};

pub const RayCollision = extern struct {
    hit: bool,
    distance: f32,
    point: Vector3,
    normal: Vector3,
};

pub const BoundingBox = extern struct {
    min: Vector3,
    max: Vector3,
};

pub const Wave = extern struct {
    frameCount: c_uint,
    sampleRate: c_uint,
    sampleSize: c_uint,
    channels: c_uint,
    data: *anyopaque,

    /// Unload wave data
    pub fn unload(self: Wave) void {
        rl.unloadWave(self);
    }
};

pub const rAudioBuffer = opaque {};
pub const rAudioProcessor = opaque {};

pub const AudioStream = extern struct {
    buffer: *rAudioBuffer,
    processor: *rAudioProcessor,
    sampleRate: c_uint,
    sampleSize: c_uint,
    channels: c_uint,

    /// Unload audio stream and free memory
    pub fn unload(self: AudioStream) void {
        rl.unloadAudioStream(self);
    }
};

pub const Sound = extern struct {
    stream: AudioStream,
    frameCount: c_uint,

    /// Unload sound
    pub fn unload(self: Sound) void {
        rl.unloadSound(self);
    }
};

pub const Music = extern struct {
    stream: AudioStream,
    frameCount: c_uint,
    looping: bool,
    ctxType: c_int,
    ctxData: *anyopaque,

    /// Unload music stream
    pub fn unload(self: Music) void {
        rl.unloadMusicStream(self);
    }
};

pub const VrDeviceInfo = extern struct {
    hResolution: c_int,
    vResolution: c_int,
    hScreenSize: f32,
    vScreenSize: f32,
    vScreenCenter: f32,
    eyeToScreenDistance: f32,
    lensSeparationDistance: f32,
    interpupillaryDistance: f32,
    lensDistortionValues: [4]f32,
    chromaAbCorrection: [4]f32,
};

pub const VrStereoConfig = extern struct {
    projection: [2]Matrix,
    viewOffset: [2]Matrix,
    leftLensCenter: [2]f32,
    rightLensCenter: [2]f32,
    leftScreenCenter: [2]f32,
    rightScreenCenter: [2]f32,
    scale: [2]f32,
    scaleIn: [2]f32,

    /// Unload VR stereo config
    pub fn unload(self: VrStereoConfig) void {
        rl.unloadVrStereoConfig(self);
    }
};

pub const FilePathList = extern struct {
    capacity: c_uint,
    count: c_uint,
    paths: [*c][*c]u8,
};

pub const AutomationEvent = extern struct {
    frame: c_uint,
    type: c_uint,
    params: [4]c_int,
};

pub const AutomationEventList = extern struct {
    capacity: c_uint,
    count: c_uint,
    events: [*c]AutomationEvent,

    /// Unload automation events list from file
    pub fn unload(self: AutomationEventList) void {
        rl.unloadAutomationEventList(self);
    }
};

pub const ConfigFlags = packed struct {
    __reserved: bool = false,
    fullscreen_mode: bool = false,
    window_resizable: bool = false,
    window_undecorated: bool = false,
    window_transparent: bool = false,
    msaa_4x_hint: bool = false,
    vsync_hint: bool = false,
    window_hidden: bool = false,
    window_always_run: bool = false,
    window_minimized: bool = false,
    window_maximized: bool = false,
    window_unfocused: bool = false,
    window_topmost: bool = false,
    window_highdpi: bool = false,
    window_mouse_passthrough: bool = false,
    borderless_windowed_mode: bool = false,
    interlaced_hint: bool = false,
    __reserved2: bool = false,
    __reserved3: bool = false,
    __reserved4: bool = false,
    __reserved5: bool = false,
    __reserved6: bool = false,
    __reserved7: bool = false,
    __reserved8: bool = false,
    __reserved9: bool = false,
    __reserved10: bool = false,
    __reserved11: bool = false,
    __reserved12: bool = false,
    __reserved13: bool = false,
    __reserved14: bool = false,
    __reserved15: bool = false,
    __reserved16: bool = false,
};

pub const TraceLogLevel = enum(c_int) {
    all = 0,
    trace = 1,
    debug = 2,
    info = 3,
    warning = 4,
    err = 5,
    fatal = 6,
    none = 7,
};

pub const KeyboardKey = enum(c_int) {
    null = 0,
    apostrophe = 39,
    comma = 44,
    minus = 45,
    period = 46,
    slash = 47,
    zero = 48,
    one = 49,
    two = 50,
    three = 51,
    four = 52,
    five = 53,
    six = 54,
    seven = 55,
    eight = 56,
    nine = 57,
    semicolon = 59,
    equal = 61,
    a = 65,
    b = 66,
    c = 67,
    d = 68,
    e = 69,
    f = 70,
    g = 71,
    h = 72,
    i = 73,
    j = 74,
    k = 75,
    l = 76,
    m = 77,
    n = 78,
    o = 79,
    p = 80,
    q = 81,
    r = 82,
    s = 83,
    t = 84,
    u = 85,
    v = 86,
    w = 87,
    x = 88,
    y = 89,
    z = 90,
    space = 32,
    escape = 256,
    enter = 257,
    tab = 258,
    backspace = 259,
    insert = 260,
    delete = 261,
    right = 262,
    left = 263,
    down = 264,
    up = 265,
    page_up = 266,
    page_down = 267,
    home = 268,
    end = 269,
    caps_lock = 280,
    scroll_lock = 281,
    num_lock = 282,
    print_screen = 283,
    pause = 284,
    f1 = 290,
    f2 = 291,
    f3 = 292,
    f4 = 293,
    f5 = 294,
    f6 = 295,
    f7 = 296,
    f8 = 297,
    f9 = 298,
    f10 = 299,
    f11 = 300,
    f12 = 301,
    left_shift = 340,
    left_control = 341,
    left_alt = 342,
    left_super = 343,
    right_shift = 344,
    right_control = 345,
    right_alt = 346,
    right_super = 347,
    kb_menu = 348,
    left_bracket = 91,
    backslash = 92,
    right_bracket = 93,
    grave = 96,
    kp_0 = 320,
    kp_1 = 321,
    kp_2 = 322,
    kp_3 = 323,
    kp_4 = 324,
    kp_5 = 325,
    kp_6 = 326,
    kp_7 = 327,
    kp_8 = 328,
    kp_9 = 329,
    kp_decimal = 330,
    kp_divide = 331,
    kp_multiply = 332,
    kp_subtract = 333,
    kp_add = 334,
    kp_enter = 335,
    kp_equal = 336,
    back = 4,
    //menu = 82,
    volume_up = 24,
    volume_down = 25,
};

pub const MouseButton = enum(c_int) {
    left = 0,
    right = 1,
    middle = 2,
    side = 3,
    extra = 4,
    forward = 5,
    back = 6,
};

pub const MouseCursor = enum(c_int) {
    default = 0,
    arrow = 1,
    ibeam = 2,
    crosshair = 3,
    pointing_hand = 4,
    resize_ew = 5,
    resize_ns = 6,
    resize_nwse = 7,
    resize_nesw = 8,
    resize_all = 9,
    not_allowed = 10,
};

pub const GamepadButton = enum(c_int) {
    unknown = 0,
    left_face_up = 1,
    left_face_right = 2,
    left_face_down = 3,
    left_face_left = 4,
    right_face_up = 5,
    right_face_right = 6,
    right_face_down = 7,
    right_face_left = 8,
    left_trigger_1 = 9,
    left_trigger_2 = 10,
    right_trigger_1 = 11,
    right_trigger_2 = 12,
    middle_left = 13,
    middle = 14,
    middle_right = 15,
    left_thumb = 16,
    right_thumb = 17,
};

pub const GamepadAxis = enum(c_int) {
    left_x = 0,
    left_y = 1,
    right_x = 2,
    right_y = 3,
    left_trigger = 4,
    right_trigger = 5,
};

pub const MaterialMapIndex = enum(c_int) {
    albedo = 0,
    metalness = 1,
    normal = 2,
    roughness = 3,
    occlusion = 4,
    emission = 5,
    height = 6,
    cubemap = 7,
    irradiance = 8,
    prefilter = 9,
    brdf = 10,
};

pub const ShaderLocationIndex = enum(c_int) {
    vertex_position = 0,
    vertex_texcoord01 = 1,
    vertex_texcoord02 = 2,
    vertex_normal = 3,
    vertex_tangent = 4,
    vertex_color = 5,
    matrix_mvp = 6,
    matrix_view = 7,
    matrix_projection = 8,
    matrix_model = 9,
    matrix_normal = 10,
    vector_view = 11,
    color_diffuse = 12,
    color_specular = 13,
    color_ambient = 14,
    map_albedo = 15,
    map_metalness = 16,
    map_normal = 17,
    map_roughness = 18,
    map_occlusion = 19,
    map_emission = 20,
    map_height = 21,
    map_cubemap = 22,
    map_irradiance = 23,
    map_prefilter = 24,
    map_brdf = 25,
    vertex_boneids = 26,
    vertex_boneweights = 27,
    bone_matrices = 28,
    shader_loc_vertex_instance_tx = 29,
    //
};

pub const ShaderUniformDataType = enum(c_int) {
    float = 0,
    vec2 = 1,
    vec3 = 2,
    vec4 = 3,
    int = 4,
    ivec2 = 5,
    ivec3 = 6,
    ivec4 = 7,
    sampler2d = 8,
};

pub const ShaderAttribute = enum(c_int) {
    float = 0,
    vec2 = 1,
    vec3 = 2,
    vec4 = 3,
};

pub const PixelFormat = enum(c_int) {
    uncompressed_grayscale = 1,
    uncompressed_gray_alpha = 2,
    uncompressed_r5g6b5 = 3,
    uncompressed_r8g8b8 = 4,
    uncompressed_r5g5b5a1 = 5,
    uncompressed_r4g4b4a4 = 6,
    uncompressed_r8g8b8a8 = 7,
    uncompressed_r32 = 8,
    uncompressed_r32g32b32 = 9,
    uncompressed_r32g32b32a32 = 10,
    uncompressed_r16 = 11,
    uncompressed_r16g16b16 = 12,
    uncompressed_r16g16b16a16 = 13,
    compressed_dxt1_rgb = 14,
    compressed_dxt1_rgba = 15,
    compressed_dxt3_rgba = 16,
    compressed_dxt5_rgba = 17,
    compressed_etc1_rgb = 18,
    compressed_etc2_rgb = 19,
    compressed_etc2_eac_rgba = 20,
    compressed_pvrt_rgb = 21,
    compressed_pvrt_rgba = 22,
    compressed_astc_4x4_rgba = 23,
    compressed_astc_8x8_rgba = 24,
};

pub const TextureFilter = enum(c_int) {
    point = 0,
    bilinear = 1,
    trilinear = 2,
    anisotropic_4x = 3,
    anisotropic_8x = 4,
    anisotropic_16x = 5,
};

pub const TextureWrap = enum(c_int) {
    repeat = 0,
    clamp = 1,
    mirror_repeat = 2,
    mirror_clamp = 3,
};

pub const CubemapLayout = enum(c_int) {
    auto_detect = 0,
    line_vertical = 1,
    line_horizontal = 2,
    cross_three_by_four = 3,
    cross_four_by_three = 4,
};

pub const FontType = enum(c_int) {
    default = 0,
    bitmap = 1,
    sdf = 2,
};

pub const BlendMode = enum(c_int) {
    alpha = 0,
    additive = 1,
    multiplied = 2,
    add_colors = 3,
    subtract_colors = 4,
    alpha_premultiply = 5,
    custom = 6,
    custom_separate = 7,
};

pub const Gesture = packed struct {
    tap: bool = false,
    doubletap: bool = false,
    hold: bool = false,
    drag: bool = false,
    swipe_right: bool = false,
    swipe_left: bool = false,
    swipe_up: bool = false,
    swipe_down: bool = false,
    pinch_in: bool = false,
    pinch_out: bool = false,
    __reserved1: bool = false,
    __reserved2: bool = false,
    __reserved3: bool = false,
    __reserved4: bool = false,
    __reserved5: bool = false,
    __reserved6: bool = false,
};

pub const CameraMode = enum(c_int) {
    custom = 0,
    free = 1,
    orbital = 2,
    first_person = 3,
    third_person = 4,
};

pub const CameraProjection = enum(c_int) {
    perspective = 0,
    orthographic = 1,
};

pub const NPatchType = enum(c_int) {
    nine_patch = 0,
    three_patch_vertical = 1,
    three_patch_horizontal = 2,
};

// pub const TraceLogCallback = ?fn (c_int, [*c]const u8, [*c]struct___va_list_tag) callconv(C) void;
pub const LoadFileDataCallback = *const fn ([*c]const u8, [*c]c_uint) callconv(C) [*c]u8;
pub const SaveFileDataCallback = *const fn ([*c]const u8, ?*anyopaque, c_uint) callconv(C) bool;
pub const LoadFileTextCallback = *const fn ([*c]const u8) callconv(C) [*c]u8;
pub const SaveFileTextCallback = *const fn ([*c]const u8, [*c]u8) callconv(C) bool;
pub const AudioCallback = ?*const fn (?*anyopaque, c_uint) callconv(C) void;

pub const RAYLIB_VERSION_MAJOR = @as(i32, 5);
pub const RAYLIB_VERSION_MINOR = @as(i32, 5);
pub const RAYLIB_VERSION_PATCH = @as(i32, 0);
pub const RAYLIB_VERSION = "5.6-dev";

pub const MAX_TOUCH_POINTS = 10;
pub const MAX_MATERIAL_MAPS = 12;
pub const MAX_SHADER_LOCATIONS = 32;

pub const MATERIAL_MAP_DIFFUSE = MaterialMapIndex.albedo;
pub const MATERIAL_MAP_SPECULAR = MaterialMapIndex.metalness;
pub const SHADER_LOC_MAP_DIFFUSE = ShaderLocationIndex.map_albedo;
pub const SHADER_LOC_MAP_SPECULAR = ShaderLocationIndex.map_metalness;

/// Set icon for window (multiple images, RGBA 32bit, only PLATFORM_DESKTOP)
pub fn setWindowIcons(images: []Image) void {
    cdef.SetWindowIcons(@as([*c]Image, @ptrCast(images)), @as(c_int, @intCast(images.len)));
}

/// Load shader from files and bind default locations
pub fn loadShader(vsFileName: ?[:0]const u8, fsFileName: ?[:0]const u8) RaylibError!Shader {
    var vsFileNameFinal = @as([*c]const u8, 0);
    var fsFileNameFinal = @as([*c]const u8, 0);
    if (vsFileName) |vsFileNameSure| {
        vsFileNameFinal = @as([*c]const u8, @ptrCast(vsFileNameSure));
    }
    if (fsFileName) |fsFileNameSure| {
        fsFileNameFinal = @as([*c]const u8, @ptrCast(fsFileNameSure));
    }
    const shader = cdef.LoadShader(vsFileNameFinal, fsFileNameFinal);
    const isValid = cdef.IsShaderValid(shader);
    return if (isValid) shader else RaylibError.LoadShader;
}

/// Load shader from code strings and bind default locations
pub fn loadShaderFromMemory(vsCode: ?[:0]const u8, fsCode: ?[:0]const u8) RaylibError!Shader {
    var vsCodeFinal = @as([*c]const u8, 0);
    var fsCodeFinal = @as([*c]const u8, 0);
    if (vsCode) |vsCodeSure| {
        vsCodeFinal = @as([*c]const u8, @ptrCast(vsCodeSure));
    }
    if (fsCode) |fsCodeSure| {
        fsCodeFinal = @as([*c]const u8, @ptrCast(fsCodeSure));
    }
    const shader = cdef.LoadShaderFromMemory(vsCodeFinal, fsCodeFinal);
    const isValid = cdef.IsShaderValid(shader);
    return if (isValid) shader else RaylibError.LoadShader;
}

pub fn loadRandomSequence(count: u32, min: i32, max: i32) []i32 {
    var res: []i32 = undefined;

    const ptr = cdef.LoadRandomSequence(@as(c_uint, @intCast(count)), @as(c_int, @intCast(min)), @as(c_int, @intCast(max)));

    res.ptr = @as([*]i32, @ptrCast(ptr));
    res.len = @as(usize, @intCast(count));
    return res;
}

/// Save data to file from byte array (write), returns true on success
pub fn saveFileData(fileName: [:0]const u8, data: []u8) bool {
    return cdef.SaveFileData(@as([*c]const u8, @ptrCast(fileName)), @as(*anyopaque, @ptrCast(data.ptr)), @as(c_int, @intCast(data.len)));
}

/// Export data to code (.h), returns true on success
pub fn exportDataAsCode(data: []const u8, fileName: [:0]const u8) bool {
    return cdef.ExportDataAsCode(@as([*c]const u8, @ptrCast(data)), @as(c_int, @intCast(data.len)), @as([*c]const u8, @ptrCast(fileName)));
}

pub fn computeCRC32(data: []u8) u32 {
    return cdef.ComputeCRC32(@as([*c]u8, @ptrCast(data)), @as(c_int, @intCast(data.len)));
}

pub fn computeMD5(data: []u8) [4]u32 {
    const res: [*]c_uint = cdef.ComputeMD5(@as([*c]u8, @ptrCast(data)), @as(c_int, @intCast(data.len)));
    return res[0..4].*;
}

pub fn computeSHA1(data: []u8) [5]u32 {
    const res: [*]c_uint = cdef.ComputeSHA1(@as([*c]u8, @ptrCast(data)), @as(c_int, @intCast(data.len)));
    return res[0..5].*;
}

/// Load image from file into CPU memory (RAM)
pub fn loadImage(fileName: [:0]const u8) RaylibError!Image {
    const image = cdef.LoadImage(@as([*c]const u8, @ptrCast(fileName)));
    const isValid = cdef.IsImageValid(image);
    return if (isValid) image else RaylibError.LoadImage;
}

/// Load image from RAW file data
pub fn loadImageRaw(fileName: [:0]const u8, width: i32, height: i32, format: PixelFormat, headerSize: i32) RaylibError!Image {
    const image = cdef.LoadImageRaw(@as([*c]const u8, @ptrCast(fileName)), @as(c_int, width), @as(c_int, height), format, @as(c_int, headerSize));
    const isValid = cdef.IsImageValid(image);
    return if (isValid) image else RaylibError.LoadImage;
}

/// Load image sequence from file (frames appended to image.data)
pub fn loadImageAnim(fileName: [:0]const u8, frames: *i32) RaylibError!Image {
    const image = cdef.LoadImageAnim(@as([*c]const u8, @ptrCast(fileName)), @as([*c]c_int, @ptrCast(frames)));
    const isValid = cdef.IsImageValid(image);
    return if (isValid) image else RaylibError.LoadImage;
}

/// Load image from GPU texture data
pub fn loadImageFromTexture(texture: Texture2D) RaylibError!Image {
    const image = cdef.LoadImageFromTexture(texture);
    const isValid = cdef.IsImageValid(image);
    return if (isValid) image else RaylibError.LoadImage;
}

/// Load image from screen buffer and (screenshot)
pub fn loadImageFromScreen() RaylibError!Image {
    const image = cdef.LoadImageFromScreen();
    const isValid = cdef.IsImageValid(image);
    return if (isValid) image else RaylibError.LoadImage;
}

pub fn loadImageAnimFromMemory(fileType: [:0]const u8, fileData: []const u8, frames: *i32) RaylibError!Image {
    const image = cdef.LoadImageAnimFromMemory(@as([*c]const u8, @ptrCast(fileType)), @as([*c]const u8, @ptrCast(fileData)), @as(c_int, @intCast(fileData.len)), @as([*c]c_int, @ptrCast(frames)));
    const isValid = cdef.IsImageValid(image);
    return if (isValid) image else RaylibError.LoadImage;
}

/// Load image from memory buffer, fileType refers to extension: i.e. '.png'
pub fn loadImageFromMemory(fileType: [:0]const u8, fileData: []const u8) RaylibError!Image {
    const image = cdef.LoadImageFromMemory(@as([*c]const u8, @ptrCast(fileType)), @as([*c]const u8, @ptrCast(fileData)), @as(c_int, @intCast(fileData.len)));
    const isValid = cdef.IsImageValid(image);
    return if (isValid) image else RaylibError.LoadImage;
}

/// Create an image from text (default font)
pub fn imageText(text: [:0]const u8, fontSize: i32, color: Color) RaylibError!Image {
    // TODO: ImageText requires SUPPORT_MODULE_RTEXT. Error out if not loaded.
    const image = cdef.ImageText(@as([*c]const u8, @ptrCast(text)), @as(c_int, fontSize), color);
    const isValid = cdef.IsImageValid(image);
    return if (isValid) image else RaylibError.LoadImage;
}

/// Create an image from text (custom sprite font)
pub fn imageTextEx(font: Font, text: [:0]const u8, fontSize: f32, spacing: f32, tint: Color) RaylibError!Image {
    // TODO: ImageTextEx requires SUPPORT_MODULE_RTEXT. Error out if not loaded.
    const image = cdef.ImageTextEx(font, @as([*c]const u8, @ptrCast(text)), fontSize, spacing, tint);
    const isValid = cdef.IsImageValid(image);
    return if (isValid) image else RaylibError.LoadImage;
}

/// Load color data from image as a Color array (RGBA - 32bit)
pub fn loadImageColors(image: Image) RaylibError![]Color {
    var res: []Color = undefined;

    const ptr = cdef.LoadImageColors(image);
    if (ptr == 0) return RaylibError.LoadImageColors;

    res.ptr = @as([*]Color, @ptrCast(ptr));
    res.len = @as(usize, @intCast(image.width * image.height));
    return res;
}

/// Load texture from file into GPU memory (VRAM)
pub fn loadTexture(fileName: [:0]const u8) RaylibError!Texture2D {
    const texture = cdef.LoadTexture(@as([*c]const u8, @ptrCast(fileName)));
    const isValid = cdef.IsTextureValid(texture);
    return if (isValid) texture else RaylibError.LoadTexture;
}

/// Load texture from image data
pub fn loadTextureFromImage(image: Image) RaylibError!Texture2D {
    const texture = cdef.LoadTextureFromImage(image);
    const isValid = cdef.IsTextureValid(texture);
    return if (isValid) texture else RaylibError.LoadTexture;
}

/// Load cubemap from image, multiple image cubemap layouts supported
pub fn loadTextureCubemap(image: Image, layout: CubemapLayout) RaylibError!TextureCubemap {
    const texture = cdef.LoadTextureCubemap(image, layout);
    const isValid = cdef.IsTextureValid(texture);
    return if (isValid) texture else RaylibError.LoadTexture;
}

/// Load texture for rendering (framebuffer)
pub fn loadRenderTexture(width: i32, height: i32) RaylibError!RenderTexture2D {
    const render_texture = cdef.LoadRenderTexture(@as(c_int, width), @as(c_int, height));
    const isValid = cdef.IsRenderTextureValid(render_texture);
    return if (isValid) render_texture else RaylibError.LoadRenderTexture;
}

pub fn colorToInt(color: Color) i32 {
    return if (@inComptime())
        (@as(i32, color.r) << 24) | (@as(i32, color.g) << 16) | (@as(i32, color.b) << 8) | @as(i32, color.a)
    else
        @as(i32, cdef.ColorToInt(color));
}

/// Get the default Font
pub fn getFontDefault() RaylibError!Font {
    // TODO: GetFontDefault requires SUPPORT_DEFAULT_FONT. Error out if unset.
    const font = cdef.GetFontDefault();
    const isValid = cdef.IsFontValid(font);
    return if (isValid) font else RaylibError.LoadFont;
}

/// Load font from file into GPU memory (VRAM)
pub fn loadFont(fileName: [:0]const u8) RaylibError!Font {
    const font = cdef.LoadFont(@as([*c]const u8, @ptrCast(fileName)));
    const isValid = cdef.IsFontValid(font);
    return if (isValid) font else RaylibError.LoadFont;
}

/// Load font from file with extended parameters, use null for fontChars to load the default character set
pub fn loadFontEx(fileName: [:0]const u8, fontSize: i32, fontChars: ?[]const i32) RaylibError!Font {
    var fontCharsFinal = @as([*c]const c_int, 0);
    var fontCharsLen: c_int = @as(c_int, 0);
    if (fontChars) |fontCharsSure| {
        fontCharsFinal = @as([*c]const c_int, @ptrCast(fontCharsSure));
        fontCharsLen = @as(i32, @intCast(fontCharsSure.len));
    }
    const font = cdef.LoadFontEx(@as([*c]const u8, @ptrCast(fileName)), @as(c_int, fontSize), fontCharsFinal, fontCharsLen);
    const isValid = cdef.IsFontValid(font);
    return if (isValid) font else RaylibError.LoadFont;
}

/// Load font from memory buffer, fileType refers to extension: i.e. '.ttf'
pub fn loadFontFromMemory(fileType: [:0]const u8, fileData: ?[]const u8, fontSize: i32, fontChars: ?[]const i32) RaylibError!Font {
    var fileDataFinal = @as([*c]const u8, 0);
    var fileDataLen: i32 = 0;
    if (fileData) |fileDataSure| {
        fileDataFinal = @as([*c]const u8, @ptrCast(fileDataSure));
        fileDataLen = @as(i32, @intCast(fileDataSure.len));
    }
    const codepointCount: c_int = if (fontChars) |fontCharsSure| @intCast(fontCharsSure.len) else 0;
    const font = cdef.LoadFontFromMemory(@as([*c]const u8, @ptrCast(fileType)), @as([*c]const u8, @ptrCast(fileDataFinal)), @as(c_int, @intCast(fileDataLen)), @as(c_int, fontSize), @as([*c]const c_int, @ptrCast(fontChars)), codepointCount);
    const isValid = cdef.IsFontValid(font);
    return if (isValid) font else RaylibError.LoadFont;
}

/// Load font from Image (XNA style)
pub fn loadFontFromImage(image: Image, key: Color, firstChar: i32) RaylibError!Font {
    const font = cdef.LoadFontFromImage(image, key, @as(c_int, firstChar));
    const isValid = cdef.IsFontValid(font);
    return if (isValid) font else RaylibError.LoadFont;
}

/// Load font data for further use
pub fn loadFontData(fileData: []const u8, fontSize: i32, codePoints: ?[]const i32, ty: FontType) RaylibError![]GlyphInfo {
    var res: []GlyphInfo = undefined;

    var codePointsFinal = @as([*c]const i32, 0);
    var codePointsLen: i32 = 0;
    if (codePoints) |codePointsSure| {
        codePointsFinal = @as([*c]const i32, @ptrCast(codePointsSure));
        codePointsLen = @as(i32, @intCast(codePointsSure.len));
    } else {
        codePointsLen = 95;
    }

    const ptr = cdef.LoadFontData(@as([*c]const u8, @ptrCast(fileData)), @as(c_int, @intCast(fileData.len)), @as(c_int, fontSize), codePointsFinal, @as(c_int, @intCast(codePointsLen)), ty, @as([*c]i32, &codePointsLen));
    if (ptr == 0) return RaylibError.LoadFontData;

    res.ptr = @as([*]GlyphInfo, @ptrCast(ptr));
    res.len = @as(usize, @intCast(codePointsLen));
    return res;
}

/// Text formatting with variables (sprintf() style)
pub fn textFormat(text: [:0]const u8, args: anytype) [:0]const u8 {
    comptime {
        const info = @typeInfo(@TypeOf(args));
        switch (info) {
            .@"struct" => {
                if (!info.@"struct".is_tuple)
                    @compileError("Args should be in a tuple (call this function like textFormat(.{arg1, arg2, ...});)!");
            },
            else => {
                @compileError("Args should be in a tuple (call this function like textFormat(.{arg1, arg2, ...});)!");
            },
        }
    }

    return std.mem.span(@call(.auto, cdef.TextFormat, .{@as([*c]const u8, @ptrCast(text))} ++ args));
}

/// Show trace log messages (LOG_DEBUG, LOG_INFO, LOG_WARNING, LOG_ERROR...)
pub fn traceLog(logLevel: TraceLogLevel, text: [:0]const u8, args: anytype) void {
    comptime {
        const info = @typeInfo(@TypeOf(args));
        switch (info) {
            .@"struct" => {
                if (!info.@"struct".is_tuple)
                    @compileError("Args should be in a tuple (call this function like traceLog(.{arg1, arg2, ...});)!");
            },
            else => {
                @compileError("Args should be in a tuple (call this function like traceLog(.{arg1, arg2, ...});)!");
            },
        }
    }

    @call(.auto, cdef.TraceLog, .{ logLevel, @as([*c]const u8, @ptrCast(text)) } ++ args);
}

/// Draw multiple mesh instances with material and different transforms
pub fn drawMeshInstanced(mesh: Mesh, material: Material, transforms: []const Matrix) void {
    cdef.DrawMeshInstanced(mesh, material, @as([*c]const Matrix, @ptrCast(transforms)), @as(c_int, @intCast(transforms.len)));
}

/// Load default material (Supports: DIFFUSE, SPECULAR, NORMAL maps)
pub fn loadMaterialDefault() RaylibError!Material {
    const material = cdef.LoadMaterialDefault();
    const isValid = cdef.IsMaterialValid(material);
    return if (isValid) material else RaylibError.LoadMaterial;
}

/// Load materials from model file
pub fn loadMaterials(fileName: [:0]const u8) RaylibError![]Material {
    var materialCount: i32 = 0;
    var res: []Material = undefined;

    const ptr = cdef.LoadMaterials(@as([*c]const u8, @ptrCast(fileName)), @as([*c]c_int, @ptrCast(&materialCount)));
    if (ptr == 0) return RaylibError.LoadMaterials;

    res.ptr = @as([*]Material, @ptrCast(ptr));
    res.len = @as(usize, @intCast(materialCount));

    for (res) |r| {
        if (!cdef.IsMaterialValid(r))
            return RaylibError.LoadMaterial;
    }

    return res;
}

/// Load model from files (meshes and materials)
pub fn loadModel(fileName: [:0]const u8) RaylibError!Model {
    const model = cdef.LoadModel(@as([*c]const u8, @ptrCast(fileName)));
    const isValid = cdef.IsModelValid(model);
    return if (isValid) model else RaylibError.LoadModel;
}

/// Load model from generated mesh (default material)
pub fn loadModelFromMesh(mesh: Mesh) RaylibError!Model {
    const model = cdef.LoadModelFromMesh(mesh);
    const isValid = cdef.IsModelValid(model);
    return if (isValid) model else RaylibError.LoadModel;
}

/// Unload animation data
pub fn unloadModelAnimations(animations: []ModelAnimation) void {
    cdef.UnloadModelAnimations(@as([*c]ModelAnimation, @ptrCast(animations)), @as(c_int, @intCast(animations.len)));
}

/// Load sound from file
pub fn loadSound(fileName: [:0]const u8) RaylibError!Sound {
    const sound = cdef.LoadSound(@as([*c]const u8, @ptrCast(fileName)));
    const isValid = cdef.IsSoundValid(sound);
    return if (isValid) sound else RaylibError.LoadSound;
}

/// Load wave data from file
pub fn loadWave(fileName: [:0]const u8) RaylibError!Wave {
    const wave = cdef.LoadWave(@as([*c]const u8, @ptrCast(fileName)));
    const isValid = cdef.IsWaveValid(wave);
    return if (isValid) wave else RaylibError.LoadWave;
}

/// Load wave from memory buffer, fileType refers to extension: i.e. '.wav'
pub fn loadWaveFromMemory(fileType: [:0]const u8, fileData: []const u8) RaylibError!Wave {
    const wave = cdef.LoadWaveFromMemory(@as([*c]const u8, @ptrCast(fileType)), @as([*c]const u8, @ptrCast(fileData)), @as(c_int, @intCast(fileData.len)));
    const isValid = cdef.IsWaveValid(wave);
    return if (isValid) wave else RaylibError.LoadWave;
}

/// Load samples data from wave as a 32bit float data array
pub fn loadWaveSamples(wave: Wave) []f32 {
    var res: []f32 = undefined;
    res.ptr = @as([*]f32, @ptrCast(cdef.LoadWaveSamples(wave)));
    res.len = @as(usize, @intCast(wave.frameCount * wave.channels));
    return res;
}

/// Load music stream from file
pub fn loadMusicStream(fileName: [:0]const u8) RaylibError!Music {
    const music = cdef.LoadMusicStream(@as([*c]const u8, @ptrCast(fileName)));
    const isValid = cdef.IsMusicValid(music);
    return if (isValid) music else RaylibError.LoadMusic;
}

/// Load music stream from data
pub fn loadMusicStreamFromMemory(fileType: [:0]const u8, data: []const u8) RaylibError!Music {
    const music = cdef.LoadMusicStreamFromMemory(@as([*c]const u8, @ptrCast(fileType)), @as([*c]const u8, @ptrCast(data)), @as(c_int, @intCast(data.len)));
    const isValid = cdef.IsMusicValid(music);
    return if (isValid) music else RaylibError.LoadMusic;
}

/// Load audio stream (to stream raw audio pcm data)
pub fn loadAudioStream(sampleRate: u32, sampleSize: u32, channels: u32) RaylibError!AudioStream {
    const audio_stream = cdef.LoadAudioStream(@as(c_uint, sampleRate), @as(c_uint, sampleSize), @as(c_uint, channels));
    const isValid = cdef.IsAudioStreamValid(audio_stream);
    return if (isValid) audio_stream else RaylibError.LoadAudioStream;
}

/// Draw lines sequence (using gl lines)
pub fn drawLineStrip(points: []const Vector2, color: Color) void {
    cdef.DrawLineStrip(@as([*c]const Vector2, @ptrCast(points)), @as(c_int, @intCast(points.len)), color);
}

/// Draw a triangle fan defined by points (first vertex is the center)
pub fn drawTriangleFan(points: []const Vector2, color: Color) void {
    cdef.DrawTriangleFan(@as([*c]const Vector2, @ptrCast(points)), @as(c_int, @intCast(points.len)), color);
}

/// Draw a triangle strip defined by points
pub fn drawTriangleStrip(points: []const Vector2, color: Color) void {
    cdef.DrawTriangleStrip(@as([*c]const Vector2, @ptrCast(points)), @as(c_int, @intCast(points.len)), color);
}

/// Draw spline: Linear, minimum 2 points
pub fn drawSplineLinear(points: []const Vector2, thick: f32, color: Color) void {
    cdef.DrawSplineLinear(@as([*c]const Vector2, @ptrCast(points)), @as(c_int, @intCast(points.len)), thick, color);
}

/// Draw spline: B-Spline, minimum 4 points
pub fn drawSplineBasis(points: []const Vector2, thick: f32, color: Color) void {
    cdef.DrawSplineBasis(@as([*c]const Vector2, @ptrCast(points)), @as(c_int, @intCast(points.len)), thick, color);
}

/// Draw spline: Catmull-Rom, minimum 4 points
pub fn drawSplineCatmullRom(points: []const Vector2, thick: f32, color: Color) void {
    cdef.DrawSplineCatmullRom(@as([*c]const Vector2, @ptrCast(points)), @as(c_int, @intCast(points.len)), thick, color);
}

/// Draw spline: Quadratic Bezier, minimum 3 points (1 control point): [p1, c2, p3, c4...]
pub fn drawSplineBezierQuadratic(points: []const Vector2, thick: f32, color: Color) void {
    cdef.DrawSplineBezierQuadratic(@as([*c]const Vector2, @ptrCast(points)), @as(c_int, @intCast(points.len)), thick, color);
}

/// Draw spline: Cubic Bezier, minimum 4 points (2 control points): [p1, c2, c3, p4, c5, c6...]
pub fn drawSplineBezierCubic(points: []const Vector2, thick: f32, color: Color) void {
    cdef.DrawSplineBezierCubic(@as([*c]const Vector2, @ptrCast(points)), @as(c_int, @intCast(points.len)), thick, color);
}

/// Check if point is within a polygon described by array of vertices
pub fn checkCollisionPointPoly(point: Vector2, points: []const Vector2) bool {
    return cdef.CheckCollisionPointPoly(point, @as([*c]const Vector2, @ptrCast(points)), @as(c_int, @intCast(points.len)));
}

pub fn imageKernelConvolution(image: *Image, kernel: []const f32) void {
    cdef.ImageKernelConvolution(@as([*c]Image, @ptrCast(image)), @as([*c]const f32, @ptrCast(kernel)), @as(c_int, @intCast(kernel.len)));
}

/// Generate image font atlas using chars info
pub fn genImageFontAtlas(glyphs: []const GlyphInfo, fontSize: i32, padding: i32, packMethod: i32) RaylibError!struct { Image, []Rectangle } {
    var res: []Rectangle = undefined;
    var recs: [*c]Rectangle = 0;
    const image = cdef.GenImageFontAtlas(@as([*c]const GlyphInfo, @ptrCast(glyphs)), @as([*c][*c]Rectangle, @ptrCast(&recs)), @as(c_int, @intCast(glyphs.len)), @as(c_int, fontSize), @as(c_int, padding), @as(c_int, packMethod));
    const isValid = cdef.IsImageValid(image);

    if (!isValid) return RaylibError.GenImageFontAtlas;

    res.ptr = @as([*]Rectangle, @ptrCast(@alignCast(recs)));
    res.len = @as(usize, @intCast(glyphs.len));

    return .{ image, res };
}

/// Unload font chars info data (RAM)
pub fn unloadFontData(chars: []GlyphInfo) void {
    cdef.UnloadFontData(@as([*c]GlyphInfo, @ptrCast(chars)), @as(c_int, @intCast(chars.len)));
}

/// Draw multiple character (codepoint)
pub fn drawTextCodepoints(font: Font, codepoints: []const c_int, position: Vector2, fontSize: f32, spacing: f32, tint: Color) void {
    cdef.DrawTextCodepoints(font, @as([*c]const c_int, @ptrCast(codepoints)), @as(c_int, @intCast(codepoints.len)), position, fontSize, spacing, tint);
}

/// Load UTF-8 text encoded from codepoints array
pub fn loadUTF8(codepoints: []const c_int) [:0]u8 {
    return std.mem.span(cdef.LoadUTF8(@as([*c]const c_int, @ptrCast(codepoints)), @as(c_int, @intCast(codepoints.len))));
}

// Load text as separate lines ('\n')
pub fn loadTextLines(text: [:0]const u8) RaylibError![][:0]u8 {
    var lineCount: i32 = 0;
    var res: [][:0]u8 = undefined;

    const ptr = cdef.LoadTextLines(@as([*c]const u8, @ptrCast(text)), @as([*c]c_int, @ptrCast(&lineCount)));
    if (ptr == 0) return RaylibError.LoadTextLines;

    res.ptr = @as([*][:0]u8, @ptrCast(ptr));
    res.len = @as(usize, @intCast(lineCount));

    return res;
}

pub fn unloadTextLines(lines: [][:0]u8) void {
    cdef.UnloadTextLines(@as([*c][*c]u8, @ptrCast(lines)), @as(c_int, @intCast(lines.len)));
}

/// Join text strings with delimiter
pub fn textJoin(textList: [][:0]u8, delimiter: [:0]const u8) [:0]const u8 {
    return std.mem.span(cdef.TextJoin(@as([*c][*c]u8, @ptrCast(textList)), @as(c_int, @intCast(textList.len)), @as([*c]const u8, @ptrCast(delimiter))));
}

/// Draw a triangle strip defined by points
pub fn drawTriangleStrip3D(points: []const Vector3, color: Color) void {
    cdef.DrawTriangleStrip3D(@as([*c]const Vector3, @ptrCast(points)), @as(c_int, @intCast(points.len)), color);
}

/// Internal memory allocator
fn alloc(_: *anyopaque, len: usize, _: std.mem.Alignment, _: usize) ?[*]u8 {
    std.debug.assert(len > 0);
    return @ptrCast(cdef.MemAlloc(@intCast(len)));
}

fn resize(_: *anyopaque, buf: []u8, _: std.mem.Alignment, new_len: usize, _: usize) bool {
    return (new_len <= buf.len);
}

/// Internal memory free
fn free(_: *anyopaque, buf: []u8, _: std.mem.Alignment, _: usize) void {
    cdef.MemFree(buf.ptr);
}

fn remap(_: *anyopaque, buf: []u8, _: std.mem.Alignment, new_len: usize, _: usize) ?[*]u8 {
    if (new_len <= buf.len) {
        return buf.ptr;
    } else {
        return null;
    }
}

const mem_vtable = std.mem.Allocator.VTable{
    .alloc = alloc,
    .resize = resize,
    .free = free,
    .remap = remap,
};

pub const mem = std.mem.Allocator{
    .ptr = undefined,
    .vtable = &mem_vtable,
};

/// Initialize window and OpenGL context
pub fn initWindow(width: i32, height: i32, title: [:0]const u8) void {
    cdef.InitWindow(@as(c_int, width), @as(c_int, height), @as([*c]const u8, @ptrCast(title)));
}

/// Close window and unload OpenGL context
pub fn closeWindow() void {
    cdef.CloseWindow();
}

/// Check if application should close (KEY_ESCAPE pressed or windows close icon clicked)
pub fn windowShouldClose() bool {
    return cdef.WindowShouldClose();
}

/// Check if window has been initialized successfully
pub fn isWindowReady() bool {
    return cdef.IsWindowReady();
}

/// Check if window is currently fullscreen
pub fn isWindowFullscreen() bool {
    return cdef.IsWindowFullscreen();
}

/// Check if window is currently hidden
pub fn isWindowHidden() bool {
    return cdef.IsWindowHidden();
}

/// Check if window is currently minimized
pub fn isWindowMinimized() bool {
    return cdef.IsWindowMinimized();
}

/// Check if window is currently maximized
pub fn isWindowMaximized() bool {
    return cdef.IsWindowMaximized();
}

/// Check if window is currently focused
pub fn isWindowFocused() bool {
    return cdef.IsWindowFocused();
}

/// Check if window has been resized last frame
pub fn isWindowResized() bool {
    return cdef.IsWindowResized();
}

/// Check if one specific window flag is enabled
pub fn isWindowState(flag: ConfigFlags) bool {
    return cdef.IsWindowState(flag);
}

/// Set window configuration state using flags
pub fn setWindowState(flags: ConfigFlags) void {
    cdef.SetWindowState(flags);
}

/// Clear window configuration state flags
pub fn clearWindowState(flags: ConfigFlags) void {
    cdef.ClearWindowState(flags);
}

/// Toggle window state: fullscreen/windowed, resizes monitor to match window resolution
pub fn toggleFullscreen() void {
    cdef.ToggleFullscreen();
}

/// Toggle window state: borderless windowed, resizes window to match monitor resolution
pub fn toggleBorderlessWindowed() void {
    cdef.ToggleBorderlessWindowed();
}

/// Set window state: maximized, if resizable
pub fn maximizeWindow() void {
    cdef.MaximizeWindow();
}

/// Set window state: minimized, if resizable
pub fn minimizeWindow() void {
    cdef.MinimizeWindow();
}

/// Restore window from being minimized/maximized
pub fn restoreWindow() void {
    cdef.RestoreWindow();
}

/// Set icon for window (single image, RGBA 32bit)
pub fn setWindowIcon(image: Image) void {
    cdef.SetWindowIcon(image);
}

/// Set title for window
pub fn setWindowTitle(title: [:0]const u8) void {
    cdef.SetWindowTitle(@as([*c]const u8, @ptrCast(title)));
}

/// Set window position on screen
pub fn setWindowPosition(x: i32, y: i32) void {
    cdef.SetWindowPosition(@as(c_int, x), @as(c_int, y));
}

/// Set monitor for the current window
pub fn setWindowMonitor(monitor: i32) void {
    cdef.SetWindowMonitor(@as(c_int, monitor));
}

/// Set window minimum dimensions (for FLAG_WINDOW_RESIZABLE)
pub fn setWindowMinSize(width: i32, height: i32) void {
    cdef.SetWindowMinSize(@as(c_int, width), @as(c_int, height));
}

/// Set window maximum dimensions (for FLAG_WINDOW_RESIZABLE)
pub fn setWindowMaxSize(width: i32, height: i32) void {
    cdef.SetWindowMaxSize(@as(c_int, width), @as(c_int, height));
}

/// Set window dimensions
pub fn setWindowSize(width: i32, height: i32) void {
    cdef.SetWindowSize(@as(c_int, width), @as(c_int, height));
}

/// Set window opacity [0.0f..1.0f]
pub fn setWindowOpacity(opacity: f32) void {
    cdef.SetWindowOpacity(opacity);
}

/// Set window focused
pub fn setWindowFocused() void {
    cdef.SetWindowFocused();
}

/// Get native window handle
pub fn getWindowHandle() *anyopaque {
    return cdef.GetWindowHandle();
}

/// Get current screen width
pub fn getScreenWidth() i32 {
    return @as(i32, cdef.GetScreenWidth());
}

/// Get current screen height
pub fn getScreenHeight() i32 {
    return @as(i32, cdef.GetScreenHeight());
}

/// Get current render width (it considers HiDPI)
pub fn getRenderWidth() i32 {
    return @as(i32, cdef.GetRenderWidth());
}

/// Get current render height (it considers HiDPI)
pub fn getRenderHeight() i32 {
    return @as(i32, cdef.GetRenderHeight());
}

/// Get number of connected monitors
pub fn getMonitorCount() i32 {
    return @as(i32, cdef.GetMonitorCount());
}

/// Get current monitor where window is placed
pub fn getCurrentMonitor() i32 {
    return @as(i32, cdef.GetCurrentMonitor());
}

/// Get specified monitor position
pub fn getMonitorPosition(monitor: i32) Vector2 {
    return cdef.GetMonitorPosition(@as(c_int, monitor));
}

/// Get specified monitor width (current video mode used by monitor)
pub fn getMonitorWidth(monitor: i32) i32 {
    return @as(i32, cdef.GetMonitorWidth(@as(c_int, monitor)));
}

/// Get specified monitor height (current video mode used by monitor)
pub fn getMonitorHeight(monitor: i32) i32 {
    return @as(i32, cdef.GetMonitorHeight(@as(c_int, monitor)));
}

/// Get specified monitor physical width in millimetres
pub fn getMonitorPhysicalWidth(monitor: i32) i32 {
    return @as(i32, cdef.GetMonitorPhysicalWidth(@as(c_int, monitor)));
}

/// Get specified monitor physical height in millimetres
pub fn getMonitorPhysicalHeight(monitor: i32) i32 {
    return @as(i32, cdef.GetMonitorPhysicalHeight(@as(c_int, monitor)));
}

/// Get specified monitor refresh rate
pub fn getMonitorRefreshRate(monitor: i32) i32 {
    return @as(i32, cdef.GetMonitorRefreshRate(@as(c_int, monitor)));
}

/// Get window position XY on monitor
pub fn getWindowPosition() Vector2 {
    return cdef.GetWindowPosition();
}

/// Get window scale DPI factor
pub fn getWindowScaleDPI() Vector2 {
    return cdef.GetWindowScaleDPI();
}

/// Get the human-readable, UTF-8 encoded name of the specified monitor
pub fn getMonitorName(monitor: i32) [:0]const u8 {
    return std.mem.span(cdef.GetMonitorName(@as(c_int, monitor)));
}

/// Set clipboard text content
pub fn setClipboardText(text: [:0]const u8) void {
    cdef.SetClipboardText(@as([*c]const u8, @ptrCast(text)));
}

/// Get clipboard text content
pub fn getClipboardText() [:0]const u8 {
    return std.mem.span(cdef.GetClipboardText());
}

/// Get clipboard image content
pub fn getClipboardImage() Image {
    return cdef.GetClipboardImage();
}

/// Enable waiting for events on EndDrawing(), no automatic event polling
pub fn enableEventWaiting() void {
    cdef.EnableEventWaiting();
}

/// Disable waiting for events on EndDrawing(), automatic events polling
pub fn disableEventWaiting() void {
    cdef.DisableEventWaiting();
}

/// Shows cursor
pub fn showCursor() void {
    cdef.ShowCursor();
}

/// Hides cursor
pub fn hideCursor() void {
    cdef.HideCursor();
}

/// Check if cursor is not visible
pub fn isCursorHidden() bool {
    return cdef.IsCursorHidden();
}

/// Enables cursor (unlock cursor)
pub fn enableCursor() void {
    cdef.EnableCursor();
}

/// Disables cursor (lock cursor)
pub fn disableCursor() void {
    cdef.DisableCursor();
}

/// Check if cursor is on the screen
pub fn isCursorOnScreen() bool {
    return cdef.IsCursorOnScreen();
}

/// Set background color (framebuffer clear color)
pub fn clearBackground(color: Color) void {
    cdef.ClearBackground(color);
}

/// Setup canvas (framebuffer) to start drawing
pub fn beginDrawing() void {
    cdef.BeginDrawing();
}

/// End canvas drawing and swap buffers (double buffering)
pub fn endDrawing() void {
    cdef.EndDrawing();
}

/// Begin 2D mode with custom camera (2D)
pub fn beginMode2D(camera: Camera2D) void {
    cdef.BeginMode2D(camera);
}

/// Ends 2D mode with custom camera
pub fn endMode2D() void {
    cdef.EndMode2D();
}

/// Begin 3D mode with custom camera (3D)
pub fn beginMode3D(camera: Camera3D) void {
    cdef.BeginMode3D(camera);
}

/// Ends 3D mode and returns to default 2D orthographic mode
pub fn endMode3D() void {
    cdef.EndMode3D();
}

/// Begin drawing to render texture
pub fn beginTextureMode(target: RenderTexture2D) void {
    cdef.BeginTextureMode(target);
}

/// Ends drawing to render texture
pub fn endTextureMode() void {
    cdef.EndTextureMode();
}

/// Begin custom shader drawing
pub fn beginShaderMode(shader: Shader) void {
    cdef.BeginShaderMode(shader);
}

/// End custom shader drawing (use default shader)
pub fn endShaderMode() void {
    cdef.EndShaderMode();
}

/// Begin blending mode (alpha, additive, multiplied, subtract, custom)
pub fn beginBlendMode(mode: BlendMode) void {
    cdef.BeginBlendMode(mode);
}

/// End blending mode (reset to default: alpha blending)
pub fn endBlendMode() void {
    cdef.EndBlendMode();
}

/// Begin scissor mode (define screen area for following drawing)
pub fn beginScissorMode(x: i32, y: i32, width: i32, height: i32) void {
    cdef.BeginScissorMode(@as(c_int, x), @as(c_int, y), @as(c_int, width), @as(c_int, height));
}

/// End scissor mode
pub fn endScissorMode() void {
    cdef.EndScissorMode();
}

/// Begin stereo rendering (requires VR simulator)
pub fn beginVrStereoMode(config: VrStereoConfig) void {
    cdef.BeginVrStereoMode(config);
}

/// End stereo rendering (requires VR simulator)
pub fn endVrStereoMode() void {
    cdef.EndVrStereoMode();
}

/// Load VR stereo config for VR simulator device parameters
pub fn loadVrStereoConfig(device: VrDeviceInfo) VrStereoConfig {
    return cdef.LoadVrStereoConfig(device);
}

/// Unload VR stereo config
pub fn unloadVrStereoConfig(config: VrStereoConfig) void {
    cdef.UnloadVrStereoConfig(config);
}

/// Check if a shader is valid (loaded on GPU)
pub fn isShaderValid(shader: Shader) bool {
    return cdef.IsShaderValid(shader);
}

/// Get shader uniform location
pub fn getShaderLocation(shader: Shader, uniformName: [:0]const u8) i32 {
    return @as(i32, cdef.GetShaderLocation(shader, @as([*c]const u8, @ptrCast(uniformName))));
}

/// Get shader attribute location
pub fn getShaderLocationAttrib(shader: Shader, attribName: [:0]const u8) i32 {
    return @as(i32, cdef.GetShaderLocationAttrib(shader, @as([*c]const u8, @ptrCast(attribName))));
}

/// Set shader uniform value
pub fn setShaderValue(shader: Shader, locIndex: i32, value: *const anyopaque, uniformType: ShaderUniformDataType) void {
    cdef.SetShaderValue(shader, @as(c_int, locIndex), value, uniformType);
}

/// Set shader uniform value vector
pub fn setShaderValueV(shader: Shader, locIndex: i32, value: *const anyopaque, uniformType: ShaderUniformDataType, count: i32) void {
    cdef.SetShaderValueV(shader, @as(c_int, locIndex), value, uniformType, @as(c_int, count));
}

/// Set shader uniform value (matrix 4x4)
pub fn setShaderValueMatrix(shader: Shader, locIndex: i32, mat: Matrix) void {
    cdef.SetShaderValueMatrix(shader, @as(c_int, locIndex), mat);
}

/// Set shader uniform value and bind the texture (sampler2d)
pub fn setShaderValueTexture(shader: Shader, locIndex: i32, texture: Texture2D) void {
    cdef.SetShaderValueTexture(shader, @as(c_int, locIndex), texture);
}

/// Unload shader from GPU memory (VRAM)
pub fn unloadShader(shader: Shader) void {
    cdef.UnloadShader(shader);
}

/// Get a ray trace from screen position (i.e mouse)
pub fn getScreenToWorldRay(position: Vector2, camera: Camera) Ray {
    return cdef.GetScreenToWorldRay(position, camera);
}

/// Get a ray trace from screen position (i.e mouse) in a viewport
pub fn getScreenToWorldRayEx(position: Vector2, camera: Camera, width: i32, height: i32) Ray {
    return cdef.GetScreenToWorldRayEx(position, camera, @as(c_int, width), @as(c_int, height));
}

/// Get the screen space position for a 3d world space position
pub fn getWorldToScreen(position: Vector3, camera: Camera) Vector2 {
    return cdef.GetWorldToScreen(position, camera);
}

/// Get size position for a 3d world space position
pub fn getWorldToScreenEx(position: Vector3, camera: Camera, width: i32, height: i32) Vector2 {
    return cdef.GetWorldToScreenEx(position, camera, @as(c_int, width), @as(c_int, height));
}

/// Get the screen space position for a 2d camera world space position
pub fn getWorldToScreen2D(position: Vector2, camera: Camera2D) Vector2 {
    return cdef.GetWorldToScreen2D(position, camera);
}

/// Get the world space position for a 2d camera screen space position
pub fn getScreenToWorld2D(position: Vector2, camera: Camera2D) Vector2 {
    return cdef.GetScreenToWorld2D(position, camera);
}

/// Get camera transform matrix (view matrix)
pub fn getCameraMatrix(camera: Camera) Matrix {
    return cdef.GetCameraMatrix(camera);
}

/// Get camera 2d transform matrix
pub fn getCameraMatrix2D(camera: Camera2D) Matrix {
    return cdef.GetCameraMatrix2D(camera);
}

/// Set target FPS (maximum)
pub fn setTargetFPS(fps: i32) void {
    cdef.SetTargetFPS(@as(c_int, fps));
}

/// Get time in seconds for last frame drawn (delta time)
pub fn getFrameTime() f32 {
    return cdef.GetFrameTime();
}

/// Get elapsed time in seconds since InitWindow()
pub fn getTime() f64 {
    return cdef.GetTime();
}

/// Get current FPS
pub fn getFPS() i32 {
    return @as(i32, cdef.GetFPS());
}

/// Swap back buffer with front buffer (screen drawing)
pub fn swapScreenBuffer() void {
    cdef.SwapScreenBuffer();
}

/// Register all input events
pub fn pollInputEvents() void {
    cdef.PollInputEvents();
}

/// Wait for some time (halt program execution)
pub fn waitTime(seconds: f64) void {
    cdef.WaitTime(seconds);
}

/// Set the seed for the random number generator
pub fn setRandomSeed(seed: u32) void {
    cdef.SetRandomSeed(@as(c_uint, seed));
}

/// Get a random value between min and max (both included)
pub fn getRandomValue(min: i32, max: i32) i32 {
    return @as(i32, cdef.GetRandomValue(@as(c_int, min), @as(c_int, max)));
}

/// Unload random values sequence
pub fn unloadRandomSequence(sequence: []i32) void {
    cdef.UnloadRandomSequence(@as([*c]c_int, @ptrCast(sequence)));
}

/// Takes a screenshot of current screen (filename extension defines format)
pub fn takeScreenshot(fileName: [:0]const u8) void {
    cdef.TakeScreenshot(@as([*c]const u8, @ptrCast(fileName)));
}

/// Setup init configuration flags (view FLAGS)
pub fn setConfigFlags(flags: ConfigFlags) void {
    cdef.SetConfigFlags(flags);
}

/// Open URL with default system browser (if available)
pub fn openURL(url: [:0]const u8) void {
    cdef.OpenURL(@as([*c]const u8, @ptrCast(url)));
}

/// Set the current threshold (minimum) log level
pub fn setTraceLogLevel(logLevel: TraceLogLevel) void {
    cdef.SetTraceLogLevel(logLevel);
}

/// Internal memory allocator
pub fn memAlloc(size: u32) *anyopaque {
    return cdef.MemAlloc(@as(c_uint, size));
}

/// Internal memory reallocator
pub fn memRealloc(ptr: *anyopaque, size: u32) *anyopaque {
    return cdef.MemRealloc(ptr, @as(c_uint, size));
}

/// Internal memory free
pub fn memFree(ptr: *anyopaque) void {
    cdef.MemFree(ptr);
}

/// Set custom file binary data loader
pub fn setLoadFileDataCallback(callback: LoadFileDataCallback) void {
    cdef.SetLoadFileDataCallback(callback);
}

/// Set custom file binary data saver
pub fn setSaveFileDataCallback(callback: SaveFileDataCallback) void {
    cdef.SetSaveFileDataCallback(callback);
}

/// Set custom file text data loader
pub fn setLoadFileTextCallback(callback: LoadFileTextCallback) void {
    cdef.SetLoadFileTextCallback(callback);
}

/// Set custom file text data saver
pub fn setSaveFileTextCallback(callback: SaveFileTextCallback) void {
    cdef.SetSaveFileTextCallback(callback);
}

/// Load file data as byte array (read)
pub fn loadFileData(fileName: []const u8) RaylibError![]u8 {
    var _len: i32 = 0;
    const _ptr = cdef.LoadFileData(@as([*c]const u8, @ptrCast(fileName)), @as([*c]c_int, @ptrCast(&_len)));
    if (_ptr == 0) return RaylibError.LoadFileData;
    return _ptr[0..@as(usize, @intCast(_len))];
}

/// Unload file data allocated by LoadFileData()
pub fn unloadFileData(data: []u8) void {
    cdef.UnloadFileData(@as([*c]u8, @ptrCast(data)));
}

/// Load text data from file (read), returns a '\0' terminated string
pub fn loadFileText(fileName: [:0]const u8) [:0]u8 {
    return std.mem.span(cdef.LoadFileText(@as([*c]const u8, @ptrCast(fileName))));
}

/// Unload file text data allocated by LoadFileText()
pub fn unloadFileText(text: [:0]u8) void {
    cdef.UnloadFileText(@as([*c]u8, @ptrCast(text)));
}

/// Save text data to file (write), string must be '\0' terminated, returns true on success
pub fn saveFileText(fileName: [:0]const u8, text: [:0]const u8) bool {
    return cdef.SaveFileText(@as([*c]const u8, @ptrCast(fileName)), @as([*c]const u8, @ptrCast(text)));
}

/// Rename file (if exists)
pub fn fileRename(fileName: [:0]const u8, fileRename_: [:0]const u8) i32 {
    return @as(i32, cdef.FileRename(@as([*c]const u8, @ptrCast(fileName)), @as([*c]const u8, @ptrCast(fileRename_))));
}

/// Remove file (if exists)
pub fn fileRemove(fileName: [:0]const u8) i32 {
    return @as(i32, cdef.FileRemove(@as([*c]const u8, @ptrCast(fileName))));
}

/// Copy file from one path to another, dstPath created if it doesn't exist
pub fn fileCopy(srcPath: [:0]const u8, dstPath: [:0]const u8) i32 {
    return @as(i32, cdef.FileCopy(@as([*c]const u8, @ptrCast(srcPath)), @as([*c]const u8, @ptrCast(dstPath))));
}

/// Move file from one directory to another, dstPath created if it doesn't exist
pub fn fileMove(srcPath: [:0]const u8, dstPath: [:0]const u8) i32 {
    return @as(i32, cdef.FileMove(@as([*c]const u8, @ptrCast(srcPath)), @as([*c]const u8, @ptrCast(dstPath))));
}

/// Replace text in an existing file
pub fn fileTextReplace(fileName: [:0]const u8, search: [:0]const u8, replacement: [:0]const u8) i32 {
    return @as(i32, cdef.FileTextReplace(@as([*c]const u8, @ptrCast(fileName)), @as([*c]const u8, @ptrCast(search)), @as([*c]const u8, @ptrCast(replacement))));
}

/// Find text in existing file
pub fn fileTextFindIndex(fileName: [:0]const u8, search: [:0]const u8) i32 {
    return @as(i32, cdef.FileTextFindIndex(@as([*c]const u8, @ptrCast(fileName)), @as([*c]const u8, @ptrCast(search))));
}

/// Check if file exists
pub fn fileExists(fileName: [:0]const u8) bool {
    return cdef.FileExists(@as([*c]const u8, @ptrCast(fileName)));
}

/// Check if a directory path exists
pub fn directoryExists(dirPath: [:0]const u8) bool {
    return cdef.DirectoryExists(@as([*c]const u8, @ptrCast(dirPath)));
}

/// Check file extension (recommended include point: .png, .wav)
pub fn isFileExtension(fileName: [:0]const u8, ext: [:0]const u8) bool {
    return cdef.IsFileExtension(@as([*c]const u8, @ptrCast(fileName)), @as([*c]const u8, @ptrCast(ext)));
}

/// Get file length in bytes (NOTE: GetFileSize() conflicts with windows.h)
pub fn getFileLength(fileName: [:0]const u8) i32 {
    return @as(i32, cdef.GetFileLength(@as([*c]const u8, @ptrCast(fileName))));
}

/// Get file modification time (last write time)
pub fn getFileModTime(fileName: [:0]const u8) i64 {
    return @as(i64, cdef.GetFileModTime(@as([*c]const u8, @ptrCast(fileName))));
}

/// Get pointer to extension for a filename string (includes dot: '.png')
pub fn getFileExtension(fileName: [:0]const u8) [:0]const u8 {
    return std.mem.span(cdef.GetFileExtension(@as([*c]const u8, @ptrCast(fileName))));
}

/// Get pointer to filename for a path string
pub fn getFileName(filePath: [:0]const u8) [:0]const u8 {
    return std.mem.span(cdef.GetFileName(@as([*c]const u8, @ptrCast(filePath))));
}

/// Get filename string without extension (uses static string)
pub fn getFileNameWithoutExt(filePath: [:0]const u8) [:0]const u8 {
    return std.mem.span(cdef.GetFileNameWithoutExt(@as([*c]const u8, @ptrCast(filePath))));
}

/// Get full path for a given fileName with path (uses static string)
pub fn getDirectoryPath(filePath: [:0]const u8) [:0]const u8 {
    return std.mem.span(cdef.GetDirectoryPath(@as([*c]const u8, @ptrCast(filePath))));
}

/// Get previous directory path for a given path (uses static string)
pub fn getPrevDirectoryPath(dirPath: [:0]const u8) [:0]const u8 {
    return std.mem.span(cdef.GetPrevDirectoryPath(@as([*c]const u8, @ptrCast(dirPath))));
}

/// Get current working directory (uses static string)
pub fn getWorkingDirectory() [:0]const u8 {
    return std.mem.span(cdef.GetWorkingDirectory());
}

/// Get the directory of the running application (uses static string)
pub fn getApplicationDirectory() [:0]const u8 {
    return std.mem.span(cdef.GetApplicationDirectory());
}

/// Create directories (including full path requested), returns 0 on success
pub fn makeDirectory(dirPath: [:0]const u8) i32 {
    return @as(i32, cdef.MakeDirectory(@as([*c]const u8, @ptrCast(dirPath))));
}

/// Change working directory, return true on success
pub fn changeDirectory(dir: [:0]const u8) bool {
    return cdef.ChangeDirectory(@as([*c]const u8, @ptrCast(dir)));
}

/// Check if a given path is a file or a directory
pub fn isPathFile(path: [:0]const u8) bool {
    return cdef.IsPathFile(@as([*c]const u8, @ptrCast(path)));
}

/// Check if fileName is valid for the platform/OS
pub fn isFileNameValid(fileName: [:0]const u8) bool {
    return cdef.IsFileNameValid(@as([*c]const u8, @ptrCast(fileName)));
}

/// Load directory filepaths
pub fn loadDirectoryFiles(dirPath: [:0]const u8) FilePathList {
    return cdef.LoadDirectoryFiles(@as([*c]const u8, @ptrCast(dirPath)));
}

/// Load directory filepaths with extension filtering and recursive directory scan. Use 'DIR' in the filter string to include directories in the result
pub fn loadDirectoryFilesEx(basePath: [:0]const u8, filter: [:0]const u8, scanSubdirs: bool) FilePathList {
    return cdef.LoadDirectoryFilesEx(@as([*c]const u8, @ptrCast(basePath)), @as([*c]const u8, @ptrCast(filter)), scanSubdirs);
}

/// Unload filepaths
pub fn unloadDirectoryFiles(files: FilePathList) void {
    cdef.UnloadDirectoryFiles(files);
}

/// Check if a file has been dropped into window
pub fn isFileDropped() bool {
    return cdef.IsFileDropped();
}

/// Load dropped filepaths
pub fn loadDroppedFiles() FilePathList {
    return cdef.LoadDroppedFiles();
}

/// Unload dropped filepaths
pub fn unloadDroppedFiles(files: FilePathList) void {
    cdef.UnloadDroppedFiles(files);
}

/// Compress data (DEFLATE algorithm), memory must be MemFree()
pub fn compressData(data: []const u8, dataSize: i32) RaylibError![]u8 {
    var _len: i32 = 0;
    const _ptr = cdef.CompressData(@as([*c]const u8, @ptrCast(data)), @as(c_int, dataSize), @as([*c]c_int, @ptrCast(&_len)));
    if (_ptr == 0) return RaylibError.CompressData;
    return _ptr[0..@as(usize, @intCast(_len))];
}

/// Decompress data (DEFLATE algorithm), memory must be MemFree()
pub fn decompressData(compData: []const u8, compDataSize: i32) RaylibError![]u8 {
    var _len: i32 = 0;
    const _ptr = cdef.DecompressData(@as([*c]const u8, @ptrCast(compData)), @as(c_int, compDataSize), @as([*c]c_int, @ptrCast(&_len)));
    if (_ptr == 0) return RaylibError.DecompressData;
    return _ptr[0..@as(usize, @intCast(_len))];
}

/// Encode data to Base64 string (includes NULL terminator), memory must be MemFree()
pub fn encodeDataBase64(data: []const u8, dataSize: i32) RaylibError![]u8 {
    var _len: i32 = 0;
    const _ptr = cdef.EncodeDataBase64(@as([*c]const u8, @ptrCast(data)), @as(c_int, dataSize), @as([*c]c_int, @ptrCast(&_len)));
    if (_ptr == 0) return RaylibError.EncodeDataBase64;
    return _ptr[0..@as(usize, @intCast(_len))];
}

/// Decode Base64 string (expected NULL terminated), memory must be MemFree()
pub fn decodeDataBase64(text: []const u8) RaylibError![]u8 {
    var _len: i32 = 0;
    const _ptr = cdef.DecodeDataBase64(@as([*c]const u8, @ptrCast(text)), @as([*c]c_int, @ptrCast(&_len)));
    if (_ptr == 0) return RaylibError.DecodeDataBase64;
    return _ptr[0..@as(usize, @intCast(_len))];
}

/// Load automation events list from file, NULL for empty list, capacity = MAX_AUTOMATION_EVENTS
pub fn loadAutomationEventList(fileName: [:0]const u8) AutomationEventList {
    return cdef.LoadAutomationEventList(@as([*c]const u8, @ptrCast(fileName)));
}

/// Unload automation events list from file
pub fn unloadAutomationEventList(list: AutomationEventList) void {
    cdef.UnloadAutomationEventList(list);
}

/// Export automation events list as text file
pub fn exportAutomationEventList(list: AutomationEventList, fileName: [:0]const u8) bool {
    return cdef.ExportAutomationEventList(list, @as([*c]const u8, @ptrCast(fileName)));
}

/// Set automation event list to record to
pub fn setAutomationEventList(list: *AutomationEventList) void {
    cdef.SetAutomationEventList(@as([*c]AutomationEventList, @ptrCast(list)));
}

/// Set automation event internal base frame to start recording
pub fn setAutomationEventBaseFrame(frame: i32) void {
    cdef.SetAutomationEventBaseFrame(@as(c_int, frame));
}

/// Start recording automation events (AutomationEventList must be set)
pub fn startAutomationEventRecording() void {
    cdef.StartAutomationEventRecording();
}

/// Stop recording automation events
pub fn stopAutomationEventRecording() void {
    cdef.StopAutomationEventRecording();
}

/// Play a recorded automation event
pub fn playAutomationEvent(event: AutomationEvent) void {
    cdef.PlayAutomationEvent(event);
}

/// Check if a key has been pressed once
pub fn isKeyPressed(key: KeyboardKey) bool {
    return cdef.IsKeyPressed(key);
}

/// Check if a key has been pressed again
pub fn isKeyPressedRepeat(key: KeyboardKey) bool {
    return cdef.IsKeyPressedRepeat(key);
}

/// Check if a key is being pressed
pub fn isKeyDown(key: KeyboardKey) bool {
    return cdef.IsKeyDown(key);
}

/// Check if a key has been released once
pub fn isKeyReleased(key: KeyboardKey) bool {
    return cdef.IsKeyReleased(key);
}

/// Check if a key is NOT being pressed
pub fn isKeyUp(key: KeyboardKey) bool {
    return cdef.IsKeyUp(key);
}

/// Get key pressed (keycode), call it multiple times for keys queued, returns 0 when the queue is empty
pub fn getKeyPressed() KeyboardKey {
    return cdef.GetKeyPressed();
}

/// Get char pressed (unicode), call it multiple times for chars queued, returns 0 when the queue is empty
pub fn getCharPressed() i32 {
    return @as(i32, cdef.GetCharPressed());
}

/// Get name of a QWERTY key on the current keyboard layout (eg returns string 'q' for KEY_A on an AZERTY keyboard)
pub fn getKeyName(key: KeyboardKey) [:0]const u8 {
    return std.mem.span(cdef.GetKeyName(key));
}

/// Set a custom key to exit program (default is ESC)
pub fn setExitKey(key: KeyboardKey) void {
    cdef.SetExitKey(key);
}

/// Check if a gamepad is available
pub fn isGamepadAvailable(gamepad: i32) bool {
    return cdef.IsGamepadAvailable(@as(c_int, gamepad));
}

/// Get gamepad internal name id
pub fn getGamepadName(gamepad: i32) [:0]const u8 {
    return std.mem.span(cdef.GetGamepadName(@as(c_int, gamepad)));
}

/// Check if a gamepad button has been pressed once
pub fn isGamepadButtonPressed(gamepad: i32, button: GamepadButton) bool {
    return cdef.IsGamepadButtonPressed(@as(c_int, gamepad), button);
}

/// Check if a gamepad button is being pressed
pub fn isGamepadButtonDown(gamepad: i32, button: GamepadButton) bool {
    return cdef.IsGamepadButtonDown(@as(c_int, gamepad), button);
}

/// Check if a gamepad button has been released once
pub fn isGamepadButtonReleased(gamepad: i32, button: GamepadButton) bool {
    return cdef.IsGamepadButtonReleased(@as(c_int, gamepad), button);
}

/// Check if a gamepad button is NOT being pressed
pub fn isGamepadButtonUp(gamepad: i32, button: GamepadButton) bool {
    return cdef.IsGamepadButtonUp(@as(c_int, gamepad), button);
}

/// Get the last gamepad button pressed
pub fn getGamepadButtonPressed() GamepadButton {
    return cdef.GetGamepadButtonPressed();
}

/// Get axis count for a gamepad
pub fn getGamepadAxisCount(gamepad: i32) i32 {
    return @as(i32, cdef.GetGamepadAxisCount(@as(c_int, gamepad)));
}

/// Get movement value for a gamepad axis
pub fn getGamepadAxisMovement(gamepad: i32, axis: GamepadAxis) f32 {
    return cdef.GetGamepadAxisMovement(@as(c_int, gamepad), axis);
}

/// Set internal gamepad mappings (SDL_GameControllerDB)
pub fn setGamepadMappings(mappings: [:0]const u8) i32 {
    return @as(i32, cdef.SetGamepadMappings(@as([*c]const u8, @ptrCast(mappings))));
}

/// Set gamepad vibration for both motors (duration in seconds)
pub fn setGamepadVibration(gamepad: i32, leftMotor: f32, rightMotor: f32, duration: f32) void {
    cdef.SetGamepadVibration(@as(c_int, gamepad), leftMotor, rightMotor, duration);
}

/// Check if a mouse button has been pressed once
pub fn isMouseButtonPressed(button: MouseButton) bool {
    return cdef.IsMouseButtonPressed(button);
}

/// Check if a mouse button is being pressed
pub fn isMouseButtonDown(button: MouseButton) bool {
    return cdef.IsMouseButtonDown(button);
}

/// Check if a mouse button has been released once
pub fn isMouseButtonReleased(button: MouseButton) bool {
    return cdef.IsMouseButtonReleased(button);
}

/// Check if a mouse button is NOT being pressed
pub fn isMouseButtonUp(button: MouseButton) bool {
    return cdef.IsMouseButtonUp(button);
}

/// Get mouse position X
pub fn getMouseX() i32 {
    return @as(i32, cdef.GetMouseX());
}

/// Get mouse position Y
pub fn getMouseY() i32 {
    return @as(i32, cdef.GetMouseY());
}

/// Get mouse position XY
pub fn getMousePosition() Vector2 {
    return cdef.GetMousePosition();
}

/// Get mouse delta between frames
pub fn getMouseDelta() Vector2 {
    return cdef.GetMouseDelta();
}

/// Set mouse position XY
pub fn setMousePosition(x: i32, y: i32) void {
    cdef.SetMousePosition(@as(c_int, x), @as(c_int, y));
}

/// Set mouse offset
pub fn setMouseOffset(offsetX: i32, offsetY: i32) void {
    cdef.SetMouseOffset(@as(c_int, offsetX), @as(c_int, offsetY));
}

/// Set mouse scaling
pub fn setMouseScale(scaleX: f32, scaleY: f32) void {
    cdef.SetMouseScale(scaleX, scaleY);
}

/// Get mouse wheel movement for X or Y, whichever is larger
pub fn getMouseWheelMove() f32 {
    return cdef.GetMouseWheelMove();
}

/// Get mouse wheel movement for both X and Y
pub fn getMouseWheelMoveV() Vector2 {
    return cdef.GetMouseWheelMoveV();
}

/// Set mouse cursor
pub fn setMouseCursor(cursor: MouseCursor) void {
    cdef.SetMouseCursor(cursor);
}

/// Get touch position X for touch point 0 (relative to screen size)
pub fn getTouchX() i32 {
    return @as(i32, cdef.GetTouchX());
}

/// Get touch position Y for touch point 0 (relative to screen size)
pub fn getTouchY() i32 {
    return @as(i32, cdef.GetTouchY());
}

/// Get touch position XY for a touch point index (relative to screen size)
pub fn getTouchPosition(index: i32) Vector2 {
    return cdef.GetTouchPosition(@as(c_int, index));
}

/// Get touch point identifier for given index
pub fn getTouchPointId(index: i32) i32 {
    return @as(i32, cdef.GetTouchPointId(@as(c_int, index)));
}

/// Get number of touch points
pub fn getTouchPointCount() i32 {
    return @as(i32, cdef.GetTouchPointCount());
}

/// Enable a set of gestures using flags
pub fn setGesturesEnabled(flags: Gesture) void {
    cdef.SetGesturesEnabled(flags);
}

/// Check if a gesture have been detected
pub fn isGestureDetected(gesture: Gesture) bool {
    return cdef.IsGestureDetected(gesture);
}

/// Get latest detected gesture
pub fn getGestureDetected() Gesture {
    return cdef.GetGestureDetected();
}

/// Get gesture hold time in seconds
pub fn getGestureHoldDuration() f32 {
    return cdef.GetGestureHoldDuration();
}

/// Get gesture drag vector
pub fn getGestureDragVector() Vector2 {
    return cdef.GetGestureDragVector();
}

/// Get gesture drag angle
pub fn getGestureDragAngle() f32 {
    return cdef.GetGestureDragAngle();
}

/// Get gesture pinch delta
pub fn getGesturePinchVector() Vector2 {
    return cdef.GetGesturePinchVector();
}

/// Get gesture pinch angle
pub fn getGesturePinchAngle() f32 {
    return cdef.GetGesturePinchAngle();
}

/// Update camera position for selected mode
pub fn updateCamera(camera: *Camera, mode: CameraMode) void {
    cdef.UpdateCamera(@as([*c]Camera, @ptrCast(camera)), mode);
}

/// Update camera movement/rotation
pub fn updateCameraPro(camera: *Camera, movement: Vector3, rotation: Vector3, zoom: f32) void {
    cdef.UpdateCameraPro(@as([*c]Camera, @ptrCast(camera)), movement, rotation, zoom);
}

/// Set texture and rectangle to be used on shapes drawing
pub fn setShapesTexture(texture: Texture2D, source: Rectangle) void {
    cdef.SetShapesTexture(texture, source);
}

/// Get texture that is used for shapes drawing
pub fn getShapesTexture() Texture2D {
    return cdef.GetShapesTexture();
}

/// Get texture source rectangle that is used for shapes drawing
pub fn getShapesTextureRectangle() Rectangle {
    return cdef.GetShapesTextureRectangle();
}

/// Draw a pixel using geometry [Can be slow, use with care]
pub fn drawPixel(posX: i32, posY: i32, color: Color) void {
    cdef.DrawPixel(@as(c_int, posX), @as(c_int, posY), color);
}

/// Draw a pixel using geometry (Vector version) [Can be slow, use with care]
pub fn drawPixelV(position: Vector2, color: Color) void {
    cdef.DrawPixelV(position, color);
}

/// Draw a line
pub fn drawLine(startPosX: i32, startPosY: i32, endPosX: i32, endPosY: i32, color: Color) void {
    cdef.DrawLine(@as(c_int, startPosX), @as(c_int, startPosY), @as(c_int, endPosX), @as(c_int, endPosY), color);
}

/// Draw a line (using gl lines)
pub fn drawLineV(startPos: Vector2, endPos: Vector2, color: Color) void {
    cdef.DrawLineV(startPos, endPos, color);
}

/// Draw a line (using triangles/quads)
pub fn drawLineEx(startPos: Vector2, endPos: Vector2, thick: f32, color: Color) void {
    cdef.DrawLineEx(startPos, endPos, thick, color);
}

/// Draw line segment cubic-bezier in-out interpolation
pub fn drawLineBezier(startPos: Vector2, endPos: Vector2, thick: f32, color: Color) void {
    cdef.DrawLineBezier(startPos, endPos, thick, color);
}

/// Draw a dashed line
pub fn drawLineDashed(startPos: Vector2, endPos: Vector2, dashSize: i32, spaceSize: i32, color: Color) void {
    cdef.DrawLineDashed(startPos, endPos, @as(c_int, dashSize), @as(c_int, spaceSize), color);
}

/// Draw a color-filled circle
pub fn drawCircle(centerX: i32, centerY: i32, radius: f32, color: Color) void {
    cdef.DrawCircle(@as(c_int, centerX), @as(c_int, centerY), radius, color);
}

/// Draw a piece of a circle
pub fn drawCircleSector(center: Vector2, radius: f32, startAngle: f32, endAngle: f32, segments: i32, color: Color) void {
    cdef.DrawCircleSector(center, radius, startAngle, endAngle, @as(c_int, segments), color);
}

/// Draw circle sector outline
pub fn drawCircleSectorLines(center: Vector2, radius: f32, startAngle: f32, endAngle: f32, segments: i32, color: Color) void {
    cdef.DrawCircleSectorLines(center, radius, startAngle, endAngle, @as(c_int, segments), color);
}

/// Draw a gradient-filled circle
pub fn drawCircleGradient(centerX: i32, centerY: i32, radius: f32, inner: Color, outer: Color) void {
    cdef.DrawCircleGradient(@as(c_int, centerX), @as(c_int, centerY), radius, inner, outer);
}

/// Draw a color-filled circle (Vector version)
pub fn drawCircleV(center: Vector2, radius: f32, color: Color) void {
    cdef.DrawCircleV(center, radius, color);
}

/// Draw circle outline
pub fn drawCircleLines(centerX: i32, centerY: i32, radius: f32, color: Color) void {
    cdef.DrawCircleLines(@as(c_int, centerX), @as(c_int, centerY), radius, color);
}

/// Draw circle outline (Vector version)
pub fn drawCircleLinesV(center: Vector2, radius: f32, color: Color) void {
    cdef.DrawCircleLinesV(center, radius, color);
}

/// Draw ellipse
pub fn drawEllipse(centerX: i32, centerY: i32, radiusH: f32, radiusV: f32, color: Color) void {
    cdef.DrawEllipse(@as(c_int, centerX), @as(c_int, centerY), radiusH, radiusV, color);
}

/// Draw ellipse (Vector version)
pub fn drawEllipseV(center: Vector2, radiusH: f32, radiusV: f32, color: Color) void {
    cdef.DrawEllipseV(center, radiusH, radiusV, color);
}

/// Draw ellipse outline
pub fn drawEllipseLines(centerX: i32, centerY: i32, radiusH: f32, radiusV: f32, color: Color) void {
    cdef.DrawEllipseLines(@as(c_int, centerX), @as(c_int, centerY), radiusH, radiusV, color);
}

/// Draw ellipse outline (Vector version)
pub fn drawEllipseLinesV(center: Vector2, radiusH: f32, radiusV: f32, color: Color) void {
    cdef.DrawEllipseLinesV(center, radiusH, radiusV, color);
}

/// Draw ring
pub fn drawRing(center: Vector2, innerRadius: f32, outerRadius: f32, startAngle: f32, endAngle: f32, segments: i32, color: Color) void {
    cdef.DrawRing(center, innerRadius, outerRadius, startAngle, endAngle, @as(c_int, segments), color);
}

/// Draw ring outline
pub fn drawRingLines(center: Vector2, innerRadius: f32, outerRadius: f32, startAngle: f32, endAngle: f32, segments: i32, color: Color) void {
    cdef.DrawRingLines(center, innerRadius, outerRadius, startAngle, endAngle, @as(c_int, segments), color);
}

/// Draw a color-filled rectangle
pub fn drawRectangle(posX: i32, posY: i32, width: i32, height: i32, color: Color) void {
    cdef.DrawRectangle(@as(c_int, posX), @as(c_int, posY), @as(c_int, width), @as(c_int, height), color);
}

/// Draw a color-filled rectangle (Vector version)
pub fn drawRectangleV(position: Vector2, size: Vector2, color: Color) void {
    cdef.DrawRectangleV(position, size, color);
}

/// Draw a color-filled rectangle
pub fn drawRectangleRec(rec: Rectangle, color: Color) void {
    cdef.DrawRectangleRec(rec, color);
}

/// Draw a color-filled rectangle with pro parameters
pub fn drawRectanglePro(rec: Rectangle, origin: Vector2, rotation: f32, color: Color) void {
    cdef.DrawRectanglePro(rec, origin, rotation, color);
}

/// Draw a vertical-gradient-filled rectangle
pub fn drawRectangleGradientV(posX: i32, posY: i32, width: i32, height: i32, top: Color, bottom: Color) void {
    cdef.DrawRectangleGradientV(@as(c_int, posX), @as(c_int, posY), @as(c_int, width), @as(c_int, height), top, bottom);
}

/// Draw a horizontal-gradient-filled rectangle
pub fn drawRectangleGradientH(posX: i32, posY: i32, width: i32, height: i32, left: Color, right: Color) void {
    cdef.DrawRectangleGradientH(@as(c_int, posX), @as(c_int, posY), @as(c_int, width), @as(c_int, height), left, right);
}

/// Draw a gradient-filled rectangle with custom vertex colors
pub fn drawRectangleGradientEx(rec: Rectangle, topLeft: Color, bottomLeft: Color, bottomRight: Color, topRight: Color) void {
    cdef.DrawRectangleGradientEx(rec, topLeft, bottomLeft, bottomRight, topRight);
}

/// Draw rectangle outline
pub fn drawRectangleLines(posX: i32, posY: i32, width: i32, height: i32, color: Color) void {
    cdef.DrawRectangleLines(@as(c_int, posX), @as(c_int, posY), @as(c_int, width), @as(c_int, height), color);
}

/// Draw rectangle outline with extended parameters
pub fn drawRectangleLinesEx(rec: Rectangle, lineThick: f32, color: Color) void {
    cdef.DrawRectangleLinesEx(rec, lineThick, color);
}

/// Draw rectangle with rounded edges
pub fn drawRectangleRounded(rec: Rectangle, roundness: f32, segments: i32, color: Color) void {
    cdef.DrawRectangleRounded(rec, roundness, @as(c_int, segments), color);
}

/// Draw rectangle lines with rounded edges
pub fn drawRectangleRoundedLines(rec: Rectangle, roundness: f32, segments: i32, color: Color) void {
    cdef.DrawRectangleRoundedLines(rec, roundness, @as(c_int, segments), color);
}

/// Draw rectangle with rounded edges outline
pub fn drawRectangleRoundedLinesEx(rec: Rectangle, roundness: f32, segments: i32, lineThick: f32, color: Color) void {
    cdef.DrawRectangleRoundedLinesEx(rec, roundness, @as(c_int, segments), lineThick, color);
}

/// Draw a color-filled triangle (vertex in counter-clockwise order!)
pub fn drawTriangle(v1: Vector2, v2: Vector2, v3: Vector2, color: Color) void {
    cdef.DrawTriangle(v1, v2, v3, color);
}

/// Draw triangle outline (vertex in counter-clockwise order!)
pub fn drawTriangleLines(v1: Vector2, v2: Vector2, v3: Vector2, color: Color) void {
    cdef.DrawTriangleLines(v1, v2, v3, color);
}

/// Draw a regular polygon (Vector version)
pub fn drawPoly(center: Vector2, sides: i32, radius: f32, rotation: f32, color: Color) void {
    cdef.DrawPoly(center, @as(c_int, sides), radius, rotation, color);
}

/// Draw a polygon outline of n sides
pub fn drawPolyLines(center: Vector2, sides: i32, radius: f32, rotation: f32, color: Color) void {
    cdef.DrawPolyLines(center, @as(c_int, sides), radius, rotation, color);
}

/// Draw a polygon outline of n sides with extended parameters
pub fn drawPolyLinesEx(center: Vector2, sides: i32, radius: f32, rotation: f32, lineThick: f32, color: Color) void {
    cdef.DrawPolyLinesEx(center, @as(c_int, sides), radius, rotation, lineThick, color);
}

/// Draw spline segment: Linear, 2 points
pub fn drawSplineSegmentLinear(p1: Vector2, p2: Vector2, thick: f32, color: Color) void {
    cdef.DrawSplineSegmentLinear(p1, p2, thick, color);
}

/// Draw spline segment: B-Spline, 4 points
pub fn drawSplineSegmentBasis(p1: Vector2, p2: Vector2, p3: Vector2, p4: Vector2, thick: f32, color: Color) void {
    cdef.DrawSplineSegmentBasis(p1, p2, p3, p4, thick, color);
}

/// Draw spline segment: Catmull-Rom, 4 points
pub fn drawSplineSegmentCatmullRom(p1: Vector2, p2: Vector2, p3: Vector2, p4: Vector2, thick: f32, color: Color) void {
    cdef.DrawSplineSegmentCatmullRom(p1, p2, p3, p4, thick, color);
}

/// Draw spline segment: Quadratic Bezier, 2 points, 1 control point
pub fn drawSplineSegmentBezierQuadratic(p1: Vector2, c2: Vector2, p3: Vector2, thick: f32, color: Color) void {
    cdef.DrawSplineSegmentBezierQuadratic(p1, c2, p3, thick, color);
}

/// Draw spline segment: Cubic Bezier, 2 points, 2 control points
pub fn drawSplineSegmentBezierCubic(p1: Vector2, c2: Vector2, c3: Vector2, p4: Vector2, thick: f32, color: Color) void {
    cdef.DrawSplineSegmentBezierCubic(p1, c2, c3, p4, thick, color);
}

/// Get (evaluate) spline point: Linear
pub fn getSplinePointLinear(startPos: Vector2, endPos: Vector2, t: f32) Vector2 {
    return cdef.GetSplinePointLinear(startPos, endPos, t);
}

/// Get (evaluate) spline point: B-Spline
pub fn getSplinePointBasis(p1: Vector2, p2: Vector2, p3: Vector2, p4: Vector2, t: f32) Vector2 {
    return cdef.GetSplinePointBasis(p1, p2, p3, p4, t);
}

/// Get (evaluate) spline point: Catmull-Rom
pub fn getSplinePointCatmullRom(p1: Vector2, p2: Vector2, p3: Vector2, p4: Vector2, t: f32) Vector2 {
    return cdef.GetSplinePointCatmullRom(p1, p2, p3, p4, t);
}

/// Get (evaluate) spline point: Quadratic Bezier
pub fn getSplinePointBezierQuad(p1: Vector2, c2: Vector2, p3: Vector2, t: f32) Vector2 {
    return cdef.GetSplinePointBezierQuad(p1, c2, p3, t);
}

/// Get (evaluate) spline point: Cubic Bezier
pub fn getSplinePointBezierCubic(p1: Vector2, c2: Vector2, c3: Vector2, p4: Vector2, t: f32) Vector2 {
    return cdef.GetSplinePointBezierCubic(p1, c2, c3, p4, t);
}

/// Check collision between two rectangles
pub fn checkCollisionRecs(rec1: Rectangle, rec2: Rectangle) bool {
    return cdef.CheckCollisionRecs(rec1, rec2);
}

/// Check collision between two circles
pub fn checkCollisionCircles(center1: Vector2, radius1: f32, center2: Vector2, radius2: f32) bool {
    return cdef.CheckCollisionCircles(center1, radius1, center2, radius2);
}

/// Check collision between circle and rectangle
pub fn checkCollisionCircleRec(center: Vector2, radius: f32, rec: Rectangle) bool {
    return cdef.CheckCollisionCircleRec(center, radius, rec);
}

/// Check if circle collides with a line created betweeen two points [p1] and [p2]
pub fn checkCollisionCircleLine(center: Vector2, radius: f32, p1: Vector2, p2: Vector2) bool {
    return cdef.CheckCollisionCircleLine(center, radius, p1, p2);
}

/// Check if point is inside rectangle
pub fn checkCollisionPointRec(point: Vector2, rec: Rectangle) bool {
    return cdef.CheckCollisionPointRec(point, rec);
}

/// Check if point is inside circle
pub fn checkCollisionPointCircle(point: Vector2, center: Vector2, radius: f32) bool {
    return cdef.CheckCollisionPointCircle(point, center, radius);
}

/// Check if point is inside a triangle
pub fn checkCollisionPointTriangle(point: Vector2, p1: Vector2, p2: Vector2, p3: Vector2) bool {
    return cdef.CheckCollisionPointTriangle(point, p1, p2, p3);
}

/// Check if point belongs to line created between two points [p1] and [p2] with defined margin in pixels [threshold]
pub fn checkCollisionPointLine(point: Vector2, p1: Vector2, p2: Vector2, threshold: i32) bool {
    return cdef.CheckCollisionPointLine(point, p1, p2, @as(c_int, threshold));
}

/// Check the collision between two lines defined by two points each, returns collision point by reference
pub fn checkCollisionLines(startPos1: Vector2, endPos1: Vector2, startPos2: Vector2, endPos2: Vector2, collisionPoint: *Vector2) bool {
    return cdef.CheckCollisionLines(startPos1, endPos1, startPos2, endPos2, @as([*c]Vector2, @ptrCast(collisionPoint)));
}

/// Get collision rectangle for two rectangles collision
pub fn getCollisionRec(rec1: Rectangle, rec2: Rectangle) Rectangle {
    return cdef.GetCollisionRec(rec1, rec2);
}

/// Check if an image is valid (data and parameters)
pub fn isImageValid(image: Image) bool {
    return cdef.IsImageValid(image);
}

/// Unload image from CPU memory (RAM)
pub fn unloadImage(image: Image) void {
    cdef.UnloadImage(image);
}

/// Export image data to file, returns true on success
pub fn exportImage(image: Image, fileName: [:0]const u8) bool {
    return cdef.ExportImage(image, @as([*c]const u8, @ptrCast(fileName)));
}

/// Export image to memory buffer
pub fn exportImageToMemory(image: Image, fileType: []const u8) RaylibError![]u8 {
    var _len: i32 = 0;
    const _ptr = cdef.ExportImageToMemory(image, @as([*c]const u8, @ptrCast(fileType)), @as([*c]c_int, @ptrCast(&_len)));
    if (_ptr == 0) return RaylibError.ExportImageToMemory;
    return _ptr[0..@as(usize, @intCast(_len))];
}

/// Export image as code file defining an array of bytes, returns true on success
pub fn exportImageAsCode(image: Image, fileName: [:0]const u8) bool {
    return cdef.ExportImageAsCode(image, @as([*c]const u8, @ptrCast(fileName)));
}

/// Generate image: plain color
pub fn genImageColor(width: i32, height: i32, color: Color) Image {
    return cdef.GenImageColor(@as(c_int, width), @as(c_int, height), color);
}

/// Generate image: linear gradient, direction in degrees [0..360], 0=Vertical gradient
pub fn genImageGradientLinear(width: i32, height: i32, direction: i32, start: Color, end: Color) Image {
    return cdef.GenImageGradientLinear(@as(c_int, width), @as(c_int, height), @as(c_int, direction), start, end);
}

/// Generate image: radial gradient
pub fn genImageGradientRadial(width: i32, height: i32, density: f32, inner: Color, outer: Color) Image {
    return cdef.GenImageGradientRadial(@as(c_int, width), @as(c_int, height), density, inner, outer);
}

/// Generate image: square gradient
pub fn genImageGradientSquare(width: i32, height: i32, density: f32, inner: Color, outer: Color) Image {
    return cdef.GenImageGradientSquare(@as(c_int, width), @as(c_int, height), density, inner, outer);
}

/// Generate image: checked
pub fn genImageChecked(width: i32, height: i32, checksX: i32, checksY: i32, col1: Color, col2: Color) Image {
    return cdef.GenImageChecked(@as(c_int, width), @as(c_int, height), @as(c_int, checksX), @as(c_int, checksY), col1, col2);
}

/// Generate image: white noise
pub fn genImageWhiteNoise(width: i32, height: i32, factor: f32) Image {
    return cdef.GenImageWhiteNoise(@as(c_int, width), @as(c_int, height), factor);
}

/// Generate image: perlin noise
pub fn genImagePerlinNoise(width: i32, height: i32, offsetX: i32, offsetY: i32, scale: f32) Image {
    return cdef.GenImagePerlinNoise(@as(c_int, width), @as(c_int, height), @as(c_int, offsetX), @as(c_int, offsetY), scale);
}

/// Generate image: cellular algorithm, bigger tileSize means bigger cells
pub fn genImageCellular(width: i32, height: i32, tileSize: i32) Image {
    return cdef.GenImageCellular(@as(c_int, width), @as(c_int, height), @as(c_int, tileSize));
}

/// Generate image: grayscale image from text data
pub fn genImageText(width: i32, height: i32, text: [:0]const u8) Image {
    return cdef.GenImageText(@as(c_int, width), @as(c_int, height), @as([*c]const u8, @ptrCast(text)));
}

/// Create an image duplicate (useful for transformations)
pub fn imageCopy(image: Image) Image {
    return cdef.ImageCopy(image);
}

/// Create an image from another image piece
pub fn imageFromImage(image: Image, rec: Rectangle) Image {
    return cdef.ImageFromImage(image, rec);
}

/// Create an image from a selected channel of another image (GRAYSCALE)
pub fn imageFromChannel(image: Image, selectedChannel: i32) Image {
    return cdef.ImageFromChannel(image, @as(c_int, selectedChannel));
}

/// Convert image data to desired format
pub fn imageFormat(image: *Image, newFormat: PixelFormat) void {
    cdef.ImageFormat(@as([*c]Image, @ptrCast(image)), newFormat);
}

/// Convert image to POT (power-of-two)
pub fn imageToPOT(image: *Image, fill: Color) void {
    cdef.ImageToPOT(@as([*c]Image, @ptrCast(image)), fill);
}

/// Crop an image to a defined rectangle
pub fn imageCrop(image: *Image, crop: Rectangle) void {
    cdef.ImageCrop(@as([*c]Image, @ptrCast(image)), crop);
}

/// Crop image depending on alpha value
pub fn imageAlphaCrop(image: *Image, threshold: f32) void {
    cdef.ImageAlphaCrop(@as([*c]Image, @ptrCast(image)), threshold);
}

/// Clear alpha channel to desired color
pub fn imageAlphaClear(image: *Image, color: Color, threshold: f32) void {
    cdef.ImageAlphaClear(@as([*c]Image, @ptrCast(image)), color, threshold);
}

/// Apply alpha mask to image
pub fn imageAlphaMask(image: *Image, alphaMask: Image) void {
    cdef.ImageAlphaMask(@as([*c]Image, @ptrCast(image)), alphaMask);
}

/// Premultiply alpha channel
pub fn imageAlphaPremultiply(image: *Image) void {
    cdef.ImageAlphaPremultiply(@as([*c]Image, @ptrCast(image)));
}

/// Apply Gaussian blur using a box blur approximation
pub fn imageBlurGaussian(image: *Image, blurSize: i32) void {
    cdef.ImageBlurGaussian(@as([*c]Image, @ptrCast(image)), @as(c_int, blurSize));
}

/// Resize image (Bicubic scaling algorithm)
pub fn imageResize(image: *Image, newWidth: i32, newHeight: i32) void {
    cdef.ImageResize(@as([*c]Image, @ptrCast(image)), @as(c_int, newWidth), @as(c_int, newHeight));
}

/// Resize image (Nearest-Neighbor scaling algorithm)
pub fn imageResizeNN(image: *Image, newWidth: i32, newHeight: i32) void {
    cdef.ImageResizeNN(@as([*c]Image, @ptrCast(image)), @as(c_int, newWidth), @as(c_int, newHeight));
}

/// Resize canvas and fill with color
pub fn imageResizeCanvas(image: *Image, newWidth: i32, newHeight: i32, offsetX: i32, offsetY: i32, fill: Color) void {
    cdef.ImageResizeCanvas(@as([*c]Image, @ptrCast(image)), @as(c_int, newWidth), @as(c_int, newHeight), @as(c_int, offsetX), @as(c_int, offsetY), fill);
}

/// Compute all mipmap levels for a provided image
pub fn imageMipmaps(image: *Image) void {
    cdef.ImageMipmaps(@as([*c]Image, @ptrCast(image)));
}

/// Dither image data to 16bpp or lower (Floyd-Steinberg dithering)
pub fn imageDither(image: *Image, rBpp: i32, gBpp: i32, bBpp: i32, aBpp: i32) void {
    cdef.ImageDither(@as([*c]Image, @ptrCast(image)), @as(c_int, rBpp), @as(c_int, gBpp), @as(c_int, bBpp), @as(c_int, aBpp));
}

/// Flip image vertically
pub fn imageFlipVertical(image: *Image) void {
    cdef.ImageFlipVertical(@as([*c]Image, @ptrCast(image)));
}

/// Flip image horizontally
pub fn imageFlipHorizontal(image: *Image) void {
    cdef.ImageFlipHorizontal(@as([*c]Image, @ptrCast(image)));
}

/// Rotate image by input angle in degrees (-359 to 359)
pub fn imageRotate(image: *Image, degrees: i32) void {
    cdef.ImageRotate(@as([*c]Image, @ptrCast(image)), @as(c_int, degrees));
}

/// Rotate image clockwise 90deg
pub fn imageRotateCW(image: *Image) void {
    cdef.ImageRotateCW(@as([*c]Image, @ptrCast(image)));
}

/// Rotate image counter-clockwise 90deg
pub fn imageRotateCCW(image: *Image) void {
    cdef.ImageRotateCCW(@as([*c]Image, @ptrCast(image)));
}

/// Modify image color: tint
pub fn imageColorTint(image: *Image, color: Color) void {
    cdef.ImageColorTint(@as([*c]Image, @ptrCast(image)), color);
}

/// Modify image color: invert
pub fn imageColorInvert(image: *Image) void {
    cdef.ImageColorInvert(@as([*c]Image, @ptrCast(image)));
}

/// Modify image color: grayscale
pub fn imageColorGrayscale(image: *Image) void {
    cdef.ImageColorGrayscale(@as([*c]Image, @ptrCast(image)));
}

/// Modify image color: contrast (-100 to 100)
pub fn imageColorContrast(image: *Image, contrast: f32) void {
    cdef.ImageColorContrast(@as([*c]Image, @ptrCast(image)), contrast);
}

/// Modify image color: brightness (-255 to 255)
pub fn imageColorBrightness(image: *Image, brightness: i32) void {
    cdef.ImageColorBrightness(@as([*c]Image, @ptrCast(image)), @as(c_int, brightness));
}

/// Modify image color: replace color
pub fn imageColorReplace(image: *Image, color: Color, replace: Color) void {
    cdef.ImageColorReplace(@as([*c]Image, @ptrCast(image)), color, replace);
}

/// Load colors palette from image as a Color array (RGBA - 32bit)
pub fn loadImagePalette(image: Image, maxPaletteSize: i32) RaylibError![]Color {
    var _len: i32 = 0;
    const _ptr = cdef.LoadImagePalette(image, @as(c_int, maxPaletteSize), @as([*c]c_int, @ptrCast(&_len)));
    if (_ptr == 0) return RaylibError.LoadImagePalette;
    return _ptr[0..@as(usize, @intCast(_len))];
}

/// Unload color data loaded with LoadImageColors()
pub fn unloadImageColors(colors: []Color) void {
    cdef.UnloadImageColors(@as([*c]Color, @ptrCast(colors)));
}

/// Unload colors palette loaded with LoadImagePalette()
pub fn unloadImagePalette(colors: []Color) void {
    cdef.UnloadImagePalette(@as([*c]Color, @ptrCast(colors)));
}

/// Get image alpha border rectangle
pub fn getImageAlphaBorder(image: Image, threshold: f32) Rectangle {
    return cdef.GetImageAlphaBorder(image, threshold);
}

/// Get image pixel color at (x, y) position
pub fn getImageColor(image: Image, x: i32, y: i32) Color {
    return cdef.GetImageColor(image, @as(c_int, x), @as(c_int, y));
}

/// Clear image background with given color
pub fn imageClearBackground(dst: *Image, color: Color) void {
    cdef.ImageClearBackground(@as([*c]Image, @ptrCast(dst)), color);
}

/// Draw pixel within an image
pub fn imageDrawPixel(dst: *Image, posX: i32, posY: i32, color: Color) void {
    cdef.ImageDrawPixel(@as([*c]Image, @ptrCast(dst)), @as(c_int, posX), @as(c_int, posY), color);
}

/// Draw pixel within an image (Vector version)
pub fn imageDrawPixelV(dst: *Image, position: Vector2, color: Color) void {
    cdef.ImageDrawPixelV(@as([*c]Image, @ptrCast(dst)), position, color);
}

/// Draw line within an image
pub fn imageDrawLine(dst: *Image, startPosX: i32, startPosY: i32, endPosX: i32, endPosY: i32, color: Color) void {
    cdef.ImageDrawLine(@as([*c]Image, @ptrCast(dst)), @as(c_int, startPosX), @as(c_int, startPosY), @as(c_int, endPosX), @as(c_int, endPosY), color);
}

/// Draw line within an image (Vector version)
pub fn imageDrawLineV(dst: *Image, start: Vector2, end: Vector2, color: Color) void {
    cdef.ImageDrawLineV(@as([*c]Image, @ptrCast(dst)), start, end, color);
}

/// Draw a line defining thickness within an image
pub fn imageDrawLineEx(dst: *Image, start: Vector2, end: Vector2, thick: i32, color: Color) void {
    cdef.ImageDrawLineEx(@as([*c]Image, @ptrCast(dst)), start, end, @as(c_int, thick), color);
}

/// Draw a filled circle within an image
pub fn imageDrawCircle(dst: *Image, centerX: i32, centerY: i32, radius: i32, color: Color) void {
    cdef.ImageDrawCircle(@as([*c]Image, @ptrCast(dst)), @as(c_int, centerX), @as(c_int, centerY), @as(c_int, radius), color);
}

/// Draw a filled circle within an image (Vector version)
pub fn imageDrawCircleV(dst: *Image, center: Vector2, radius: i32, color: Color) void {
    cdef.ImageDrawCircleV(@as([*c]Image, @ptrCast(dst)), center, @as(c_int, radius), color);
}

/// Draw circle outline within an image
pub fn imageDrawCircleLines(dst: *Image, centerX: i32, centerY: i32, radius: i32, color: Color) void {
    cdef.ImageDrawCircleLines(@as([*c]Image, @ptrCast(dst)), @as(c_int, centerX), @as(c_int, centerY), @as(c_int, radius), color);
}

/// Draw circle outline within an image (Vector version)
pub fn imageDrawCircleLinesV(dst: *Image, center: Vector2, radius: i32, color: Color) void {
    cdef.ImageDrawCircleLinesV(@as([*c]Image, @ptrCast(dst)), center, @as(c_int, radius), color);
}

/// Draw rectangle within an image
pub fn imageDrawRectangle(dst: *Image, posX: i32, posY: i32, width: i32, height: i32, color: Color) void {
    cdef.ImageDrawRectangle(@as([*c]Image, @ptrCast(dst)), @as(c_int, posX), @as(c_int, posY), @as(c_int, width), @as(c_int, height), color);
}

/// Draw rectangle within an image (Vector version)
pub fn imageDrawRectangleV(dst: *Image, position: Vector2, size: Vector2, color: Color) void {
    cdef.ImageDrawRectangleV(@as([*c]Image, @ptrCast(dst)), position, size, color);
}

/// Draw rectangle within an image
pub fn imageDrawRectangleRec(dst: *Image, rec: Rectangle, color: Color) void {
    cdef.ImageDrawRectangleRec(@as([*c]Image, @ptrCast(dst)), rec, color);
}

/// Draw rectangle lines within an image
pub fn imageDrawRectangleLines(dst: *Image, rec: Rectangle, thick: i32, color: Color) void {
    cdef.ImageDrawRectangleLines(@as([*c]Image, @ptrCast(dst)), rec, @as(c_int, thick), color);
}

/// Draw triangle within an image
pub fn imageDrawTriangle(dst: *Image, v1: Vector2, v2: Vector2, v3: Vector2, color: Color) void {
    cdef.ImageDrawTriangle(@as([*c]Image, @ptrCast(dst)), v1, v2, v3, color);
}

/// Draw triangle with interpolated colors within an image
pub fn imageDrawTriangleEx(dst: *Image, v1: Vector2, v2: Vector2, v3: Vector2, c1: Color, c2: Color, c3: Color) void {
    cdef.ImageDrawTriangleEx(@as([*c]Image, @ptrCast(dst)), v1, v2, v3, c1, c2, c3);
}

/// Draw triangle outline within an image
pub fn imageDrawTriangleLines(dst: *Image, v1: Vector2, v2: Vector2, v3: Vector2, color: Color) void {
    cdef.ImageDrawTriangleLines(@as([*c]Image, @ptrCast(dst)), v1, v2, v3, color);
}

/// Draw a triangle fan defined by points within an image (first vertex is the center)
pub fn imageDrawTriangleFan(dst: *Image, points: []const Vector2, pointCount: i32, color: Color) void {
    cdef.ImageDrawTriangleFan(@as([*c]Image, @ptrCast(dst)), @as([*c]const Vector2, @ptrCast(points)), @as(c_int, pointCount), color);
}

/// Draw a triangle strip defined by points within an image
pub fn imageDrawTriangleStrip(dst: *Image, points: []const Vector2, pointCount: i32, color: Color) void {
    cdef.ImageDrawTriangleStrip(@as([*c]Image, @ptrCast(dst)), @as([*c]const Vector2, @ptrCast(points)), @as(c_int, pointCount), color);
}

/// Draw a source image within a destination image (tint applied to source)
pub fn imageDraw(dst: *Image, src: Image, srcRec: Rectangle, dstRec: Rectangle, tint: Color) void {
    cdef.ImageDraw(@as([*c]Image, @ptrCast(dst)), src, srcRec, dstRec, tint);
}

/// Draw text (using default font) within an image (destination)
pub fn imageDrawText(dst: *Image, text: [:0]const u8, posX: i32, posY: i32, fontSize: i32, color: Color) void {
    cdef.ImageDrawText(@as([*c]Image, @ptrCast(dst)), @as([*c]const u8, @ptrCast(text)), @as(c_int, posX), @as(c_int, posY), @as(c_int, fontSize), color);
}

/// Draw text (custom sprite font) within an image (destination)
pub fn imageDrawTextEx(dst: *Image, font: Font, text: [:0]const u8, position: Vector2, fontSize: f32, spacing: f32, tint: Color) void {
    cdef.ImageDrawTextEx(@as([*c]Image, @ptrCast(dst)), font, @as([*c]const u8, @ptrCast(text)), position, fontSize, spacing, tint);
}

/// Check if a texture is valid (loaded in GPU)
pub fn isTextureValid(texture: Texture2D) bool {
    return cdef.IsTextureValid(texture);
}

/// Unload texture from GPU memory (VRAM)
pub fn unloadTexture(texture: Texture2D) void {
    cdef.UnloadTexture(texture);
}

/// Check if a render texture is valid (loaded in GPU)
pub fn isRenderTextureValid(target: RenderTexture2D) bool {
    return cdef.IsRenderTextureValid(target);
}

/// Unload render texture from GPU memory (VRAM)
pub fn unloadRenderTexture(target: RenderTexture2D) void {
    cdef.UnloadRenderTexture(target);
}

/// Update GPU texture with new data (pixels should be able to fill texture)
pub fn updateTexture(texture: Texture2D, pixels: *const anyopaque) void {
    cdef.UpdateTexture(texture, pixels);
}

/// Update GPU texture rectangle with new data (pixels and rec should fit in texture)
pub fn updateTextureRec(texture: Texture2D, rec: Rectangle, pixels: *const anyopaque) void {
    cdef.UpdateTextureRec(texture, rec, pixels);
}

/// Generate GPU mipmaps for a texture
pub fn genTextureMipmaps(texture: *Texture2D) void {
    cdef.GenTextureMipmaps(@as([*c]Texture2D, @ptrCast(texture)));
}

/// Set texture scaling filter mode
pub fn setTextureFilter(texture: Texture2D, filter: TextureFilter) void {
    cdef.SetTextureFilter(texture, filter);
}

/// Set texture wrapping mode
pub fn setTextureWrap(texture: Texture2D, wrap: TextureWrap) void {
    cdef.SetTextureWrap(texture, wrap);
}

/// Draw a Texture2D
pub fn drawTexture(texture: Texture2D, posX: i32, posY: i32, tint: Color) void {
    cdef.DrawTexture(texture, @as(c_int, posX), @as(c_int, posY), tint);
}

/// Draw a Texture2D with position defined as Vector2
pub fn drawTextureV(texture: Texture2D, position: Vector2, tint: Color) void {
    cdef.DrawTextureV(texture, position, tint);
}

/// Draw a Texture2D with extended parameters
pub fn drawTextureEx(texture: Texture2D, position: Vector2, rotation: f32, scale: f32, tint: Color) void {
    cdef.DrawTextureEx(texture, position, rotation, scale, tint);
}

/// Draw a part of a texture defined by a rectangle
pub fn drawTextureRec(texture: Texture2D, source: Rectangle, position: Vector2, tint: Color) void {
    cdef.DrawTextureRec(texture, source, position, tint);
}

/// Draw a part of a texture defined by a rectangle with 'pro' parameters
pub fn drawTexturePro(texture: Texture2D, source: Rectangle, dest: Rectangle, origin: Vector2, rotation: f32, tint: Color) void {
    cdef.DrawTexturePro(texture, source, dest, origin, rotation, tint);
}

/// Draws a texture (or part of it) that stretches or shrinks nicely
pub fn drawTextureNPatch(texture: Texture2D, nPatchInfo: NPatchInfo, dest: Rectangle, origin: Vector2, rotation: f32, tint: Color) void {
    cdef.DrawTextureNPatch(texture, nPatchInfo, dest, origin, rotation, tint);
}

/// Check if two colors are equal
pub fn colorIsEqual(col1: Color, col2: Color) bool {
    return cdef.ColorIsEqual(col1, col2);
}

/// Get color with alpha applied, alpha goes from 0.0f to 1.0f
pub fn fade(color: Color, alpha: f32) Color {
    return cdef.Fade(color, alpha);
}

/// Get Color normalized as float [0..1]
pub fn colorNormalize(color: Color) Vector4 {
    return cdef.ColorNormalize(color);
}

/// Get Color from normalized values [0..1]
pub fn colorFromNormalized(normalized: Vector4) Color {
    return cdef.ColorFromNormalized(normalized);
}

/// Get HSV values for a Color, hue [0..360], saturation/value [0..1]
pub fn colorToHSV(color: Color) Vector3 {
    return cdef.ColorToHSV(color);
}

/// Get a Color from HSV values, hue [0..360], saturation/value [0..1]
pub fn colorFromHSV(hue: f32, saturation: f32, value: f32) Color {
    return cdef.ColorFromHSV(hue, saturation, value);
}

/// Get color multiplied with another color
pub fn colorTint(color: Color, tint: Color) Color {
    return cdef.ColorTint(color, tint);
}

/// Get color with brightness correction, brightness factor goes from -1.0f to 1.0f
pub fn colorBrightness(color: Color, factor: f32) Color {
    return cdef.ColorBrightness(color, factor);
}

/// Get color with contrast correction, contrast values between -1.0f and 1.0f
pub fn colorContrast(color: Color, contrast: f32) Color {
    return cdef.ColorContrast(color, contrast);
}

/// Get color with alpha applied, alpha goes from 0.0f to 1.0f
pub fn colorAlpha(color: Color, alpha: f32) Color {
    return cdef.ColorAlpha(color, alpha);
}

/// Get src alpha-blended into dst color with tint
pub fn colorAlphaBlend(dst: Color, src: Color, tint: Color) Color {
    return cdef.ColorAlphaBlend(dst, src, tint);
}

/// Get color lerp interpolation between two colors, factor [0.0f..1.0f]
pub fn colorLerp(color1: Color, color2: Color, factor: f32) Color {
    return cdef.ColorLerp(color1, color2, factor);
}

/// Get Color structure from hexadecimal value
pub fn getColor(hexValue: u32) Color {
    return cdef.GetColor(@as(c_uint, hexValue));
}

/// Get Color from a source pixel pointer of certain format
pub fn getPixelColor(srcPtr: *anyopaque, format: PixelFormat) Color {
    return cdef.GetPixelColor(srcPtr, format);
}

/// Set color formatted into destination pixel pointer
pub fn setPixelColor(dstPtr: *anyopaque, color: Color, format: PixelFormat) void {
    cdef.SetPixelColor(dstPtr, color, format);
}

/// Get pixel data size in bytes for certain format
pub fn getPixelDataSize(width: i32, height: i32, format: PixelFormat) i32 {
    return @as(i32, cdef.GetPixelDataSize(@as(c_int, width), @as(c_int, height), format));
}

/// Check if a font is valid (font data loaded, WARNING: GPU texture not checked)
pub fn isFontValid(font: Font) bool {
    return cdef.IsFontValid(font);
}

/// Unload font from GPU memory (VRAM)
pub fn unloadFont(font: Font) void {
    cdef.UnloadFont(font);
}

/// Export font as code file, returns true on success
pub fn exportFontAsCode(font: Font, fileName: [:0]const u8) bool {
    return cdef.ExportFontAsCode(font, @as([*c]const u8, @ptrCast(fileName)));
}

/// Draw current FPS
pub fn drawFPS(posX: i32, posY: i32) void {
    cdef.DrawFPS(@as(c_int, posX), @as(c_int, posY));
}

/// Draw text (using default font)
pub fn drawText(text: [:0]const u8, posX: i32, posY: i32, fontSize: i32, color: Color) void {
    cdef.DrawText(@as([*c]const u8, @ptrCast(text)), @as(c_int, posX), @as(c_int, posY), @as(c_int, fontSize), color);
}

/// Draw text using font and additional parameters
pub fn drawTextEx(font: Font, text: [:0]const u8, position: Vector2, fontSize: f32, spacing: f32, tint: Color) void {
    cdef.DrawTextEx(font, @as([*c]const u8, @ptrCast(text)), position, fontSize, spacing, tint);
}

/// Draw text using Font and pro parameters (rotation)
pub fn drawTextPro(font: Font, text: [:0]const u8, position: Vector2, origin: Vector2, rotation: f32, fontSize: f32, spacing: f32, tint: Color) void {
    cdef.DrawTextPro(font, @as([*c]const u8, @ptrCast(text)), position, origin, rotation, fontSize, spacing, tint);
}

/// Draw one character (codepoint)
pub fn drawTextCodepoint(font: Font, codepoint: i32, position: Vector2, fontSize: f32, tint: Color) void {
    cdef.DrawTextCodepoint(font, @as(c_int, codepoint), position, fontSize, tint);
}

/// Set vertical line spacing when drawing with line-breaks
pub fn setTextLineSpacing(spacing: i32) void {
    cdef.SetTextLineSpacing(@as(c_int, spacing));
}

/// Measure string width for default font
pub fn measureText(text: [:0]const u8, fontSize: i32) i32 {
    return @as(i32, cdef.MeasureText(@as([*c]const u8, @ptrCast(text)), @as(c_int, fontSize)));
}

/// Measure string size for Font
pub fn measureTextEx(font: Font, text: [:0]const u8, fontSize: f32, spacing: f32) Vector2 {
    return cdef.MeasureTextEx(font, @as([*c]const u8, @ptrCast(text)), fontSize, spacing);
}

/// Get glyph index position in font for a codepoint (unicode character), fallback to '?' if not found
pub fn getGlyphIndex(font: Font, codepoint: i32) i32 {
    return @as(i32, cdef.GetGlyphIndex(font, @as(c_int, codepoint)));
}

/// Get glyph font info data for a codepoint (unicode character), fallback to '?' if not found
pub fn getGlyphInfo(font: Font, codepoint: i32) GlyphInfo {
    return cdef.GetGlyphInfo(font, @as(c_int, codepoint));
}

/// Get glyph rectangle in font atlas for a codepoint (unicode character), fallback to '?' if not found
pub fn getGlyphAtlasRec(font: Font, codepoint: i32) Rectangle {
    return cdef.GetGlyphAtlasRec(font, @as(c_int, codepoint));
}

/// Unload UTF-8 text encoded from codepoints array
pub fn unloadUTF8(text: [:0]u8) void {
    cdef.UnloadUTF8(@as([*c]u8, @ptrCast(text)));
}

/// Load all codepoints from a UTF-8 text string, codepoints count returned by parameter
pub fn loadCodepoints(text: []const u8) RaylibError![]i32 {
    var _len: i32 = 0;
    const _ptr = cdef.LoadCodepoints(@as([*c]const u8, @ptrCast(text)), @as([*c]c_int, @ptrCast(&_len)));
    if (_ptr == 0) return RaylibError.LoadCodepoints;
    return _ptr[0..@as(usize, @intCast(_len))];
}

/// Unload codepoints data from memory
pub fn unloadCodepoints(codepoints: []i32) void {
    cdef.UnloadCodepoints(@as([*c]c_int, @ptrCast(codepoints)));
}

/// Get total number of codepoints in a UTF-8 encoded string
pub fn getCodepointCount(text: [:0]const u8) i32 {
    return @as(i32, cdef.GetCodepointCount(@as([*c]const u8, @ptrCast(text))));
}

/// Get next codepoint in a UTF-8 encoded string, 0x3f('?') is returned on failure
pub fn getCodepoint(text: [:0]const u8, codepointSize: *i32) i32 {
    return @as(i32, cdef.GetCodepoint(@as([*c]const u8, @ptrCast(text)), @as([*c]c_int, @ptrCast(codepointSize))));
}

/// Get next codepoint in a UTF-8 encoded string, 0x3f('?') is returned on failure
pub fn getCodepointNext(text: [:0]const u8, codepointSize: *i32) i32 {
    return @as(i32, cdef.GetCodepointNext(@as([*c]const u8, @ptrCast(text)), @as([*c]c_int, @ptrCast(codepointSize))));
}

/// Get previous codepoint in a UTF-8 encoded string, 0x3f('?') is returned on failure
pub fn getCodepointPrevious(text: [:0]const u8, codepointSize: *i32) i32 {
    return @as(i32, cdef.GetCodepointPrevious(@as([*c]const u8, @ptrCast(text)), @as([*c]c_int, @ptrCast(codepointSize))));
}

/// Encode one codepoint into UTF-8 byte array (array length returned as parameter)
pub fn codepointToUTF8(codepoint: i32, utf8Size: *i32) [:0]const u8 {
    return std.mem.span(cdef.CodepointToUTF8(@as(c_int, codepoint), @as([*c]c_int, @ptrCast(utf8Size))));
}

/// Copy one string to another, returns bytes copied
pub fn textCopy(dst: *u8, src: [:0]const u8) i32 {
    return @as(i32, cdef.TextCopy(@as([*c]u8, @ptrCast(dst)), @as([*c]const u8, @ptrCast(src))));
}

/// Check if two text string are equal
pub fn textIsEqual(text1: [:0]const u8, text2: [:0]const u8) bool {
    return cdef.TextIsEqual(@as([*c]const u8, @ptrCast(text1)), @as([*c]const u8, @ptrCast(text2)));
}

/// Get text length, checks for '\0' ending
pub fn textLength(text: [:0]const u8) u32 {
    return @as(u32, cdef.TextLength(@as([*c]const u8, @ptrCast(text))));
}

/// Get a piece of a text string
pub fn textSubtext(text: [:0]const u8, position: i32, length: i32) [:0]const u8 {
    return std.mem.span(cdef.TextSubtext(@as([*c]const u8, @ptrCast(text)), @as(c_int, position), @as(c_int, length)));
}

/// Remove text spaces, concat words
pub fn textRemoveSpaces(text: [:0]const u8) [:0]const u8 {
    return std.mem.span(cdef.TextRemoveSpaces(@as([*c]const u8, @ptrCast(text))));
}

/// Get text between two strings
pub fn getTextBetween(text: [:0]const u8, begin: [:0]const u8, end: [:0]const u8) [:0]u8 {
    return std.mem.span(cdef.GetTextBetween(@as([*c]const u8, @ptrCast(text)), @as([*c]const u8, @ptrCast(begin)), @as([*c]const u8, @ptrCast(end))));
}

/// Replace text string (WARNING: memory must be freed!)
pub fn textReplace(text: [:0]const u8, search: [:0]const u8, replacement: [:0]const u8) [:0]u8 {
    return std.mem.span(cdef.TextReplace(@as([*c]const u8, @ptrCast(text)), @as([*c]const u8, @ptrCast(search)), @as([*c]const u8, @ptrCast(replacement))));
}

/// Replace text between two specific strings (WARNING: memory must be freed!)
pub fn textReplaceBetween(text: [:0]const u8, begin: [:0]const u8, end: [:0]const u8, replacement: [:0]const u8) [:0]u8 {
    return std.mem.span(cdef.TextReplaceBetween(@as([*c]const u8, @ptrCast(text)), @as([*c]const u8, @ptrCast(begin)), @as([*c]const u8, @ptrCast(end)), @as([*c]const u8, @ptrCast(replacement))));
}

/// Insert text in a position (WARNING: memory must be freed!)
pub fn textInsert(text: [:0]const u8, insert: [:0]const u8, position: i32) [:0]u8 {
    return std.mem.span(cdef.TextInsert(@as([*c]const u8, @ptrCast(text)), @as([*c]const u8, @ptrCast(insert)), @as(c_int, position)));
}

/// Split text into multiple strings, using MAX_TEXTSPLIT_COUNT static strings
pub fn textSplit(text: []const u8, delimiter: u8) RaylibError![][:0]u8 {
    var _len: i32 = 0;
    const _ptr = cdef.TextSplit(@as([*c]const u8, @ptrCast(text)), delimiter, @as([*c]c_int, @ptrCast(&_len)));
    if (_ptr == 0) return RaylibError.TextSplit;
    return @as([*][:0]u8, @ptrCast(_ptr))[0..@as(usize, @intCast(_len))];
}

/// Append text at specific position and move cursor
pub fn textAppend(text: [:0]u8, append: [:0]const u8, position: *i32) void {
    cdef.TextAppend(@as([*c]u8, @ptrCast(text)), @as([*c]const u8, @ptrCast(append)), @as([*c]c_int, @ptrCast(position)));
}

/// Find first text occurrence within a string, -1 if not found
pub fn textFindIndex(text: [:0]const u8, search: [:0]const u8) i32 {
    return @as(i32, cdef.TextFindIndex(@as([*c]const u8, @ptrCast(text)), @as([*c]const u8, @ptrCast(search))));
}

/// Get upper case version of provided string
pub fn textToUpper(text: [:0]const u8) [:0]u8 {
    return std.mem.span(cdef.TextToUpper(@as([*c]const u8, @ptrCast(text))));
}

/// Get lower case version of provided string
pub fn textToLower(text: [:0]const u8) [:0]u8 {
    return std.mem.span(cdef.TextToLower(@as([*c]const u8, @ptrCast(text))));
}

/// Get Pascal case notation version of provided string
pub fn textToPascal(text: [:0]const u8) [:0]u8 {
    return std.mem.span(cdef.TextToPascal(@as([*c]const u8, @ptrCast(text))));
}

/// Get Snake case notation version of provided string
pub fn textToSnake(text: [:0]const u8) [:0]u8 {
    return std.mem.span(cdef.TextToSnake(@as([*c]const u8, @ptrCast(text))));
}

/// Get Camel case notation version of provided string
pub fn textToCamel(text: [:0]const u8) [:0]u8 {
    return std.mem.span(cdef.TextToCamel(@as([*c]const u8, @ptrCast(text))));
}

/// Get integer value from text
pub fn textToInteger(text: [:0]const u8) i32 {
    return @as(i32, cdef.TextToInteger(@as([*c]const u8, @ptrCast(text))));
}

/// Get float value from text
pub fn textToFloat(text: [:0]const u8) f32 {
    return cdef.TextToFloat(@as([*c]const u8, @ptrCast(text)));
}

/// Draw a line in 3D world space
pub fn drawLine3D(startPos: Vector3, endPos: Vector3, color: Color) void {
    cdef.DrawLine3D(startPos, endPos, color);
}

/// Draw a point in 3D space, actually a small line
pub fn drawPoint3D(position: Vector3, color: Color) void {
    cdef.DrawPoint3D(position, color);
}

/// Draw a circle in 3D world space
pub fn drawCircle3D(center: Vector3, radius: f32, rotationAxis: Vector3, rotationAngle: f32, color: Color) void {
    cdef.DrawCircle3D(center, radius, rotationAxis, rotationAngle, color);
}

/// Draw a color-filled triangle (vertex in counter-clockwise order!)
pub fn drawTriangle3D(v1: Vector3, v2: Vector3, v3: Vector3, color: Color) void {
    cdef.DrawTriangle3D(v1, v2, v3, color);
}

/// Draw cube
pub fn drawCube(position: Vector3, width: f32, height: f32, length: f32, color: Color) void {
    cdef.DrawCube(position, width, height, length, color);
}

/// Draw cube (Vector version)
pub fn drawCubeV(position: Vector3, size: Vector3, color: Color) void {
    cdef.DrawCubeV(position, size, color);
}

/// Draw cube wires
pub fn drawCubeWires(position: Vector3, width: f32, height: f32, length: f32, color: Color) void {
    cdef.DrawCubeWires(position, width, height, length, color);
}

/// Draw cube wires (Vector version)
pub fn drawCubeWiresV(position: Vector3, size: Vector3, color: Color) void {
    cdef.DrawCubeWiresV(position, size, color);
}

/// Draw sphere
pub fn drawSphere(centerPos: Vector3, radius: f32, color: Color) void {
    cdef.DrawSphere(centerPos, radius, color);
}

/// Draw sphere with extended parameters
pub fn drawSphereEx(centerPos: Vector3, radius: f32, rings: i32, slices: i32, color: Color) void {
    cdef.DrawSphereEx(centerPos, radius, @as(c_int, rings), @as(c_int, slices), color);
}

/// Draw sphere wires
pub fn drawSphereWires(centerPos: Vector3, radius: f32, rings: i32, slices: i32, color: Color) void {
    cdef.DrawSphereWires(centerPos, radius, @as(c_int, rings), @as(c_int, slices), color);
}

/// Draw a cylinder/cone
pub fn drawCylinder(position: Vector3, radiusTop: f32, radiusBottom: f32, height: f32, slices: i32, color: Color) void {
    cdef.DrawCylinder(position, radiusTop, radiusBottom, height, @as(c_int, slices), color);
}

/// Draw a cylinder with base at startPos and top at endPos
pub fn drawCylinderEx(startPos: Vector3, endPos: Vector3, startRadius: f32, endRadius: f32, sides: i32, color: Color) void {
    cdef.DrawCylinderEx(startPos, endPos, startRadius, endRadius, @as(c_int, sides), color);
}

/// Draw a cylinder/cone wires
pub fn drawCylinderWires(position: Vector3, radiusTop: f32, radiusBottom: f32, height: f32, slices: i32, color: Color) void {
    cdef.DrawCylinderWires(position, radiusTop, radiusBottom, height, @as(c_int, slices), color);
}

/// Draw a cylinder wires with base at startPos and top at endPos
pub fn drawCylinderWiresEx(startPos: Vector3, endPos: Vector3, startRadius: f32, endRadius: f32, sides: i32, color: Color) void {
    cdef.DrawCylinderWiresEx(startPos, endPos, startRadius, endRadius, @as(c_int, sides), color);
}

/// Draw a capsule with the center of its sphere caps at startPos and endPos
pub fn drawCapsule(startPos: Vector3, endPos: Vector3, radius: f32, slices: i32, rings: i32, color: Color) void {
    cdef.DrawCapsule(startPos, endPos, radius, @as(c_int, slices), @as(c_int, rings), color);
}

/// Draw capsule wireframe with the center of its sphere caps at startPos and endPos
pub fn drawCapsuleWires(startPos: Vector3, endPos: Vector3, radius: f32, slices: i32, rings: i32, color: Color) void {
    cdef.DrawCapsuleWires(startPos, endPos, radius, @as(c_int, slices), @as(c_int, rings), color);
}

/// Draw a plane XZ
pub fn drawPlane(centerPos: Vector3, size: Vector2, color: Color) void {
    cdef.DrawPlane(centerPos, size, color);
}

/// Draw a ray line
pub fn drawRay(ray: Ray, color: Color) void {
    cdef.DrawRay(ray, color);
}

/// Draw a grid (centered at (0, 0, 0))
pub fn drawGrid(slices: i32, spacing: f32) void {
    cdef.DrawGrid(@as(c_int, slices), spacing);
}

/// Check if a model is valid (loaded in GPU, VAO/VBOs)
pub fn isModelValid(model: Model) bool {
    return cdef.IsModelValid(model);
}

/// Unload model (including meshes) from memory (RAM and/or VRAM)
pub fn unloadModel(model: Model) void {
    cdef.UnloadModel(model);
}

/// Compute model bounding box limits (considers all meshes)
pub fn getModelBoundingBox(model: Model) BoundingBox {
    return cdef.GetModelBoundingBox(model);
}

/// Draw a model (with texture if set)
pub fn drawModel(model: Model, position: Vector3, scale: f32, tint: Color) void {
    cdef.DrawModel(model, position, scale, tint);
}

/// Draw a model with extended parameters
pub fn drawModelEx(model: Model, position: Vector3, rotationAxis: Vector3, rotationAngle: f32, scale: Vector3, tint: Color) void {
    cdef.DrawModelEx(model, position, rotationAxis, rotationAngle, scale, tint);
}

/// Draw a model wires (with texture if set)
pub fn drawModelWires(model: Model, position: Vector3, scale: f32, tint: Color) void {
    cdef.DrawModelWires(model, position, scale, tint);
}

/// Draw a model wires (with texture if set) with extended parameters
pub fn drawModelWiresEx(model: Model, position: Vector3, rotationAxis: Vector3, rotationAngle: f32, scale: Vector3, tint: Color) void {
    cdef.DrawModelWiresEx(model, position, rotationAxis, rotationAngle, scale, tint);
}

/// Draw a model as points
pub fn drawModelPoints(model: Model, position: Vector3, scale: f32, tint: Color) void {
    cdef.DrawModelPoints(model, position, scale, tint);
}

/// Draw a model as points with extended parameters
pub fn drawModelPointsEx(model: Model, position: Vector3, rotationAxis: Vector3, rotationAngle: f32, scale: Vector3, tint: Color) void {
    cdef.DrawModelPointsEx(model, position, rotationAxis, rotationAngle, scale, tint);
}

/// Draw bounding box (wires)
pub fn drawBoundingBox(box: BoundingBox, color: Color) void {
    cdef.DrawBoundingBox(box, color);
}

/// Draw a billboard texture
pub fn drawBillboard(camera: Camera, texture: Texture2D, position: Vector3, scale: f32, tint: Color) void {
    cdef.DrawBillboard(camera, texture, position, scale, tint);
}

/// Draw a billboard texture defined by source
pub fn drawBillboardRec(camera: Camera, texture: Texture2D, source: Rectangle, position: Vector3, size: Vector2, tint: Color) void {
    cdef.DrawBillboardRec(camera, texture, source, position, size, tint);
}

/// Draw a billboard texture defined by source and rotation
pub fn drawBillboardPro(camera: Camera, texture: Texture2D, source: Rectangle, position: Vector3, up: Vector3, size: Vector2, origin: Vector2, rotation: f32, tint: Color) void {
    cdef.DrawBillboardPro(camera, texture, source, position, up, size, origin, rotation, tint);
}

/// Upload mesh vertex data in GPU and provide VAO/VBO ids
pub fn uploadMesh(mesh: *Mesh, dynamic: bool) void {
    cdef.UploadMesh(@as([*c]Mesh, @ptrCast(mesh)), dynamic);
}

/// Update mesh vertex data in GPU for a specific buffer index
pub fn updateMeshBuffer(mesh: Mesh, index: i32, data: *const anyopaque, dataSize: i32, offset: i32) void {
    cdef.UpdateMeshBuffer(mesh, @as(c_int, index), data, @as(c_int, dataSize), @as(c_int, offset));
}

/// Unload mesh data from CPU and GPU
pub fn unloadMesh(mesh: Mesh) void {
    cdef.UnloadMesh(mesh);
}

/// Draw a 3d mesh with material and transform
pub fn drawMesh(mesh: Mesh, material: Material, transform: Matrix) void {
    cdef.DrawMesh(mesh, material, transform);
}

/// Compute mesh bounding box limits
pub fn getMeshBoundingBox(mesh: Mesh) BoundingBox {
    return cdef.GetMeshBoundingBox(mesh);
}

/// Compute mesh tangents
pub fn genMeshTangents(mesh: *Mesh) void {
    cdef.GenMeshTangents(@as([*c]Mesh, @ptrCast(mesh)));
}

/// Export mesh data to file, returns true on success
pub fn exportMesh(mesh: Mesh, fileName: [:0]const u8) bool {
    return cdef.ExportMesh(mesh, @as([*c]const u8, @ptrCast(fileName)));
}

/// Export mesh as code file (.h) defining multiple arrays of vertex attributes
pub fn exportMeshAsCode(mesh: Mesh, fileName: [:0]const u8) bool {
    return cdef.ExportMeshAsCode(mesh, @as([*c]const u8, @ptrCast(fileName)));
}

/// Generate polygonal mesh
pub fn genMeshPoly(sides: i32, radius: f32) Mesh {
    return cdef.GenMeshPoly(@as(c_int, sides), radius);
}

/// Generate plane mesh (with subdivisions)
pub fn genMeshPlane(width: f32, length: f32, resX: i32, resZ: i32) Mesh {
    return cdef.GenMeshPlane(width, length, @as(c_int, resX), @as(c_int, resZ));
}

/// Generate cuboid mesh
pub fn genMeshCube(width: f32, height: f32, length: f32) Mesh {
    return cdef.GenMeshCube(width, height, length);
}

/// Generate sphere mesh (standard sphere)
pub fn genMeshSphere(radius: f32, rings: i32, slices: i32) Mesh {
    return cdef.GenMeshSphere(radius, @as(c_int, rings), @as(c_int, slices));
}

/// Generate half-sphere mesh (no bottom cap)
pub fn genMeshHemiSphere(radius: f32, rings: i32, slices: i32) Mesh {
    return cdef.GenMeshHemiSphere(radius, @as(c_int, rings), @as(c_int, slices));
}

/// Generate cylinder mesh
pub fn genMeshCylinder(radius: f32, height: f32, slices: i32) Mesh {
    return cdef.GenMeshCylinder(radius, height, @as(c_int, slices));
}

/// Generate cone/pyramid mesh
pub fn genMeshCone(radius: f32, height: f32, slices: i32) Mesh {
    return cdef.GenMeshCone(radius, height, @as(c_int, slices));
}

/// Generate torus mesh
pub fn genMeshTorus(radius: f32, size: f32, radSeg: i32, sides: i32) Mesh {
    return cdef.GenMeshTorus(radius, size, @as(c_int, radSeg), @as(c_int, sides));
}

/// Generate trefoil knot mesh
pub fn genMeshKnot(radius: f32, size: f32, radSeg: i32, sides: i32) Mesh {
    return cdef.GenMeshKnot(radius, size, @as(c_int, radSeg), @as(c_int, sides));
}

/// Generate heightmap mesh from image data
pub fn genMeshHeightmap(heightmap: Image, size: Vector3) Mesh {
    return cdef.GenMeshHeightmap(heightmap, size);
}

/// Generate cubes-based map mesh from image data
pub fn genMeshCubicmap(cubicmap: Image, cubeSize: Vector3) Mesh {
    return cdef.GenMeshCubicmap(cubicmap, cubeSize);
}

/// Check if a material is valid (shader assigned, map textures loaded in GPU)
pub fn isMaterialValid(material: Material) bool {
    return cdef.IsMaterialValid(material);
}

/// Unload material from GPU memory (VRAM)
pub fn unloadMaterial(material: Material) void {
    cdef.UnloadMaterial(material);
}

/// Set texture for a material map type (MATERIAL_MAP_DIFFUSE, MATERIAL_MAP_SPECULAR...)
pub fn setMaterialTexture(material: *Material, mapType: MaterialMapIndex, texture: Texture2D) void {
    cdef.SetMaterialTexture(@as([*c]Material, @ptrCast(material)), mapType, texture);
}

/// Set material for a mesh
pub fn setModelMeshMaterial(model: *Model, meshId: i32, materialId: i32) void {
    cdef.SetModelMeshMaterial(@as([*c]Model, @ptrCast(model)), @as(c_int, meshId), @as(c_int, materialId));
}

/// Load model animations from file
pub fn loadModelAnimations(fileName: []const u8) RaylibError![]ModelAnimation {
    var _len: i32 = 0;
    const _ptr = cdef.LoadModelAnimations(@as([*c]const u8, @ptrCast(fileName)), @as([*c]c_int, @ptrCast(&_len)));
    if (_ptr == 0) return RaylibError.LoadModelAnimations;
    return _ptr[0..@as(usize, @intCast(_len))];
}

/// Update model animation pose (CPU)
pub fn updateModelAnimation(model: Model, anim: ModelAnimation, frame: i32) void {
    cdef.UpdateModelAnimation(model, anim, @as(c_int, frame));
}

/// Update model animation mesh bone matrices (GPU skinning)
pub fn updateModelAnimationBones(model: Model, anim: ModelAnimation, frame: i32) void {
    cdef.UpdateModelAnimationBones(model, anim, @as(c_int, frame));
}

/// Unload animation data
pub fn unloadModelAnimation(anim: ModelAnimation) void {
    cdef.UnloadModelAnimation(anim);
}

/// Check model animation skeleton match
pub fn isModelAnimationValid(model: Model, anim: ModelAnimation) bool {
    return cdef.IsModelAnimationValid(model, anim);
}

/// Check collision between two spheres
pub fn checkCollisionSpheres(center1: Vector3, radius1: f32, center2: Vector3, radius2: f32) bool {
    return cdef.CheckCollisionSpheres(center1, radius1, center2, radius2);
}

/// Check collision between two bounding boxes
pub fn checkCollisionBoxes(box1: BoundingBox, box2: BoundingBox) bool {
    return cdef.CheckCollisionBoxes(box1, box2);
}

/// Check collision between box and sphere
pub fn checkCollisionBoxSphere(box: BoundingBox, center: Vector3, radius: f32) bool {
    return cdef.CheckCollisionBoxSphere(box, center, radius);
}

/// Get collision info between ray and sphere
pub fn getRayCollisionSphere(ray: Ray, center: Vector3, radius: f32) RayCollision {
    return cdef.GetRayCollisionSphere(ray, center, radius);
}

/// Get collision info between ray and box
pub fn getRayCollisionBox(ray: Ray, box: BoundingBox) RayCollision {
    return cdef.GetRayCollisionBox(ray, box);
}

/// Get collision info between ray and mesh
pub fn getRayCollisionMesh(ray: Ray, mesh: Mesh, transform: Matrix) RayCollision {
    return cdef.GetRayCollisionMesh(ray, mesh, transform);
}

/// Get collision info between ray and triangle
pub fn getRayCollisionTriangle(ray: Ray, p1: Vector3, p2: Vector3, p3: Vector3) RayCollision {
    return cdef.GetRayCollisionTriangle(ray, p1, p2, p3);
}

/// Get collision info between ray and quad
pub fn getRayCollisionQuad(ray: Ray, p1: Vector3, p2: Vector3, p3: Vector3, p4: Vector3) RayCollision {
    return cdef.GetRayCollisionQuad(ray, p1, p2, p3, p4);
}

/// Initialize audio device and context
pub fn initAudioDevice() void {
    cdef.InitAudioDevice();
}

/// Close the audio device and context
pub fn closeAudioDevice() void {
    cdef.CloseAudioDevice();
}

/// Check if audio device has been initialized successfully
pub fn isAudioDeviceReady() bool {
    return cdef.IsAudioDeviceReady();
}

/// Set master volume (listener)
pub fn setMasterVolume(volume: f32) void {
    cdef.SetMasterVolume(volume);
}

/// Get master volume (listener)
pub fn getMasterVolume() f32 {
    return cdef.GetMasterVolume();
}

/// Checks if wave data is valid (data loaded and parameters)
pub fn isWaveValid(wave: Wave) bool {
    return cdef.IsWaveValid(wave);
}

/// Load sound from wave data
pub fn loadSoundFromWave(wave: Wave) Sound {
    return cdef.LoadSoundFromWave(wave);
}

/// Create a new sound that shares the same sample data as the source sound, does not own the sound data
pub fn loadSoundAlias(source: Sound) Sound {
    return cdef.LoadSoundAlias(source);
}

/// Checks if a sound is valid (data loaded and buffers initialized)
pub fn isSoundValid(sound: Sound) bool {
    return cdef.IsSoundValid(sound);
}

/// Update sound buffer with new data (data and frame count should fit in sound)
pub fn updateSound(sound: Sound, data: *const anyopaque, sampleCount: i32) void {
    cdef.UpdateSound(sound, data, @as(c_int, sampleCount));
}

/// Unload wave data
pub fn unloadWave(wave: Wave) void {
    cdef.UnloadWave(wave);
}

/// Unload sound
pub fn unloadSound(sound: Sound) void {
    cdef.UnloadSound(sound);
}

/// Unload a sound alias (does not deallocate sample data)
pub fn unloadSoundAlias(alias: Sound) void {
    cdef.UnloadSoundAlias(alias);
}

/// Export wave data to file, returns true on success
pub fn exportWave(wave: Wave, fileName: [:0]const u8) bool {
    return cdef.ExportWave(wave, @as([*c]const u8, @ptrCast(fileName)));
}

/// Export wave sample data to code (.h), returns true on success
pub fn exportWaveAsCode(wave: Wave, fileName: [:0]const u8) bool {
    return cdef.ExportWaveAsCode(wave, @as([*c]const u8, @ptrCast(fileName)));
}

/// Play a sound
pub fn playSound(sound: Sound) void {
    cdef.PlaySound(sound);
}

/// Stop playing a sound
pub fn stopSound(sound: Sound) void {
    cdef.StopSound(sound);
}

/// Pause a sound
pub fn pauseSound(sound: Sound) void {
    cdef.PauseSound(sound);
}

/// Resume a paused sound
pub fn resumeSound(sound: Sound) void {
    cdef.ResumeSound(sound);
}

/// Check if a sound is currently playing
pub fn isSoundPlaying(sound: Sound) bool {
    return cdef.IsSoundPlaying(sound);
}

/// Set volume for a sound (1.0 is max level)
pub fn setSoundVolume(sound: Sound, volume: f32) void {
    cdef.SetSoundVolume(sound, volume);
}

/// Set pitch for a sound (1.0 is base level)
pub fn setSoundPitch(sound: Sound, pitch: f32) void {
    cdef.SetSoundPitch(sound, pitch);
}

/// Set pan for a sound (0.5 is center)
pub fn setSoundPan(sound: Sound, pan: f32) void {
    cdef.SetSoundPan(sound, pan);
}

/// Copy a wave to a new wave
pub fn waveCopy(wave: Wave) Wave {
    return cdef.WaveCopy(wave);
}

/// Crop a wave to defined frames range
pub fn waveCrop(wave: *Wave, initFrame: i32, finalFrame: i32) void {
    cdef.WaveCrop(@as([*c]Wave, @ptrCast(wave)), @as(c_int, initFrame), @as(c_int, finalFrame));
}

/// Convert wave data to desired format
pub fn waveFormat(wave: *Wave, sampleRate: i32, sampleSize: i32, channels: i32) void {
    cdef.WaveFormat(@as([*c]Wave, @ptrCast(wave)), @as(c_int, sampleRate), @as(c_int, sampleSize), @as(c_int, channels));
}

/// Unload samples data loaded with LoadWaveSamples()
pub fn unloadWaveSamples(samples: []f32) void {
    cdef.UnloadWaveSamples(@as([*c]f32, @ptrCast(samples)));
}

/// Checks if a music stream is valid (context and buffers initialized)
pub fn isMusicValid(music: Music) bool {
    return cdef.IsMusicValid(music);
}

/// Unload music stream
pub fn unloadMusicStream(music: Music) void {
    cdef.UnloadMusicStream(music);
}

/// Start music playing
pub fn playMusicStream(music: Music) void {
    cdef.PlayMusicStream(music);
}

/// Check if music is playing
pub fn isMusicStreamPlaying(music: Music) bool {
    return cdef.IsMusicStreamPlaying(music);
}

/// Updates buffers for music streaming
pub fn updateMusicStream(music: Music) void {
    cdef.UpdateMusicStream(music);
}

/// Stop music playing
pub fn stopMusicStream(music: Music) void {
    cdef.StopMusicStream(music);
}

/// Pause music playing
pub fn pauseMusicStream(music: Music) void {
    cdef.PauseMusicStream(music);
}

/// Resume playing paused music
pub fn resumeMusicStream(music: Music) void {
    cdef.ResumeMusicStream(music);
}

/// Seek music to a position (in seconds)
pub fn seekMusicStream(music: Music, position: f32) void {
    cdef.SeekMusicStream(music, position);
}

/// Set volume for music (1.0 is max level)
pub fn setMusicVolume(music: Music, volume: f32) void {
    cdef.SetMusicVolume(music, volume);
}

/// Set pitch for a music (1.0 is base level)
pub fn setMusicPitch(music: Music, pitch: f32) void {
    cdef.SetMusicPitch(music, pitch);
}

/// Set pan for a music (0.5 is center)
pub fn setMusicPan(music: Music, pan: f32) void {
    cdef.SetMusicPan(music, pan);
}

/// Get music time length (in seconds)
pub fn getMusicTimeLength(music: Music) f32 {
    return cdef.GetMusicTimeLength(music);
}

/// Get current music time played (in seconds)
pub fn getMusicTimePlayed(music: Music) f32 {
    return cdef.GetMusicTimePlayed(music);
}

/// Checks if an audio stream is valid (buffers initialized)
pub fn isAudioStreamValid(stream: AudioStream) bool {
    return cdef.IsAudioStreamValid(stream);
}

/// Unload audio stream and free memory
pub fn unloadAudioStream(stream: AudioStream) void {
    cdef.UnloadAudioStream(stream);
}

/// Update audio stream buffers with data
pub fn updateAudioStream(stream: AudioStream, data: *const anyopaque, frameCount: i32) void {
    cdef.UpdateAudioStream(stream, data, @as(c_int, frameCount));
}

/// Check if any audio stream buffers requires refill
pub fn isAudioStreamProcessed(stream: AudioStream) bool {
    return cdef.IsAudioStreamProcessed(stream);
}

/// Play audio stream
pub fn playAudioStream(stream: AudioStream) void {
    cdef.PlayAudioStream(stream);
}

/// Pause audio stream
pub fn pauseAudioStream(stream: AudioStream) void {
    cdef.PauseAudioStream(stream);
}

/// Resume audio stream
pub fn resumeAudioStream(stream: AudioStream) void {
    cdef.ResumeAudioStream(stream);
}

/// Check if audio stream is playing
pub fn isAudioStreamPlaying(stream: AudioStream) bool {
    return cdef.IsAudioStreamPlaying(stream);
}

/// Stop audio stream
pub fn stopAudioStream(stream: AudioStream) void {
    cdef.StopAudioStream(stream);
}

/// Set volume for audio stream (1.0 is max level)
pub fn setAudioStreamVolume(stream: AudioStream, volume: f32) void {
    cdef.SetAudioStreamVolume(stream, volume);
}

/// Set pitch for audio stream (1.0 is base level)
pub fn setAudioStreamPitch(stream: AudioStream, pitch: f32) void {
    cdef.SetAudioStreamPitch(stream, pitch);
}

/// Set pan for audio stream (0.5 is centered)
pub fn setAudioStreamPan(stream: AudioStream, pan: f32) void {
    cdef.SetAudioStreamPan(stream, pan);
}

/// Default size for new audio streams
pub fn setAudioStreamBufferSizeDefault(size: i32) void {
    cdef.SetAudioStreamBufferSizeDefault(@as(c_int, size));
}

/// Audio thread callback to request new data
pub fn setAudioStreamCallback(stream: AudioStream, callback: AudioCallback) void {
    cdef.SetAudioStreamCallback(stream, callback);
}

/// Attach audio stream processor to stream, receives frames x 2 samples as 'float' (stereo)
pub fn attachAudioStreamProcessor(stream: AudioStream, processor: AudioCallback) void {
    cdef.AttachAudioStreamProcessor(stream, processor);
}

/// Detach audio stream processor from stream
pub fn detachAudioStreamProcessor(stream: AudioStream, processor: AudioCallback) void {
    cdef.DetachAudioStreamProcessor(stream, processor);
}

/// Attach audio stream processor to the entire audio pipeline, receives frames x 2 samples as 'float' (stereo)
pub fn attachAudioMixedProcessor(processor: AudioCallback) void {
    cdef.AttachAudioMixedProcessor(processor);
}

/// Detach audio stream processor from the entire audio pipeline
pub fn detachAudioMixedProcessor(processor: AudioCallback) void {
    cdef.DetachAudioMixedProcessor(processor);
}
