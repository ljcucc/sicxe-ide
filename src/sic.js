export class SICEmulator{
  constructor(mem, reg, pc){
    this.mem = new Uint8Array(0x10000);
    this.reg = new Uint32Array(0xF);

    this.pc = 0;
    this.instrType = "";
    this.fetchedInstr = 0x00;
  }

  eval(){
    let instr_t;
    this.fetchedInstr = 0x0;
    (instr_t = this.fetchInstrLen(this.mem[this.pc]));
    this.instrType = `f${instr_t}`;

    for(let i = 0; i < instr_t; i++){
      this.fetchedInstr |= (this.mem[this.pc++]) << (8*i);
    }

    // console.log(this.fetchedInstr.toString(16));
  }

  fetchInstrLen(opc){
    var type = (opc & 0xFC ) >> 4;
    var ni = opc & 0x3;

    // this.fetchedInstr = opc;
    // useful text: var __mm = 0x3, mm__ = 0xC;

    /**
     * 0xC: 1100b
     * 0x3: 0011b
     * 
     * 0x8: 1000b
     * 0xFC: 1111 1100b
     */

    if(!(type ^ 0xB | type ^0xF)){
      // console.log("format 1");
      return 1;
    }

    if(!(type & 0xC ^ 0x8) && type & 0x3){
      // console.log("format 2");
      return 2;
    }

    return 3;
  }

  evalSequence(){
    return function*() {
      for (this.pc = 0;;)
        yield eval();
    }.bind(this)
  }
}