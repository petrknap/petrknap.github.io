$(function() {
    $('.carousel').each(function () {
        $('body').append('<div id="carousel-ruler" class="carousel"></div>');
        var $ruler = $('#carousel-ruler'), maximalHeight = 0;
        $ruler.html($(this).html());
        $ruler.find('.item').each(function () {
            $(this).show();
            maximalHeight = Math.max(maximalHeight, $(this).height());
        });
        $(this).find('.item').each(function () {
            $(this).height(maximalHeight);
        });
        $ruler.remove();
    });
});
