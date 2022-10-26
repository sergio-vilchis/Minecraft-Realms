var express = require("express");
var https = require("https");
const cors = require('cors');

var app = express();
app.use(cors())

app.listen(3000, () => {
 console.log("Server running on port 3000");
});
app.get("/worlds", (req, result, next) => {
    var get_options = {
        host: 'pocket.realms.minecraft.net',
        port: '443',
        path: '/worlds',
        method: 'GET',
        headers: req.headers,
        rejectUnauthorized: false
    };

    var get_worlds = https.request(get_options, function(res) {
        res.setEncoding('utf8');
        res.on('data', function (chunk) {
            result.send(chunk);
        });
    });
  
    get_worlds.end();
});

app.get("/worlds/:id", (req, result, next) => {
    var id = req.params.id;
    var get_options = {
        host: 'pocket.realms.minecraft.net',
        port: '443',
        path: '/worlds/'+id,
        method: 'GET',
        headers: req.headers,
        rejectUnauthorized: false
    };

    var get_worlds = https.request(get_options, function(res) {
        res.setEncoding('utf8');
        res.on('data', function (chunk) {
            result.send(chunk);
        });
    });
  
    get_worlds.end();
});

app.put("/worlds/:serverId/slot/:slotId", (req, result, next) => {
    var serverId = req.params.serverId;
    var slotId = req.params.slotId;
    var put_options = {
        host: 'pocket.realms.minecraft.net',
        port: '443',
        path: '/worlds/'+serverId+"/slot/"+slotId,
        method: 'PUT',
        headers: req.headers,
        rejectUnauthorized: false
    };

    var update_slot = https.request(put_options, function(res) {
        if (res.statusCode != 200) {
            console.log(res.statusCode);
            result.send(false);
        }
        res.on('data', function (chunk) {
            result.send(chunk);
        });
    });

    update_slot.on('error', (e) => {
        console.log(e);
    });

    update_slot.end();
});