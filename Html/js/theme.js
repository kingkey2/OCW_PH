// $('.header_area').load('layout-header.html');
$('#ModalDailylogin .activity-popup-detail-inner').load('activity/dailylogin/index.html');

$('#ModalDeposit .activity-popup-detail-inner').load('activity/deposit/index.html');
$('#ModalRegister .activity-popup-detail-inner').load('activity/register/index.html');
$('#ModalBNG .activity-popup-detail-inner').load('activity/BNG/index.html');

$('.footer').load('layout-footer.html');

$(document).ready(function () {

   //語言選單
   $('[data-btn-click="openLag"]').click(function(){
    $('.lang-select-panel').fadeToggle('fast');
    });

    $('.lang-select-panel a').click(function(){
        var curLang = $(this).text();
        $('.lang-select-panel').fadeToggle('fast');
        $('[data-btn-click="openLag"]').find('span').text(curLang);
    });

    //主選單收合
    $('.navbar-toggler').click(function(){
        $('.vertical-menu').toggleClass('navbar-show');
        $('.header_menu').toggleClass('show');
    });
    $('.header_area .mask_overlay').click(function(){
        $('.header_menu, .navbarMenu').removeClass('show'); //Sidebar Menu
        $('.navbar-toggler').attr("aria-expanded","false");
        $('.vertical-menu').removeClass('navbar-show');        
    });

    //遊戲 "更多" Button 下滑
    $('.game-item .btn-more').click(function(){
        // $(this).toggleClass('show');
        $(this).closest( '.game-item-info-detail').toggleClass('open');
    });

    $('.game-item .btn-thumbUp').click(function(){
        $(this).toggleClass('added');       
    });

    $('.game-item .btn-like').click(function(){
        $(this).toggleClass('added');       
    });
    
    $('.tab-scroller__content .tab-item').click(function(){
        $(this).parent('.tab-scroller__content').children('.tab-item').removeClass('active');
        $(this).toggleClass('active');       
    });

      //紀錄 下拉明細
      $('.record-table-item:not(.show) .record-table-drop-panel').hide();

    //   $('.btn-toggle').click(function(){
    //       $(this).toggleClass('cur');
    //       $(this).parents('.record-table-item').find('.record-table-drop-panel').slideToggle();
    //   });
      $('.record-table-tab').click(function(){
        //   $(this).find('.btn-toggle').toggleClass('cur');
          $(this).parents('.record-table-item').toggleClass('show').find('.record-table-drop-panel').slideToggle();
      });


    //HERO 
    var heroIndex = new Swiper("#hero-slider", {
    loop: true,
    slidesPerView: 1,
    effect: "fade",
    speed: 1000, //Duration of transition between slides (in ms)
    // autoplay: {
    //     delay: 3500,
    //     disableOnInteraction: false,
    // },
    pagination: {
        el: ".swiper-pagination",
        clickable: true,
        renderBullet: function (index, className) {
        //   return '<span class="' + className + '">' + (index + 1) + "</span>";
            return '<span class="' + className + '">' +'<img src="images/banner/thumb-'+ (index + 1) + '.png"></span>';
        },
        },   
    
    });

    var heroLobby = new Swiper("#hero-slider-lobby", {
        loop: true,
        // slidesPerView: 1,
        slidesPerView: "auto",
        centeredSlides: true,
        // freeMode: true,
        // spaceBetween: 20,  
        speed: 1000, //Duration of transition between slides (in ms)
        // autoplay: {
        //     delay: 3500,
        //     disableOnInteraction: false,
        // },
        pagination: {
            el: ".swiper-pagination",
            clickable: true,       
            },   
    
    });


    // 推薦遊戲
    var gameRecommend = new Swiper("#game-recommend", {
        loop: true,
        slidesPerView: "auto",
        slidesPerGroup: 8,
        navigation: {
            nextEl: "#game-recommend .swiper-button-next",
            prevEl: "#game-recommend .swiper-button-prev",
          },

    });

    // 最新遊戲
    var gameNew = new Swiper("#game-new", {
        // loop: true,
        slidesPerView: 3,
        freeMode: true,
        navigation: {
            nextEl: "#game-new .swiper-button-next",
        },
        breakpoints: {
            768: {
                slidesPerView: 4,
                freeMode: true                
            },
            1200: {
                slidesPerView: 6,
                freeMode: true                
            }
        }

    });

    // 賭場遊戲
    var gameCasino = new Swiper("#pop-casino", {
    // loop: true,
        slidesPerView: 3,
        freeMode: true,
        navigation: {
            nextEl: "#pop-casino .swiper-button-next",
        },
        breakpoints: {
            768: {
                slidesPerView: 4,
                freeMode: true                
            },
            1200: {
                slidesPerView: 6,
                freeMode: true                
            }
        }

    });

    var gamelobby_1 = new Swiper("#lobbyGame-1", {
        
        // slidesPerView: 2.3,
        // loop: true,
        slidesPerView: "auto",
        slidesPerGroup: 8,          
        navigation: {
            nextEl: "#lobbyGame-1 .swiper-button-next",
            prevEl: "#lobbyGame-1 .swiper-button-prev",
        },     
    });

    var gamelobby_2 = new Swiper("#lobbyGame-2", {
        // loop: true,                
        slidesPerView: "auto",
        slidesPerGroup: 8,
        // centeredSlides: true,
        // loopFillGroupWithBlank: true,
        // loopedSlides: 24,        
        // freeMode: true, //拖曳時 會呈現 free mode
        navigation: {
            nextEl: "#lobbyGame-2 .swiper-button-next",
            prevEl: "#lobbyGame-2 .swiper-button-prev",
        },
    });

    var gamelobby_3 = new Swiper("#lobbyGame-3", {
        loop: true,        
        slidesPerView: "auto",
        freeMode: true,
        navigation: {
            nextEl: "#lobbyGame-3 .swiper-button-next",
        },
    });

   

    var gamelobby_randomRem = new Swiper("#lobbyGame-randomRem", {
            effect: "coverflow",
            grabCursor: true,
            centeredSlides: true,
            slidesPerView: "auto",
            // loopedSlides: 3,   
            
            loop: true,
            coverflowEffect: {
                rotate: 20,
                stretch: 0,
                depth: 200,
                modifier: 1,
                slideShadows: true,
            },            
            autuplay: {
                delay: 100,
                disableOnInteraction: false,
            }
    });
	

});


