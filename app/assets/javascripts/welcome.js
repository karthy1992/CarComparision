$(document).ready(function(){ 
  $("#models_select_1").change(function()
  { 
    $.ajax({
         type: "GET",// GET in place of POST
         url: "welcome/update_variants",
         data: { model_id : $('#models_select_1 :selected').val() },
         dataType: "json",
         success: function (data) {
           $select = $("#variants_select_1")
           console.log(data)
           $select.html(' ')
           if(data.length != 0)
           {
            $.each(data, function(ind, entry){
             $select.append('<option value="' + entry.id + '">' + entry.name + '</option>');
            })
           }  
         },
         error: function (){
            window.alert("something wrong!");
         }
    });
  })
})


$(document).ready(function(){ 
  $(document).on ('change', '#models_select_2' , function()
  { 
    $.ajax({
         type: "GET",// GET in place of POST
         url: "welcome/update_variants",
         data: { model_id : $('#models_select_2 :selected').val() },
         dataType: "json",
         success: function (data) {
           $select = $("#variants_select_2")
           console.log(data)
           $select.html(' ')
           if(data.length != 0)
           {
            $.each(data, function(ind, entry){
             $select.append('<option value="' + entry.id + '">' + entry.name + '</option>');
            })
           }  
         },
         error: function (){
            window.alert("something wrong!");
         }
    });
  })
})



$(document).ready( function ()
{
  $("#Add_another").click( function()
  {
    $.ajax(
    {
      type: "GET",
      url: "welcome/getform",
      dataType: "html",
      success: function(data) 
      {
        $("#identification").append(data)
      }
    }
      );
    } )
  }
    )

