var selectedText;

var selectionEndTimeout = null;

// bind selection change event to my function
document.onselectionchange = userSelectionChanged;

function userSelectionChanged() {
    // wait 500 ms after the last selection change event
    if (selectionEndTimeout) {
        clearTimeout(selectionEndTimeout);
        $('.log ol').append('<li>User Selection Changed</li>');
        // scroll to bottom of the div
        $('.log').scrollTop($('.log ol').height());
    }
    selectionEndTimeout = setTimeout(function () {
        $(window).trigger('selectionEnd');
    }, 500);
}


// helper function
function getSelectionText() {
    var text = "";
    if (window.getSelection) {
        text = window.getSelection().toString();
    } else if (document.selection && document.selection.type != "Control") {
        text = document.selection.createRange().text;
    }
    return text;
}


function showSelectedText(){
    alert(selectedText);
}

(function(){

    // the minimum version of jQuery we want
    var v = "1.3.2";

    // check for jQuery. if it exists, verify it's not too old.
    if (window.jQuery === undefined || window.jQuery.fn.jquery < v) {
        var done = false;
        var script = document.createElement("script");
        script.src = "https://apps.bdimg.com/libs/jquery/" + v + "/jquery.min.js";
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
        $(window).bind('selectionEnd', function () {
            // reset selection timeout
            selectionEndTimeout = null;

            // TODO: Do your cool stuff here........

            // get user selection
            selectedText = getSelectionText();
            // if the selection is not empty show it :)
            if(selectedText != ''){
                // scroll to bottom of the div
            }
        });
        
        (window.myBookmarklet = function() {
            $("body").append("\
            <div id='wikiframe'>\
                <div id='wikiframe_veil' style=''>\
                    <p><img src=\"http://icons.iconarchive.com/icons/martz90/circle-addon1/128/text-plus-icon.png\" onClick=\"showSelectedText()\"></p>\
                </div>\
                <style type='text/css'>\
                    #wikiframe_veil { display: block; position: fixed; width: 50; height: 50; top: 0; left: 0; background-color: rgba(255,255,255,.25); cursor: pointer; z-index: 900; }\
                    //#wikiframe_veil p { color: black; font: normal normal bold 20px/20px Helvetica, sans-serif; position: absolute; top: 50%; left: 50%; width: 10em; margin: -10px auto 0 -5em; text-align: center; }\
                </style>\
            </div>");
        })();
    }

})();
