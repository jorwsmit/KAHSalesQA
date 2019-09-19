// Function to re-disable all the picklists on selection
        function disableAllPicklists() {
            
            $('.addDisabled').each(function() {
                
                $(this).attr('disabled', 'disabled');
            });
        }
        
        // Make all the select Options disabled on page load
        window.onload = function onInitialize() {
            
            $('.addDisabled').each(function() {
                
                $(this).attr('disabled', 'disabled');
            });
            
        }
        
		// Function to make the dependent picklist disabled based on the selections
        function picklistValUpdated(changedPicklistVal, picklistIds) {
        
            var picklistIdsCollection = picklistIds.split(',');
            
            // If the picklist is updated to None Selected option, dependent picklists will become disabled and will be blanked out 
            if(changedPicklistVal == '') {
                
                $('#' + picklistIdsCollection[0]).find("select").attr('disabled', 'disabled');
                $('#' + picklistIdsCollection[0]).find("select").text('');
            }
            
            // Update all the indirect descendents disabled
            for(var index = 1; index < picklistIdsCollection.length; index++) {
            
                $('#' + picklistIdsCollection[index]).find("select").attr('disabled', 'disabled');
            }
        }
        
        // Function to update the totals for Rows/Cols when the input fields are updated
        function changeTotals(cellId, classToRefer, rowId) {
            
            var totalColHours = 0;
            var totalRowHours = 0;
            var allTotals = 0;
            
            // Capture all the column data
            $( '.' + classToRefer ).each(function( index ) {
                if($( this ).val() == ''){
                $( this ).val(0);
                }
                totalColHours += parseFloat($( this ).val());
            });
            var res;
             if (!isNaN(totalColHours)) {
             	var n = totalColHours < 0 ? true : false,
                 a = (n ? totalColHours * -1 : parseFloat(totalColHours)).toFixed(1).toString().split("."),
                 b = a[0].split("").reverse().join("").replace(/.{3,3}/g, "$&,").replace(/\,$/, "").split("").reverse().join("");
             
            	res  =   (n ? "(" : "") + b + "." + a[1] + (n ? ")" : "");
            }
            else {
            	res = '';
			}
			//$('#' + cellId).text(res); 
			$('#' + cellId).children('span').html(res);
            $('#' + cellId).children('input').val(totalColHours);
			
			// Capture all the totals of hours assigned
			$( '.rowTotals' ).each(function( index ) {
            	var MyString=($( this ).text());
            	MyString = MyString.replace(/[, ]+/g, '')
            	allTotals += parseFloat(MyString);
            });
                     
            var resultTotal;
             if (!isNaN(allTotals)) {
             	var n = allTotals < 0 ? true : false,
                a = (n ? allTotals * -1 : parseFloat(allTotals)).toFixed(1).toString().split("."),
                b = a[0].split("").reverse().join("").replace(/.{3,3}/g, "$&,").replace(/\,$/, "").split("").reverse().join("");
             
            	resultTotal  =   (n ? "(" : "") + b + "." + a[1] + (n ? ")" : "");
             }
             else {
             	resultTotal = '';
             }
           	 // $('#totalAssignedHours').text(resultTotal);
             $('#totalAssignedHours').children('span').html(resultTotal);
             $('#totalAssignedHours').children('input').val(allTotals);
            
             // Capture all the totals for the rows
             $('#' + rowId).find("input").each(function( index ) {
            
            	if(($( this ).hasClass("inputtextforaTotal"))){
            	}
            	else{
	            	if($( this ).val() == ''){
	                	$( this ).val(0);
                }
                totalRowHours += parseFloat($( this ).val());
                }
                
            });
            var result;
             if (!isNaN(totalRowHours)) {
             	var n = totalRowHours < 0 ? true : false,
                a = (n ? totalRowHours * -1 : parseFloat(totalRowHours)).toFixed(1).toString().split("."),
                b = a[0].split("").reverse().join("").replace(/.{3,3}/g, "$&,").replace(/\,$/, "").split("").reverse().join("");
             
            	result  =   (n ? "(" : "") + b + "." + a[1] + (n ? ")" : "");
             }
             else {
             	result = '';
             }
             $('#rowTotal' + rowId).children('span').html(result);
             $('#rowTotal' + rowId).children('input').val(totalRowHours);
             // $('#rowTotal' + rowId).text(result);
        }
        
      	// Function to update the totals for Rows/Cols when the input fields are updated
        function changeTotalsRev(cellId, classToRefer, rowId) {
            
            var totalColHours = 0;
            var totalRowHours = 0;
            var allTotals = 0;
            
            // Capture all the column data
            $( '.' + classToRefer ).each(function( index ) {
                if($( this ).val() == ''){
                	$( this ).val(0);
                }
                totalColHours += parseFloat($( this ).val());
            });
            
            var res;
            if (!isNaN(totalColHours)) {
            	var n = totalColHours < 0 ? true : false,
                a = (n ? totalColHours * -1 : parseFloat(totalColHours)).toFixed(2).toString().split("."),
                b = a[0].split("").reverse().join("").replace(/.{3,3}/g, "$&,").replace(/\,$/, "").split("").reverse().join("");
             
            	res  =   (n ? "(" : "") + "$" + b + "." + a[1] + (n ? ")" : "");
            }
            else {
            	res = '';
            }
            //$('#' + cellId).text(res); 
			$('#' + cellId).children('span').html(res);
            $('#' + cellId).children('input').val(totalColHours);
            
            // Capture all the totals of hours assigned
            $( '.rowTotalsRev' ).each(function( index ) {
	            var MyString=($( this ).text());
	            if(MyString.indexOf('$') >= 0)
	            {
	            	MyString = MyString.replace('$','');
	            }
	            MyString = MyString.replace(/[, ]+/g, '')
	            allTotals += parseFloat(MyString);
            });
            var resultTotal;
            if (!isNaN(allTotals)) {
            	var n = allTotals < 0 ? true : false,
            	a = (n ? allTotals * -1 : parseFloat(allTotals)).toFixed(2).toString().split("."),
            	b = a[0].split("").reverse().join("").replace(/.{3,3}/g, "$&,").replace(/\,$/, "").split("").reverse().join("");
             
            	resultTotal  =   (n ? "(" : "") + "$" + b + "." + a[1] + (n ? ")" : "");
            }
            else {
            	resultTotal = '';
            }
            // $('#totalAssignedHoursRev').text(resultTotal);
            $('#totalAssignedHoursRev').children('span').html(resultTotal);
            $('#totalAssignedHoursRev').children('input').val(allTotals);
            
            // Capture all the totals for the rows
            $('#revenueRow' + rowId).find("input").each(function( index ) {
            	
            	if(($( this ).hasClass("inputtextforaTotal"))) {
            	}
            	else{
	            	if($( this ).val() == ''){
	                	$( this ).val(0);
                }
                totalRowHours += parseFloat($( this ).val());
                }
                
            });
            var result;
            if (!isNaN(totalRowHours)) {
           		var n = totalRowHours < 0 ? true : false,
                a = (n ? totalRowHours * -1 : parseFloat(totalRowHours)).toFixed(2).toString().split("."),
                b = a[0].split("").reverse().join("").replace(/.{3,3}/g, "$&,").replace(/\,$/, "").split("").reverse().join("");
             
            	result  =   (n ? "(" : "") + "$" + b + "." + a[1] + (n ? ")" : "");
            }
            else {
            	result = '';
            }
            // $('#rowTotalrevenueRow' + rowId).text(result);
            $('#rowTotalrevenueRow' + rowId).children('span').html(result);
            $('#rowTotalrevenueRow' + rowId).children('input').val(totalRowHours);
		}
        
		function dollarFormat(val)	{
        	if (!isNaN(val)) {
            	var n = val < 0 ? true : false,
            	a = (n ? val * -1 : parseFloat(val)).toFixed(2).toString().split("."),
            	b = a[0].split("").reverse().join("").replace(/.{3,3}/g, "$&,").replace(/\,$/, "").split("").reverse().join("");
             	return((n ? "(" : "") + "$" + b + "." + a[1] + (n ? ")" : ""));
            }
          	else
            	return false;
		}
       
		function dollarFormatNumber(val)	{
			if (!isNaN(val)) {
	            var n = val < 0 ? true : false,
	            a = (n ? val * -1 : parseFloat(val)).toFixed(1).toString().split("."),
	            b = a[0].split("").reverse().join("").replace(/.{3,3}/g, "$&,").replace(/\,$/, "").split("").reverse().join("");
	            return((n ? "(" : "") + b + "." + a[1] + (n ? ")" : ""));
          	}
          	else
            	return false;
		}
       
        // Function to Allow only Numbers in the input Fields
        function isNumberKey(evt)	{
            var charCode = (evt.which) ? evt.which : event.keyCode;
            
            if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            var isTrue = checkingstring(evt);
            return isTrue;
        } 
        function revPanelrerender(value)	{
        
        	if(value == 'rev'){
        		revPanelrerenderAF();
        	}
        	if(value == 'adm') {
        		admissionPanelrerenderAF();
        	}
        }
        
        // Function to Allow only Numbers in the input Fields of Revenue and also to allow 10 integers and 2 decimal points
   		function checkingstring(inputElem) {
			
			var target = inputElem.target || inputElem.srcElement;
   			var strText = target.value;
   			var charCode = (inputElem.which) ? inputElem.which : event.keyCode;
   			
            if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            
   			if(charCode ==46){
   				if(strText.length > 10)
   					return false;
   				else if(strText.indexOf('.')!=-1)
   					return false;	
   			}
   			
   			else if(strText.indexOf('.')!=-1) {
				
				if(charCode ==46){
					return false;
				}
   				var words = strText.split(".")[0];
   				var words1 = strText.split(".")[1];
   				if(words.length > 10)
   					return false;
   				
   				if(words1.length > 1)
   					return false;
   			}
   			else {
   				if(strText.length >= 10 && (charCode != 46)) {
   					return false;
   				}
   			}
   			return true;
		}
		
		// Function to Allow only Numbers in the input Fields of Admission and also to allow 4 integers and 1 decimal points
		function checkingstringAdm(inputElem) {

			var target = inputElem.target || inputElem.srcElement;
			var strText = target.value;
			var charCode = (inputElem.which) ? inputElem.which : event.keyCode;
			 
			/*if(strText.length <= 4) {
			 
				if (charCode > 31 && (charCode < 48 || charCode > 57)){
				  
					return false;
				}
			  
				if(charCode ==46) {
					if(strText.length > 4)
						return false;
				}
			  
				else if(strText.indexOf('.')!=-1) {
				
					var words = strText.split(".")[0];
					var words1 = strText.split(".")[1];
			   
					if(words.length > 4)
						return false;
			   
					if(words1.length > 0)
						return false;
				}
				else {
					if(strText.length >= 4 && (charCode != 46)) {
						return false;
					}
				}
			}*/
			if(strText.match(/^\d{0,3}(\.\d{0})?$/)) {
				return true;
			}
			else {
			 
				return false;
			}
			 
			return true;
		}
				
		function showConfirmation(isSuccess)	{
		
			$(function($) {
				if(isSuccess == true)
					$('#SaveMessage').html('Sales Performance Inserted/Updated Successfully.');
				else
					$('#SaveMessage').html('Could not save the record');
					$('#Showfadding').delay(1).fadeIn();
					$('#Showfadding').delay(3000).fadeOut();
			});
			
			$('.modal').addClass('displayNone');
			$('.modal').removeClass('displayBlock');
		} 
		
		function stoploading()	{
		
			$('.modal').addClass('displayNone'); 
			$('.modal').removeClass('displayBlock');
		}
	    
	    function fetchDependentRoles(selectedUser, elementId) {
		
            var currentRowIndex = parseInt(elementId.split('_')[1]);
            var i = currentRowIndex + 1;
            var strToBeusedForFiltering = '';
            
            //Remove all rows when top picklist is set to none.
            if(selectedUser == '')// && elementId == 'row_0'
            {
                //Remove all picklist rows below selected row index.
                $('.rowContainingPicklist').each(function(){
                    if(parseInt($(this).attr('Id').split('_')[1]) > currentRowIndex)
                        $(this).remove();
                });
                
                //Get Parent Value to be used for filtering table data. 
                if(currentRowIndex > 1) {
                    parentRowIndex = currentRowIndex - 1;  
                    strToBeusedForFiltering = $("#pickVal_"+parentRowIndex).val();
                }
               	else if(currentRowIndex == 0 || currentRowIndex == 1) {
                    strToBeusedForFiltering = $("#pickVal_0").val();
                    //Hide the table
                }
            }
            else if(selectedUser != '') {
                $('.rowContainingPicklist').each(function(){
                    if(parseInt($(this).attr('Id').split('_')[1]) > currentRowIndex)
                        $(this).remove();
                });
                
                strToBeusedForFiltering = selectedUser;
            }
            
            var usersToDisplayInGrid = '';
			
            TBN_AssociateTargetAssignmentController.fetchUserRoles(selectedUser, i,
				
				function(result, event) { 
				
					if(result.length > 0) {
						
						var siblingHTML = result.split('#$#')[0];
						usersToDisplayInGrid = result.split('#$#')[1];
						
						if(usersToDisplayInGrid.length > 0)
							refreshActionFunction(usersToDisplayInGrid);
						else
							refreshActionFunction(strToBeusedForFiltering);
						
						$('#table1').append(siblingHTML);
					}
				},
				{escape: false}
			);

			setTimeout('disablePaste();', 1000);
        }
			
		function disablePaste() {
			
			$('body').bind('paste', function(e) {
			
				e.preventDefault();
			});
		}	