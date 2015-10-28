//console.log('Loading function');
var querystring = require('querystring');
var Elm = require('elm');

exports.handler = function(event, context) {
    var payload = querystring.parse(event.body);
    // Ignore everything from bots, including me
    if (payload.bot_id) return;

    //console.log('Received event:', JSON.stringify(payload, null, 2));

    var app = Elm.worker(Elm.Elambot.API, {modelJson: payload});

    app.ports.response.subscribe(function(message) {
        context.done(null, {"text": message});
    });
};
