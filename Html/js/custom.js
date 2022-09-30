var navbarMenu = document.getElementById("navbarMenu");
var navbarSearch = document.getElementById("navbarSearch");
var mask_overlay= document.getElementById("mask_overlay");
var data_toggle = null;
var navbartogglerID = document.getElementById("navbar_toggler");
var popupCurrencyConvert = document.getElementById("popupCurrencyConvert");
var divDropdownBox = document.getElementById("divDropdownBox");
var idMessageBox = document.getElementById("idMessageBox");

var idInputValidTest = document.getElementById("idInputValidTest");

//TAB FLOW
var idstepFlows = document.getElementById("stepFlows");

var idStepContent = document.querySelector("#idStepContent");

//Flow Step 流程步驟
function step(e){
  
  var data_step = e.dataset.step; //get TAB data-step 

  // console.log(data_step); 

  // GET EACH TAB item
  var stepFlowItems = idstepFlows.querySelectorAll('.step__flow'); //
  // console.log(stepFlowItemNum.length);


  for (var i = 0; i < stepFlowItems.length; i++) {

    stepFlowItems[i].classList.remove('active');
    // stepFlowItems[i].setAttribute("aria-checked","false");

  }
 
  //  e.classList.add('active');

  // var idStepContent = document.getElementById("idStepContent");
  // var idStepContent = document.querySelector("#idStepContent");
  
  stepFlowItems[data_step-1].classList.add('active');
  idStepContent.className = "dataList step__list step-" + data_step; 


}



//完成流程步驟 Button Test
function finishStep(e){
  

  // var idsIframeepFlows = document.getElementById("stepFlows");

  var data_stepfinish = e.dataset.stepfinish; //get data-stepfinish value
 

  // var stepflow1 = document.querySelector(".step__flow.flow-1"); //好像不能用querySelector?  
  // var stepflow1 = document.getElementsByClassName("step__flow flow-1");
  // var stepflow1 = document.querySelectorAll(".step__flow.flow-1");
  // var stepflow2 = document.querySelectorAll(".step__flow.flow-2");
  var stepflow1 = idstepFlows.querySelectorAll(".step__flow.flow-1");
  var stepflow2 = idstepFlows.querySelectorAll(".step__flow.flow-2");
  var stepflow3 = idstepFlows.querySelectorAll(".step__flow.flow-3");

  console.log("現在按的finish button：" + data_stepfinish); 

    if( data_stepfinish == '1'){

      // console.log("data_stepfinish：" + data_stepfinish);
      // console.log("stepflow-1.length：" + stepflow1.length);

      // console.log("步驟一的 aria-checked-按前：" + stepflow1[0].getAttribute("aria-checked") );

      stepflow1[0].setAttribute("aria-checked","checked"); 
      stepflow2[0].setAttribute("aria-checked","checking"); 

      stepflow1[0].classList.remove('active');
      stepflow2[0].classList.add('active');

      idStepContent.className = "dataList step__list step-2" ;
      
    }

    if( data_stepfinish == '2'){

      // console.log("data_stepfinish：" + data_stepfinish);
      // console.log("stepflow-2.length：" + stepflow2.length);

      // console.log("步驟2 的 aria-checked-按前：" + stepflow2[0].getAttribute("aria-checked") );

      stepflow1[0].setAttribute("aria-checked","checked"); 
      stepflow2[0].setAttribute("aria-checked","checked"); 
      stepflow3[0].setAttribute("aria-checked","checking"); 

      stepflow1[0].classList.remove('active');
      stepflow2[0].classList.remove('active');
      stepflow3[0].classList.add('active');

      idStepContent.className = "dataList step__list step-3" ;
     
    }



}


/* Using dynamic DOM Event */
// document.querySelector(".step__flow").addEventListener("click", function() {

//    console.log( "test:" + this.className);

// });



// tab 切換 ===================================
// var idBetLimitTab = document.querySelector("#BetLimitTab");

// function tabSwitch(e) {

//   window.event.stopPropagation();
//   window.event.preventDefault();

//   var BetLimitTabNavTabs = idBetLimitTab.querySelector(".nav-tabs");
//   var BetLimitTabNavTabsContent = idBetLimitTab.querySelector(".tab-content");
  

//   // console.log(BetLimitTabNavTabs);
//   // console.log(BetLimitTabNavTabsContent);


//   var data_toggle = e.dataset.toggle;
//   // var data_target = e.dataset.target; 
//   var data_target = e.getAttribute("href");
//   // var aria_selected = e.getAttribute("aria-selected");

//   // console.log(data_toggle);
//   // console.log(data_target);


//   if (data_toggle == "tab") {

//     // GET EACH TAB item
//     var tabNavItems = BetLimitTabNavTabs.querySelectorAll('.nav-item');
//     var tabNavItemsALink = BetLimitTabNavTabs.querySelectorAll('.nav-item a');
   

//     console.log("e.parentNode.class:"+ e.parentNode.className);  

//     for (var i = 0; i < tabNavItems.length; i++) {

//       tabNavItems[i].classList.remove('active');
//       tabNavItemsALink[i].classList.remove('active');
//       tabNavItemsALink[i].setAttribute("aria-selected", "false");

//     }

//     e.parentNode.classList.add('active');
//     e.classList.add('active');
//     e.setAttribute("aria-selected", "true");

//     //TAB 內容==========================================

//     var tabContent = BetLimitTabNavTabsContent.querySelector(data_target);

//     // GET EACH TAB CONTENT ITEM
//     var tabContentItems = BetLimitTabNavTabsContent.querySelectorAll('.tab-pane');

//     for (var i = 0; i < tabContentItems.length; i++) {
//       tabContentItems[i].classList.remove('show', 'active');
//     }

//     tabContent.classList.add('show', 'active');

//   }

//   return false;

// }

// tab 切換 宇軒改過的===================================
function tabSwitch(e, tabMainContent, tabItem, tabContent) {
  var tabMainContent = document.getElementById(tabMainContent);
  var tabItem = tabMainContent.getElementsByClassName(tabItem);
  var tabContent = tabMainContent.getElementsByClassName(tabContent);

  var data_toggle = e.dataset.toggle;
  var data_target = e.getAttribute("aria-controls");

  window.event.stopPropagation();
  window.event.preventDefault();

  for (var i = 0; i < tabItem.length; i++) {
      tabItem[i].classList.remove('active');
      tabItem[i].parentNode.classList.remove('active');
      tabItem[i].setAttribute("aria-selected", "false");

  }

  e.parentNode.classList.add('active');
  e.classList.add('active');
  e.setAttribute("aria-selected", "true");

  //TAB 內容==========================================

  for (var i = 0; i < tabContent.length; i++) {
      tabContent[i].classList.remove('show', 'active');
  }

  document.getElementById(data_target).classList.add('show', 'active');


  return false;
}




// popup 切換
function dataTogglePopup(Obj){
    
    var data_toggle = Obj.dataset.toggle;  
    var data_target = Obj.dataset.target; 

    if(data_toggle=="popup"){
      
        var data_targetRet = data_target.replace('#','');

        console.log(data_targetRet);

        var popupContent = document.getElementById(data_targetRet);
        popupContent.classList.toggle("show");
       

        // mask_overlay.classList.toggle("open");

    }
    else{
        console.log("no popup");
    }

}

//PopUP半透明遮罩
function MaskPopUp(obj){
  
 /*  parentNode和parentElement功能一樣，
    childNodes和children功能一樣 
    但 parentNode 和 childNodes 是符合W3C標準的，可以說比較通用。而另外兩個只是IE支援
 */
  console.log("obj.parentElement.id:"+ obj.parentElement.id);

  console.log("obj.parentNode.id:"+ obj.parentNode.id);  

  var getParentElementNode= obj.parentNode;

  getParentElementNode.classList.remove("show");
  

  //  divDropdownBox.classList.remove("show");
  // idMessageBox.classList.remove("show");

}

//closePopUp 關閉PopUp
function closePopUp(obj){

 

  console.log("this.parentNode.id:"+ obj.parentNode.parentNode.id);

  var getParentElementNode= obj.parentNode.parentNode;

  getParentElementNode.classList.remove("show");

}



// 下拉選單切換
function dataToggleDropdown(Obj){
    
    var data_toggle = Obj.dataset.toggle;   

    if(data_toggle=="dropdown"){
      
        // console.log(Obj.nextElementSibling.className);
        Obj.nextElementSibling.classList.toggle("show");
        mask_overlay.classList.toggle("open");

    }
    else{
        console.log("no dropdown");
    }

}

// Collapse 摺疊切換 ======================== 
function dataToggleCollapse(Obj){

    data_toggle = Obj.dataset.toggle; //get data-toggle
    var data_target = Obj.dataset.target; //get data-target
    var aria_Expanded = Obj.getAttribute("aria-expanded");

    if( data_toggle =="collapse"){     
     
        // console.log(Obj.className);      

        var data_targetRet = data_target.replace('#','');

        console.log(data_targetRet);
        console.log(aria_Expanded);


        // Target Content to collapse
        var collapseTargetContent = document.getElementById(data_targetRet);

        collapseTargetContent.classList.toggle("show");


        // Collapse Button Setting 
        if(aria_Expanded == 'false'){
          Obj.setAttribute("aria-expanded","true");
        }
        
        if(aria_Expanded == 'true'){
          Obj.setAttribute("aria-expanded","false");
        }
        

        //側邊選單切換
        if( data_targetRet == "navbarMenu"){

            // navbartogglerToggle();
            mask_overlay.classList.toggle("open");

        }

        

    }
    else{
        console.log("no collapse");
    }

}



// check mark button 打勾button 切換
function dataToggleCheck(Obj){

  // if(idInputValidTest.classList.contains("symCheck")){

  //   idInputValidTest.classList.remove("symCheck");
  //   idInputValidTest.classList.remove("symCheckAnim");

  // }
  // if(idInputValidTest.classList.contains("symError")){

  //   idInputValidTest.classList.remove("symError");
  //   idInputValidTest.classList.remove("symErrorAnim");

  // }
  
  var setTimeout=function(){

  }

  idInputValidTest.className = "form-control-underline";
  // idInputValidTest.className = "form-control-underline";
  // idInputValidTest.setAttribute("class", "form-control-underline");

  console.log("本來的class:"+idInputValidTest.className);
 

  idInputValidTest.classList.add("iconCheck","iconCheckAnim");
  // idInputValidTest.classList.add("symCheckAnim");

  console.log("check後的class:"+ idInputValidTest.className);

  

}

// cross mark button 打叉button 切換
function dataToggleCross(Obj){

  idInputValidTest.className = "form-control-underline";

  idInputValidTest.classList.toggle("iconError");
  idInputValidTest.classList.toggle("iconErrorAnim");

  console.log("cross後的class:"+ idInputValidTest.className);

}

//openFullSearch
function openFullSearch(e){
  var header_SearchFull= document.getElementById("header_SearchFull");
   header_SearchFull.classList.add("open");
}

//openFullSearch
function closeFullSearch(e){
  
  var header_SearchFull= document.getElementById("header_SearchFull");

  if(header_SearchFull.classList.contains("open")){
    header_SearchFull.classList.remove("open");
   }
  
   
}



// 黑色半透明遮罩
function maskOverlay(obj){
   
    if(obj.classList.contains("open")){
        mask_overlay.classList.remove("open");
    }
    else {
        mask_overlay.classList.add("open");
    }

    navbarMenu.classList.remove("show");   
    // popupCurrencyConvert.classList.remove("show");   
    navbartogglerID.setAttribute("aria-expanded","false");

   // 下拉選單關閉
    var els = document.querySelectorAll('.dropdown-menu.show');
    for (var i = 0; i < els.length; i++) {
        els[i].classList.remove('show')
      }

    // navbarSearch.classList.remove("show");
    // navbartogglerToggle();

}



// MENU BUTTON 切換
function navbartogglerToggle(){ 

    var navbartoggler_ariaExpanded = navbartogglerID.getAttribute("aria-expanded");
   
    if(navbartoggler_ariaExpanded == 'false'){
        navbartogglerID.setAttribute("aria-expanded","true");
    }
    
    if(navbartoggler_ariaExpanded == 'true'){
        navbartogglerID.setAttribute("aria-expanded","false");
    }

   
}



//header Scroll to add class
var nav_offset_top = 10;

window.onscroll = function (e) {

    var bodyTop = 0;

    if (typeof window.pageYOffset != "undefined") {
        bodyTop = window.pageYOffset;
    
    } else if (typeof document.compatMode != "undefined"
                && document.compatMode != "BackCompat") {
        bodyTop = document.documentElement.scrollTop;
    
    } else if (typeof document.body != "undefined") {
        bodyTop = document.body.scrollTop;
    }

    
   


    // 當頁面的滾動條滾動時,會執行這裡的代碼
    // document.getElementById("demo").innerHTML = "You scrolled" + bodyTop;

    // var element = document.getElementById("header_area");
    // var element = document.getElementsByClassName("header_area");


    // if (bodyTop >= nav_offset_top) {        
    //     element[0].classList.add("show");
    // } else {        
    //     element[0].classList.remove("show");
    // }


} 


// Header Nav MENU => iFrame 載入各頁面




//Custom Select ===============================================
var x, i, j, l, ll, selElmnt, a, b, c;
/* Look for any elements with the class "custom-select": */
x = document.getElementsByClassName("custom-select-js");
l = x.length;
for (i = 0; i < l; i++) {
  selElmnt = x[i].getElementsByTagName("select")[0];
  ll = selElmnt.length;
  /* For each element, create a new DIV that will act as the selected item: */
  a = document.createElement("DIV");
  a.setAttribute("class", "select-selected");
  a.innerHTML = selElmnt.options[selElmnt.selectedIndex].innerHTML;
  x[i].appendChild(a);
  /* For each element, create a new DIV that will contain the option list: */
  b = document.createElement("DIV");
  b.setAttribute("class", "select-items select-hide");
  for (j = 1; j < ll; j++) {
    /* For each option in the original select element,
    create a new DIV that will act as an option item: */
    c = document.createElement("DIV");

    c.setAttribute("class", "select-item"); //each item --ELMA

    c.innerHTML = selElmnt.options[j].innerHTML;
    c.addEventListener("click", function(e) {
        /* When an item is clicked, update the original select box,
        and the selected item: */
        var y, i, k, s, h, sl, yl;
        s = this.parentNode.parentNode.getElementsByTagName("select")[0];
        sl = s.length;
        h = this.parentNode.previousSibling;
        for (i = 0; i < sl; i++) {
          if (s.options[i].innerHTML == this.innerHTML) {
            s.selectedIndex = i;
            h.innerHTML = this.innerHTML;
            y = this.parentNode.getElementsByClassName("same-as-selected");
            yl = y.length;
            for (k = 0; k < yl; k++) {
            //   y[k].removeAttribute("class");
              y[k].classList.remove("same-as-selected"); //ELMA
            }
            // this.setAttribute("class", "same-as-selected");
            this.classList.add("same-as-selected"); //ELMA
            break;
          }
        }
        h.click();
    });
    b.appendChild(c);
  }
  x[i].appendChild(b);
  a.addEventListener("click", function(e) {
    /* When the select box is clicked, close any other select boxes,
    and open/close the current select box: */
    e.stopPropagation();
    closeAllSelect(this);
    this.nextSibling.classList.toggle("select-hide");
    this.classList.toggle("select-arrow-active");
  });
}

function closeAllSelect(elmnt) {
  /* A function that will close all select boxes in the document,
  except the current select box: */
  var x, y, i, xl, yl, arrNo = [];
  x = document.getElementsByClassName("select-items");
  y = document.getElementsByClassName("select-selected");
  xl = x.length;
  yl = y.length;
  for (i = 0; i < yl; i++) {
    if (elmnt == y[i]) {
      arrNo.push(i)
    } else {
      y[i].classList.remove("select-arrow-active");
    }
  }
  for (i = 0; i < xl; i++) {
    if (arrNo.indexOf(i)) {
      x[i].classList.add("select-hide");
    }
  }
}

/* If the user clicks anywhere outside the select box,
then close all select boxes: */
document.addEventListener("click", closeAllSelect);
