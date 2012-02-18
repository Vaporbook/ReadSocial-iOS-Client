var RS = {
    loadParagraphsInView: function()
    {
        var paragraphs = document.querySelectorAll("p");
        RS.paragraphs = [];
        
        for (var i=0; i<paragraphs.length; ++i)
        {
            if (paragraphs[i].getBoundingClientRect().bottom<0)
            {
                continue;
            }
            
            else if (paragraphs[i].getBoundingClientRect().top > window.innerHeight)
            {
                break;
            }
            
            RS.paragraphs.push(paragraphs[i]);
        }
    },
    
    countParagraphsInView: function()
    {
        return RS.paragraphs.length;
    },
    
    paragraphAtIndex: function(i)
    {
        return RS.paragraphs[i];
    },
    
    indexAtSelection: function()
    {
        var p = window.getSelection().anchorNode.parentElement; //parentNode
        return RS.paragraphs.indexOf(p);
    },
    
    coordinatesForParagraphAtIndex: function(i)
    {
        var p    = RS.paragraphAtIndex(i),
            rect = p.getBoundingClientRect();
        return [
            rect.left,
            rect.top,
            rect.right-rect.left,
            rect.bottom-rect.top
        ].join(",");
    },
    
    refresh: function()
    {
        RS.loadParagraphsInView();
        window.location = "rs://reload";
    }
};

(function(){RS.loadParagraphsInView();document.addEventListener("scroll", RS.refresh);})()