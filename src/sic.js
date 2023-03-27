const opcs = [
  "LDA",  "LDX", "LDL",   "STA",  "STX",  "STL",  "ADD",  "SUB",  "MUL",   "DIV",    "COMP",   "TIX", "JEQ", "JGT",   "JLT", "J",
  "AND",  "OR",  "RSUB",  "JSUB", "LDCH", "STCH", "ADDF", "SUBF", "MULF",  "DIVF",   "LDB",    "LDS", "LDF", "LDT",   "STB", "STS",
  "STF",  "STT", "COMPF", "N/A",  "ADDR", "SUB",  "MULR", "DIVR", "COMPR", "SHIFTL", "SHIFTR", "RMO", "SVC", "CLEAR", "TIXR", "N/A",
  "FLOAT","FIX", "NORM",  "N/A",  "LPS",  "STI",  "RD",   "WD",   "TD",    "N/A",    "STSW",   "SSK", "SIO", "HIO",   "TIO", "N/A",
]; // pls do not format!!!
export function getOpcName(opc){
  return opcs[opc >>> 2] || "N/A";
}

// black hole instruction decoder
class InstrDecoder{
  constructor(model){
    this.model = model;
    this.mem = model.mem;
    this.pc = model.pc;

    // instr formats
    this.instrType = null;
    this.instr_t = null;
    this.flags = {};

    // instr regisster
    this.fetchedInstrStr = 0x00;
    this.instr = 0x00;
  }

  exec() {
    // 1. format check and generate flag-bits
    let opc1 = this.mem[this.pc], opc2 = this.mem[this.pc + 1];
    let { xbpe, ni } = this.maskInstrFlag(opc1, opc2);

    // 2. calculate instruction length (format) as number (1,2,(3/4))
    this.instr_t = this.calcInstrLen(opc1);

    // 3. still calculate instruction length, but classify f3 and f4
    this.instr_t = this.instr_t > 2 || ni ^ 0 ?  /* if f3,f4 and ni != 0 */
      this.peekInstrFormat(opc2) :
      this.instr_t;

    // 4. store and formatting result to strings and dict
    this.instrType = `f${this.instr_t}`;
    this.flags = this.decodeInstrFlags(ni, xbpe);

    // 5. finally fetch full instruction by format
    this.fetchFullInstr();

    // 6. ar the end, update pc
    this.model.pc = this.pc;
  }

  fetchFullInstr() {
    let instrDisplay, instr;

    // fetch full instruction
    for (let i = 0; i < this.instr_t; i++) {
      const fetched = (this.mem[this.pc++]);

      // only for display (easy to decode in js)
      instrDisplay |= fetched << (8 * i);

      // only for decoding for VM;
      instr <<= 8;
      instr |= fetched;
    }

    this.instr = instr;
    this.fetchedInstrStr = instrDisplay;
  }

  decodeInstrFlags(ni, xbpe) {
    return {
      n: ni & 0b10,
      i: ni & 0b01,
      x: xbpe & 0b1000,
      b: xbpe & 0b0100,
      p: xbpe & 0b0010,
      e: xbpe & 0b0001,
    };
  }

  calcInstrLen(opc) {
    var type = (opc & 0xFC) >>> 4;
    var instr_t;

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

    return instr_t;

  }

  maskInstrFlag(opc1, opc2){
    return {
      xbpe: (opc2 & 0b11110000) >>> 4,
      ni: opc1 & 0x3
    };
  }

  peekInstrFormat(opc2){
    if(opc2 & 0x10) return 4
    return 3;
  }
}

class InstrOpFetch{
  /**
   * 
   * @param {Uint8Array} mem 
   * @param {Number} pc 
   * @param {InstrDecoder} ID 
   * @param {any} regs
   */
  constructor(model, ID){
    this.model = model;
    this.mem = model.mem;
    this.pc = model.pc;
    this.ID = ID;

    this.operand = 0;
    this.TA = 0;
  }

  exec(){
    const 
      fetchedInstr = this.ID.instr,
      instr_t = this.ID.instr_t,
      instrFlag = this.ID.flags;

    if(instr_t > 2){
      this.operand = this.fetchOperand(
        fetchedInstr,
        instrFlag,
        this.model
      );
    }else if(instr_t == 2){
      this.operand = fetchedInstr & 0x00FF;
    }

    console.log(`fetched operand: ${this.operand}`)
  }

  maskOperand(){
    this.sicOperand = instr & 0x07FFFF
      , sicxeOperand = flags.e ?
        instr & 0x000FFFFF : instr & 0x000FFF;
  }

  fetchOperand(instr, flags, regs) {
    // calculate TA
    let sicOperand = instr & 0x07FFFF
      , sicxeOperand = flags.e ?
        instr & 0x000FFFFF : instr & 0x000FFF;
    let TA = 0;

    do {
      if (flags.n == flags.i) { // sipmle addressing
        // sic compatable(ni=00) and sicxe f-3
        TA += flags.n == 0 ? sicOperand : sicxeOperand;
        if (flags.n == 0) break;
      } else if (flags.n == 1) { // indirect addressing
        TA += sicxeOperand;
      } else { // Immediate addressing f-4
        console.log("i enable", sicxeOperand)
        TA += sicxeOperand;
      }

      if (flags.p) TA += regs.pc;
      else if (flags.b) TA += regs.b;
    } while (false);

    if (flags.x) TA += flags.x * regs.x;

    // fetch TA
    // simple addressing
    if (flags.n == flags.i) {
      TA = this.peekMem(TA);
    } // indirect addressing
    else if (flags.n) {
      TA = this.peekMem(TA);
      TA = this.peekMem(TA);
    } // immediate addressing

    return TA;
  }

  peekMem(ta){
    return this.mem[ta] || 0;
  }
}

// A class object that store every memory, registers
class ComputerModel{
  mem;
  reg;
  pc;

  constructor(){
    this.mem = new Uint8Array(0x10000);
    this.reg = {
      x: 0,
      a: 0,
      l: 0,
      b: 0,
      p: 0,
    };
    this.pc = 0;


    for(var i = 0; i < this.mem.length; i++){
      this.mem[i] = this.mem[i] || 0;
    } 
  }

  reset(){
  }
}

export class SICEmulator {
  constructor() {
    this.model = new ComputerModel();
    this.instrType = "";
    this.fetchedInstrStr = 0x00;
    this.instrFlag = {};
  }

  Eval(){
    this.fetchedInstrStr = 0x0;

    // 1. instruction decoding
    let ID = new InstrDecoder(this.model);
    ID.exec();

    console.log(this.model);

    this.instrType = ID.instrType; // string
    this.instrFlag = ID.flags;     // string
    this.fetchedInstrStr = ID.fetchedInstrStr; // bitwise string

    // 2. fetch operand for f-3, f-4
    let OF = new InstrOpFetch(this.model, ID);
    OF.exec();
    this.operand = OF.operand;
  }
}