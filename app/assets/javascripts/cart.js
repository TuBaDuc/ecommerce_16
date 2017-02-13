$(document).on('turbolinks:load', function () {
  $('.add-to-cart').each(function () {
    $(this).click(function(e){
      e.preventDefault();
      var id = $(this).attr('data');
      var product = $(this).parent().parent().parent();
      var image_url = product.find('img').attr('src');
      var name = product.attr('id');
      $.ajax({
        url: '/cart/' + id,
        method: 'POST',
        data: {
          product_id: id,
          image_url: image_url,
          product_name: name
        },
        success: function (response) {
          $('#cart-wrapper').remove();
          $('.drop-cart').append(response);
          var res_length = $('.cart-item').length;
          $('#shopping-cart').find('.number-cart').text(res_length);
        }
      })
    });
  });
  var data = {};
  $('.cart-quantity').each(function(){
    var id = $(this).attr('data');
    var quantity = parseInt($('#quantity-' + id).val(), 10);
    data[id] = quantity;
    $(this).bind('keyup change click', function () {
      id = $(this).attr('data');
      quantity = parseInt($('#quantity-' + id).val(), 10);
      var price = parseFloat($('#price-' + id).text().trim());
      if(isNaN(quantity * price)){
        $('#total-' + id).text(0);
      } else {
        $('#total-' + id).text(quantity * price);
      }
      data[id] = quantity;
    });
  });

  $('#update-cart').click(function(){
    var flag = true;
    $.each(data, function (key,value) {
      if(value <= 0){
        alert(I18n.t("quantity_error"));
        $('#quantity-' + key).val(1);
        flag = false;
        return;
      }
    });
    if(flag == true){
      if(Object.keys(data).length != 0){
        $.ajax({
          url: '/cart/',
          data: {
            cart: data
          },
          method: 'PATCH',
          success: function(result){
          }
        });
      }
    }
  });
});
