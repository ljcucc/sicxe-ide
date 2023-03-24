let play_btn, clock_elm;

var isPlay = false;
function pp_control(){
  isPlay = !isPlay;

  if(isPlay){
    // document.querySelector(".disp").style.width = "50%";
    clock_elm.classList.add("clock-on");
    console.log(isPlay)
  }
  else{
    clock_elm.classList.remove("clock-on");
    document.querySelector(".disp").style.width = "";
  }

}

function onload(){
  play_btn = document.querySelector(".play");
  clock_elm = document.querySelector(".cycle-ani");

  play_btn.addEventListener("click", pp_control);
}

window.addEventListener("load", onload);