//
//  main.swift
//  mediakeys
//
//  Created by Elia on 19/04/15.
//  Copyright (c) 2015 Elia Schito. All rights reserved.
//

import Foundation
import AppKit

func doKey(key: Int, down: Bool) {
  let flags = NSEventModifierFlags(down ? 0xa00 : 0xb00)
  let data1 = (key << 16) | ((down ? 0xa : 0xb) << 8)

  let ev = NSEvent.otherEventWithType(
    NSEventType.SystemDefined,
    location: NSPoint(x:0.0, y:0.0),
    modifierFlags: flags,
    timestamp: NSTimeInterval(0),
    windowNumber: 0,
    context: nil,
    // context: 0,
    subtype: 8,
    data1: data1,
    data2: -1
  )
  let cev = ev!.CGEvent!
  CGEventPost(0, cev)
}

func HIDPostAuxKey(key: Int) {
  doKey(key, true)
  doKey(key, false)
}


// hidsystem/ev_keymap.h
let NX_KEYTYPE_SOUND_UP   = 0
let NX_KEYTYPE_SOUND_DOWN = 1
let NX_KEYTYPE_PLAY       = 16
let NX_KEYTYPE_NEXT       = 17
let NX_KEYTYPE_PREVIOUS   = 18
let NX_KEYTYPE_FAST       = 19
let NX_KEYTYPE_REWIND     = 20

let commands = [
  "playpause":  NX_KEYTYPE_PLAY,
  "next":       NX_KEYTYPE_NEXT,
  "prev":       NX_KEYTYPE_PREVIOUS,
  "volup":      NX_KEYTYPE_SOUND_UP,
  "voldown":    NX_KEYTYPE_SOUND_DOWN
]

func usage() {
  let command_names = commands.keys
  println("Usage: \(Process.arguments[0]) command")
  print("\tSupported commands are: ")
  for name in command_names {
    print("\(name) ")
  }
}

if Process.arguments.count != 2 {
  usage()
  exit(1)
}

let command_name = Process.arguments[1] // "playpause"
let command = commands[command_name]

if command == nil {
  usage()
  exit(1)
}

HIDPostAuxKey(command!)
