import { SICEmulator } from "./sic.js";

export class SICTest extends SICEmulator{
  constructor(){
    super();

    let arr = new Array(0x10000);
    arr = [
      0x4, 0x0, 0x3,
      0x90, 0x10, 
      0x20, 0x30, 0x40,
      0x50, 0x60, 0x70,
      0x80, 0x90, 0xa0,
      0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    ].concat(arr);
    console.log(arr);
    this.model.mem = new Uint8Array(arr);
    for(var i = 0; i < arr.length; i++){
      this.model.mem[i] = arr[i] || 0;
    } 
  }
}