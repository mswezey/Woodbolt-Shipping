function remove_fields(link) {  
    $(link).prev("input[type=hidden]").val("1");  
    $(link).closest(".fields").hide();  
}  
   
function add_fields(link, association, content) {  
    var new_id = new Date().getTime();  
    var regexp = new RegExp("new_" + association, "g");  
    $(link).before(content.replace(regexp, new_id));  
}

// pending 

function pendingHandleSelection(id) {
	alert('ID selected : ' + id);
}

// $('input[name=delivered_check]').live("change", function(){
// 	if($(this).is(":checked")){
// 		var rowId = $(this).parent().parent().attr("id");
// 		$(this).parent().parent().parent().parent().saveRow(rowId, true);
// 		var checkbox = $(this);
// 		$.ajax({
// 		   type: "GET",
// 		   url: "/shipments/"+ $(this).parent().parent().attr("id")+"/deliver.js",
// 		   success: function(){
// 				checkbox.parent().parent().hide();
// 				alert("Shipment status successfully changed to Delivered");
// 		   },
// 			error: function(xhr){
// 				alert(xhr.responseText);
// 				checkbox.attr('checked', false);
// 			}
// 		 });
// 	}
// });

$('.deliver').live("click", function(){
	var row = $(this).parent().parent();
	$(this).parent().parent().parent().parent().saveRow(row.attr("id"), true);
	$.ajax({
	   type: "GET",
	   url: "/shipments/"+ row.attr("id")+"/deliver.js",
	   success: function(){
			row.hide();
			alert("Shipment status successfully changed to Delivered");
	   },
		error: function(xhr){
			alert(xhr.responseText);
			row.parent().parent().editRow(row.attr("id"), true);
		}
	 });
});

// $('input[name=invoiced_check]').live("change", function(){
// 	if($(this).is(":checked")){
// 		var checkbox = $(this);
// 		$.ajax({
// 		   type: "GET",
// 		   url: "/shipments/"+ $(this).parent().parent().attr("id")+"/invoice.js",
// 		   success: function(){
// 				checkbox.parent().parent().hide();
// 				alert("Shipment status successfully changed to Invoiced");
// 		   },
// 			error: function(xhr){
// 				alert(xhr.responseText);
// 				checkbox.attr('checked', false);
// 			}
// 		 });
// 	}
// });

$('.invoice').live("click", function(){
		var row = $(this).parent().parent();
		$(this).parent().parent().parent().parent().saveRow(row.attr("id"), true);
		$.ajax({
		   type: "GET",
		   url: "/shipments/"+ row.attr("id")+"/invoice.js",
		   success: function(){
				row.hide();
				alert("Shipment status successfully changed to Invoiced");
		   },
			error: function(xhr){
				alert(xhr.responseText);
				row.parent().parent().editRow(row.attr("id"), true);
			}
		 });
});

$('input[name=has_credit]').live("change", function(){
	if($(this).is(":checked")){
		var checkbox = $(this);
		$.ajax({
		   type: "GET",
		   url: "/shipments/"+ $(this).parent().parent().attr("id")+"/credit.js",
		   success: function(){
				var r = confirm("Would you like to edit the credit information now?");
				if(r == true){
					window.location = '/credits';
				} else {
					return false;
				}
		   },
			error: function(xhr){
				alert(xhr.responseText);
				checkbox.attr('checked', false);
			}
		 });
	}
});

$('input[name=credits_applied]').live("change", function(){
	if($(this).is(":checked")){
		var checkbox = $(this);
		$.ajax({
		   type: "GET",
		   url: "/shipments/"+ $(this).parent().parent().attr("id")+"/credit_applied.js",
		   success: function(){
				alert("Shipment credits have been applied");
		   },
			error: function(xhr){
				alert(xhr.responseText);
				checkbox.attr('checked', false);
			}
		 });
	}
});