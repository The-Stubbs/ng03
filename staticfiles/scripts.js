function $(element) {
    
    if (arguments.length > 1) {
        for (var i = 0, elements = [], length = arguments.length; i < length; i++)
            elements.push($(arguments[i]));
        return elements;
    }

    if (typeof element == 'string') return document.getElementById(element);
    
    return element;
}