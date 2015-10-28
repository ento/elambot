(function() {
    var window =
        { setTimeout: setTimeout
        };
    var requestAnimationFrame = function(cb) { setTimeout(cb, 1000/60); }
