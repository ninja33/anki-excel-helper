function getSelText() {
    var s = '';
    if (window.getSelection) {
        s = window.getSelection();
    } else if (document.getSelection) {
        s = document.getSelection();
    } else if (document.selection) {
        s = document.selection.createRange().text;
    }
    return s;
}

function selectText()
{
    var s = "";
    s = getSelText().toString();
    alert("Text : [" + s + "] was selected");
}

(function(){

    // the minimum version of jQuery we want
    var v = "1.3.2";

    // check for jQuery. if it exists, verify it's not too old.
    if (window.jQuery === undefined || window.jQuery.fn.jquery < v) {
        var done = false;
        var script = document.createElement("script");
        script.src = "https://ajax.googleapis.com/ajax/libs/jquery/" + v + "/jquery.min.js";
        script.onload = script.onreadystatechange = function(){
            if (!done && (!this.readyState || this.readyState == "loaded" || this.readyState == "complete")) {
                done = true;
                initMyBookmarklet();
            }
        };
        document.getElementsByTagName("head")[0].appendChild(script);
    } else {
        initMyBookmarklet();
    }
    
    function initMyBookmarklet() {
        (window.myBookmarklet = function() {
            $("body").append("\
            <div id='wikiframe'>\
                <div id='wikiframe_veil' style=''>\
                    <p><img src=\"http://icons.iconarchive.com/icons/martz90/circle-addon1/128/text-plus-icon.png\" onClick=\"selectText()\"></p>\
                </div>\
                <style type='text/css'>\
                    #wikiframe_veil { display: block; position: fixed; width: 50; height: 50; top: 0; left: 0; background-color: rgba(255,255,255,.25); cursor: pointer; z-index: 900; }\
                    //#wikiframe_veil p { color: black; font: normal normal bold 20px/20px Helvetica, sans-serif; position: absolute; top: 50%; left: 50%; width: 10em; margin: -10px auto 0 -5em; text-align: center; }\
                </style>\
            </div>");
        })();
    }

})();
