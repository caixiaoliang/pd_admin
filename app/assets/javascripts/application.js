// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks

//= require jquery_ujs
//= require turbolinks
//= require bootstrap.min
//= require holder.min
//= require cropbox
//= require_tree .

// file upload  start

var errorMessage=[];
var key;
function fileName(select){
  return $(select).val().split("\\").pop();
}

function pretreatmentFile(){
  displayFileName();
  clearError();
  if(!formatValidate()){
    displayErrors(errorMessage.join(","));
    $(".product_info_submit")[0].disabled=true;
  }
  else{
    $(".product_info_submit")[0].disabled=false;
  }
}

function displayFileName(){
  filename = fileName("#product_info_file")
  $(".filename").text(truncate(filename,8));
}

function clearFileNmae(){
  $(".filename").text("");
}

function truncate(str,lengthLimit){
  return str.length < lengthLimit ? str : str.slice(0,lengthLimit) + "...";
}


function formatValidate(){
  errorMessage=[];
  var filename = fileName("#product_info_file")
  suffix = filename.split(".").pop();

  gaccount = $('select[name="gaccount_id"]').val()

  if(suffix == "")
  {
    errorMessage.push("不能为空");
  }
  else if(suffix != "csv")
  {
    errorMessage.push("文件格式错误,只允许csv");
  }
  else if(gaccount == ""){
    errorMessage.push("请选择商品上传到的商户");
  }
  return errorMessage.length==0
}


function clearFileScope(){
  var file = $("#product_info_file");
  file.after(file.clone().val(""));
  file.remove();
}

function displayErrors(error){
  $("#upload-errors").text(error);
}
function clearError(){
  $("#upload-errors").text("");
}


$(function(){
  var oReq;
  var itv;

  var displayUploadProgress = function(){
    if(oReq.readyState == 4){
      if (oReq.status == 200) {
        console.log("success")
        alert("上传完成");
        // var data = JSON.parse(oReq.responseText);
        // key = data.key
        // askProgress();
        // itv = setInterval(askProgress,1000*3);
      }
      else {
        console.log("error");
      }
    }
  }

  askProgress = function(){
    var url = "/products_info/upload_progress"+"?key="+key;
    $.get(url,function(res){

      if(res.count)
      {
        var persentage = (res.count.completed_count/res.count.total_count).toFixed(2);
      }
      // console.log(res.count);
      // console.log(persentage);
      if(res.completed)
      {
        $("#upload-percentage").text("上传完成"+(persentage*100)+"%");
        setTimeout(function(){
          alert("上传完成");
          clearFileNmae();
          $(".percentage").addClass("hidden");
          $(".product_info_submit")[0].disabled=false;
          clearInterval(itv);
          clearFileScope();
        },1000);
      }
      else{
        $(".product_info_submit")[0].disabled=true;
        $(".percentage").removeClass("hidden")
        $("#upload-percentage").text("上传中... "+(persentage*100)+"%");
      }
    },"json");
  }

  $('#gaccount_id').change(() => {
    console.log($('#gaccount_id').val());
      if(formatValidate()){
        clearError();
        $(".product_info_submit")[0].disabled=false;
      }
    }
  )

  $(document).on("submit","#product_info_upload",function(event){
    event.preventDefault();
 
    if(formatValidate()){
      $(".product_info_submit")[0].disabled=false;
      submitFile();
    }
    else{
      displayErrors(errorMessage.join(","));
      $(".product_info_submit")[0].disabled=true;
    }
  })

  function submitFile(){
    var fd = new FormData();
    oReq = new XMLHttpRequest();
    fd.append('file',$('#product_info_file')[0].files[0]);
    fd.append('authenticity_token',$('input[name="authenticity_token"]').val());
    fd.append('gaccount_id',$('select[name="gaccount_id"]').val());
    oReq.onreadystatechange = displayUploadProgress;
    // oReq.open("POST", "/products_info/upload",true);
    oReq.open("POST", "/groupon_products/upload",true);
    oReq.send(fd);
  }

});
// file upload  end