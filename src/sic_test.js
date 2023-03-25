import { SICEmulator } from "./sic.js";

export class SICTest extends SICEmulator{
  constructor(){
    super();

    let arr = new Array(0x10000);
    arr = [
      0x90, 0x10, 
      0x20, 0x30, 0x40,
      0x50, 0x60, 0x70,
      0x80, 0x90, 0xa0,
    ].concat(arr);
    console.log(arr);
    this.mem = new Uint8Array(arr);
    for(var i = 0; i < this.mem.length; i++){
      this.mem[i] = this.mem[i] || 0;
    } 
  }
}