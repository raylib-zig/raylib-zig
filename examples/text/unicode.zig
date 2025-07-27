//!******************************************************************************************
//!
//!   raylib-zig port of the [text] example - Unicode
//!   https://github.com/raysan5/raylib/blob/master/examples/text/text_unicode.c
//!
//!   Example complexity rating: [★★★★] 4/4
//!
//!   Example originally created with raylib 2.5, last time updated with raylib 4.0
//!
//!   Example contributed by Vlad Adrian (@demizdor) and reviewed by Ramon Santamaria (@raysan5)
//!   Translated to raylib-zig by Timothy Fiss (@TheFissk)
//!
//!   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//!   BSD-like license that allows static linking with closed source software
//!
//!   Copyright (c) 2019-2025 Vlad Adrian (@demizdor) and Ramon Santamaria (@raysan5)
//!
//!*******************************************************************************************/

const rl = @import("raylib");
const std = @import("std");

const emoji_per_width = 8;
const emoji_per_height = 4;

// String containing 180 emoji codepoints separated by a '\0' char
const emojiCodepoints = "\xF0\x9F\x8C\x80\x00\xF0\x9F\x98\x80\x00\xF0\x9F\x98\x82\x00\xF0\x9F\xA4\xA3\x00\xF0\x9F\x98\x83\x00\xF0\x9F\x98\x86\x00\xF0\x9F\x98\x89\x00" ++
    "\xF0\x9F\x98\x8B\x00\xF0\x9F\x98\x8E\x00\xF0\x9F\x98\x8D\x00\xF0\x9F\x98\x98\x00\xF0\x9F\x98\x97\x00\xF0\x9F\x98\x99\x00\xF0\x9F\x98\x9A\x00\xF0\x9F\x99\x82\x00" ++
    "\xF0\x9F\xA4\x97\x00\xF0\x9F\xA4\xA9\x00\xF0\x9F\xA4\x94\x00\xF0\x9F\xA4\xA8\x00\xF0\x9F\x98\x90\x00\xF0\x9F\x98\x91\x00\xF0\x9F\x98\xB6\x00\xF0\x9F\x99\x84\x00" ++
    "\xF0\x9F\x98\x8F\x00\xF0\x9F\x98\xA3\x00\xF0\x9F\x98\xA5\x00\xF0\x9F\x98\xAE\x00\xF0\x9F\xA4\x90\x00\xF0\x9F\x98\xAF\x00\xF0\x9F\x98\xAA\x00\xF0\x9F\x98\xAB\x00" ++
    "\xF0\x9F\x98\xB4\x00\xF0\x9F\x98\x8C\x00\xF0\x9F\x98\x9B\x00\xF0\x9F\x98\x9D\x00\xF0\x9F\xA4\xA4\x00\xF0\x9F\x98\x92\x00\xF0\x9F\x98\x95\x00\xF0\x9F\x99\x83\x00" ++
    "\xF0\x9F\xA4\x91\x00\xF0\x9F\x98\xB2\x00\xF0\x9F\x99\x81\x00\xF0\x9F\x98\x96\x00\xF0\x9F\x98\x9E\x00\xF0\x9F\x98\x9F\x00\xF0\x9F\x98\xA4\x00\xF0\x9F\x98\xA2\x00" ++
    "\xF0\x9F\x98\xAD\x00\xF0\x9F\x98\xA6\x00\xF0\x9F\x98\xA9\x00\xF0\x9F\xA4\xAF\x00\xF0\x9F\x98\xAC\x00\xF0\x9F\x98\xB0\x00\xF0\x9F\x98\xB1\x00\xF0\x9F\x98\xB3\x00" ++
    "\xF0\x9F\xA4\xAA\x00\xF0\x9F\x98\xB5\x00\xF0\x9F\x98\xA1\x00\xF0\x9F\x98\xA0\x00\xF0\x9F\xA4\xAC\x00\xF0\x9F\x98\xB7\x00\xF0\x9F\xA4\x92\x00\xF0\x9F\xA4\x95\x00" ++
    "\xF0\x9F\xA4\xA2\x00\xF0\x9F\xA4\xAE\x00\xF0\x9F\xA4\xA7\x00\xF0\x9F\x98\x87\x00\xF0\x9F\xA4\xA0\x00\xF0\x9F\xA4\xAB\x00\xF0\x9F\xA4\xAD\x00\xF0\x9F\xA7\x90\x00" ++
    "\xF0\x9F\xA4\x93\x00\xF0\x9F\x98\x88\x00\xF0\x9F\x91\xBF\x00\xF0\x9F\x91\xB9\x00\xF0\x9F\x91\xBA\x00\xF0\x9F\x92\x80\x00\xF0\x9F\x91\xBB\x00\xF0\x9F\x91\xBD\x00" ++
    "\xF0\x9F\x91\xBE\x00\xF0\x9F\xA4\x96\x00\xF0\x9F\x92\xA9\x00\xF0\x9F\x98\xBA\x00\xF0\x9F\x98\xB8\x00\xF0\x9F\x98\xB9\x00\xF0\x9F\x98\xBB\x00\xF0\x9F\x98\xBD\x00" ++
    "\xF0\x9F\x99\x80\x00\xF0\x9F\x98\xBF\x00\xF0\x9F\x8C\xBE\x00\xF0\x9F\x8C\xBF\x00\xF0\x9F\x8D\x80\x00\xF0\x9F\x8D\x83\x00\xF0\x9F\x8D\x87\x00\xF0\x9F\x8D\x93\x00" ++
    "\xF0\x9F\xA5\x9D\x00\xF0\x9F\x8D\x85\x00\xF0\x9F\xA5\xA5\x00\xF0\x9F\xA5\x91\x00\xF0\x9F\x8D\x86\x00\xF0\x9F\xA5\x94\x00\xF0\x9F\xA5\x95\x00\xF0\x9F\x8C\xBD\x00" ++
    "\xF0\x9F\x8C\xB6\x00\xF0\x9F\xA5\x92\x00\xF0\x9F\xA5\xA6\x00\xF0\x9F\x8D\x84\x00\xF0\x9F\xA5\x9C\x00\xF0\x9F\x8C\xB0\x00\xF0\x9F\x8D\x9E\x00\xF0\x9F\xA5\x90\x00" ++
    "\xF0\x9F\xA5\x96\x00\xF0\x9F\xA5\xA8\x00\xF0\x9F\xA5\x9E\x00\xF0\x9F\xA7\x80\x00\xF0\x9F\x8D\x96\x00\xF0\x9F\x8D\x97\x00\xF0\x9F\xA5\xA9\x00\xF0\x9F\xA5\x93\x00" ++
    "\xF0\x9F\x8D\x94\x00\xF0\x9F\x8D\x9F\x00\xF0\x9F\x8D\x95\x00\xF0\x9F\x8C\xAD\x00\xF0\x9F\xA5\xAA\x00\xF0\x9F\x8C\xAE\x00\xF0\x9F\x8C\xAF\x00\xF0\x9F\xA5\x99\x00" ++
    "\xF0\x9F\xA5\x9A\x00\xF0\x9F\x8D\xB3\x00\xF0\x9F\xA5\x98\x00\xF0\x9F\x8D\xB2\x00\xF0\x9F\xA5\xA3\x00\xF0\x9F\xA5\x97\x00\xF0\x9F\x8D\xBF\x00\xF0\x9F\xA5\xAB\x00" ++
    "\xF0\x9F\x8D\xB1\x00\xF0\x9F\x8D\x98\x00\xF0\x9F\x8D\x9D\x00\xF0\x9F\x8D\xA0\x00\xF0\x9F\x8D\xA2\x00\xF0\x9F\x8D\xA5\x00\xF0\x9F\x8D\xA1\x00\xF0\x9F\xA5\x9F\x00" ++
    "\xF0\x9F\xA5\xA1\x00\xF0\x9F\x8D\xA6\x00\xF0\x9F\x8D\xAA\x00\xF0\x9F\x8E\x82\x00\xF0\x9F\x8D\xB0\x00\xF0\x9F\xA5\xA7\x00\xF0\x9F\x8D\xAB\x00\xF0\x9F\x8D\xAF\x00" ++
    "\xF0\x9F\x8D\xBC\x00\xF0\x9F\xA5\x9B\x00\xF0\x9F\x8D\xB5\x00\xF0\x9F\x8D\xB6\x00\xF0\x9F\x8D\xBE\x00\xF0\x9F\x8D\xB7\x00\xF0\x9F\x8D\xBB\x00\xF0\x9F\xA5\x82\x00" ++
    "\xF0\x9F\xA5\x83\x00\xF0\x9F\xA5\xA4\x00\xF0\x9F\xA5\xA2\x00\xF0\x9F\x91\x81\x00\xF0\x9F\x91\x85\x00\xF0\x9F\x91\x84\x00\xF0\x9F\x92\x8B\x00\xF0\x9F\x92\x98\x00" ++
    "\xF0\x9F\x92\x93\x00\xF0\x9F\x92\x97\x00\xF0\x9F\x92\x99\x00\xF0\x9F\x92\x9B\x00\xF0\x9F\xA7\xA1\x00\xF0\x9F\x92\x9C\x00\xF0\x9F\x96\xA4\x00\xF0\x9F\x92\x9D\x00" ++
    "\xF0\x9F\x92\x9F\x00\xF0\x9F\x92\x8C\x00\xF0\x9F\x92\xA4\x00\xF0\x9F\x92\xA2\x00\xF0\x9F\x92\xA3\x00";

const Message = struct {
    text: [:0]const u8,
    language: [:0]const u8,
};

/// Array containing all of the emojis messages
const messages = [_]Message{
    .{
        .text = "\x46\x61\x6C\x73\x63\x68\x65\x73\x20\xC3\x9C\x62\x65\x6E\x20\x76\x6F\x6E\x20\x58\x79\x6C\x6F\x70\x68\x6F\x6E\x6D\x75\x73\x69\x6B\x20\x71\x75\xC3\xA4\x6C\x74\x20\x6A\x65\x64\x65\x6E\x20\x67\x72\xC3\xB6\xC3\x9F\x65\x72\x65\x6E\x20\x5A\x77\x65\x72\x67",
        .language = "German",
    },
    .{
        .text = "\x42\x65\x69\xC3\x9F\x20\x6E\x69\x63\x68\x74\x20\x69\x6E\x20\x64\x69\x65\x20\x48\x61\x6E\x64\x2C\x20\x64\x69\x65\x20\x64\x69\x63\x68\x20\x66\xC3\xBC\x74\x74\x65\x72\x74\x2E",
        .language = "German",
    },
    .{
        .text = "\x41\x75\xC3\x9F\x65\x72\x6F\x72\x64\x65\x6E\x74\x6C\x69\x63\x68\x65\x20\xC3\x9C\x62\x65\x6C\x20\x65\x72\x66\x6F\x72\x64\x65\x72\x6E\x20\x61\x75\xC3\x9F\x65\x72\x6F\x72\x64\x65\x6E\x74\x6C\x69\x63\x68\x65\x20\x4D\x69\x74\x74\x65\x6C\x2E",
        .language = "German",
    },
    .{
        .text = "\xD4\xBF\xD6\x80\xD5\xB6\xD5\xA1\xD5\xB4\x20\xD5\xA1\xD5\xBA\xD5\xA1\xD5\xAF\xD5\xAB\x20\xD5\xB8\xD6\x82\xD5\xBF\xD5\xA5\xD5\xAC\x20\xD6\x87\x20\xD5\xAB\xD5\xB6\xD5\xAE\xD5\xAB\x20\xD5\xA1\xD5\xB6\xD5\xB0\xD5\xA1\xD5\xB6\xD5\xA3\xD5\xAB\xD5\xBD\xD5\xBF\x20\xD5\xB9\xD5\xA8\xD5\xB6\xD5\xA5\xD6\x80",
        .language = "Armenian",
    },
    .{
        .text = "\xD4\xB5\xD6\x80\xD5\xA2\x20\xD5\xB8\xD6\x80\x20\xD5\xAF\xD5\xA1\xD6\x81\xD5\xAB\xD5\xB6\xD5\xA8\x20\xD5\xA5\xD5\xAF\xD5\xA1\xD6\x82\x20\xD5\xA1\xD5\xB6\xD5\xBF\xD5\xA1\xD5\xBC\x2C\x20\xD5\xAE\xD5\xA1\xD5\xBC\xD5\xA5\xD6\x80\xD5\xA8\x20\xD5\xA1\xD5\xBD\xD5\xA1\xD6\x81\xD5\xAB\xD5\xB6\x2E\x2E\x2E\x20\xC2\xAB\xD4\xBF\xD5\xB8\xD5\xBF\xD5\xA8\x20\xD5\xB4\xD5\xA5\xD6\x80\xD5\xB8\xD5\xB6\xD6\x81\xD5\xAB\xD6\x81\x20\xD5\xA7\x3A\xC2\xBB",
        .language = "Armenian",
    },
    .{
        .text = "\xD4\xB3\xD5\xA1\xD5\xBC\xD5\xA8\xD5\x9D\x20\xD5\xA3\xD5\xA1\xD6\x80\xD5\xB6\xD5\xA1\xD5\xB6\x2C\x20\xD5\xB1\xD5\xAB\xD6\x82\xD5\xB6\xD5\xA8\xD5\x9D\x20\xD5\xB1\xD5\xB4\xD5\xBC\xD5\xA1\xD5\xB6",
        .language = "Armenian",
    },
    .{
        .text = "\x4A\x65\xC5\xBC\x75\x20\x6B\x6C\xC4\x85\x74\x77\x2C\x20\x73\x70\xC5\x82\xC3\xB3\x64\xC5\xBA\x20\x46\x69\x6E\x6F\x6D\x20\x63\x7A\xC4\x99\xC5\x9B\xC4\x87\x20\x67\x72\x79\x20\x68\x61\xC5\x84\x62\x21",
        .language = "Polish",
    },
    .{
        .text = "\x44\x6F\x62\x72\x79\x6D\x69\x20\x63\x68\xC4\x99\x63\x69\x61\x6D\x69\x20\x6A\x65\x73\x74\x20\x70\x69\x65\x6B\xC5\x82\x6F\x20\x77\x79\x62\x72\x75\x6B\x6F\x77\x61\x6E\x65\x2E",
        .language = "Polish",
    },
    .{
        .text = "\xC3\x8E\xC8\x9B\x69\x20\x6D\x75\x6C\xC8\x9B\x75\x6D\x65\x73\x63\x20\x63\xC4\x83\x20\x61\x69\x20\x61\x6C\x65\x73\x20\x72\x61\x79\x6C\x69\x62\x2E\x0A\xC8\x98\x69\x20\x73\x70\x65\x72\x20\x73\xC4\x83\x20\x61\x69\x20\x6F\x20\x7A\x69\x20\x62\x75\x6E\xC4\x83\x21",
        .language = "Romanian",
    },
    .{
        .text = "\xD0\xAD\xD1\x85\x2C\x20\xD1\x87\xD1\x83\xD0\xB6\xD0\xB0\xD0\xBA\x2C\x20\xD0\xBE\xD0\xB1\xD1\x89\xD0\xB8\xD0\xB9\x20\xD1\x81\xD1\x8A\xD1\x91\xD0\xBC\x20\xD1\x86\xD0\xB5\xD0\xBD\x20\xD1\x88\xD0\xBB\xD1\x8F\xD0\xBF\x20\x28\xD1\x8E\xD1\x84\xD1\x82\xD1\x8C\x29\x20\xD0\xB2\xD0\xB4\xD1\x80\xD1\x8B\xD0\xB7\xD0\xB3\x21",
        .language = "Russian",
    },
    .{
        .text = "\xD0\xAF\x20\xD0\xBB\xD1\x8E\xD0\xB1\xD0\xBB\xD1\x8E\x20\x72\x61\x79\x6C\x69\x62\x21",
        .language = "Russian",
    },
    .{
        .text = "\xD0\x9C\xD0\xBE\xD0\xBB\xD1\x87\xD0\xB8\x2C\x20\xD1\x81\xD0\xBA\xD1\x80\xD1\x8B\xD0\xB2\xD0\xB0\xD0\xB9\xD1\x81\xD1\x8F\x20\xD0\xB8\x20\xD1\x82\xD0\xB0\xD0\xB8\x0A\xD0\x98\x20\xD1\x87\xD1\x83\xD0\xB2\xD1\x81\xD1\x82\xD0\xB2\xD0\xB0\x20\xD0\xB8\x20\xD0\xBC\xD0\xB5\xD1\x87\xD1\x82\xD1\x8B\x20\xD1\x81\xD0\xB2\xD0\xBE\xD0\xB8\x20\xE2\x80\x93\x0A\xD0\x9F\xD1\x83\xD1\x81\xD0\xBA\xD0\xB0\xD0\xB9\x20\xD0\xB2\x20\xD0\xB4\xD1\x83\xD1\x88\xD0\xB5\xD0\xB2\xD0\xBD\xD0\xBE\xD0\xB9\x20\xD0\xB3\xD0\xBB\xD1\x83\xD0\xB1\xD0\xB8\xD0\xBD\xD0\xB5\x0A\xD0\x98\x20\xD0\xB2\xD1\x81\xD1\x85\xD0\xBE\xD0\xB4\xD1\x8F\xD1\x82\x20\xD0\xB8\x20\xD0\xB7\xD0\xB0\xD0\xB9\xD0\xB4\xD1\x83\xD1\x82\x20\xD0\xBE\xD0\xBD\xD0\xB5\x0A\xD0\x9A\xD0\xB0\xD0\xBA\x20\xD0\xB7\xD0\xB2\xD0\xB5\xD0\xB7\xD0\xB4\xD1\x8B\x20\xD1\x8F\xD1\x81\xD0\xBD\xD1\x8B\xD0\xB5\x20\xD0\xB2\x20\xD0\xBD\xD0\xBE\xD1\x87\xD0\xB8\x2D\x0A\xD0\x9B\xD1\x8E\xD0\xB1\xD1\x83\xD0\xB9\xD1\x81\xD1\x8F\x20\xD0\xB8\xD0\xBC\xD0\xB8\x20\xE2\x80\x93\x20\xD0\xB8\x20\xD0\xBC\xD0\xBE\xD0\xBB\xD1\x87\xD0\xB8\x2E",
        .language = "Russian",
    },
    .{
        .text = "\x56\x6F\x69\x78\x20\x61\x6D\x62\x69\x67\x75\xC3\xAB\x20\x64\xE2\x80\x99\x75\x6E\x20\x63\xC5\x93\x75\x72\x20\x71\x75\x69\x20\x61\x75\x20\x7A\xC3\xA9\x70\x68\x79\x72\x20\x70\x72\xC3\xA9\x66\xC3\xA8\x72\x65\x20\x6C\x65\x73\x20\x6A\x61\x74\x74\x65\x73\x20\x64\x65\x20\x6B\x69\x77\x69",
        .language = "French",
    },
    .{
        .text = "\x42\x65\x6E\x6A\x61\x6D\xC3\xAD\x6E\x20\x70\x69\x64\x69\xC3\xB3\x20\x75\x6E\x61\x20\x62\x65\x62\x69\x64\x61\x20\x64\x65\x20\x6B\x69\x77\x69\x20\x79\x20\x66\x72\x65\x73\x61\x3B\x20\x4E\x6F\xC3\xA9\x2C\x20\x73\x69\x6E\x20\x76\x65\x72\x67\xC3\xBC\x65\x6E\x7A\x61\x2C\x20\x6C\x61\x20\x6D\xC3\xA1\x73\x20\x65\x78\x71\x75\x69\x73\x69\x74\x61\x20\x63\x68\x61\x6D\x70\x61\xC3\xB1\x61\x20\x64\x65\x6C\x20\x6D\x65\x6E\xC3\xBA\x2E",
        .language = "Spanish",
    },
    .{
        .text = "\xCE\xA4\xCE\xB1\xCF\x87\xCE\xAF\xCF\x83\xCF\x84\xCE\xB7\x20\xCE\xB1\xCE\xBB\xCF\x8E\xCF\x80\xCE\xB7\xCE\xBE\x20\xCE\xB2\xCE\xB1\xCF\x86\xCE\xAE\xCF\x82\x20\xCF\x88\xCE\xB7\xCE\xBC\xCE\xAD\xCE\xBD\xCE\xB7\x20\xCE\xB3\xCE\xB7\x2C\x20\xCE\xB4\xCF\x81\xCE\xB1\xCF\x83\xCE\xBA\xCE\xB5\xCE\xBB\xCE\xAF\xCE\xB6\xCE\xB5\xCE\xB9\x20\xCF\x85\xCF\x80\xCE\xAD\xCF\x81\x20\xCE\xBD\xCF\x89\xCE\xB8\xCF\x81\xCE\xBF\xCF\x8D\x20\xCE\xBA\xCF\x85\xCE\xBD\xCF\x8C\xCF\x82",
        .language = "Greek",
    },
    .{
        .text = "\xCE\x97\x20\xCE\xBA\xCE\xB1\xCE\xBB\xCF\x8D\xCF\x84\xCE\xB5\xCF\x81\xCE\xB7\x20\xCE\xAC\xCE\xBC\xCF\x85\xCE\xBD\xCE\xB1\x20\xCE\xB5\xCE\xAF\xCE\xBD\xCE\xB1\xCE\xB9\x20\xCE\xB7\x20\xCE\xB5\xCF\x80\xCE\xAF\xCE\xB8\xCE\xB5\xCF\x83\xCE\xB7\x2E",
        .language = "Greek",
    },
    .{
        .text = "\xCE\xA7\xCF\x81\xCF\x8C\xCE\xBD\xCE\xB9\xCE\xB1\x20\xCE\xBA\xCE\xB1\xCE\xB9\x20\xCE\xB6\xCE\xB1\xCE\xBC\xCE\xAC\xCE\xBD\xCE\xB9\xCE\xB1\x21",
        .language = "Greek",
    },
    .{
        .text = "\xCE\xA0\xCF\x8E\xCF\x82\x20\xCF\x84\xCE\xB1\x20\xCF\x80\xCE\xB1\xCF\x82\x20\xCF\x83\xCE\xAE\xCE\xBC\xCE\xB5\xCF\x81\xCE\xB1\x3B",
        .language = "Greek",
    },
    .{
        .text = "\xE6\x88\x91\xE8\x83\xBD\xE5\x90\x9E\xE4\xB8\x8B\xE7\x8E\xBB\xE7\x92\x83\xE8\x80\x8C\xE4\xB8\x8D\xE4\xBC\xA4\xE8\xBA\xAB\xE4\xBD\x93\xE3\x80\x82",
        .language = "Chinese",
    },
    .{
        .text = "\xE4\xBD\xA0\xE5\x90\x83\xE4\xBA\x86\xE5\x90\x97\xEF\xBC\x9F",
        .language = "Chinese",
    },
    .{
        .text = "\xE4\xB8\x8D\xE4\xBD\x9C\xE4\xB8\x8D\xE6\xAD\xBB\xE3\x80\x82",
        .language = "Chinese",
    },
    .{
        .text = "\xE6\x9C\x80\xE8\xBF\x91\xE5\xA5\xBD\xE5\x90\x97\xEF\xBC\x9F",
        .language = "Chinese",
    },
    .{
        .text = "\xE5\xA1\x9E\xE7\xBF\x81\xE5\xA4\xB1\xE9\xA9\xAC\xEF\xBC\x8C\xE7\x84\x89\xE7\x9F\xA5\xE9\x9D\x9E\xE7\xA6\x8F\xE3\x80\x82",
        .language = "Chinese",
    },
    .{
        .text = "\xE5\x8D\x83\xE5\x86\x9B\xE6\x98\x93\xE5\xBE\x97\x2C\x20\xE4\xB8\x80\xE5\xB0\x86\xE9\x9A\xBE\xE6\xB1\x82",
        .language = "Chinese",
    },
    .{
        .text = "\xE4\xB8\x87\xE4\xBA\x8B\xE5\xBC\x80\xE5\xA4\xB4\xE9\x9A\xBE\xE3\x80\x82",
        .language = "Chinese",
    },
    .{
        .text = "\xE9\xA3\x8E\xE6\x97\xA0\xE5\xB8\xB8\xE9\xA1\xBA\xEF\xBC\x8C\xE5\x85\xB5\xE6\x97\xA0\xE5\xB8\xB8\xE8\x83\x9C\xE3\x80\x82",
        .language = "Chinese",
    },
    .{
        .text = "\xE6\xB4\xBB\xE5\x88\xB0\xE8\x80\x81\xEF\xBC\x8C\xE5\xAD\xA6\xE5\x88\xB0\xE8\x80\x81\xE3\x80\x82",
        .language = "Chinese",
    },
    .{
        .text = "\xE4\xB8\x80\xE8\xA8\x80\xE6\x97\xA2\xE5\x87\xBA\xEF\xBC\x8C\xE9\xA9\xB7\xE9\xA9\xAC\xE9\x9A\xBE\xE8\xBF\xBD\xE3\x80\x82",
        .language = "Chinese",
    },
    .{
        .text = "\xE8\xB7\xAF\xE9\x81\xA5\xE7\x9F\xA5\xE9\xA9\xAC\xE5\x8A\x9B\xEF\xBC\x8C\xE6\x97\xA5\xE4\xB9\x85\xE8\xA7\x81\xE4\xBA\xBA\xE5\xBF\x83",
        .language = "Chinese",
    },
    .{
        .text = "\xE6\x9C\x89\xE7\x90\x86\xE8\xB5\xB0\xE9\x81\x8D\xE5\xA4\xA9\xE4\xB8\x8B\xEF\xBC\x8C\xE6\x97\xA0\xE7\x90\x86\xE5\xAF\xB8\xE6\xAD\xA5\xE9\x9A\xBE\xE8\xA1\x8C\xE3\x80\x82",
        .language = "Chinese",
    },
    .{
        .text = "\xE7\x8C\xBF\xE3\x82\x82\xE6\x9C\xA8\xE3\x81\x8B\xE3\x82\x89\xE8\x90\xBD\xE3\x81\xA1\xE3\x82\x8B",
        .language = "Japanese",
    },
    .{
        .text = "\xE4\xBA\x80\xE3\x81\xAE\xE7\x94\xB2\xE3\x82\x88\xE3\x82\x8A\xE5\xB9\xB4\xE3\x81\xAE\xE5\x8A\x9F",
        .language = "Japanese",
    },
    .{
        .text = "\xE3\x81\x86\xE3\x82\x89\xE3\x82\x84\xE3\x81\xBE\xE3\x81\x97\x20\x20\xE6\x80\x9D\xE3\x81\xB2\xE5\x88\x87\xE3\x82\x8B\xE6\x99\x82\x20\x20\xE7\x8C\xAB\xE3\x81\xAE\xE6\x81\x8B",
        .language = "Japanese",
    },
    .{
        .text = "\xE8\x99\x8E\xE7\xA9\xB4\xE3\x81\xAB\xE5\x85\xA5\xE3\x82\x89\xE3\x81\x9A\xE3\x82\x93\xE3\x81\xB0\xE8\x99\x8E\xE5\xAD\x90\xE3\x82\x92\xE5\xBE\x97\xE3\x81\x9A\xE3\x80\x82",
        .language = "Japanese",
    },
    .{
        .text = "\xE4\xBA\x8C\xE5\x85\x8E\xE3\x82\x92\xE8\xBF\xBD\xE3\x81\x86\xE8\x80\x85\xE3\x81\xAF\xE4\xB8\x80\xE5\x85\x8E\xE3\x82\x92\xE3\x82\x82\xE5\xBE\x97\xE3\x81\x9A\xE3\x80\x82",
        .language = "Japanese",
    },
    .{
        .text = "\xE9\xA6\xAC\xE9\xB9\xBF\xE3\x81\xAF\xE6\xAD\xBB\xE3\x81\xAA\xE3\x81\xAA\xE3\x81\x8D\xE3\x82\x83\xE6\xB2\xBB\xE3\x82\x89\xE3\x81\xAA\xE3\x81\x84\xE3\x80\x82",
        .language = "Japanese",
    },
    .{
        .text = "\xE6\x9E\xAF\xE9\x87\x8E\xE8\xB7\xAF\xE3\x81\xAB\xE3\x80\x80\xE5\xBD\xB1\xE3\x81\x8B\xE3\x81\x95\xE3\x81\xAA\xE3\x82\x8A\xE3\x81\xA6\xE3\x80\x80\xE3\x82\x8F\xE3\x81\x8B\xE3\x82\x8C\xE3\x81\x91\xE3\x82\x8A",
        .language = "Japanese",
    },
    .{
        .text = "\xE7\xB9\xB0\xE3\x82\x8A\xE8\xBF\x94\xE3\x81\x97\xE9\xBA\xA6\xE3\x81\xAE\xE7\x95\x9D\xE7\xB8\xAB\xE3\x81\xB5\xE8\x83\xA1\xE8\x9D\xB6\xE5\x93\x89",
        .language = "Japanese",
    },
    .{
        .text = "\xEC\x95\x84\xEB\x93\x9D\xED\x95\x9C\x20\xEB\xB0\x94\xEB\x8B\xA4\x20\xEC\x9C\x84\xEC\x97\x90\x20\xEA\xB0\x88\xEB\xA7\xA4\xEA\xB8\xB0\x20\xEB\x91\x90\xEC\x97\x87\x20\xEB\x82\xA0\xEC\x95\x84\x20\xEB\x8F\x88\xEB\x8B\xA4\x2E\x0A\xEB\x84\x88\xED\x9B\x8C\xEB\x84\x88\xED\x9B\x8C\x20\xEC\x8B\x9C\xEB\xA5\xBC\x20\xEC\x93\xB4\xEB\x8B\xA4\x2E\x20\xEB\xAA\xA8\xEB\xA5\xB4\xEB\x8A\x94\x20\xEB\x82\x98\xEB\x9D\xBC\x20\xEA\xB8\x80\xEC\x9E\x90\xEB\x8B\xA4\x2E\x0A\xEB\x84\x90\xEB\x94\xB0\xEB\x9E\x80\x20\xED\x95\x98\xEB\x8A\x98\x20\xEB\xB3\xB5\xED\x8C\x90\xEC\x97\x90\x20\xEB\x82\x98\xEB\x8F\x84\x20\xEA\xB0\x99\xEC\x9D\xB4\x20\xEC\x8B\x9C\xEB\xA5\xBC\x20\xEC\x93\xB4\xEB\x8B\xA4\x2E",
        .language = "Korean",
    },
    .{
        .text = "\xEC\xA0\x9C\x20\xEB\x88\x88\xEC\x97\x90\x20\xEC\x95\x88\xEA\xB2\xBD\xEC\x9D\xB4\xEB\x8B\xA4",
        .language = "Korean",
    },
    .{
        .text = "\xEA\xBF\xA9\x20\xEB\xA8\xB9\xEA\xB3\xA0\x20\xEC\x95\x8C\x20\xEB\xA8\xB9\xEB\x8A\x94\xEB\x8B\xA4",
        .language = "Korean",
    },
    .{
        .text = "\xEB\xA1\x9C\xEB\xA7\x88\xEB\x8A\x94\x20\xED\x95\x98\xEB\xA3\xA8\xEC\x95\x84\xEC\xB9\xA8\xEC\x97\x90\x20\xEC\x9D\xB4\xEB\xA3\xA8\xEC\x96\xB4\xEC\xA7\x84\x20\xEA\xB2\x83\xEC\x9D\xB4\x20\xEC\x95\x84\xEB\x8B\x88\xEB\x8B\xA4",
        .language = "Korean",
    },
    .{
        .text = "\xEA\xB3\xA0\xEC\x83\x9D\x20\xEB\x81\x9D\xEC\x97\x90\x20\xEB\x82\x99\xEC\x9D\xB4\x20\xEC\x98\xA8\xEB\x8B\xA4",
        .language = "Korean",
    },
    .{
        .text = "\xEA\xB0\x9C\xEC\xB2\x9C\xEC\x97\x90\xEC\x84\x9C\x20\xEC\x9A\xA9\x20\xEB\x82\x9C\xEB\x8B\xA4",
        .language = "Korean",
    },
    .{
        .text = "\xEC\x95\x88\xEB\x85\x95\xED\x95\x98\xEC\x84\xB8\xEC\x9A\x94\x3F",
        .language = "Korean",
    },
    .{
        .text = "\xEB\xA7\x8C\xEB\x82\x98\xEC\x84\x9C\x20\xEB\xB0\x98\xEA\xB0\x91\xEC\x8A\xB5\xEB\x8B\x88\xEB\x8B\xA4",
        .language = "Korean",
    },
    .{
        .text = "\xED\x95\x9C\xEA\xB5\xAD\xEB\xA7\x90\x20\xED\x95\x98\xEC\x8B\xA4\x20\xEC\xA4\x84\x20\xEC\x95\x84\xEC\x84\xB8\xEC\x9A\x94\x3F",
        .language = "Korean",
    },
};

//--------------------------------------------------------------------------------------
// Global variables
//--------------------------------------------------------------------------------------
// Arrays that holds the random emojis
const Emoji = struct {
    index: usize, // Index inside `emojiCodepoints`
    message: *const Message, // Message index
    color: rl.Color, // Emoji color
};

var emojis: [emoji_per_height * emoji_per_width]Emoji = undefined;

var hovered: ?*Emoji = null;
var selected_emoji: ?*Emoji = null;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    rl.setConfigFlags(.{ .msaa_4x_hint = true, .vsync_hint = true });
    rl.initWindow(screen_width, screen_height, "raylib [text] example - unicode");
    defer rl.closeWindow();

    // Load the font resources
    // NOTE: fontAsian is for asian languages,
    // fontEmoji is the emojis and fontDefault is used for everything else
    const font_default = try rl.loadFont("examples/text/resources/dejavu.fnt");
    defer rl.unloadFont(font_default);
    const font_asian = try rl.loadFont("examples/text/resources/noto_cjk.fnt");
    defer rl.unloadFont(font_asian);
    const font_emoji = try rl.loadFont("examples/text/resources/symbola.fnt");
    defer rl.unloadFont(font_emoji);

    var hovered_pos = rl.Vector2{ .x = 0.0, .y = 0.0 };
    var selected_pos = rl.Vector2{ .x = 0.0, .y = 0.0 };

    // Set a random set of emojis when starting up
    randomizeEmoji();

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main loop
    while (!rl.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        // Add a new set of emojis when SPACE is pressed
        if (rl.isKeyPressed(.space)) randomizeEmoji();

        // Set the selected emoji
        if (rl.isMouseButtonPressed(.left) and (hovered != null) and (hovered != selected_emoji)) {
            selected_emoji = hovered;
            selected_pos = hovered_pos;
        }

        const mouse = rl.getMousePosition();
        var position = rl.Vector2{ .x = 28.8, .y = 10.0 };
        hovered = null;
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        // Draw random emojis in the background
        //------------------------------------------------------------------------------
        for (&emojis, 0..) |*emoji, i| {
            const txt = emojiCodepoints[emoji.index..];
            const emoji_rect = rl.Rectangle{
                .x = position.x,
                .y = position.y,
                .height = @floatFromInt(font_emoji.baseSize),
                .width = @floatFromInt(font_emoji.baseSize),
            };

            if (!rl.checkCollisionPointRec(mouse, emoji_rect)) {
                rl.drawTextEx(font_emoji, txt, position, @floatFromInt(font_emoji.baseSize), 1.0, if (selected_emoji == emoji) emoji.color else rl.fade(.light_gray, 0.4));
            } else {
                rl.drawTextEx(font_emoji, txt, position, @floatFromInt(font_emoji.baseSize), 1.0, emoji.color);
                hovered = emoji;
                hovered_pos = position;
            }

            if ((i != 0) and (i % emoji_per_width == 0)) {
                position.y += @as(f32, @floatFromInt(font_emoji.baseSize)) + 24.25;
                position.x = 28.8;
            } else {
                position.x += @as(f32, @floatFromInt(font_emoji.baseSize)) + 28.8;
            }
        }
        //------------------------------------------------------------------------------

        // Draw the message when a emoji is selected
        //------------------------------------------------------------------------------
        if (selected_emoji) |selected| {
            const message = selected.message;
            const horizontal_padding = 20;
            const vertical_padding = 30;
            var font = &font_default;

            // Set correct font for asian languages
            font = if (rl.textIsEqual(message.language, "Chinese") or
                rl.textIsEqual(message.language, "Korean") or
                rl.textIsEqual(message.language, "Japanese")) &font_asian else font;

            // Calculate size for the message box (approximate the height and width)
            var sz = rl.measureTextEx(font.*, message.text, @floatFromInt(font.baseSize), 1.0);
            if (sz.x > 300) {
                sz.y *= sz.x / 300;
                sz.x = 300;
            } else if (sz.x < 160) {
                sz.x = 160;
            }

            var msg_rect = rl.Rectangle{
                .x = selected_pos.x - 38.8,
                .y = selected_pos.y,
                .width = 2 * horizontal_padding + sz.x,
                .height = 2 * vertical_padding + sz.y,
            };
            msg_rect.y -= msg_rect.height;

            // Coordinates for the chat bubble triangle
            var a = rl.Vector2{ .x = selected_pos.x, .y = msg_rect.y + msg_rect.height };
            var b = rl.Vector2{ .x = a.x + 8, .y = a.y + 10 };
            var c = rl.Vector2{ .x = a.x + 10, .y = a.y };

            // Don't go outside the screen
            if (msg_rect.x < 10) msg_rect.x += 28;
            if (msg_rect.y < 10) {
                msg_rect.y = selected_pos.y + 84;
                a.y = msg_rect.y;
                c.y = a.y;
                b.y = a.y - 10;

                // Swap values so we can actually render the triangle :(
                const tmp = a;
                a = b;
                b = tmp;
            }

            if (msg_rect.x + msg_rect.width > screen_width) msg_rect.x -= (msg_rect.x + msg_rect.width) - screen_width + 10;

            // Draw chat bubble
            rl.drawRectangleRec(msg_rect, selected.color);
            rl.drawTriangle(a, b, c, selected.color);

            // Draw the main text message
            const text_rect = rl.Rectangle{
                .x = msg_rect.x + horizontal_padding / 2,
                .y = msg_rect.y + vertical_padding / 2,
                .width = msg_rect.width - horizontal_padding,
                .height = msg_rect.height,
            };
            drawTextBoxed(font.*, message.text, text_rect, @floatFromInt(font.baseSize), 1.0, true, .white);

            // Draw the info text below the main message
            const size = message.text.len;
            const length = rl.getCodepointCount(message.text);
            const info = rl.textFormat("%s %u characters %i bytes", .{ message.language.ptr, length, size });
            sz = rl.measureTextEx(font_default, info, 10, 1.0);

            rl.drawText(info, @intFromFloat(text_rect.x + text_rect.width - sz.x), @intFromFloat(msg_rect.y + msg_rect.height - sz.y - 2), 10, .ray_white);
        }
        //------------------------------------------------------------------------------

        // Draw the info text
        rl.drawText("These emojis have something to tell you, click each to find out!", (screen_width - 650) / 2, screen_height - 40, 20, .gray);
        rl.drawText("Each emoji is a unicode character from a font, not a texture... Press [SPACEBAR] to refresh", (screen_width - 484) / 2, screen_height - 16, 10, .gray);

        //----------------------------------------------------------------------------------
    }
}

// Fills the emoji array with random emoji (only those emojis present in fontEmoji)
fn randomizeEmoji() void {
    hovered = null;
    selected_emoji = null;
    const start = rl.getRandomValue(45, 360);

    for (&emojis, 0..) |*emoji, i| {
        // 0-179 emoji codepoints (from emoji char array) each 4bytes + null char
        emoji.index = @intCast(rl.getRandomValue(0, 179) * 5);

        // Generate a random color for this emoji
        const hue: f32 = @floatFromInt(@rem(start * @as(i32, @intCast(i + 1)), 360));
        emoji.color = rl.fade(rl.colorFromHSV(hue, 0.6, 0.85), 0.8);

        // Set a random message for this emoji
        emoji.message = &messages[@intCast(rl.getRandomValue(0, messages.len - 1))];
    }
}

//--------------------------------------------------------------------------------------
// Module functions definition
//--------------------------------------------------------------------------------------

// Draw text using font inside rectangle limits
fn drawTextBoxed(font: rl.Font, text: [:0]const u8, rec: rl.Rectangle, font_size: f32, spacing: f32, word_wrap: bool, tint: rl.Color) void {
    drawTextBoxedSelectable(font, text, rec, font_size, spacing, word_wrap, tint, 0, 0, .white, .white);
}

// Draw text using font inside rectangle limits with support for text selection
fn drawTextBoxedSelectable(font: rl.Font, text: [:0]const u8, rec: rl.Rectangle, font_size: f32, spacing: f32, word_wrap: bool, tint: rl.Color, select_box_start: i32, select_length: i32, select_tint: rl.Color, select_back_tint: rl.Color) void {
    var select_start = select_box_start;
    const length = rl.textLength(text); // Total length in bytes of the text, scanned by codepoints in loop

    var text_offset_y: f32 = 0; // Offset between lines (on line break '\n')
    var text_offset_x: f32 = 0.0; // Offset X to next character to draw

    const scale_factor = font_size / @as(f32, @floatFromInt(font.baseSize)); // Character rectangle scaling factor

    // Word/character wrapping mechanism variables
    const MeasureState = enum(u8) { measure, draw };
    var state: MeasureState = if (word_wrap) .measure else .draw;

    var start_line: i32 = -1; // Index where to begin drawing (where a line begins)
    var end_line: i32 = -1; // Index where to stop drawing (where a line ends)
    var last_char: i32 = -1; // Holds last value of the character position

    var i: i32 = 0;
    var k: i32 = 0;
    while (i < length) : ({
        i += 1;
        k += 1;
    }) {
        // Get next codepoint from byte string and glyph index in font
        var codepoint_byte_count: i32 = 0;
        const codepoint = rl.getCodepoint(text[@intCast(i)..], &codepoint_byte_count);
        const index: usize = @intCast(rl.getGlyphIndex(font, codepoint));

        // NOTE: Normally we exit the decoding sequence as soon as a bad byte is found (and return 0x3f)
        // but we need to draw all of the bad bytes using the '?' symbol moving one byte
        if (codepoint == 0x3f) codepoint_byte_count = 1;
        i += @intCast(codepoint_byte_count - 1);

        var glyph_width: f32 = 0;
        if (codepoint != '\n') {
            glyph_width = if (font.glyphs[index].advanceX == 0) font.recs[index].width * scale_factor else @as(f32, @floatFromInt(font.glyphs[index].advanceX)) * scale_factor;

            if (i + 1 < length) glyph_width = glyph_width + spacing;
        }
        // NOTE: When wordWrap is ON we first measure how much of the text we can draw before going outside of the rec container
        // We store this info in startLine and endLine, then we change states, draw the text between those two variables
        // and change states again and again recursively until the end of the text (or until we get outside of the container).
        // When wordWrap is OFF we don't need the measure state so we go to the drawing state immediately
        // and begin drawing on the next line before we can get outside the container.
        if (state == .measure) {
            // TODO: There are multiple types of spaces in UNICODE, maybe it's a good idea to add support for more
            // Ref: http://jkorpela.fi/chars/spaces.html
            if ((codepoint == ' ') or (codepoint == '\t') or (codepoint == '\n')) end_line = @intCast(i);

            if ((text_offset_x + glyph_width) > rec.width) {
                end_line = if (end_line < 1) @intCast(i) else end_line;
                if (i == end_line) end_line -= codepoint_byte_count;
                if ((start_line + codepoint_byte_count) == end_line) end_line = @as(i32, @intCast(i)) - codepoint_byte_count;

                state = if (state == .draw) .measure else .draw;
            } else if ((i + 1) == length) {
                end_line = @intCast(i);
                state = if (state == .draw) .measure else .draw;
            } else if (codepoint == '\n') {
                state = if (state == .draw) .measure else .draw;
            }

            if (state == .draw) {
                text_offset_x = 0;
                i = @intCast(start_line);
                glyph_width = 0;

                // Save character position when we switch states
                const tmp = last_char;
                last_char = k - 1;
                k = tmp;
            }
        } else {
            if (codepoint == '\n') {
                if (!word_wrap) {
                    const bS: f32 = @floatFromInt(font.baseSize);
                    text_offset_y += (bS + bS / 2) * scale_factor;
                    text_offset_x = 0;
                }
            } else {
                if (!word_wrap and ((text_offset_x + glyph_width) > rec.width)) {
                    const bS: f32 = @floatFromInt(font.baseSize);
                    text_offset_y += (bS + bS / 2) * scale_factor;
                    text_offset_x = 0;
                }

                // When text overflows rectangle height limit, just stop drawing
                if ((text_offset_y + @as(f32, @floatFromInt(font.baseSize)) * scale_factor) > rec.height) break;

                // Draw selection background
                var is_glyph_selected = false;
                if ((select_start >= 0) and (k >= select_start) and (k < (select_start + select_length))) {
                    rl.drawRectangleRec(.{
                        .x = rec.x + text_offset_x - 1,
                        .y = rec.y + text_offset_y,
                        .width = glyph_width,
                        .height = @as(f32, @floatFromInt(font.baseSize)) * scale_factor,
                    }, select_back_tint);
                    is_glyph_selected = true;
                }

                // Draw current character glyph
                if ((codepoint != ' ') and (codepoint != '\t')) {
                    rl.drawTextCodepoint(font, codepoint, .{
                        .x = rec.x + text_offset_x,
                        .y = rec.y + text_offset_y,
                    }, font_size, if (is_glyph_selected) select_tint else tint);
                }
            }

            if (word_wrap and (i == end_line)) {
                const bS: f32 = @floatFromInt(font.baseSize);
                text_offset_y += (bS + bS / 2) * scale_factor;
                text_offset_x = 0;
                start_line = end_line;
                end_line = -1;
                glyph_width = 0;
                select_start += last_char - k;
                k = last_char;

                state = if (state == .draw) .measure else .draw;
            }
        }

        if ((text_offset_x != 0) or (codepoint != ' ')) text_offset_x += glyph_width; // avoid leading spaces
    }
}
