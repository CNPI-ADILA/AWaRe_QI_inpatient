// Document title management
document.addEventListener('DOMContentLoaded', function() {
  document.title = 'AWaRe QI Dashboard';
  var observer = new MutationObserver(function(mutations) {
    mutations.forEach(function(mutation) {
      if (mutation.type === 'childList' && document.title !== 'AWaRe QI Dashboard') {
        document.title = 'AWaRe QI Dashboard';
      }
    });
  });
  observer.observe(document.querySelector('title'), { childList: true });
});

// Main jQuery functionality
$(document).ready(function() {
  // Collapsible sections
  $('.collapsible-header').click(function() {
    var content = $(this).next('.collapsible-content');
    var icon = $(this).find('.toggle-icon');
    content.slideToggle(300);
    icon.toggleClass('rotated');
    if (content.hasClass('show')) { 
      content.removeClass('show'); 
    } else { 
      content.addClass('show'); 
    }
  });
  
  // Scroll to top when sidebar menu item clicked
  $('.sidebar-menu a').click(function() {
    window.scrollTo({top: 0, behavior: 'smooth'});
  });
  
  // MOBILE MENU TOGGLE
  $('.navbar-toggle, .sidebar-toggle').click(function(e) {
    e.preventDefault();
    e.stopPropagation();
    toggleSidebar();
  });
  
  // Close sidebar when clicking overlay
  $(document).on('click', function(e) {
    if ($(window).width() <= 768) {
      if ($('body').hasClass('sidebar-open') && 
          !$(e.target).closest('.main-sidebar').length && 
          !$(e.target).closest('.navbar-toggle, .sidebar-toggle').length) {
        toggleSidebar();
      }
    }
  });
  
  // Close sidebar when menu item clicked on mobile
  $('.sidebar-menu a').click(function() {
    if ($(window).width() <= 768) {
      setTimeout(function() {
        if ($('body').hasClass('sidebar-open')) {
          toggleSidebar();
        }
      }, 300);
    }
  });
  
  // Prevent body scroll when sidebar open on mobile
  function updateBodyScroll() {
    if ($(window).width() <= 768 && $('body').hasClass('sidebar-open')) {
      $('body').css('overflow', 'hidden');
    } else {
      $('body').css('overflow', '');
    }
  }
  
  // Handle window resize
  $(window).resize(function() {
    if ($(window).width() > 768) {
      $('.main-sidebar').removeClass('sidebar-open');
      $('body').removeClass('sidebar-open').css('overflow', '');
    }
  });
});

// Toggle sidebar function
function toggleSidebar() {
  $('.main-sidebar').toggleClass('sidebar-open');
  $('body').toggleClass('sidebar-open');
  
  // Update body scroll
  if ($(window).width() <= 768 && $('body').hasClass('sidebar-open')) {
    $('body').css('overflow', 'hidden');
  } else {
    $('body').css('overflow', '');
  }
}

// Open menu for specific tab
function openMenuForTab(tabName) {
  var $link = $('.sidebar-menu a[href="#shiny-tab-' + tabName + '"]');
  if ($link.length === 0) return;

  var $tree = $link.closest('li.treeview');
  if ($tree.length === 0) { 
    $tree = $link.closest('ul.treeview-menu').closest('li.treeview'); 
  }
  if ($tree.length) {
    $('.sidebar-menu li.treeview').removeClass('menu-open active');
    $('.sidebar-menu li.treeview > ul.treeview-menu').css('display', 'none');

    $tree.addClass('menu-open active');
    $tree.children('ul.treeview-menu').css('display', 'block');

    $tree.find('ul.treeview-menu > li').removeClass('active');
    var $targetLi = $link.closest('li');
    $targetLi.addClass('active');
  }

  var $topLi = $tree;
  if ($topLi.length) {
    $('.sidebar-menu > li').removeClass('active');
    $topLi.addClass('active');
  }
  
  window.scrollTo({top: 0, behavior: 'smooth'});
}

// Shiny custom message handler
Shiny.addCustomMessageHandler('openMenu', function(tabName) {
  setTimeout(function(){ 
    openMenuForTab(tabName); 
  }, 100);
});
