let profile = encodeURIComponent('User 1');
let deckName = encodeURIComponent('Default');
let typeName = encodeURIComponent('Antimoon');
let fieldWord = encodeURIComponent('expression');
let fieldSentence = encodeURIComponent('sentence');
let blockTags = ['LI', 'P', 'DIV', 'BODY'];
const enReg = /^[^\u4e00-\u9fa5]+$/i;
const numReg = /\d/;
    
function getBlock(node, deep) {
    if (blockTags.indexOf(node.nodeName.toUpperCase()) !== -1 || deep === 0) {
        return node;
    } else {
        return getBlock(node.parentElement, deep - 1);
    }
}

// autocut function
function autocutSentenceIfNeeded(word, sentence) {
    var autocut = true;
    var sentenceNum = 3;

    if (autocut && sentenceNum > 0) {
        let puncts = sentence.match(/[\.\?!;]/g) || [];
        let arr = sentence.split(/[\.\?!;]/).filter(s => s.trim() !== '').map((s, index) => s.trim() + `${puncts[index] || ''} `);
        let index = arr.findIndex(s => s.indexOf(word) !== -1);
        let left = Math.ceil((sentenceNum - 1) / 2);
        let start = index - left;
        let end = index + ((sentenceNum - 1) - left);

        if (start < 0) {
            start = 0;
            end = sentenceNum - 1;
        } else if (end > (arr.length - 1)) {
            end = arr.length - 1;

            if ((end - (sentenceNum -1)) < 0) {
                start = 0;
            } else {
                start = end - (sentenceNum - 1);
            }
        }

        return arr.slice(start, end + 1).join('');
    } else {
        return sentence;
    }
}

function getSentence(word, elem) {
    let wordContent = '';
    let upNum = 4;

    elem = getBlock(elem, upNum);

    if (elem !== document) {
        wordContent = elem.innerText;
    }

    return autocutSentenceIfNeeded(word, wordContent);
}

function changeAnkiLink(word, node){
    if (!word) {
        return;
    }

    if (word.length < 3 || numReg.test(word)) {
        return;
    }

    if (!enReg.test(word)) {
        return;
    }

    if (['INPUT', 'TEXTAREA'].indexOf(node.tagName) !== -1) {
        return;
    }

    var expression = encodeURIComponent(word);
    var sentence = encodeURIComponent(getSentence(word, node));

    var link = `anki://x-callback-url/addnote?profile=${profile}&type=${typeName}&deck=${deckName}&fld${fieldWord}=${expression}&fld${fieldSentence}=${sentence}`;
    document.getElementById("ankilink").href = link; 
    //alert(link);
}

function initMyBookmarklet() {
    document.addEventListener('selectionchange', function(event) {
        var selection = window.getSelection();
        var word = (selection.toString() || '').trim();
        var node = selection.getRangeAt(0).commonAncestorContainer 
        changeAnkiLink(word, node);
    },false);


    (window.myBookmarklet = function() {
        var elemDiv = document.createElement('div');
        elemDiv.innerHTML = "\
            <div id='ankiframe'>\
                <div id='ankiframe_veil' style=''>\
                    <a id='ankilink' href=\"anki://\"><img src=\"https://raw.githubusercontent.com/ninja33/anki-excel-helper/master/Java/plus_64.png\"></a>\
                </div>\
                <style type='text/css'>\
                    #ankiframe { float: right; }\
                    #ankiframe_veil { display: block; position: fixed; bottom: 10px; right: 10px; cursor: pointer; z-index: 900; }\
                </style>\
            </div>";
        document.body.appendChild(elemDiv);
    })();
        
}

(function(){
    initMyBookmarklet();
})();
