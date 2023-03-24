import { SICEmulator } from "./sic.js";

export class SICTest extends SICEmulator{
  constructor(){
    super();

    this.mem = new Uint8Array([
      0x90, 0x10, 
      0x20, 0x30, 0x40,
      0x50, 0x60, 0x70,
      0x80, 0x90, 0xa0,
    ]);
  }
}