jQuery(function($) {
  $(".new_message").bind("ajaxSend", function() {
    $(":text", this).val("");
  });
});
