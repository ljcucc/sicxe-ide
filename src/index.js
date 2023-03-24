import { createApp } from "/src/lib/vue.esm-browser.js";

const emulatorUI = createApp({
  methods:{
    togglePBar(){
      this.isProgressBar = !this.isProgressBar;
    },
    toggleEditor(){
      this.isEditorOpen = !this.isEditorOpen;
    },
    toggleDarkMode(){
      this.isDarkMode = !this.isDarkMode;
    }
  },
  data() {
    return {
      isProgressBar: false,
      isEditorOpen: false,
      isDarkMode: false,
      reg: {
        pc: 0,
        a: 0,
        x: 0,
        l: 0,
        b: 0,
        s: 0,
        t: 0,
        f: "0.0",
      }
    };
  }
})
emulatorUI.mount(".app");

function initCanvas() {
  const canvas = document.querySelector('canvas');
  const ctx = canvas.getContext('2d');
  ctx.fillStyle = 'black';
  // ctx.fillRect(0, 0,canvas.width, canvas.height);

  console.log("done")
}