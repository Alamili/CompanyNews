
//Här kommer app setting

"use strict";

function getQueryStringParameter(urlParameterKey) {
    var params = document.URL.split('?')[1].split('&');
    var strParams = '';
    for (var i = 0; i < params.length; i = i + 1) {
        var singleParam = params[i].split('=');
        if (singleParam[0] == urlParameterKey)
            return decodeURIComponent(singleParam[1]);
    }
}

// Create var out of the param value



var colorValue = getQueryStringParameter('MyEnum');

var category = getQueryStringParameter('Category');


(function ($) {

    if (colorValue == 1) {
        $(".contain").css("background-color", "antiquewhite");
    };
    if (colorValue == 2) {
        $(".contain").css("background-color", "bisque");
    };
    if (colorValue == 3) {
        $(".contain").css("background-color", "white");
    };


    //denna funkar fast inte på categoryn , om man skriver #listResult istället det fungerar  
    if (category == "false") {
        $("#categ").hide()
    } else {
        $("#categ").show();
    };


})(jQuery);


