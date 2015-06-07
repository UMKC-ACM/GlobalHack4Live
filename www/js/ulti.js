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
  getTweets("apple",10,"popular");
}
function getTweets(tag,count,type){
    var url = "http://104.236.78.214:5001/getTweets?tag="+tag+"&count="+count+"&type="+type;
    jQuery.get(url, function(data, status){
      tweets=data;
      fill_view();
      console.log("Data: " + data + "\nStatus: " + status);
    });
}
function fill_view(){
    $class("section").innerHTML = "";
    var html="<div class='collection'>";
    console.log(tweets);
    for(var i=0;i<tweets["statuses"].length;i++){
        html+="<a href='#!' class='collection-item'>";
        html+=tweets["statuses"][i]["text"];
        html+="</a>";
    }
    html+="</div>";
    $id("tweets-list").innerHTML = html;
}
