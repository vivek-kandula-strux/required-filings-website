(function($) {
    "use strict";
  
    const $documentOn = $(document);
    const $windowOn = $(window);
  
    $documentOn.ready( function() {
  
      /* ================================
       Mobile Menu Js Start
    ================================ */
    
      $('#mobile-menu').meanmenu({
        meanMenuContainer: '.mobile-menu',
        meanScreenWidth: "1199",
        meanExpand: ['<i class="far fa-plus"></i>'],
    });

      // Second meanmenu init used a bogus 19920px breakpoint, meaning it
      // triggered at every viewport size and duplicated behaviour. Guarded
      // so it only runs if the target element actually exists AND a sane
      // breakpoint is provided via data attribute — otherwise dead code.
      if ($('#mobile-menus').length) {
          var _menusBp = $('#mobile-menus').data('mean-screen-width') || "1199";
          $('#mobile-menus').meanmenu({
              meanMenuContainer: '.mobile-menus',
              meanScreenWidth: String(_menusBp),
              meanExpand: ['<i class="far fa-plus"></i>'],
          });
      }

     $documentOn.on("click", ".mean-expand", function () {
        let icon = $(this).find("i");

        if (icon.hasClass("fa-plus")) {
            icon.removeClass("fa-plus").addClass("fa-minus"); 
        } else {
            icon.removeClass("fa-minus").addClass("fa-plus"); 
        }
    });

    /* ================================
        Sidebar Toggle & Sticky Item Logic
        ================================ */

    var _offcanvasLastFocus = null;
    var _offcanvasFocusTrap = null;

    function _offcanvasOpen(trigger) {
      _offcanvasLastFocus = trigger || null;
      $(".offcanvas__info").addClass("info-open");
      $(".offcanvas__overlay").addClass("overlay-open");
      document.body.classList.add("offcanvas-open");
      $(".sidebar-sticky-item").fadeOut().removeClass("active");
      // Move focus into offcanvas after transition
      setTimeout(function () {
        var closeBtn = document.querySelector(".offcanvas__close button");
        if (closeBtn) closeBtn.focus();
      }, 150);
      // Set up focus trap
      var offcanvas = document.querySelector(".offcanvas__info");
      if (offcanvas) {
        _offcanvasFocusTrap = function (e) {
          if (e.key !== "Tab") return;
          var focusable = Array.from(offcanvas.querySelectorAll(
            'a[href], button:not([disabled]), [tabindex]:not([tabindex="-1"])'
          )).filter(function (el) { return !el.closest("[hidden]"); });
          if (!focusable.length) return;
          var first = focusable[0], last = focusable[focusable.length - 1];
          if (e.shiftKey && document.activeElement === first) {
            e.preventDefault(); last.focus();
          } else if (!e.shiftKey && document.activeElement === last) {
            e.preventDefault(); first.focus();
          }
        };
        document.addEventListener("keydown", _offcanvasFocusTrap);
      }
    }

    function _offcanvasClose() {
      $(".offcanvas__info").removeClass("info-open");
      $(".offcanvas__overlay").removeClass("overlay-open");
      document.body.classList.remove("offcanvas-open");
      $(".sidebar-sticky-item").fadeIn().addClass("active");
      if (_offcanvasFocusTrap) {
        document.removeEventListener("keydown", _offcanvasFocusTrap);
        _offcanvasFocusTrap = null;
      }
      if (_offcanvasLastFocus) {
        _offcanvasLastFocus.focus();
        _offcanvasLastFocus = null;
      }
    }

        $(".sidebar__toggle").on("click", function () { _offcanvasOpen(this); });
        $(".offcanvas__close, .offcanvas__overlay").on("click", _offcanvasClose);

        // Escape key closes offcanvas
        $documentOn.on("keydown.offcanvas", function (e) {
          if (e.key === "Escape" && $(".offcanvas__info").hasClass("info-open")) {
            _offcanvasClose();
          }
        });

        /* ================================
        Body Overlay Js Start
        ================================ */

        $(".body-overlay").on("click", function () {
        $(".offcanvas__area").removeClass("offcanvas-opened");
        $(".df-search-area").removeClass("opened");
        $(".body-overlay").removeClass("opened");

        // Show sticky item when overlay clicked
        $(".sidebar-sticky-item").fadeIn().addClass("active");
        });

        /* ================================
        Offcanvas Link Click (Optional)
        ================================ */

        $(".offcanvas a").on("click", function () {
        $(".sidebar-sticky-item").fadeIn().addClass("active");
    });

    /* ================================
       Nav Dropdown — aria-expanded
    ================================ */
    (function () {
      var dropdownItems = document.querySelectorAll('.has-dropdown');
      dropdownItems.forEach(function (item) {
        var trigger = item.querySelector(':scope > a');
        if (!trigger) return;
        trigger.setAttribute('aria-haspopup', 'true');
        trigger.setAttribute('aria-expanded', 'false');

        // Desktop: sync aria-expanded with CSS hover state
        item.addEventListener('mouseenter', function () {
          trigger.setAttribute('aria-expanded', 'true');
        });
        item.addEventListener('mouseleave', function () {
          trigger.setAttribute('aria-expanded', 'false');
        });

        // Keyboard: Enter or Space opens/closes; Escape closes
        trigger.addEventListener('keydown', function (e) {
          if (e.key === 'Enter' || e.key === ' ') {
            e.preventDefault();
            var isOpen = trigger.getAttribute('aria-expanded') === 'true';
            trigger.setAttribute('aria-expanded', isOpen ? 'false' : 'true');
            var submenu = item.querySelector('.submenu');
            if (submenu) submenu.style.display = isOpen ? '' : 'block';
          }
          if (e.key === 'Escape') {
            trigger.setAttribute('aria-expanded', 'false');
            var submenu = item.querySelector('.submenu');
            if (submenu) submenu.style.display = '';
            trigger.focus();
          }
        });

        // Close on outside click
        document.addEventListener('click', function (e) {
          if (!item.contains(e.target)) {
            trigger.setAttribute('aria-expanded', 'false');
            var submenu = item.querySelector('.submenu');
            if (submenu) submenu.style.display = '';
          }
        });
      });
    })();

      /* ================================
       Sticky Header Js Start
    ================================ */

       $windowOn.on("scroll", function () {
        if ($(this).scrollTop() > 250) {
          $("#header-sticky").addClass("sticky");
        } else {
          $("#header-sticky").removeClass("sticky");
        }
      });      
      
       /* ================================
       Video & Image Popup Js Start
    ================================ */

      if (typeof $.fn.magnificPopup !== 'undefined') {
        $(".img-popup").magnificPopup({
          type: "image",
          gallery: {
            enabled: true,
          },
        });
        $(".video-popup").magnificPopup({
          type: "iframe",
          callbacks: {},
        });
      }

      /* ================================
       Counterup Js Start
    ================================ */

      if (typeof $.fn.counterUp !== 'undefined') {
        $(".count").counterUp({
          delay: 15,
          time: 4000,
        });
      }
  
      /* ================================
       Wow Animation Js — REMOVED (2026-07-18)
       wow.min.js and animate.css were unloaded; GSAP handles all
       reveals via .text-anim / .tz-*-title. Legacy `class="wow …"`
       markup in the HTML is a no-op — the Phase 16.11 CSS safety net
       keeps those elements visible regardless.
    ================================ */
      if (typeof WOW === "function") { try { new WOW().init(); } catch (e) {} }
  
      /* ================================
       Nice Select Js Start
    ================================ */

    if ($('.single-select').length) {
        $('.single-select').niceSelect();
    }

      /* ================================
       Parallaxie Js Start
    ================================ */

      if ($('.parallaxie').length && $(window).width() > 991) {
          if ($(window).width() > 768) {
              $('.parallaxie').parallaxie({
                  speed: 0.55,
                  offset: 0,
              });
          }
      }

      /* ================================
      Hover Active Js Start
    ================================ */

    $(".counter-box, .service-card-item, .choose-list li, .feature-box-style-3, .about-wrapper-5 .about-icon-item, .service-box-style-5, .counter-box-style-5, .work-process-box-style-4, .contact-info-box").hover(
		// Function to run when the mouse enters the element
		function () {
			// Remove the "active" class from all elements
			$(".counter-box, .service-card-item, .choose-list li, .feature-box-style-3, .about-wrapper-5 .about-icon-item, .service-box-style-5, .counter-box-style-5, .work-process-box-style-4, .contact-info-box").removeClass("active");
			// Add the "active" class to the currently hovered element
			$(this).addClass("active");
		}
	);

     /* ================================
     Button Hover Js Start
    ================================ */
    
    if (typeof gsap !== "undefined") {
        const hoverBtns = gsap.utils.toArray(".wt-hover-btn-wrapper");
        const hoverBtnItems = gsap.utils.toArray(".wt-hover-btn-item");

        if (hoverBtns.length && hoverBtnItems.length) {
            hoverBtns.forEach((btn, i) => {
                const $btn = $(btn);

                $btn.on("mousemove", function (e) {
                    const relX = e.pageX - $btn.offset().left;
                    const relY = e.pageY - $btn.offset().top;

                    gsap.to(hoverBtnItems[i], {
                        duration: 0.6,
                        x: ((relX - $btn.width() / 2) / $btn.width()) * 60,
                        y: ((relY - $btn.height() / 2) / $btn.height()) * 60,
                        ease: "power2.out"
                    });
                });

                $btn.on("mouseleave", function () {
                    gsap.to(hoverBtnItems[i], {
                        duration: 0.6,
                        x: 0,
                        y: 0,
                        ease: "power2.out"
                    });
                });
            });
        }
    }

    /* ================================
     Scrolldown Js Start
    ================================ */
    $("#scrollDown").on("click", function () {
        setTimeout(function () {
            $("html, body").animate({ scrollTop: "+=1000px" }, "slow");
        }, 1000);
    });

    /* ================================
      Brand Slider Js Start
    ================================ */

   if ($('.brand-slider').length > 0) {
    const brandSlider = new Swiper(".brand-slider", {
        spaceBetween: 30,
        speed: 1300,
        loop: true,
        autoplay: {
            delay: 2000,
            disableOnInteraction: false,
        },
        navigation: {
            nextEl: ".array-next",
            prevEl: ".array-prev",
        },
        breakpoints: {
            1399: {
                slidesPerView: 6,
            },
            1199: {
                slidesPerView: 5.5,
            },
            991: {
                slidesPerView: 4.5,
            },
            767: {
                slidesPerView: 3.3,
            },
            575: {
                slidesPerView: 2,
            },
            0: {
                slidesPerView: 1.6,
            },
        },
    });
   }

    /* ================================
      Feature Box Slider Js Start
    ================================ */
   if ($('.feature-box-slider').length > 0) {
    var _prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    const featureBoxSlider = new Swiper(".feature-box-slider", {
        spaceBetween: 30,
        speed: 600,
        loop: true,
        a11y: { enabled: true },
        autoplay: _prefersReducedMotion ? false : {
            delay: 4000,
            disableOnInteraction: false,
            pauseOnMouseEnter: true,
        },
        navigation: {
            nextEl: ".array-next",
            prevEl: ".array-prev",
        },
        pagination: {
            el: ".dot",
            clickable: true,
        },
        breakpoints: {
            1199: {
                slidesPerView: 4,
            },
            991: {
                slidesPerView: 3,
            },
            767: {
                slidesPerView: 2,
            },
            575: {
                slidesPerView: 1.5,
            },
            0: {
                slidesPerView: 1.2,
            },
        },
    });
   }

   /* ================================
      Feature Box Slider Js Start
    ================================ */
   if ($('.service-slider-3').length > 0) {
    const serviceSlider3 = new Swiper(".service-slider-3", {
        spaceBetween: 30,
        speed: 1300,
        loop: true,
         centeredSlides: true,
        autoplay: {
            delay: 2000,
            disableOnInteraction: false,
        },
        navigation: {
            nextEl: ".array-next",
            prevEl: ".array-prev",
        },
        pagination: {
            el: ".dot",
            clickable: true,
        },
        breakpoints: {
            1399: {
                slidesPerView: 4,
            },
            1199: {
                slidesPerView: 3.4,
            },
            991: {
                slidesPerView: 2.8,
            },
            767: {
                slidesPerView: 2,
            },
            575: {
                slidesPerView: 1.5,
            },
            0: {
                slidesPerView: 1.2,
            },
        },
    });
   }

    /* ================================
      Project Slider Js Start
    ================================ */

   if ($('.project-slider').length > 0) {
    const projectSlider = new Swiper(".project-slider", {
        spaceBetween: 30,
        speed: 1300,
        loop: true,
        centeredSlides: true,
        navigation: {
            nextEl: ".array-next",
            prevEl: ".array-prev",
        },
        autoplay: {
            delay: 2000,
            disableOnInteraction: false,
        },
        pagination: {
            el: ".dot",
            clickable: true,
        },
        breakpoints: {
            1399: {
                slidesPerView: 4,
            },
            1199: {
                slidesPerView: 4,
            },
            991: {
                slidesPerView: 3,
            },
            767: {
                slidesPerView: 2,
            },
            575: {
                slidesPerView: 1.5,
            },
            0: {
                slidesPerView: 1.2,
            },
        },
    });
   }

    /* ================================
     Testimonial Slider Js Start
    ================================ */

    if ($('.testimonial-slider-content').length) {
		var slider = new Swiper ('.testimonial-slider-content', {
			slidesPerView: 1,
			spaceBetween: 30,
			navigation: true,
			centeredSlides: true,
            speed: 1300,
			loop: true,
			loopedSlides: 6,
			navigation: {
                nextEl: ".array-next",
                prevEl: ".array-prev",
            },
            pagination: {
                el: ".dot2",
                clickable: true,
            },
		});
		var thumbs = new Swiper ('.testimonial-thumbs', {
			slidesPerView: 3,
			spaceBetween: 0,
			centeredSlides: true,
			loop: true,
            speed: 1300,
			slideToClickedSlide: true,
		});
		slider.controller.control = thumbs;
		thumbs.controller.control = slider;
	}

    if ($('.testimonial-slider-2').length > 0) {
    const testimonialSlider2 = new Swiper(".testimonial-slider-2", {
        spaceBetween: 30,
        speed: 1300,
        loop: true,
        centeredSlides: true,
        autoplay: {
            delay: 2000,
            disableOnInteraction: false,
        },
        navigation: {
            nextEl: ".array-next",
            prevEl: ".array-prev",
        },
        pagination: {
            el: ".dot2",
            clickable: true,
        },
        breakpoints: {
            1199: {
                slidesPerView: 2.1,
            },
            991: {
                slidesPerView: 1.9,
            },
            767: {
                slidesPerView: 1.8,
            },
            575: {
                slidesPerView: 1.1,
            },
            0: {
                slidesPerView: 1,
            },
        },
    });
   }

    if ($('.testimonial-slider-3').length > 0) {
    const testimonialSlider3 = new Swiper(".testimonial-slider-3", {
        spaceBetween: 30,
        speed: 1300,
        loop: true,
         centeredSlides: true,
        autoplay: {
            delay: 2000,
            disableOnInteraction: false,
        },
        navigation: {
            nextEl: ".array-next",
            prevEl: ".array-prev",
        },
        pagination: {
            el: ".dot2",
            clickable: true,
        },
        breakpoints: {
            1399: {
                slidesPerView: 4,
            },
            1199: {
                slidesPerView: 3.4,
            },
            991: {
                slidesPerView: 3,
            },
            767: {
                slidesPerView: 2,
            },
            575: {
                slidesPerView: 1.5,
            },
            0: {
                slidesPerView: 1.2,
            },
        },
    });
    }

    if ($('.testimonial-slider-4').length > 0) {
    const testimonialSlider4 = new Swiper(".testimonial-slider-4", {
        spaceBetween: 30,
        speed: 1300,
        loop: true,
        autoplay: {
            delay: 2000,
            disableOnInteraction: false,
        },
        navigation: {
            nextEl: ".array-next",
            prevEl: ".array-prev",
        },
        pagination: {
            el: ".dot2",
            clickable: true,
        },
        breakpoints: {
            1399: {
                slidesPerView: 4,
            },
             1199: {
                slidesPerView: 3,
            },
            991: {
                slidesPerView: 2.4,
            },
            767: {
                slidesPerView: 1.3,
            },
            575: {
                slidesPerView: 1.3,
            },
            0: {
                slidesPerView: 1.2,
            },
        },
    });
    }

    if ($('.testimonial-slider-5').length > 0) {
    const testimonialSlider5 = new Swiper(".testimonial-slider-5", {
        spaceBetween: 30,
        speed: 1300,
        loop: true,
        autoplay: {
            delay: 2000,
            disableOnInteraction: false,
        },
        navigation: {
            nextEl: ".array-next",
            prevEl: ".array-prev",
        },
        pagination: {
            el: ".dot2",
            clickable: true,
        },
        breakpoints: {
            1199: {
                slidesPerView: 3,
            },
            991: {
                slidesPerView: 3,
            },
            767: {
                slidesPerView: 2,
            },
            575: {
                slidesPerView: 1.5,
            },
            0: {
                slidesPerView: 1.2,
            },
        },
    });
    }
    
   /* ================================
      Global Service Box Js Start
    ================================ */

    if (document.querySelectorAll(".global-service-box").length) {
    const globalServiceBoxes = document.querySelectorAll(".global-service-box");

    globalServiceBoxes.forEach((box) => {
        const hoverImg = box.querySelector(".hover-image");
        if (!hoverImg) return;

        box.addEventListener("mousemove", (event) => {
        const rect = box.getBoundingClientRect();
        const x = event.clientX - rect.left;
        const y = event.clientY - rect.top;

        hoverImg.style.opacity = "1";
        hoverImg.style.visibility = "visible";
        hoverImg.style.transform = `translate(${x}px, ${y}px) rotate(10deg)`;
        });

        box.addEventListener("mouseleave", () => {
        hoverImg.style.opacity = "0";
        hoverImg.style.visibility = "hidden";
        hoverImg.style.transform = `translateY(-50%) rotate(10deg)`;
        });
    });
    }

    /* ================================
      Custom Accordion Js Start
    ================================ */

   if ($('.accordion-box').length) {
        // Set initial aria-expanded states
        $('.accordion-box .acc-btn').each(function() {
            var isOpen = $(this).closest('.accordion').hasClass('active-block');
            $(this).attr('aria-expanded', isOpen ? 'true' : 'false');
        });

        $(".accordion-box").on('click', '.acc-btn', function () {
            var outerBox = $(this).closest('.accordion-box');
            var target = $(this).closest('.accordion');
            var accBtn = $(this);
            var accContent = accBtn.next('.acc-content');

            if (target.hasClass('active-block')) {
                // Already open, so close it
                accBtn.removeClass('active').attr('aria-expanded', 'false');
                target.removeClass('active-block');
                accContent.slideUp(300);
            } else {
                // Close all others
                outerBox.find('.accordion').removeClass('active-block');
                outerBox.find('.acc-btn').removeClass('active').attr('aria-expanded', 'false');
                outerBox.find('.acc-content').slideUp(300);

                // Open clicked one
                accBtn.addClass('active').attr('aria-expanded', 'true');
                target.addClass('active-block');
                accContent.slideDown(300);
            }
        });

        // Keyboard: Enter/Space triggers click on div-based acc-btn
        $(".accordion-box").on('keydown', '.acc-btn', function(e) {
            if (e.key === 'Enter' || e.key === ' ') {
                e.preventDefault();
                $(this).trigger('click');
            }
        });
    }

    if ($('.service-box-style-4').length) {
        $(".service-box-style-4").on('click', '.service-acc-btn', function () {
            var outerBox = $(this).closest('.service-box-style-4');
            var target = $(this).closest('.accordion');
            var accBtn = $(this);
            var accContent = accBtn.next('.service-acc-content');

            if (target.hasClass('active-block')) {
                // Already open, so close it
                accBtn.removeClass('active');
                target.removeClass('active-block');
                accContent.slideUp(300);
            } else {
                // Close all others
                outerBox.find('.accordion').removeClass('active-block');
                outerBox.find('.service-acc-btn').removeClass('active');
                outerBox.find('.service-acc-content').slideUp(300);

                // Open clicked one
                accBtn.addClass('active');
                target.addClass('active-block');
                accContent.slideDown(300);
            }
        });
    }


    /* ================================
        Mouse Cursor Animation Js Start
    ================================ */

    // Custom cursor: skip entirely on touch/coarse-pointer devices where
    // window.onmousemove either never fires or fires as a synthetic single
    // event, leaving a stuck cursor dot at (0,0). CSS also hides the
    // elements via @media (hover: none) — this guards the JS too.
    var _hasFinePointer = window.matchMedia('(hover: hover) and (pointer: fine)').matches;
    if (_hasFinePointer && $(".mouseCursor").length > 0) {
        function itCursor() {
            var myCursor = jQuery(".mouseCursor");
            if (myCursor.length) {
                const e = document.querySelector(".cursor-inner"),
                      t = document.querySelector(".cursor-outer");
                if (!e || !t) return; // Defensive: element missing on some templates
                let n, i = 0, o = !1;
                window.onmousemove = function(s) {
                    if (!o) {
                        t.style.transform = "translate(" + s.clientX + "px, " + s.clientY + "px)";
                    }
                    e.style.transform = "translate(" + s.clientX + "px, " + s.clientY + "px)";
                    n = s.clientY;
                    i = s.clientX;
                };
                $("body").on("mouseenter", "button, a, .cursor-pointer", function() {
                    e.classList.add("cursor-hover");
                    t.classList.add("cursor-hover");
                });
                $("body").on("mouseleave", "button, a, .cursor-pointer", function() {
                    if (!($(this).is("a", "button") && $(this).closest(".cursor-pointer").length)) {
                        e.classList.remove("cursor-hover");
                        t.classList.remove("cursor-hover");
                    }
                });
                e.style.visibility = "visible";
                t.style.visibility = "visible";
            }
        }
        itCursor();
    }

    /* ================================
        Back To Top Button Js Start
    ================================ */
    $windowOn.on('scroll', function() {
        var windowScrollTop = $(this).scrollTop();
        var windowHeight = $(window).height();
        var documentHeight = $(document).height();

        if (windowScrollTop + windowHeight >= documentHeight - 10) {
            $("#back-top").addClass("show");
        } else {
            $("#back-top").removeClass("show");
        }
    });

    $documentOn.on('click', '#back-top', function() {
        $('html, body').animate({ scrollTop: 0 }, 800);
        return false;
    });

    /* ================================
       Search Popup Toggle Js Start
    ================================ */

    if ($(".search-toggler").length) {
        $(".search-toggler").on("click", function(e) {
            e.preventDefault();
            $(".search-popup").toggleClass("active");
            $("body").toggleClass("locked");
        });
    }

    
	
    /* ================================
       Smooth Scroller And Title Animation Js Start
    ================================ */
    if ($('#smooth-wrapper').length && $('#smooth-content').length) {
        gsap.registerPlugin(ScrollTrigger, ScrollSmoother, SplitText);

        gsap.config({
            nullTargetWarn: false,
        });

        let smoother = ScrollSmoother.create({
            wrapper: "#smooth-wrapper",
            content: "#smooth-content",
            smooth: 2,
            effects: true,
            smoothTouch: 0.1,
            normalizeScroll: false,
            ignoreMobileResize: true,
        });
    }

    

     /* ================================
      Text Invert Js Start
      Guarded: skip if the target element is absent (some pages lack it)
      or if the user prefers reduced motion. Prior code threw on pages
      without `.text_invert-2` when SplitText returned zero lines.
    ================================ */

    var _rfReduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

    if (!_rfReduceMotion && document.querySelector(".text_invert-2")) {
        const split2 = new SplitText(".text_invert-2", { type: "lines" });

        split2.lines.forEach((target) => {
            gsap.to(target, {
                backgroundPositionX: 0,
                ease: "none",
                scrollTrigger: {
                    trigger: target,
                    scrub: 1,
                    start: 'top 85%',
                    end: "bottom center",
                    invalidateOnRefresh: true,
                }
            });
        });
    }

    // Per-character scrub: desktop/tablet only (>=576px). On mobile the
    // effect is barely visible and causes measurable jank on scroll.
    // Also skipped under prefers-reduced-motion (revealed instantly).
    if($('.tz-sub-tilte').length) {
      var _tzSubOk = window.matchMedia('(min-width: 576px)').matches && !_rfReduceMotion;
      var agtsub = $(".tz-sub-tilte");

      if (!_tzSubOk) {
        // Ensure text is visible instead of stuck at opacity:0
        gsap.set(agtsub.toArray(), { clearProps: "all", opacity: 1 });
      } else {
        if(agtsub.length == 0) return; gsap.registerPlugin(SplitText); agtsub.each(function(index, el) {

          el.split = new SplitText(el, {
            type: "lines,words,chars",
            linesClass: "split-line"
          });

          if( $(el).hasClass('tz-sub-anim') ){
            gsap.set(el.split.chars, {
              opacity: 0,
              x: "7",
            });
          }

          el.anim = gsap.to(el.split.chars, {
            scrollTrigger: {
              trigger: el,
              start: "top 90%",
              end: "top 60%",
              markers: false,
              scrub: 1,
              invalidateOnRefresh: true,
            },

            x: "0",
            y: "0",
            opacity: 1,
            duration: .7,
            stagger: 0.2,
          });

        });
      }
    }

    // Same viewport / reduced-motion gate as .tz-sub-tilte above.
    if($('.tz-itm-title').length) {
		var _tzItmOk = window.matchMedia('(min-width: 576px)').matches && !_rfReduceMotion;
		var txtheading = $(".tz-itm-title");

    if (!_tzItmOk) {
        gsap.set(txtheading.toArray(), { clearProps: "all", opacity: 1 });
    } else {
        if(txtheading.length == 0) return; gsap.registerPlugin(SplitText); txtheading.each(function(index, el) {

        el.split = new SplitText(el, {
          type: "lines,words,chars",
          linesClass: "split-line"
        });

        if( $(el).hasClass('tz-itm-anim') ){
          gsap.set(el.split.chars, {
            opacity: .3,
            x: "-7",
          });
        }
        el.anim = gsap.to(el.split.chars, {
          scrollTrigger: {
            trigger: el,
            start: "top 92%",
            end: "top 60%",
            markers: false,
            scrub: 1,
            invalidateOnRefresh: true,
          },

          x: "0",
          y: "0",
          opacity: 1,
          duration: .7,
          stagger: 0.2,
        });

      });
    }
    }


    /* ================================
       Text Anim Js Start
    ================================ */

   // .text-anim: cheap one-shot entrance (no scrub) — runs everywhere
   // except under reduced-motion, where we simply skip it.
   if (!_rfReduceMotion && $(".text-anim").length) {
        let staggerAmount = 0.02,
            translateXValue = 20,
            delayValue = 0.1,
            easeType = "power2.out",
            animatedTextElements = document.querySelectorAll(".text-anim");

        animatedTextElements.forEach(element => {
            let animationSplitText = new SplitText(element, { type: "chars, words" });

            // ScrollTrigger দিয়ে section এ ঢুকলে animation শুরু হবে
            ScrollTrigger.create({
                trigger: element,
                start: "top 85%",
                onEnter: () => {
                    gsap.from(animationSplitText.chars, {
                        duration: 0.6,
                        delay: delayValue,
                        x: translateXValue,
                        autoAlpha: 0,
                        stagger: staggerAmount,
                        ease: easeType,
                    });
                },
            });
        });
    }
    // Debounced resize + orientation handler. Refreshes ScrollTrigger so
    // start/end positions recalculate when the viewport crosses breakpoints
    // or the mobile URL bar collapses/expands. Prior code listened only for
    // orientationchange and missed manual browser resizes on desktop.
    (function () {
        if (typeof ScrollTrigger === "undefined") return;
        var _rfResizeTO;
        function _rfRefresh() {
            clearTimeout(_rfResizeTO);
            _rfResizeTO = setTimeout(function () { ScrollTrigger.refresh(); }, 200);
        }
        window.addEventListener("resize", _rfRefresh, { passive: true });
        window.addEventListener("orientationchange", _rfRefresh);
    })();

    // Dev-only responsive QA helper. Enable by appending ?rfQA=1 to any URL
    // (e.g. https://requiredfilings.com/index.html?rfQA=1). Logs every DOM
    // element whose right edge exceeds the viewport width so overflow bugs
    // can be traced back to a specific class or transform. Off by default —
    // costs zero on production loads.
    (function () {
        try {
            var params = new URLSearchParams(window.location.search);
            if (params.get("rfQA") !== "1") return;
            window.rfOverflow = function () {
                var vw = document.documentElement.clientWidth;
                var offenders = Array.prototype.filter.call(
                    document.querySelectorAll("*"),
                    function (el) { return el.getBoundingClientRect().right > vw + 1; }
                );
                console.groupCollapsed("[rfQA] %d overflow offender(s) @ %dpx", offenders.length, vw);
                offenders.forEach(function (el) {
                    var r = el.getBoundingClientRect();
                    console.log("→", el.tagName.toLowerCase() +
                        (el.className ? "." + String(el.className).trim().replace(/\s+/g, ".") : ""),
                        "right:", Math.round(r.right), "width:", Math.round(r.width), el);
                });
                console.groupEnd();
                return offenders;
            };
            // Auto-run once after load.
            window.addEventListener("load", function () { setTimeout(window.rfOverflow, 250); });
            console.info("[rfQA] Diagnostic mode on. Call rfOverflow() in DevTools anytime.");
        } catch (e) { /* URLSearchParams unsupported — ignore */ }
    })();

    }); // End Document Ready Function

     /* ================================
      Pricing Toggle Js Start
    ================================ */

   document.addEventListener("DOMContentLoaded", () => {
    const monthlyBtn = document.querySelector(".monthly-label");
    const yearlyBtn = document.querySelector(".yearly-label");
    const prices = document.querySelectorAll(".price");

    // Only run if the page has the pricing elements
    if (!monthlyBtn || !yearlyBtn || prices.length === 0) return;

    let isAnimating = false;

    function changePrice(type) {
        if (isAnimating) return; // Prevent double click bug
        isAnimating = true;

        prices.forEach(price => {
            price.classList.add("fade-out");

            setTimeout(() => {
                const value = price.dataset[type];
                const period = type === "monthly" ? "months" : "year";

                price.innerHTML = `$${value}<sub>/ ${period}</sub>`;

                price.classList.remove("fade-out");
                price.classList.add("fade-in");

                setTimeout(() => {
                    price.classList.remove("fade-in");
                    isAnimating = false;
                }, 300);
            }, 300);
        });
    }

    monthlyBtn.addEventListener("click", function () {
        if (!this.classList.contains("active")) {
            monthlyBtn.classList.add("active");
            yearlyBtn.classList.remove("active");
            changePrice("monthly");
        }
    });

    yearlyBtn.addEventListener("click", function () {
        if (!this.classList.contains("active")) {
            yearlyBtn.classList.add("active");
            monthlyBtn.classList.remove("active");
            changePrice("yearly");
        }
    });
});


     /* ================================
       Preloader Js Start
    ================================ */

     function loader() {
        $(window).on('load', function() {
            // Animate loader off screen
            $(".preloader").addClass('loaded');                    
            $(".preloader").delay(600).fadeOut();                       
        });
    }
    loader();


  
  })(jQuery); // End jQuery

