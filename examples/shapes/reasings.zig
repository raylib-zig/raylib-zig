const math = @import("std").math;

// Linear Easing functions
pub fn linearNone(t: f32, b: f32, c: f32, d: f32) f32 {
    return (c * t / d + b);
}
pub fn linearIn(t: f32, b: f32, c: f32, d: f32) f32 {
    return (c * t / d + b);
}
pub fn linearOut(t: f32, b: f32, c: f32, d: f32) f32 {
    return (c * t / d + b);
}
pub fn linearInOut(t: f32, b: f32, c: f32, d: f32) f32 {
    return (c * t / d + b);
}

pub fn sineIn(t: f32, b: f32, c: f32, d: f32) f32 {
    return (-c * math.cos(t / d * (math.pi / 2.0)) + c + b);
}
pub fn sineOut(t: f32, b: f32, c: f32, d: f32) f32 {
    return (c * math.sin(t / d * (math.pi / 2.0)) + b);
}
pub fn sineInOut(t: f32, b: f32, c: f32, d: f32) f32 {
    return (-c / 2.0 * (math.cos(math.pi * t / d) - 1.0) + b);
}

// Circular Easing functions
pub fn circIn(t: f32, b: f32, c: f32, d: f32) f32 {
    const postFix = t / d;
    return (-c * (math.sqrt(1.0 - postFix * postFix) - 1.0) + b);
}
pub fn circOut(t: f32, b: f32, c: f32, d: f32) f32 {
    const postFix = t / d - 1.0;
    return (c * math.sqrt(1.0 - postFix * postFix) + b);
}
pub fn circInOut(t: f32, b: f32, c: f32, d: f32) f32 {
    var postFix = t / d;
    if ((postFix / 2.0) < 1.0) return (-c / 2.0 * (math.sqrt(1.0 - postFix * postFix) - 1.0) + b);
    postFix -= 2.0;
    return (c / 2.0 * (math.sqrt(1.0 - postFix * postFix) + 1.0) + b);
}

// Cubic Easing functions
pub fn cubicIn(t: f32, b: f32, c: f32, d: f32) f32 {
    const postFix = t / d;
    return (c * postFix * postFix * postFix + b);
}
pub fn cubicOut(t: f32, b: f32, c: f32, d: f32) f32 {
    const postFix = t / d - 1.0;
    return (c * (postFix * postFix * postFix + 1.0) + b);
}
pub fn cubicInOut(t: f32, b: f32, c: f32, d: f32) f32 {
    const postFix = t / d;
    if (postFix / 2.0 < 1.0) return (c / 2.0 * postFix * postFix * postFix + b);
    postFix -= 2.0;
    return (c / 2.0 * (t * t * t + 2.0) + b);
}

// Quadratic Easing functions
pub fn quadIn(t: f32, b: f32, c: f32, d: f32) f32 {
    const postfix = t / d;
    return (c * postfix * postfix + b);
}
pub fn quadOut(t: f32, b: f32, c: f32, d: f32) f32 {
    const postFix = t / d;
    return (-c * postFix * (postFix - 2.0) + b);
}
pub fn quadInOut(t: f32, b: f32, c: f32, d: f32) f32 // Ease: Quadratic In Out
{
    const postFix = t / d;
    return if (postFix / 2 < 1)
        (((c / 2) * (postFix * postFix)) + b)
    else
        (-c / 2.0 * (((postFix - 1.0) * (postFix - 3.0)) - 1.0) + b);
}

// Exponential Easing functions
pub fn expoIn(t: f32, b: f32, c: f32, d: f32) f32 {
    return if (t == 0.0) b else (c * math.pow(f32, 2.0, 10.0 * (t / d - 1.0)) + b);
}
pub fn expoOut(t: f32, b: f32, c: f32, d: f32) f32 {
    return if (t == d) (b + c) else (c * (-math.pow(f32, 2.0, -10.0 * t / d) + 1.0) + b);
}
pub fn expoInOut(t: f32, b: f32, c: f32, d: f32) f32 {
    if (t == 0.0) return b;
    if (t == d) return (b + c);
    const postFix = t / d;
    if ((postFix / 2.0) < 1.0) return (c / 2.0 * math.pow(f32, 2.0, 10.0 * (postFix - 1.0)) + b);

    return (c / 2.0 * (-math.pow(f32, 2.0, -10.0 * (postFix - 1.0)) + 2.0) + b);
}

// Back Easing functions
pub fn backIn(t: f32, b: f32, c: f32, d: f32) f32 {
    const s = 1.70158;
    const postFix = t / d;
    return (c * (postFix) * postFix * ((s + 1.0) * postFix - s) + b);
}

pub fn backOut(t: f32, b: f32, c: f32, d: f32) f32 {
    const s = 1.70158;
    const postFix = t / d - 1.0;
    return (c * (postFix * postFix * ((s + 1.0) * postFix + s) + 1.0) + b);
}

pub fn backInOut(t: f32, b: f32, c: f32, d: f32) f32 {
    const s = 1.70158;
    t /= d;
    if (t / 2.0 < 1.0) {
        s *= 1.525;
        return (c / 2.0 * (t * t * ((s + 1.0) * t - s)) + b);
    }
    t -= 2;
    const postFix = t;
    s *= 1.525;
    return (c / 2.0 * ((postFix) * t * ((s + 1.0) * t + s) + 2.0) + b);
}

// Bounce Easing functions

pub fn bounceOut(t: f32, b: f32, c: f32, d: f32) f32 {
    var tDivD = t / d;
    if (tDivD < (1.0 / 2.75)) {
        return (c * (7.5625 * tDivD * tDivD) + b);
    } else if (tDivD < (2.0 / 2.75)) {
        tDivD -= (1.5 / 2.75);
        return (c * (7.5625 * tDivD * tDivD + 0.75) + b);
    } else if (tDivD < (2.5 / 2.75)) {
        tDivD -= (2.25 / 2.75);
        return (c * (7.5625 * tDivD * tDivD + 0.9375) + b);
    } else {
        tDivD -= (2.625 / 2.75);
        return (c * (7.5625 * tDivD * tDivD + 0.984375) + b);
    }
}

pub fn bounceIn(t: f32, b: f32, c: f32, d: f32) f32 {
    return (c - bounceOut(d - t, 0.0, c, d) + b);
}

pub fn bounceInOut(t: f32, b: f32, c: f32, d: f32) f32 {
    if (t < d / 2.0) return (bounceIn(t * 2.0, 0.0, c, d) * 0.5 + b);
    return (bounceOut(t * 2.0 - d, 0.0, c, d) * 0.5 + c * 0.5 + b);
}

// Elastic Easing functions
pub fn elasticIn(t: f32, b: f32, c: f32, d: f32) f32 {
    if (t == 0.0) return b;
    var tDivD = t / d;
    if (tDivD == 1.0) return (b + c);

    const p = d * 0.3;
    const a = c;
    const s = p / 4.0;
    tDivD -= 1;
    const postFix = a * math.pow(f32, 2.0, 10.0 * tDivD);

    return (-(postFix * math.sin((tDivD * d - s) * (2.0 * math.pi) / p)) + b);
}

pub fn elasticOut(t: f32, b: f32, c: f32, d: f32) f32 {
    if (t == 0.0) return b;
    const tDivD = t / d;
    if (tDivD == 1.0) return (b + c);

    const p = d * 0.3;
    const a = c;
    const s = p / 4.0;

    return (a * math.pow(f32, 2.0, -10.0 * tDivD) * math.sin((tDivD * d - s) * (2.0 * math.pi) / p) + c + b);
}

pub fn elasticInOut(t: f32, b: f32, c: f32, d: f32) f32 {
    if (t == 0.0) return b;
    const tDivD = t / d;
    if (tDivD / 2.0 == 2.0) return (b + c);

    const p = d * (0.3 * 1.5);
    const a = c;
    const s = p / 4.0;

    if (tDivD < 1.0) {
        tDivD -= 1;
        const postFix = a * math.pow(f32, 2.0, 10.0 * tDivD);
        return -0.5 * (postFix * math.sin((tDivD * d - s) * (2.0 * math.pi) / p)) + b;
    }

    tDivD -= 1;
    const postFix = a * math.pow(f32, 2.0, -10.0 * (tDivD));

    return (postFix * math.sin((tDivD * d - s) * (2.0 * math.pi) / p) * 0.5 + c + b);
}
