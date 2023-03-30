import { createApp } from "./lib/vue.esm-browser.js";
import { SICEmulator, getOpcName, getBytecodeOpc } from "./sic.js";
import { SICTest } from "./sic_test.js";

var emu = new SICTest();
var audios = {
  // tap: new Audio('/assets/navigation_hover-tap.ogg'),
  // running: [new Audio('/assets/running_1.ogg'), new Audio('/assets/running_2.ogg')],
  fast_run: new Audio('./assets/fast_run2.ogg'),
  // fast_temp: new Audio('/assets/_fast_temp__long.wav'),
  temps: [
    new Audio('./assets/temp_1.ogg'),
    new Audio('./assets/temp_2.ogg'), 
    new Audio('./assets/temp_3.ogg'), 
  ],
  enter_darkmode: new Audio('./assets/enter_darkmode.ogg'),
};

// functions

function isHex(val){
  return (val.match( /[0-9A-Fa-f]{6}/g));
}

// audio

var temp_cycle = 0;
var enbale_darkmode_boom = 0;

function trackFadein(audio, vol) {
  vol = vol || 1;
  setTimeout(async () => {
    audio.play();
    for (let i = 0; i < vol; i += 0.05) {
      audio.volume = i;
      await new Promise(e => setTimeout(e, 10));
    }
    audio.volume = vol;
    audio.loop = true;
  }, 0);
}

function trackFadeout(audio, vol) {
  vol = vol || 1;
  setTimeout(async () => {
    for (let i = vol; i > 0; i -= 0.05) {
      audio.volume = i;
      await new Promise(e => setTimeout(e, 10));
    }
    audio.pause();
  }, 0);

}

audios.fast_run.addEventListener("loadeddata", () => {
  console.log("done!");
});
audios.fast_run.addEventListener("error", e => {
  console.error(e);
});

function playSounds(continuous) {
  if(app.isMuted) return;
  if (continuous) {
    setTimeout(e => {
      let a = audios.temps[(temp_cycle++) % 3];
      a.currentTime = 0;
      a.play();
    }, 0);
    return;
  }

  // setTimeout(e => audios.tap.play(), 0);
  setTimeout(e => {
      let a = audios.temps[(temp_cycle++) % 3];
      a.currentTime = 0;
      a.play();
    }, 0);


}

// Vue app

const emulatorUI = createApp({
  mounted(){
    this.memEditPeek();
  },
  methods: {
    //togglers
    togglePBar() {
      this.isProgressBar = !this.isProgressBar;
    },
    toggleEditor() {
      this.isEditorOpen = !this.isEditorOpen;
    },
    toggleDarkMode() {
      this.isDarkMode = !this.isDarkMode;
    },
    toggleMute(){
      if(this.isSeqStart) return;
      this.isMuted = !this.isMuted;
    },
    toggleFastRun() {
      if(this.isSeqStart) return;
      this.isFastRun = !this.isFastRun;
    },

    // assembly
    onEditorType(e){
      console.log(e);
      if(e.key == "Tab"){
        e.preventDefault();

        var start = this.$refs.editorTextbox.selectionStart;
        var end = this.$refs.editorTextbox.selectionEnd;

        // set textarea value to: text before caret + tab + text after caret
        this.$refs.editorTextbox.value = this.$refs.editorTextbox.value.substring(0, start) +
          "\t" + this.$refs.editorTextbox.value.substring(end);

        // put caret at right position again
        this.$refs.editorTextbox.selectionStart =
        this.$refs.editorTextbox.selectionEnd = start + 1;
      }
    },
    assemblyRun(){},

    // musics process
    async progressBarAnimation(stepContinuous){
      this.isProgressBar = true;
      playSounds(stepContinuous);
      await new Promise(e => setTimeout(e, 500));
      this.isProgressBar = false;
      await new Promise(e => setTimeout(e, 500));
    },
    toggleFastRunMusic(){
      setTimeout(async () => {
        if (!this.isFastRun || app.isMuted) return;

        if (this.isSeqStart) {
          if((enbale_darkmode_boom++)%10 == 0){
            audios.enter_darkmode.currentTime = 0;
            audios.enter_darkmode.play();
          }
          trackFadein(audios.fast_run);
          // trackFadein(audios.fast_temp);
          // loopUntilStop(audios.fast_temp);
        } else {
          trackFadeout(audios.fast_run);
          audios.enter_darkmode.pause();
        }
      }, 0);
    },

    // emulator core
    async start(){
      // const val = !seqRunner? (seqRunner = emu.evalSequence()()): seqRunner;
      this.isSeqStart = !this.isSeqStart;

      this.toggleFastRunMusic();

      for (; this.isSeqStart;) {
        try {
          emu.Eval();
        } catch (e) {
          this.err_msg = e.toString();
          this.isSeqStart = false;
          console.error(e);
          break;
        }
        this.isProgressBar = true;
        this.update();
        if (!this.isFastRun)
          await this.progressBarAnimation(true);
        else
          await new Promise(e => setTimeout(e, 10));
      }
      this.isProgressBar = false;
    },
    async step() {
      try {
        emu.Eval();
      } catch (e) {
        this.err_msg = e.toString();
        console.error(e);
      }
      this.update();

      await this.progressBarAnimation(false);
    },
    reset(){
      emu.model.pc = 0;
      emu.fetchedInstrStr = 0;
      emu.instrType = 0;

      this.update();

      this.title = "[Emulator]"
    },
    update(){
      this.reg_pc = emu.model.pc.toString(16).toUpperCase();
      this.fmt_disp = emu.instrType;
      this.fetched_instr = emu.fetchedInstrStr;
      this.memEditPeek(this.seg_base);

      var opc = emu.fetchedInstrStr & 0xFC;
      this.cur_opc = getOpcName(opc);
      this.title = `[0x${emu.model.pc.toString(16).toUpperCase()}] ${emu.instrType == 'f4'?'+':''}${this.cur_opc}`;
      this.instr_flag = `${
        emu.instrFlag.n?'n':'_'
      }${
        emu.instrFlag.i?'i':'_'
      }${
        emu.instrFlag.x?'x':'_'
      }${
        emu.instrFlag.b?'b':'_'
      }${
        emu.instrFlag.p?'p':'_'
      }${
        emu.instrFlag.e?'e':'_'
      }`;

      this.operand = emu.operand.toString(16).toUpperCase().padStart(8,'0');

      this.reg_a = emu.model.reg.a.toString(16).toUpperCase().padStart(6, '0');
      this.reg_x = emu.model.reg.x.toString(16).toUpperCase().padStart(6, '0');
      this.reg_l = emu.model.reg.l.toString(16).toUpperCase().padStart(6, '0');
      this.reg_b = emu.model.reg.b.toString(16).toUpperCase().padStart(6, '0');
      this.reg_s = emu.model.reg.s.toString(16).toUpperCase().padStart(6, '0');
      this.reg_t = emu.model.reg.t.toString(16).toUpperCase().padStart(6, '0');
      this.reg_f = emu.model.reg.f.toString()
      console.log(emu.model);
    },

    // memory editor
    memAutoOpc(){
      for(let i = 0; i < 16; i++){
        if(isNaN(this.mem_map[i]) && !isHex(this.mem_map[i])){
          let item = this.mem_map[i]; 
          let result = 0;
          if(item.indexOf('#') > -1){
            result |= 1;
            item = item.replace('#','');
          }
          if(item.indexOf('@') > -1){
            result |= 2;
            item = item.replace('@','');
          } 

          result |= getBytecodeOpc(item.toUpperCase().trim());
          if(result == 255) continue;

          this.mem_map[i] = result.toString(16).toUpperCase();
          
          const base = this.seg_base;
          emu.model.mem[base*16 + i] = parseInt(this.mem_map[i], 16);
        }
      }
    },
    memEditPoke(value, index){
      const base = this.seg_base;

      console.log(this.mem_map[base+index-1], index,base)
      for(let i = 0; i < 16;i++){
        emu.model.mem[base*16 + i] = parseInt(this.mem_map[i], 16);
      }
    },
    memEditPeek(nval){
      const base = nval || 0;
      for(let i = 0; i < 16;i++){
        this.mem_map[i] = (emu.model.mem[base*16 + i]||0).toString(16).toUpperCase();
      }
    }
  },
  watch: {
    reg_pc(nval, old){
      if (this.isSeqStart) {
        return;
      }

      emu.model.pc = parseInt(nval, 16);
    },
    reg_a(nval, old){
      if(this.isSeqStart) return;

      emu.model.reg.a = parseInt(nval, 16);
    },
    reg_f(nval, old){
      if(this.isSeqStart) return;

      emu.model.reg.a = parseFloat(nval, 16);
    },
    seg_base(nval, old){
      this.memEditPeek(nval);
    }
  },
  data() {
    return {
      isProgressBar: false,
      isEditorOpen: false,
      isDarkMode: false,
      isSeqStart: false,
      isMuted: true,
      isFastRun: false,

      reg_pc: 0,
      reg_a: 0,
      reg_x: 0,
      reg_l: 0,
      reg_b: 0,
      reg_s: 0,
      reg_t: 0,
      reg_f: "0.0",

      seg_base: 0x0,
      mem_map: new Array(16),

      operand: "",

      fmt_disp: "",
      fetched_instr: 0x00,
      title: "[Emulator]",
      cur_opc: "",
      instr_flag: "",
    };
  }
})
var app = emulatorUI.mount(".app");

// function initCanvas() {
//   const canvas = document.querySelector('canvas');
//   const ctx = canvas.getContext('2d');
//   ctx.fillStyle = 'black';
//   // ctx.fillRect(0, 0,canvas.width, canvas.height);

//   console.log("done")
// }