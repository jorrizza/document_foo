$(function () {
    $(".alert-message").alert();

    $(".dellink").click(
      function () {
        $("#confirm_modal .primary").attr('href', this.href);
        $("#confirm_modal").modal('show');
        return false;
      }
    );

    $("#confirm_modal .secondary").click(
      function () {
        $("#confirm_modal").modal('hide');
      }
    );

    // A quick jQuery-hack to highlight the current page
    // in the menu based on the path prefix.
    $('.nav a').each(
      function () {
        if ($(this).attr('href') == window.location.pathname.substring(0, $(this).attr('href').length)) {
          $(this).parent().addClass('active');
        }
      }
    );

    if ($("#role").attr('value') == 'customer') {
      $('.accountant').css('display', 'block');
    }

    $('#role').change(
      function () {
        if (this.value == 'customer') {
          $('.accountant').css('display', 'block');
        } else {
          $('.accountant').css('display', 'none');
        }
      }
    );
  }
 );
