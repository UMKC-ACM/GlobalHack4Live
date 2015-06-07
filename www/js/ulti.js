window.twttr = (function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0],
    t = window.twttr || {};
  if (d.getElementById(id)) return t;
  js = d.createElement(s);
  js.id = id;
  js.src = "https://platform.twitter.com/widgets.js";
  fjs.parentNode.insertBefore(js, fjs);

  t._e = [];
  t.ready = function(f) {
    t._e.push(f);
  };

  return t;
}(document, "script", "twitter-wjs"));

function switchChange(element){
  console.log(element.checked);
  var current = element.checked
  enableTwitter(current);

}
function enableTwitter(clause){
  if (clause){
    //show twitter
  }
  else{
    //hide twitter
    $class('nothidden')[0].className="sectionhidden";
  }
}
function loadIMG(event){
  if (event.keyCode == 13 ){
  var link = $id('imglinkField').value;
  $id('annot').src = link;
  }
}
function createTweetfromID(position,id,callback){
  var html;
  jQuery.ajax({
      url: 'https://api.twitter.com/1/statuses/oembed.json?url=https://twitter.com/Interior/status/'+id,
      type: 'GET',
      crossDomain: true,
      dataType: 'jsonp',
      success: function(result) {
        html=result['html'];
        callback(position,html);
      },
      error: function() { console.log('Failed!'); }

  });

}

var tweets={};
/*
{
  "statuses": [
    {
      "text": "The Foolish Mortals #freebandnames",
      "user": {
        "screen_name": "Omnitarian"
      }
    },
    {
      "text": "The Foolish Mortals #freebandnames",
      "user": {
        "screen_name": "Omnitarian"
      }
    },
    {
      "text": "The Foolish Mortals #freebandnames",
      "user": {
        "screen_name": "Omnitarian"
      }
    },
    {
      "text": "The Foolish Mortals #freebandnames",
      "user": {
        "screen_name": "Omnitarian"
      }
    }
  ]
};
*/
function $id(id){
    return document.getElementById(id);
}
function $class(classes){
    return document.getElementsByClassName(classes);
}

function initialize(){
  //$id('TwitterContainer').style.display = hidden;
  getTweets("warcraft",5,"popular");
}

function getTweets(tag,count,type){
    var url = "http://104.236.78.214:5001/api/getTweets?tag="+tag+"&count="+count+"&type="+type;
    jQuery.get(url, function(data, status){
      tweets=data;
      fill_view();
      console.log("Data: " + data + "\nStatus: " + status);

    });
}
function fillTextArea(element){
  $class('annotorious-editor-text goog-textarea')[0].value = element.nextSibling.innerHTML;
}

function fill_view(){
    var tempHTML;
    var list = $id("tweets-list");
    list.innerHTML = "";



    console.log(tweets);
    //construct structure
    tempHTML+="<div class='collection'>";
    for(var i=0;i<tweets["statuses"].length;i++){
      tempHTML+="<a href='#!' class='waves-effect waves-teal btn-flat' onclick='fillTextArea(this)' style='float:right;top:50px'>GET LINK</a>";
      tempHTML+="<div class='collection-item' style='display: block; -webkit-transition: 0.25s;-moz-transition: 0.25s;-o-transition: 0.25s;-ms-transition: 0.25s;transition: 0.25s;color: #26a69a;'></div>";
    }
    tempHTML+="</div>";
    list.innerHTML = tempHTML;

    //inject real tweets
    for(var i=0;i<tweets["statuses"].length;i++){
        var id = tweets["statuses"][i]['id_str'];
        console.log(id);
        this.createTweetfromID(i,id,function(pos,html){

          this.$class('collection-item')[pos].innerHTML = html;
        });
    }
    }
        //html+="<a href='#!' class='collection-item'>";
        //html+=tweets["statuses"][i]["text"];
        //html+="</a>";
