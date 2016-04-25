//fixture data
/*
var lines = [{
    "id": 1,
    "position": 0,
    "content_type": "Non-Dialogue",
    "content_text": "ACT ONE",
    "color": null,
    "visibility": false,
    "created_at": "2014-12-23T05:48:54.228Z",
    "updated_at": "2014-12-23T05:48:54.228Z"
}, {
    "id": 2,
    "position": 1,
    "content_type": "Non-Dialogue",
    "content_text": "Scene 1 - an office - mid-meeting - tense silence.",
    "color": null,
    "visibility": false,
    "created_at": "2014-12-23T05:48:54.246Z",
    "updated_at": "2014-12-23T05:48:54.246Z"
}, {
    "id": 3,
    "position": 2,
    "content_type": "Non-Dialogue",
    "content_text": "Two men. A desk between them. SHAG - 40’s - stands on the power-deficit side of the desk.  ",
    "color": null,
    "visibility": false,
    "created_at": "2014-12-23T05:48:54.281Z",
    "updated_at": "2014-12-23T05:48:54.281Z"
}, {
    "id": 4,
    "position": 4,
    "content_type": "Dialogue",
    "content_text": "Shag: Why me?",
    "color": null,
    "visibility": true,
    "created_at": "2014-12-23T05:48:54.301Z",
    "updated_at": "2014-12-23T05:48:54.301Z"
}, {
    "id": 5,
    "position": 4,
    "content_type": "Non-Dialogue",
    "content_text": "CECIL - 40’s - in spite of a permanently bent body and short stature, sits on the power surplus side of the desk. ",
    "color": null,
    "visibility": false,
    "created_at": "2014-12-23T05:48:54.325Z",
    "updated_at": "2014-12-23T05:48:54.325Z"
}, {
    "id": 6,
    "position": 6,
    "content_type": "Dialogue",
    "content_text": "CECIL: It wasn’t that others weren’t considered. ",
    "color": null,
    "visibility": true,
    "created_at": "2014-12-23T05:48:54.344Z",
    "updated_at": "2014-12-23T05:48:54.344Z"
}, {
    "id": 7,
    "position": 6,
    "content_type": "Non-Dialogue",
    "content_text": "On the table - a manuscript. Cecil moves the manuscript towards Shag. Shag does not take it. ",
    "color": null,
    "visibility": false,
    "created_at": "2014-12-23T05:48:54.363Z",
    "updated_at": "2014-12-23T05:48:54.363Z"
}, {
    "id": 8,
    "position": 8,
    "content_type": "Dialogue",
    "content_text": "Shag: I can’t make the decision.",
    "color": null,
    "visibility": true,
    "created_at": "2014-12-23T05:48:54.385Z",
    "updated_at": "2014-12-23T05:48:54.385Z"
}, {
    "id": 9,
    "position": 9,
    "content_type": "Dialogue",
    "content_text": "CECIL: Why not?",
    "color": null,
    "visibility": true,
    "created_at": "2014-12-23T05:48:54.406Z",
    "updated_at": "2014-12-23T05:48:54.406Z"
}, {
    "id": 10,
    "position": 10,
    "content_type": "Dialogue",
    "content_text": "SHAG: We’re a cooperative venture.",
    "color": null,
    "visibility": true,
    "created_at": "2014-12-23T05:48:54.426Z",
    "updated_at": "2014-12-23T05:48:54.426Z"
}, {
    "id": 11,
    "position": 11,
    "content_type": "Dialogue",
    "content_text": "CECIL: Who’s in charge?",
    "color": null,
    "visibility": true,
    "created_at": "2014-12-23T05:48:54.446Z",
    "updated_at": "2014-12-23T05:48:54.446Z"
}, {
    "id": 12,
    "position": 12,
    "content_type": "Dialogue",
    "content_text": "SHAG: We all share equally in the income and responsibilities of the theater...We’re a cooperative venture.",
    "color": null,
    "visibility": true,
    "created_at": "2014-12-23T05:48:54.466Z",
    "updated_at": "2014-12-23T05:48:54.466Z"
}, {
    "id": 13,
    "position": 13,
    "content_type": "Dialogue",
    "content_text": "CECIL: Who’s in charge?",
    "color": null,
    "visibility": true,
    "created_at": "2014-12-23T05:48:54.490Z",
    "updated_at": "2014-12-23T05:48:54.490Z"
}, {
    "id": 14,
    "position": 14,
    "content_type": "Dialogue",
    "content_text": "SHAG: Richard.",
    "color": null,
    "visibility": true,
    "created_at": "2014-12-23T05:48:54.511Z",
    "updated_at": "2014-12-23T05:48:54.511Z"
}, {
    "id": 15,
    "position": 14,
    "content_type": "Non-Dialogue",
    "content_text": "Money is placed on the table. ",
    "color": null,
    "visibility": false,
    "created_at": "2014-12-23T05:48:54.531Z",
    "updated_at": "2014-12-23T05:48:54.531Z"
}, {
    "id": 16,
    "position": 16,
    "content_type": "Dialogue",
    "content_text": "CECIL: This will take care of Richard...One week.",
    "color": null,
    "visibility": true,
    "created_at": "2014-12-23T05:48:54.551Z",
    "updated_at": "2014-12-23T05:48:54.551Z"
}, {
    "id": 17,
    "position": 17,
    "content_type": "Dialogue",
    "content_text": "SHAG: One?",
    "color": null,
    "visibility": true,
    "created_at": "2014-12-23T05:48:54.574Z",
    "updated_at": "2014-12-23T05:48:54.574Z"
}, {
    "id": 18,
    "position": 18,
    "content_type": "Dialogue",
    "content_text": "CECIL: He said/she said. Enter/exit. Drums/trumpets. How long can it take?",
    "color": null,
    "visibility": true,
    "created_at": "2014-12-23T05:48:54.595Z",
    "updated_at": "2014-12-23T05:48:54.595Z"
}, {
    "id": 19,
    "position": 18,
    "content_type": "Non-Dialogue",
    "content_text": "(then, leaving)",
    "color": null,
    "visibility": false,
    "created_at": "2014-12-23T05:48:54.614Z",
    "updated_at": "2014-12-23T05:48:54.614Z"
}, {
    "id": 20,
    "position": 20,
    "content_type": "Dialogue",
    "content_text": "CECIL: You have one week to “dialogue” this.",
    "color": null,
    "visibility": true,
    "created_at": "2014-12-23T05:48:54.640Z",
    "updated_at": "2014-12-23T05:48:54.640Z"
}, {
    "id": 21,
    "position": 21,
    "content_type": "Dialogue",
    "content_text": "SHAG: We’re already working on a new play. ",
    "color": null,
    "visibility": true,
    "created_at": "2014-12-23T05:48:54.662Z",
    "updated_at": "2014-12-23T05:48:54.662Z"
}, {
    "id": 22,
    "position": 22,
    "content_type": "Dialogue",
    "content_text": "CECIL: About?",
    "color": null,
    "visibility": true,
    "created_at": "2014-12-23T05:48:54.681Z",
    "updated_at": "2014-12-23T05:48:54.681Z"
}, {
    "id": 23,
    "position": 23,
    "content_type": "Dialogue",
    "content_text": "SHAG: A king.",
    "color": null,
    "visibility": true,
    "created_at": "2014-12-23T05:48:54.702Z",
    "updated_at": "2014-12-23T05:48:54.702Z"
}, {
    "id": 24,
    "position": 23,
    "content_type": "Non-Dialogue",
    "content_text": "Cecil, the prime minister of England, takes a profession interest in this.",
    "color": null,
    "visibility": false,
    "created_at": "2014-12-23T05:48:54.726Z",
    "updated_at": "2014-12-23T05:48:54.726Z"
}, {
    "id": 25,
    "position": 25,
    "content_type": "Dialogue",
    "content_text": "CECIL: How does he die?",
    "color": null,
    "visibility": true,
    "created_at": "2014-12-23T05:48:54.749Z",
    "updated_at": "2014-12-23T05:48:54.749Z"
}, {
    "id": 26,
    "position": 26,
    "content_type": "Dialogue",
    "content_text": "SHAG: What makes you think he dies?",
    "color": null,
    "visibility": true,
    "created_at": "2014-12-23T05:48:54.823Z",
    "updated_at": "2014-12-23T05:48:54.823Z"
}, {
    "id": 27,
    "position": 26,
    "content_type": "Non-Dialogue",
    "content_text": "(amused admiration)",
    "color": null,
    "visibility": false,
    "created_at": "2014-12-23T05:48:54.841Z",
    "updated_at": "2014-12-23T05:48:54.841Z"
}, {
    "id": 28,
    "position": 28,
    "content_type": "Dialogue",
    "content_text": "CeCIL: You’ve killed more kings than any man alive. Your brain is a graveyard for royalty.",
    "color": null,
    "visibility": true,
    "created_at": "2014-12-23T05:48:54.859Z",
    "updated_at": "2014-12-23T05:48:54.859Z"
}, {
    "id": 29,
    "position": 29,
    "content_type": "Dialogue",
    "content_text": "SHAG: This one dies of a broken heart. ",
    "color": null,
    "visibility": true,
    "created_at": "2014-12-23T05:48:54.879Z",
    "updated_at": "2014-12-23T05:48:54.879Z"
}];
*/
