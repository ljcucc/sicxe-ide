const opcs = [
  "LDA", "LDX", "LDL", "STA", "STX", "STL", "ADD", "SUB", "MUL", "DIV", "COMP", "TIX", "JEQ", "JGT", "JLT", "J",
  "AND", "OR", "RSUB", "JSUB", "LDCH", "STCH", "ADDF", "SUBF", "MULF", "DIVF", "LDB", "LDS", "LDF", "LDT", "STB", "STS",
  "STF", "STT", "COMPF", "N/A", "ADDR", "SUB", "MULR", "DIVR", "COMPR", "SHIFTL", "SHIFTR", "RMO", "SVC", "CLEAR", "TIXR", "N/A",
  "FLOAT", "FIX", "NORM", "N/A", "LPS", "STI", "RD", "WD", "TD", "N/A", "STSW", "SSK", "SIO", "HIO", "TIO", "N/A",
]

export class SICEmulator{
  constructor(mem, reg, pc){
    this.mem = new Uint8Array(0x10000);
    this.reg = new Uint32Array(0xF);

    this.pc = 0;
    this.instrType = "";
    this.fetchedInstr = 0x00;
    this.instrFlag = {
      n: false,
      i: false
    };
  }

  getOpcName(opc){
    return opcs[opc >> 2] || "N/A";
  }

  Eval(){
    this.fetchedInstr = 0x0;

    // format check
    let { instr_t, ni } = this.fetchInstrLen(this.mem[this.pc]),
        xbpe = this.peekInstrFlag(this.mem[this.pc+1]);
    instr_t = instr_t > 2 || ni ^ 0 ?  /* if f3,f4 and ni != 0 */
      this.peekInstrFormat(this.mem[this.pc+1]):
      instr_t;
    this.instrType = `f${instr_t}`;
    this.instrFlag = {
      n: ni & 0b10,
      i: ni & 0b01,
      x: xbpe & 0b1000, 
      b: xbpe & 0b0100, 
      p: xbpe & 0b0010, 
      x: xbpe & 0b0001, 
    };

    // fetch full instruction
    for(let i = 0; i < instr_t; i++){
      this.fetchedInstr |= (this.mem[this.pc++]) << (8*i);
    }

    // decode and fetch operand
    this.calcTA(this.fetchedInstr, this.instrFlag);

    // console.log(this.fetchedInstr.toString(16));
  }

  calcTA(instr, flags){
  }

  getValueFromTA(){
  }

  fetchInstrLen(opc){
    var type = (opc & 0xFC ) >> 4;
    var instr_t, ni = opc & 0x3;

    /**
     * 0xC: 1100b
     * 0x3: 0011b
     * 
     * 0x8: 1000b
     * 0xFC: 1111 1100b
     */

    if (!(type ^ 0xB | type ^ 0xF))
      instr_t = 1;
    else if (!(type & 0xC ^ 0x8) && type & 0x3)
      instr_t = 2;
    else
      instr_t = 3;

    return {
      instr_t,
      ni
    }

  }

  peekInstrFormat(opc2){
    if(opc2 & 0x10) return 4
    return 3;
  }

  peekInstrFlag(opc2){
    return (opc2 & 0b11110000) >> 4;
  }

  evalSequence(){
    return function*() {
      for (this.pc = 0;;)
        yield eval();
    }.bind(this)
  }
}