const opcs = [
  "LDA",  "LDX", "LDL",   "STA",  "STX",  "STL",  "ADD",  "SUB",  "MUL",   "DIV",    "COMP",   "TIX", "JEQ", "JGT",   "JLT", "J",
  "AND",  "OR",  "RSUB",  "JSUB", "LDCH", "STCH", "ADDF", "SUBF", "MULF",  "DIVF",   "LDB",    "LDS", "LDF", "LDT",   "STB", "STS",
  "STF",  "STT", "COMPF", "N/A",  "ADDR", "SUB",  "MULR", "DIVR", "COMPR", "SHIFTL", "SHIFTR", "RMO", "SVC", "CLEAR", "TIXR", "N/A",
  "FLOAT","FIX", "NORM",  "N/A",  "LPS",  "STI",  "RD",   "WD",   "TD",    "N/A",    "STSW",   "SSK", "SIO", "HIO",   "TIO", "N/A",
]; // pls do not format!!!
export function getOpcName(opc){
  return opcs[opc >>> 2] || "N/A";
}
export function getBytecodeOpc(opcstr){
  let r = opcs.indexOf(opcstr);
  return r>=0? r << 2: 0xff;
}

// black hole instruction decoder
class InstrDecoder{
  opcode = 0;

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
    this.opcode = opc1 & 0xFC;

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
  model;
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
    let sicOperand = instr & 0x007FFF
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
    if (flags.n) {
      TA = this.model.peekInt(TA);
    } // immediate addressing and simple addressing are fetch from or store to in execution

    return TA;
  }

  peekMem(ta){
    return this.mem[ta] || 0;
  }
}

class InstrExec{
  model;
  ID;
  IOF;

  /**
   * 
   * @param {ComputerModel} model 
   * @param {InstrDecoder} ID 
   * @param {InstrOpFetch} IOF 
   */
  constructor(model, ID, IOF){
    this.model = model;
    this.ID = ID;
    this.IOF = IOF;
  }

  peekTA(TA, FP){
    if(this.ID.flags.i){ // immediate addressing
      if(FP) return this.model.operandToFloat48(TA);
      else return TA;
    }
    console.log(TA);
    let result;
    if(FP)
      result = this.model.peekFloat48(Number(TA)>>>0);
    else
      result = this.model.peekInt(Number(TA)>>>0);
    console.log(result.toString(16));
    return result;
  }

  pokeTA(TA, value, FP){
    if(this.ID.flags.i){
      throw "Error: poke operation could not have flag [i].";
    }

    if(FP) this.model.pokeFloat48(TA, value);
    else this.model.pokeInt(TA, value);
  }

  exec(){
    let opcode = this.ID.opcode;
    let operand = this.IOF.operand;
    console.log(operand.toString(16));
    const m32 = value=>value & 0xFFFFFF;
    switch(opcode){
      case 0x00: /* LDA */ this.model.reg.a=this.peekTA(operand); break;
      case 0x04: /* LDX */ this.model.reg.x=this.peekTA(operand); break;
      case 0x08: /* LDL */ this.model.reg.l=this.peekTA(operand); break;
      case 0x0C: /* STA */ this.pokeTA(operand, this.model.reg.a); break;

      case 0x10: /* STX */ this.pokeTA(operand, this.model.reg.x); break;
      case 0x14: /* STL */ this.pokeTA(operand, this.model.reg.l); break;
      case 0x18: /* ADD */ this.model.reg.a += this.peekTA(operand); break;
      case 0x1C: /* SUB */ this.model.reg.a -= this.peekTA(operand); break;

      case 0x20: /* MUL */ this.model.reg.a *= this.peekTA(operand); break;
      case 0x24: /* DIV */ this.model.reg.a /= this.peekTA(operand); break;
      case 0x28: /* COMP */ break;
      case 0x2C: /* TIX */ this.model.reg.x ++; break;

      case 0x30: /* JEQ */ break;
      case 0x34: /* JGT */ break;
      case 0x38: /* JLT */ break;
      case 0x3C: /* J*/ this.model.pc = this.peekTA(operand); break;

      case 0x40: /* AND */ this.model.reg.a = (this.model.reg.a>>>0) & (this.peekTA(operand)); break;
      case 0x44: /* OR */ this.model.reg.a = (this.model.reg.a>>>0) | (this.peekTA(operand)); break;
      case 0x48: /* JSUB */ this.model.reg.l=this.model.pc; this.pc = this.peekTA(operand); break;
      case 0x4C: /* RSUB */ this.model.pc = this.model.reg.l; break;

      case 0x50: /* LDCH */ this.model.a = this.model.mem[this.peekTA(operand)]; break;
      case 0x54: /* STCH */ this.model.mem[this.peekTA(operand)]=this.model.reg.a; break;
      case 0x58: /* ADDF */ this.model.a += this.peekTA(operand, true); break;
      case 0x5C: /* SUBF */ this.model.a -= this.peekTA(operand, true); break;

      case 0x60: /* MULF */ this.model.a *= this.peekTA(operand, true); break;
      case 0x64: /* DIVF */ this.model.a /= this.peekTA(operand, true); break;
      case 0x68: /* LDB */this.model.reg.b=this.peekTA(operand); break;
      case 0x6C: /* LDS */this.model.reg.s=this.peekTA(operand); break;

      case 0x70: /* LDF */ this.model.reg.f=this.peekTA(operand, true); break;
      case 0x74: /* LDT */this.model.reg.t=this.peekTA(operand); break;
      case 0x78: /* STB */ this.pokeTA(operand, this.model.reg.b); break;
      case 0x7C: /* STS */this.pokeTA(operand, this.model.reg.b); break;

      case 0x80: /* STF */this.pokeTA(operand, this.model.reg.f, true); break;
      case 0x84: /* STT */this.pokeTA(operand, this.model.reg.t); break;
      case 0x88: /* COMPF */ this.pokeSWBit(); break;
      case 0x8C: /* N/A */ break;

      case 0x90: /* ADDR */ break;
      case 0x94: /* SUBR */ break;
      case 0x98: /* MULR */ break;
      case 0x9C: /* DIVR */ break;

      case 0xA0: /* COMPR */ break;
      case 0xA4: /* SHIFTL */ break;
      case 0xA8: /* SHITR */ break;
      case 0xAC: /* RMO */ break;

      case 0xb0: /* SVC */ break;
      case 0xb4: /* CLEAR */ break;
      case 0xb8: /* TIXR */ break;
      case 0xbC: /* N/A */ break;

      case 0xC0: /* FLOAT */ break;
      case 0xC4: /* FIX */ break;
      case 0xC8: /* NORM */ break;
      case 0xCC: /* N/A */ break;

      case 0xD0: /* LPS */ break;
      case 0xD4: /* STI */ break;
      case 0xD8: /* RD */ break;
      case 0xDC: /* WD */ break;

      case 0xE0: /* TD */ break;
      case 0xE4: /* N/A */ break;
      case 0xE8: /* STW */ break;
      case 0xEC: /* SSK */ break;

      case 0xF0: /* SIO */ break;
      case 0xF4: /* HIO */ break;
      case 0xF8: /* TIO */ break;
      case 0xFC: /* N/A */ break;

    }
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
      s: 0,
      t: 0,
      sw: 0,
      f: 0
    };
    this.pc = 0;

    for(var i = 0; i < this.mem.length; i++){
      this.mem[i] = this.mem[i] || 0;
    } 
  }

  peekInt(addr){
    return (
      this.mem[addr] << 16 |
      this.mem[addr+1] << 8 |
      this.mem[addr+2]
    );
  }

  pokeInt(addr,value){
    value &= 0xFFFFFF;
    for (let i = 0; i < 3; i++) {
      this.mem[addr++] = value & 0xFF;
      value >>>= 8;
    }
  }

  // Fake 48, actually 32
  peekFloat48(addr){
    let arr = new Uint8Array([
      this.mem[addr],
      this.mem[addr+1],
      this.mem[addr+2],
      this.mem[addr+3],
      this.mem[addr+4], // actually these bit
      this.mem[addr+5], // are not used in 32 bits floating point.
      0, 0              // modern computer only support 32, 64 FP, and 48 is only for pascal.
    ]);
    
    return new DataView(arr.buffer).getFloat32();
  }

  operandToFloat48(val){
    var value = new Uint8Array(4);
    let arr;
    if(val < 0x01000000){ // f-3
      new DataView(value.buffer).setUint32(0, val<<20);
    }else{ // f-4
      new DataView(value.buffer).setUint32(0, val<<12);
    }
    console.log(`to float 48 `, value)
    console.log( new DataView(value.buffer).getFloat32())
    return new DataView(value.buffer).getFloat32();
  }

  pokeFloat48(addr, value){
    let arr = new Uint8Array(4);
    new DataView(arr.buffer).setFloat32(value);

    for(let i in arr) this.mem[addr+i]=arr[i];
  }

  peekSWBit(num){
    return (val >> num) & 1;
  }

  pokeSWBit(num, val){
    val &= 1;
    if(val) number |= 1<<num;
    else number &= ~(1<<num);
  }
  
  setCondiCode(eql, g)

  // peekLong(addr){
  //   return (
  //     this.mem[addr] << 32 |
  //     this.mem[addr+1] << 24 |
  //     this.mem[addr+2] << 16 |
  //     this.mem[addr+3] << 8 |
  //     this.mem[addr+4]
  //   );
  // }

  // pokeLong(addr, value){
  //   value &= 0xFFFFFFFFFF;
  //   for (let i = 0; i < 5; i++) {
  //     this.mem[addr++] = value & 0xFF;
  //     value >>>= 8;
  //   }
  // }

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

    // 2. fetch operand for f-3, f-4
    let OF = new InstrOpFetch(this.model, ID);
    OF.exec();

    // 3. execute instruction
    let IE = new InstrExec(this.model, ID, OF);
    IE.exec();

    this.instrType = ID.instrType; // string
    this.instrFlag = ID.flags;     // string
    this.fetchedInstrStr = ID.fetchedInstrStr; // bitwise string
    this.operand = OF.operand;
  }
}