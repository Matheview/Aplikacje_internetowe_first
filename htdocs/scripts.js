$(document).ready(function() {
    $(window).scroll(function() {
        if($(window).scrollTop() > 1) {
            $('#page-logo').fadeIn();
            $("header").removeClass("background-black");
            $("header").addClass("background-white");
        }
        else {
            $('#page-logo').fadeOut();
            $("header").removeClass("background-white");
            $("header").addClass("background-black");
        }
    });
});

function auto_redirect() {
  window.setTimeout(function(){
        window.location.href = "index.php";
    }, 5000);
}

var passwd = document.getElementById("haslo"), passwd_confirm = document.getElementById("haslo_confirm");

function validatePassword(){
  if(passwd.value != passwd_confirm.value) {
    passwd_confirm.setCustomValidity("Hasła nie pasują do siebie");
  } else {
    passwd_confirm.setCustomValidity('');
  }
}

passwd.onchange = validatePassword;
passwd_confirm.onkeyup = validatePassword;
