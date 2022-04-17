
$(document).ready(function(){
  function readURL(input, rm_image, image, poza) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function (e) {
            $(image).attr('src', e.target.result);
            $(poza).show();
            $(image).show();
            $(rm_image).attr('value', 0);
        }
        
        reader.readAsDataURL(input.files[0]);
    }
  }
  $("#user_profile_picture").change(function(){
    readURL(this, '#user_remove_profile_picture', '#image', '#poza');
  });
})