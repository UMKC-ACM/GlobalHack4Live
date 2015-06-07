

function jsonString(){
  
  var myAnnotation = anno.getAnnotations();
  console.log(myAnnotation[0].text);
  console.log(JSON.stringify(myAnnotation));

}
