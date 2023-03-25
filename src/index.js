import { createApp } from "/src/lib/vue.esm-browser.js";
import { SICEmulator } from "./sic.js";
import { SICTest } from "./sic_test.js";

var emu = new SICTest();
var seqRunner;
var audios = {
  tap: new Audio('/assets/navigation_hover-tap.ogg'),
  running: [new Audio('/assets/running_1.ogg'), new Audio('/assets/running_2.ogg')],
  fast_run: new Audio('/assets/fast_run.ogg')
};

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
      let a = audios.running[Math.trunc(Math.random() * 1000 % 2)];
      a.currentTime = 0;
      a.play();
    }, 0);
    return;
  }

  audios.tap.currentTime = 0;
  setTimeout(e => audios.tap.play(), 0);


}

const emulatorUI = createApp({
  mounted(){
    this.memEditPeek();
  },
  methods: {
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
    async progressBarAnimation(stepContinuous){
      this.isProgressBar = true;
      playSounds(stepContinuous);
      await new Promise(e => setTimeout(e, 500));
      this.isProgressBar = false;
      await new Promise(e => setTimeout(e, 500));
    },
    toggleFastRunMusic(){
      setTimeout(async () => {
        if (this.isFastRun) {
          if (this.isSeqStart) {
            if (app.isMuted) return;
            audios.fast_run.play();
            for (let i = 0; i < 1; i += 0.05) {
              audios.fast_run.volume = i;
              await new Promise(e => setTimeout(e, 10));
            }
            audios.fast_run.volume = 1;
            audios.fast_run.loop = true;
          } else {
            for (let i = 1; i > 0; i -= 0.05) {
              audios.fast_run.volume = i;
              await new Promise(e => setTimeout(e, 10));
            }
            audios.fast_run.pause();
            // audios.fast_run.currentTime = 0;
          }
        }

      }, 0);
    },

    async start(){
      // const val = !seqRunner? (seqRunner = emu.evalSequence()()): seqRunner;
      this.isSeqStart = !this.isSeqStart;

      this.toggleFastRunMusic();

      for (; this.isSeqStart;) {
        emu.eval()
        this.isProgressBar = true;
        this.update();
        if (!this.isFastRun) {
          await this.progressBarAnimation(true);
        }
        else await new Promise(e => setTimeout(e, 10));
      }
      this.isProgressBar = false;
    },
    async step() {
      emu.eval();
      this.update();

      await this.progressBarAnimation(false);
    },
    reset(){
      emu.pc = 0;
      emu.fetchedInstr = 0;
      emu.instrType = 0;

      this.update();

      this.title = "[Emulator]"
    },
    update(){
      this.reg_pc = emu.pc.toString(16).toUpperCase();
      this.fmt_disp = emu.instrType;
      this.fetched_instr = emu.fetchedInstr;
      this.memEditPeek(this.seg_base);

      var opc = emu.fetchedInstr & 0xFC;
      this.cur_opc = emu.getOpcName(opc);
      this.title = `[0x${emu.pc.toString(16).toUpperCase()}] ${this.cur_opc}`;
    },
    memEditPoke(value, index){
      const base = this.seg_base;
      

      console.log(this.mem_map[base+index-1], index,base)
      for(let i = 0; i < 16;i++){
        emu.mem[base*16 + i] = parseInt(this.mem_map[base+i], 16);
      }
    },
    memEditPeek(nval){
      const base = nval || 0;
      for(let i = 0; i < 16;i++){
        this.mem_map[i] = (emu.mem[base*16 + i]||0).toString(16).toUpperCase();
      }
    }
  },
  watch: {
    reg_pc(nval, old){
      if(this.isSeqStart) return;

      emu.pc = parseInt(nval, 16);
    },
    reg_a(nval, old){
      if(this.isSeqStart) return;

      emu.reg = parseInt(nval, 16);
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

      fmt_disp: "",
      fetched_instr: 0x00,
      title: "[Emulator]",
      cur_opc: "",
    };
  }
})
var app = emulatorUI.mount(".app");

function initCanvas() {
  const canvas = document.querySelector('canvas');
  const ctx = canvas.getContext('2d');
  ctx.fillStyle = 'black';
  // ctx.fillRect(0, 0,canvas.width, canvas.height);

  console.log("done")
}