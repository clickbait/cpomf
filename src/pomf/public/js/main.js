$(window).scroll(function() {
    var scroll = $(window).scrollTop();
    if (scroll >= 50) {
        $("header").addClass("scroll");
    } else {
      $("header").removeClass("scroll");
    }
});

$(function() {
  $('form#login, form#registration').on('submit', function(e){
    $(this).find('button[type=submit]').prop('disabled', true);
  });
});
