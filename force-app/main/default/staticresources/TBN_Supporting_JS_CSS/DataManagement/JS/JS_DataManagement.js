	var j$ = jQuery.noConflict();
        var strToBeSaved = '';
        // Function to show all the fields in the referral and reassign tab if demographic view is selected.
        function DisplayAddressFields(isChecked, hasStopLoading, assignReassign) {
            
            try {
                
                var varAssign;
                var varTableId;
                var varTableHeaderId;
                if(assignReassign == 'assign'){
                
                    varAssign = 'tableFilterRow';
                    varTableId = 'referralsTableForSort';
                    varTableHeaderId = 'referralTableHeadders';
                }
                else if(assignReassign == 'reassign')  {  
                
                    varAssign = 'tableFilterRowReassign';
                    varTableId = 'reassignReferralTable';
                    varTableHeaderId = 'tableHeadRassign';
                }
                if(isChecked == true) {
                    
                    j$('.tablesorter-headerRow .clsHMS1').each(function() {
                        
                        j$('#'+varAssign).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                        j$('#'+varTableHeaderId).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                    }); 
                    
                    j$('.tablesorter-headerRow .clsHMS2').each(function() {
    
                        j$('#'+varAssign).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                        j$('#'+varTableHeaderId).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                    });
                    
                    j$('.tablesorter-headerRow .clsHMS').each(function() {
    
                        j$('#'+varAssign).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                        j$('#'+varTableHeaderId).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                    });
                    
                    j$('.tablesorter-headerRow .clsHMSIDs').each(function() {
    
                        j$('#'+varAssign).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                        j$('#'+varTableHeaderId).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                    });
                    
                    j$('.tableFilter').attr('class', 'tableFilter width100');
                    j$('.tableFilter[data-column="0"]').attr('class', 'tableFilter disabled');
                    j$('.tableFilter[data-column="1"]').attr('class', 'tableFilter width150');
                    j$('.tableFilter[data-column="3"]').attr('class', 'tableFilter 188px');
                    j$('.tableFilter[data-column="8"]').attr('class', 'tableFilter 110px');
                   /* j$('.tableFilter[data-column="1"]').attr('class', 'tableFilter width150');*/
                }
                var table = j$('.'+varTableId).DataTable();
 
                 table.columns( '.classAddress' ).visible( true ); 
                 table.columns( '.clsHMS2' ).visible( false );
                 table.columns( '.clsHMS1' ).visible( false );
                 table.columns( '.clsHMS' ).visible( false );
                 table.columns( '.clsHMSIDs' ).visible( false );
                 
                 j$('.tablesorter-headerRow .classAddress').each(function() {
                    
                    j$('#'+varAssign).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', '');
                    j$('#'+varTableHeaderId).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', '');
                });     
            }
            catch(err) {
                                    
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }
        }
        
		// Function to show all the fields in the referral and reassign tab if Home health view is selected.
        function DisplayHmsView1(isChecked, assignReassign) {
            
            try {
                
                var varAssign;
                var varTableId;
                var varTableHeaderId;
                if(assignReassign == 'assign') {
                
                    varAssign = 'tableFilterRow';
                    varTableId = 'referralsTableForSort';
                    varTableHeaderId = 'referralTableHeadders';
                }
                else if(assignReassign == 'reassign')  {  
                
                    varAssign = 'tableFilterRowReassign';
                    varTableId = 'reassignReferralTable';
                    varTableHeaderId = 'tableHeadRassign';
                }
                
                if(isChecked == true) {
                    
                    var table = j$('.'+varTableId).DataTable();
 
                     table.columns( '.classAddress' ).visible( false ); 
                     table.columns( '.clsHMS2' ).visible( false );
                     table.columns( '.clsHMS1' ).visible( true );
                     table.columns( '.clsHMS' ).visible( false );
                     table.columns( '.clsHMSIDs' ).visible( false );
                     
                     j$('.tablesorter-headerRow .clsHMS1').each(function() {
                        
                        j$('#'+varAssign).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', '');
                        j$('#'+varTableHeaderId).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', '');
                    });
                    
                    j$('.tableFilter').attr('class', 'tableFilter width50');
                    j$('.tableFilter[data-column="0"]').attr('class', 'tableFilter disabled');
                    j$('.tableFilter[data-column="1"]').attr('class', 'tableFilter width150');
                    
                    j$('.tablesorter-headerRow .clsWithoutWidgetFilter').each(function() {
                        
                        j$('#'+varAssign).find("[data-column='" + j$(this).attr('data-column') + "']").css('border', 'none');
                        j$('#'+varAssign).find("[data-column='" + j$(this).attr('data-column') + "']").attr('readonly', true);
                    });
                    
                    j$('.tablesorter-headerRow .classAddress').each(function() {
                        
                        j$('#'+varAssign).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                        j$('#'+varTableHeaderId).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                    });
                    
                    j$('.tablesorter-headerRow .clsHMS2').each(function() {
                        
                        j$('#'+varAssign).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                        j$('#'+varTableHeaderId).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                    });
                    
                    j$('.tablesorter-headerRow .clsHMS').each(function() {
                        
                        j$('#'+varAssign).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                        j$('#'+varTableHeaderId).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                    });
                    
                    j$('.tablesorter-headerRow .clsHMSIDs').each(function() {
    
                        j$('#'+varAssign).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                        j$('#'+varTableHeaderId).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                    });
                    
                }
            }
            catch(err) {
                                    
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }
        }
		
		//funtion to show the user details when the user value from the picklist is changed.
      	function detailsSelect() {
             
            try { 
                document.getElementById('inputtextId')
                j$("#userSearchTextPanelDiv").hide();
                document.getElementById('lstOption1').style.display = "none";
                document.getElementById('lstOption2').style.display = "none";
                document.getElementById("fromUserHeadingDiv").innerHTML = '';
                showHomeFacilility();
            }
            catch(err) {
                                    
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }   
        }
		
		// Function to show all the fields in the referral and reassign tab if hospice view is selected.
        function DisplayHmsView2(isChecked, assignReassign) {
            
            try {
                
                var varAssign;
                var varTableId;
                var varTableHeaderId;
                if(assignReassign == 'assign'){
                
                    varAssign = 'tableFilterRow';
                    varTableId = 'referralsTableForSort';
                    varTableHeaderId = 'referralTableHeadders';
                }
                else if(assignReassign == 'reassign')  {  
                
                    varAssign = 'tableFilterRowReassign';
                    varTableId = 'reassignReferralTable';
                    varTableHeaderId = 'tableHeadRassign';
                }
                if(isChecked == true) {
                    
                    j$('.tableFilter').attr('class', 'tableFilter width50');
                    j$('.tableFilter[data-column="0"]').attr('class', 'tableFilter disabled');
                    j$('.tableFilter[data-column="1"]').attr('class', 'tableFilter width150');
                    
                    j$('.tablesorter-headerRow .clsWithoutWidgetFilter').each(function() {
                        
                        j$('#'+varAssign).find("[data-column='" + j$(this).attr('data-column') + "']").css('border', 'none');
                        j$('#'+varAssign).find("[data-column='" + j$(this).attr('data-column') + "']").attr('readonly', true);
                    });
                    
                    j$('.tablesorter-headerRow .classAddress').each(function() {
                        
                        j$('#'+varAssign).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                        j$('#'+varTableHeaderId).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                    });
                    j$('.tablesorter-headerRow .clsHMS1').each(function() {
                        
                        j$('#'+varAssign).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                        j$('#'+varTableHeaderId).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                    });
                    
                    j$('.tablesorter-headerRow .clsHMS').each(function() {
                        
                        j$('#'+varAssign).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                        j$('#'+varTableHeaderId).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                    });
                    
                    j$('.tablesorter-headerRow .clsHMSIDs').each(function() {
    
                        j$('#'+varAssign).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                        j$('#'+varTableHeaderId).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                    });
                }
                var table = j$('.'+varTableId).DataTable();
 
                 table.columns( '.classAddress' ).visible( false ); 
                 table.columns( '.clsHMS2' ).visible( true );
                 table.columns( '.clsHMS1' ).visible( false );
                 table.columns( '.clsHMS' ).visible( false );
                 table.columns( '.clsHMSIDs' ).visible( false );
                 
                 j$('.tablesorter-headerRow .clsHMS2').each(function() {
                    
                    
                    j$('#'+varAssign).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', '');
                    j$('#'+varTableHeaderId).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', '');
                    
                });
            }
            catch(err) {
                                    
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }   
        }
		
        // Function to show all the fields in the referral and reassign tab if Metric total view is selected.
        function DisplayHmsView(isChecked, assignReassign) {
            
            try {
                
                var varAssign;
                var varTableId;
                var varTableHeaderId;
                if(assignReassign == 'assign'){
                
                    varAssign = 'tableFilterRow';
                    varTableId = 'referralsTableForSort';
                    varTableHeaderId = 'referralTableHeadders';
                }
                else if(assignReassign == 'reassign')  {  
                
                    varAssign = 'tableFilterRowReassign';
                    varTableId = 'reassignReferralTable';
                    varTableHeaderId = 'tableHeadRassign';
                }
                
                if(isChecked == true) {
                    
                    j$('.tableFilter').attr('class', 'tableFilter width50');
                    j$('.tableFilter[data-column="0"]').attr('class', 'tableFilter disabled');
                    j$('.tableFilter[data-column="1"]').attr('class', 'tableFilter width150');
                    
                    j$('.tablesorter-headerRow .clsWithoutWidgetFilter').each(function() {
                        
                        j$('#'+varAssign).find("[data-column='" + j$(this).attr('data-column') + "']").css('border', 'none');
                        j$('#'+varAssign).find("[data-column='" + j$(this).attr('data-column') + "']").attr('readonly', true);
                    });
                    
                    j$('.tablesorter-headerRow .classAddress').each(function() {
                        
                        j$('#'+varAssign).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                        j$('#'+varTableHeaderId).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                    });
                    
                    j$('.tablesorter-headerRow .clsHMS1').each(function() {
                        
                        j$('#'+varAssign).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                        j$('#'+varTableHeaderId).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                    });
                    
                    j$('.tablesorter-headerRow .clsHMS2').each(function() {
                        
                        j$('#'+varAssign).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                        j$('#'+varTableHeaderId).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                    });
                    
                    j$('.tablesorter-headerRow .clsHMSIDs').each(function() {
    
                        j$('#'+varAssign).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                        j$('#'+varTableHeaderId).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                    });
                }
                
                var table = j$('.'+varTableId).DataTable();
 
                 table.columns( '.classAddress' ).visible( false ); 
                 table.columns( '.clsHMS2' ).visible( false );
                 table.columns( '.clsHMS1' ).visible( false );
                 table.columns( '.clsHMS' ).visible( true );
                 table.columns( '.clsHMSIDs' ).visible( false );
                 
                 j$('.tablesorter-headerRow .clsHMS').each(function() {
                    
                    j$('#'+varAssign).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', '');
                    j$('#'+varTableHeaderId).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', '');
                });         
            }
            catch(err) {
                                    
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }                           
        }
		
		// Function to show all the fields in the referral and reassign tab if System IDs view is selected.
        function DisplayHMSSystemIds(isChecked, assignReassign){
            
            try {
                
                var varAssign;
                var varTableId;
                var varTableHeaderId;
                if(assignReassign == 'assign'){
                
                    varAssign = 'tableFilterRow';
                    varTableId = 'referralsTableForSort';
                    varTableHeaderId = 'referralTableHeadders';
                }
                else if(assignReassign == 'reassign')  {  
                
                    varAssign = 'tableFilterRowReassign';
                    varTableId = 'reassignReferralTable';
                    varTableHeaderId = 'tableHeadRassign';
                }
                
                if(isChecked == true) {
                     
                    j$('.tableFilter').attr('class', 'tableFilter width50');
                    j$('.tableFilter[data-column="39"]').attr('class', 'tableFilter widthSFID');
                    j$('.tableFilter[data-column="0"]').attr('class', 'tableFilter disabled');
                    j$('.tableFilter[data-column="1"]').attr('class', 'tableFilter width150');
                    
                    j$('.tablesorter-headerRow .clsWithoutWidgetFilter').each(function() {
                        
                        j$('#'+varAssign).find("[data-column='" + j$(this).attr('data-column') + "']").css('border', 'none');
                        j$('#'+varAssign).find("[data-column='" + j$(this).attr('data-column') + "']").attr('readonly', true);
                    });
                    
                    j$('.tablesorter-headerRow .classAddress').each(function() {
                        
                        j$('#'+varAssign).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                        j$('#'+varTableHeaderId).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                    });
                    
                    j$('.tablesorter-headerRow .clsHMS1').each(function() {
                        
                        j$('#'+varAssign).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                        j$('#'+varTableHeaderId).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                    });
                    
                    j$('.tablesorter-headerRow .clsHMS2').each(function() {
                        
                        j$('#'+varAssign).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                        j$('#'+varTableHeaderId).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                    });
                    
                    j$('.tablesorter-headerRow .clsHMS').each(function() {
    
                        j$('#'+varAssign).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                        j$('#'+varTableHeaderId).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                    });
                }
                
                var table = j$('.'+varTableId).DataTable();
 
                 table.columns( '.classAddress' ).visible( false ); 
                 table.columns( '.clsHMS2' ).visible( false );
                 table.columns( '.clsHMS1' ).visible( false );
                 table.columns( '.clsHMS' ).visible( false );
                 table.columns( '.clsHMSIDs' ).visible( true );
                 
                 j$('.tablesorter-headerRow .clsHMSIDs').each(function() {
                    
                    j$('#'+varAssign).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', '');
                    j$('#'+varTableHeaderId).find("[data-column='" + j$(this).attr('data-column') + "']").css('display', '');
                }); 
            }
            catch(err) {
                                    
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            } 
        }
		
		
	
		
		// Function to toggle user dropdown behvior in autocomplete
        function toggleDropdown(inputUserId) {
            
            try {
                
                if(j$('.ui-autocomplete').is(":visible")) { 
                 
                    j$('.ui-autocomplete').css('display', 'none');
                    j$("#" + inputUserId).html( getVarName(inputUserId) );
                }
                else {
                  
                    j$("#" + inputUserId).html('');
                    j$("#" + inputUserId).autocomplete( "search", "" );
                }
            }
            catch(err) {
                                    
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }
        }
        
        // Function to disable the picklists when Organization Alignment Tab is loaded
        function disableSelect() {
            
            try {
                
                j$('#tabs a[href="Details"]').tab('show');
                j$('.addDisabled').each(function() {
                    
                    j$(this).attr('disabled', 'disabled');
                });
            }
            catch(err) {
                                    
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }   
        }
        
        // Function to display the tabs and call the function to query user record
        function onUserSelect(selectedUser) {
            
            try {
                
                j$('#inputUser').blur();
                j$(".referralsTableForSort").children().children().next().children().children().val('')
                j$('#tabsDivs').css('display', 'block');
                onUserSelectFunc(selectedUser);
            }
            catch(err) {
                                    
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }
        }
        
        // Function to display the tabs and call the function to query Account record
        function onAccountSelect(selectedAccount) {
            try {
                
                var AccId = document.getElementById('AccountId_Hidden');
                fetchAccounts(selectedAccount);
            }
            catch(err) {
                                    
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }
        }
		
		//Function to check if all rows checkbox is checked, which will check 'assign' checkbox
		function markAssignChecked() {
            
            try {
                
                if (j$('.CheckboxAssignment:checked').length == j$('.CheckboxAssignment').length) { 
                    
                    j$('.Checkbox').prop('checked', true);
                }
                else {
                    
                    j$('.Checkbox').prop('checked', false);
                }
            }
            catch(err) {
                                    
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }   
        }
		
		//Function to fetch all the child role from the selected role in org alignment tab
        function fetchDependentRoles(selectedUser, elementId) {
            
            try {
                
                var currentRowIndex = parseInt(elementId.split('_')[1]);
                var i = currentRowIndex + 1;
                
                //Remove all rows when top picklist is set to none.
                if(selectedUser == '') {
                    
                    //Remove all picklist rows below selected row index.
                    j$('.rowContainingPicklist').each(function() {
                        if(parseInt(j$(this).attr('Id').split('_')[1]) > currentRowIndex)
                            j$(this).remove();
                    });
                    
                    //Get Parent Value to be used for filtering table data. 
                    if(currentRowIndex > 1) {
                        
                        parentRowIndex = currentRowIndex - 1;  
                        strToBeSaved = j$("#pickVal_"+parentRowIndex).val();
                    }
                    else if(currentRowIndex == 0 || currentRowIndex == 1) {
                        
                        strToBeSaved = j$("#pickVal_0").val();
                    }
                }
                else if(selectedUser != '') {
                    
                    j$('.rowContainingPicklist').each(function() {
                        if(parseInt(j$(this).attr('Id').split('_')[1]) > currentRowIndex)
                            j$(this).remove();
                    });
                    
                    strToBeSaved = selectedUser;
                }
                
				//calling controller method, fetchUserRoles by passing selected user.
                TBN_AssociateDataManagementController.fetchUserRoles(selectedUser,
                    function(result, event) {
                       
                        if(result.length > 0) {
                        var userNames = result.split('|')[1];
                        
                        var errMsg = '';
                        if(result.split('|')[1] == '') {
                            errMsg = errMsg+"<b>There are no users corresponding to this role</b>";
                        }
                       
                        siblingHTML =  result.split('|')[1];
                        j$('#userNames'+(i-1)).html(siblingHTML);
                                           
                        var siblingHTML = '';
                        if(result.split('|')[0] != '') {
                    
                            siblingHTML = '<tr class="rowContainingPicklist" id="row_'+i+'">' +
                                               
                                               '<td >' +
                                                   '<div class="form-group mediumMarginTop formElementsWidth">' +
                                                       '<select class="form-control formElementsWidth mediumMarginTop" size="1" onchange="fetchDependentRoles(this.value, this.id);" id="pickVal_'+i+'">'+
                                                       result.split('|')[0]+
                                                   '</select></div>' + 
                                               '</td>' +
                                               '<td width="100%">' +
                                                   '<div class="mediumMarginTop marginLeft" id="userNames'+i+'" >' +
                                                      
                                                   '</div>' + 
                                               '</td>' +
                                            '</tr>';
                            j$('#divisionTables').append(siblingHTML);
                        } 
                        else {
                        
                            if(i>1){
                                j$('#divisionTables').append(siblingHTML);
                            }
                            else {
                                j$('#userNames'+(i-1)).html('');
                            } 
                        }
                        }
                   },
                {escape: false});
                        
                renderSubmitButton();
            }
            catch(err) {
                                    
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }   
        }
        
		//Function is called when changes in org allignment is made, and changes are submitted. 
        function renderSubmitButton() {
            
            try {
                
                if(j$('.rowContainingPicklist').length > 0 || j$("#pickVal_0").val() != '')
                    j$('#userRoleSubmitBtn').css('display', 'block'); 
                else
                    j$('#userRoleSubmitBtn').css('display', 'none'); 
            }
            catch(err) {
                                    
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }
        }
        
		//Function is called when the assign checkbox is checked or unchecked to check or uncheck all the rows that are visible
        function toggleCheckbox(checkboxId, tbodyId) {
            
            try {
                
                if(j$('#'+checkboxId).is(':checked')) {
                    
                    j$('#' + tbodyId).find("tr").each( function(){
                         if ( j$(this).is(':visible'))
                            j$(this).find("td:first input").prop('checked', true);
                    });
                }
                else {
                    j$('#' + tbodyId).find("tr").each( function(){
                         if ( j$(this).is(':visible'))
                            j$(this).find("td:first input").removeAttr('checked');
                    });
                } 
            }
            catch(err) {
                                    
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }
        }
        
        function showAccountTeamMembers(selectedAccountId) {
            
            try {
                
                document.getElementById("box").innerHTML = "";
    
                var tabData = '';                 
                TBN_AssociateDataManagementController.fetchTeamMembers(selectedAccountId, 
                
                    function(result, event) {
                    
                        for(var i=0 ; i< result.length; i++)
                        {
                            document.getElementById("box").innerHTML +="<a href = '/"+result[i].Id+"' target='new'/><br />"+ result[i].Name ;  
                        }
                    
                    }, 
                    {escape: false}
                );
                
                simpleDialogVar.show();  
            }
            catch(err) {
                                    
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }
        }
        
        function showFocus(selecteduser) {
        
            try {
                
                document.getElementById('reassignUser').focus();
                toggleDropdown('reassignUser');
            }
            catch(err) {
                                    
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }
        } 
        
        function loading() {
            
            try {
                
                j$('.modal').removeClass('displayNone');
                j$('.modal').addClass('displayBlock');
            }
            catch(err) {
                                    
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }
        }
		
		function stoploading() {
            
            try {
                
                j$('.modal').addClass('displayNone');
                j$('.modal').removeClass('displayBlock');
            }
            catch(err) {
                                        
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }
        }
        
        // Function to get the roles and the uses belonging to the roles in selected user's hierarchy
        function fetchHierarchyRoles(selectedUser, selectedUserRole,strOrgAlignment) {
            
            try {
                if(selectedUser == undefined)
                    selectedUser = j$('[id$=inputUser_HiddenSalesRep]').val();
                document.getElementById('lstOption1').style.display = "none";
                document.getElementById('lstOption2').style.display = "none";
                j$("#userSearchTextPanelDiv").hide();
                document.getElementById("fromUserHeadingDiv").innerHTML = '';
                
                j$('#divisionTables').html('');
                
                
                TBN_AssociateDataManagementController.fetchParentRoles(selectedUser, selectedUserRole,
                    function(result, event) {
                        
                        if(result!= null && result.length > 0) {
                            
                            j$('#mainOrgAlignmentDiv').html(result);
                            var buttonHTML = '<table width="100%" class="smallMarginLeft" id="submitBtnTable">' +
                                                '<tr><td>&nbsp;</td></tr>' +
                                                '<tr><td>&nbsp;</td></tr>' + 
                                                '<tr> <td style="padding-top: 2%;"><button Id="userRoleSubmitBtn" style="' + (strOrgAlignment==true?'display: block;': 'display: none;')+'" type="button"  class="btn btn-info" onclick="loading();this.disabled; updateUserRole(strToBeSaved);">Submit</button> </td></tr>' +   
                                            '</table>';                  
        
                            j$('#mainOrgAlignmentDiv').append(buttonHTML);
                        }
                        else{
                             j$('#mainOrgAlignmentDiv').html('');
                        }
                    },
               {escape: false}); 
            }
               
            catch(err) {
                                        
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }
        }
        
        function fetchDependentRoles(selectedUser, elementId, strOrgAlignment) {
            
            try {
                
                var currentRowIndex = parseInt(elementId.split('_')[1]);
                var i = currentRowIndex + 1;
                
                // Remove all rows when top picklist is set to none.
                if(selectedUser == '') {
                    
                    // Remove all picklist rows below selected row index.
                    j$('.rowContainingPicklist').each(function() {
                        
                        if(parseInt(j$(this).attr('Id').split('_')[1]) > currentRowIndex)
                            j$(this).remove();
                    });
                    
                    //Get Parent Value to be used for filtering table data. 
                    if(currentRowIndex > 1) {
                        
                        parentRowIndex = currentRowIndex - 1;  
                        strToBeSaved = j$("#pickVal_"+parentRowIndex).val();
                    }
                    else if(currentRowIndex == 0 || currentRowIndex == 1) {
                        
                        strToBeSaved = j$("#pickVal_0").val();
                    }
                }
                else if(selectedUser != '') {
                    
                    j$('.rowContainingPicklist').each(function() {
                        
                        if(parseInt(j$(this).attr('Id').split('_')[1]) > currentRowIndex)
                            j$(this).remove();
                    });
                    
                    strToBeSaved = selectedUser;
                }
                
                
               TBN_AssociateDataManagementController.fetchUserRoles(selectedUser,
                   function(result, event) {
                       
                        if(result.length > 0) {
                            
                            var errMsg = '';
                            var userNames = result.split('|')[1];
                           
                            if(result.split('|')[1] == '') {
                                
                                errMsg = errMsg+"<b>There are no users corresponding to this role</b>";
                            }
                           
                            siblingHTML =  result.split('|')[1];
                            j$('#userNames'+(i-1)).html(siblingHTML);
                                               
                            var siblingHTML = '';
                            if(result.split('|')[0] != '') {
                                
                                siblingHTML = '<tr class="rowContainingPicklist" id="row_'+i+'">' +
                                                   '<td >' +
                                                       '<div class="form-group mediumMarginTop formElementsWidth">' +
                                                           '<select class="form-control formElementsWidth mediumMarginTop" size="1" onchange="fetchDependentRoles(this.value, this.id,' + strOrgAlignment+ ');" id="pickVal_'+i+'">'+
                                                           result.split('|')[0]+
                                                       '</select></div>' + 
                                                   '</td>' +                                           
                                                   '<td width="100%">' +
                                                       '<div class="mediumMarginTop marginLeft" id="userNames'+i+'" >' +
                                                          
                                                       '</div>' + 
                                                   '</td>' +
                                                '</tr>';
        
                                var btnElem = document.getElementById('submitBtnTable');
                                btnElem.parentNode.removeChild(btnElem);
                                var buttonHTML = '<table width="100%" class="smallMarginLeft" id="submitBtnTable">' +
                                                    '<tr><td>&nbsp;</td></tr>' +
                                                    '<tr><td>&nbsp;</td></tr>' + 
                                                    '<tr> <td style="padding-top: 2%;"><button Id="userRoleSubmitBtn" type="button" style="' + (strOrgAlignment==true?'display: block;': 'display: none;')+'"  class="btn btn-info" onclick="loading();this.disabled; updateUserRole(strToBeSaved);">Submit</button> </td></tr>' +   
                                                '</table>';                    
                                                    
                                j$('#mainOrgAlignmentDiv').append(siblingHTML);
                                j$('#mainOrgAlignmentDiv').append(buttonHTML);
                            } 
                            else {
                             
                                if(i>1) { 
        
                                    var btnElem = document.getElementById('submitBtnTable');
                                    btnElem.parentNode.removeChild(btnElem);
        
                                    var buttonHTML = '<table width="100%" class="smallMarginLeft" id="submitBtnTable">' +
                                                        '<tr><td>&nbsp;</td></tr>' +
                                                        '<tr><td>&nbsp;</td></tr>' + 
                                                        '<tr> <td style="padding-top: 2%;"><button Id="userRoleSubmitBtn" type="button" style="' + (strOrgAlignment==true?'display: block;': 'display: none;')+'" class="btn btn-info" onclick="loading();this.disabled; updateUserRole(strToBeSaved);">Submit</button> </td></tr>' +   
                                                    '</table>';                  
                                    
                                    j$('#mainOrgAlignmentDiv').append(siblingHTML);
                                    j$('#mainOrgAlignmentDiv').append(buttonHTML);
                                }
                                else {
        
                                    j$('#userNames'+(i-1)).html('');
                                } 
                            }   
                        }
                        else {
        
                            j$('#userNames'+(i-1)).html('');
                        }               
                    },
                {escape: false});
            }
            catch(err) {
                                        
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }
        }
        
        function reassignReferralUsersFunction() {
                 
            try {     
                
                if(j$('[id$=reassignUser_Hidden]').val() == j$('[id$=inputUser_Hidden]').val())  {
                    
                    window.scrollTo(0,0);
                    j$('#SaveMessage').html('Referrals cannot be reassigned to same User');
                    j$('#Showfadding').delay(1).fadeIn();
                    j$('#Showfadding').delay(5000).fadeOut();
                    
                }
                else{
                    
                    // Check if no assigned to user is selected or if no referral is checked
                    if(j$('#reassignTableBody').find('input[type=checkbox]:checked').length == 0 || j$('[id$=inputUser_Hidden]').val() == '' ||
                        j$('[id$=reassignUser_Hidden]').val() == '') {
                        
                        j$('#SaveMessage').html('Make sure Referrals and Assignee are selected.');
                        j$('#Showfadding').delay(1).fadeIn();
                        j$('#Showfadding').delay(5000).fadeOut();
                        document.body.scrollTop = document.documentElement.scrollTop = 0;
                    }
                    else {
                        
                        reassignReferralUsers(j$('[id$=inputUser_Hidden]').val());
                        loading();
                    }
                }
            }
            catch(err) {
                                        
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }
        }
        
        //Function is called on click on the page to restore the values in the user/home facility picklist when nothing is selected.
        function onBodyClick() {
            
            try {
                
                if(getVarName('inputUser') != '')
                    j$('#inputUser').html( getVarName('inputUser') );
                
                if(getVarName('reassignUser') != '')    
                    j$('#reassignUser').html( getVarName('reassignUser') );
                
                if(getVarName('AccountId') != '')
                    j$('#AccountId').html( getVarName('AccountId') );
                
                if(j$('#inputUser_Hidden').val() == '')
                    j$('#inputUser').html('');
                
                if(j$('#reassignUser_Hidden').val() == '')
                    j$('#reassignUser').html('');
                
                if(j$('#AccountId_Hidden').val() == '')
                    j$('#AccountId').html('');
                    
                if(j$('.ui-autocomplete').is(":visible")) {
        
                    j$('.ui-autocomplete').css('display', 'none');
                }
            }
            catch(err) {
                                        
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }
                
        }
        
        //Function is called on click in the user.home facility picklist to clear out existing value and show the dropdown list.
        function clearValue( editableDivId ) {
            
            try {
                
                toggleDropdown( editableDivId );
            }
            catch(err) {
                                        
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }
        }
    
        //Function is called on click of 'here' when the user doesnt have any home facility. which shows the user details and hides the active tab.
        function showDetalisTab() {
            
            try {
                j$('#details').addClass('active');
                j$('#referrals').removeClass('active');
                setTimeout('window.scrollTo(0,document.body.scrollHeight);',200);
            }
            catch(err) {
                                        
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }   
        }
        
        //Function is called to display home facility in the details tab
        function showHomeFacilility(homeFacility) {
            
            try {
                
                if(j$('#AccountId').is(":visible"))
                    document.getElementById('AccountId').innerHTML= homeFacility;
                if(j$('#homefacilitySalesRep').is(":visible"))    
                    document.getElementById('homefacilitySalesRep').innerHTML= homeFacility;
            }
            catch(err) {
                                        
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }
        }
        
        //Function is called when reassign referral tab is selected.
        function fetchref() {
            
            try {
                
                //If value is there in the from user picklist, 'onReassignmentSelect' action function is called, to retrive to referrals assigned to that user.
                j$('#customValidationMsg').hide();
                if(j$('[id$=reassignUser_Hidden]').val() != '')
                    onReassignmentSelect(j$('[id$=reassignUser_Hidden]').val());    
                    
                j$("#userSearchTextPanelDiv").show();
                //To the user and lstOption2 'td' will be shown with the heading for both user picklist.
                var div = document.getElementById('fromUserHeadingDiv');
                div.innerHTML = 'To this User';   
                document.getElementById('lstOption1').style.display = "block";
                document.getElementById('lstOption2').style.display = "table-cell";
                
                //Checks if the Reassign checkbox is checked, if so it will check all the visible checkbox.
                if(j$("#referralAllReassign").is(":checked")) {
                    
                    if( j$('input[type=checkbox]').is(':visible'))
                        j$('input[type=checkbox]').prop('checked', true);
                }
                //Checks if the Reassign checkbox is unchecked, if so it will uncheck all the visible checkbox.
                else if(!j$("#referralAllReassign").is(":checked")) {
                    
                    if( j$('input[type=checkbox]').is(':visible'))
                        j$('input[type=checkbox]').prop('checked', false);
                }
            }
            catch(err) {
                                    
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }
        }
    
        //variable to store the selected to user name.
        var selectedUserVal = '';
        //variable to store the selected from user name.
        var selectedReferralVal = '';
        //variable to store the selected home facility name.
        var selectedAccountVal = '';
        
        function setVarName(picklistId, newVal) {
                
            try {    
                
                //Calls the remote action 'fetchAutocompleteDetails' to fetch the data based on the Id of the picklist.
                TBN_AssociateDataManagementController.fetchAutocompleteDetails(j$( escHidden(picklistId) ).val(), 
                
                    function(result, event) { 
                   
                        if(event.type != 'exception') {
                            
                            if(picklistId == 'AccountId') {
                    
                                selectedAccountVal = result.replace('\\\'', '\'');
                            }
                            else if(picklistId == 'reassignUser') {
                                
                                selectedReferralVal = result.replace('\\\'', '\'');
                            }
                            else if(picklistId == 'inputUser') {
                                
                                selectedUserVal = result.replace('\\\'', '\'');
                            }
                            
                            if(newVal == 'true') {
                                
                                j$(esc(picklistId)).html( result.replace('\\\'', '\'') );
                                     var ua = window.navigator.userAgent;
                                     var msie = ua.indexOf("MSIE ");
                                    
                                     if (msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./))  // If Internet Explorer, return version number
                                     {
                                      //  j$('#userNameId').css('margin-top','-18px'); 
                                      //  j$('#inputUser').blur();
                                     }
                                   
                                   /*if(navigator.userAgent.test(/Trident.*rv[ :]*11\./)){
                                     alert('111111');
                                     j$('#userNameId').css('padding-top','15px');
                                   }*/
                            }
                        }
                    }, 
                {escape: false}); 
            }
            catch(err) {
                                        
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }
        }
        
        //Function is called on click of body when no value is entered in user/account picklist, to restore the values stored in variable.
        function getVarName(picklistId) {
            
            try {
                if(picklistId == 'AccountId') {
                    
                    return selectedAccountVal;
                }
                else if(picklistId == 'reassignUser') {
                    
                    return selectedReferralVal;
                }
                else if(picklistId == 'inputUser') {
                    
                    return selectedUserVal;
                }
            }
            catch(err) {
                                        
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }
        }
        
        function DisplayHmsView1Reassign(isChecked) {
            
            try {
                
                if(isChecked == true) {
                    
                    j$('.classAddress').css('display','none');
                    j$('.clsHMS1').css('display','');
                    j$('.clsHMS2').css('display','none');
                    j$('.clsHMS').css('display','none');
                    
                    j$('.tableFilter').attr('class', 'tableFilter width50');
                    j$('.tableFilter[data-column="0"]').attr('class', 'tableFilter disabled');
                    j$('.tableFilter[data-column="1"]').attr('class', 'tableFilter width150');
                    
                    var table = j$('.reassignReferralTable').DataTable();
                    
                    j$('.tablesorter-headerRow .clsHMS1').each( function(){
                        
                        j$("#tableFilterRowReassign").find("[data-column='" + j$(this).attr('data-column') + "']").css('display', '');
                        table.column( j$(this).attr('data-column') ).visible();
                    });
                    
                    j$('.tablesorter-headerRow .clsWithoutWidgetFilter').each(function(){
        
                        j$("#tableFilterRowReassign").find("[data-column='" + j$(this).attr('data-column') + "']").css('border', 'none');
                        j$("#tableFilterRowReassign").find("[data-column='" + j$(this).attr('data-column') + "']").attr('readonly', true);
                    });
                    
                    j$('.tablesorter-headerRow .classAddress').each(function(){
        
                        j$("#tableFilterRowReassign").find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                    });
        
                    j$('.tablesorter-headerRow .clsHMS2').each(function() {
                        
                        j$("#tableFilterRowReassign").find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                    });
                    
                    j$('.tablesorter-headerRow .clsHMS').each(function() {
                        
                        j$("#tableFilterRowReassign").find("[data-column='" + j$(this).attr('data-column') + "']").css('display', 'none');
                    });
                    
                    j$('input[data-column="11"]').attr('class', 'tableFilter width50 tdBgColor');
                    j$('input[data-column="12"]').attr('class', 'tableFilter width50 tdBgColor');
                    j$('input[data-column="15"]').attr('class', 'tableFilter width50 tdBgColor');
                    j$('input[data-column="16"]').attr('class', 'tableFilter width50 tdBgColor');
        
                } 
            }
            catch(err) {
                                        
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }
        }
        
        //Function is called on click of Assign/Unassign button on referral tab, which forms the JSON based on the check box val and sends to 'assignReferralSources' action function 
        function assignReferralUsers(selectedUser, firstPicklistVal, secPicklistVal, selSourceSystemVal) {
            
            try {
                var referralsTableReference = j$('.referralsTableForSort').DataTable();
                var info = referralsTableReference.page.info();
                var pageNumber = info.page;
                var referralData = [];
                
                j$("#tableBody").find("[type='checkbox']").each(function() {
                    
                    var parentId = j$(this).parent().attr('id') + '';
                    if(j$(this).is(':checked')) {
                        
                        if(parentId.split('-')[1] != 'true') {
                        
                            var typeTDId = j$(this).attr('id') + 'Type';
                            var typeId = j$(this).attr('id');
                            var typeIdRes = typeId.substring(0,3);
                            var AccorCon = '';
                            if(typeIdRes == '001'){
                                AccorCon = 'Account';
                            }
                            else if(typeIdRes == '003'){
                                AccorCon = 'Contact';
                            }
                            var wrapper = new Object();
                            wrapper['strReferralId'] = j$(this).attr('id');
                            wrapper['strType'] = AccorCon;
                            wrapper['strOperation'] = 'Insert';
                            referralData.push(wrapper);
                        }
                    }
                    else {
                        
                        if(parentId.split('-')[1] == 'true') {
                            
                            var typeTDId = j$(this).attr('id') + 'Type';
                            var typeId = j$(this).attr('id');
                            var typeIdRes = typeId.substring(0,3);
                            var AccorCon = '';
                            if(typeIdRes == '001'){
                                AccorCon = 'Account';
                            }
                            else if(typeIdRes == '003'){
                                AccorCon = 'Contact';
                            }
                            var wrapper = new Object();
                            wrapper['strReferralId'] = j$(this).attr('id');
                            wrapper['strType'] = AccorCon;
                            wrapper['strOperation'] = 'Delete';
                            referralData.push(wrapper);
                        }
                    }
                });
                
                if(referralData.length > 0) {
                    
                    TBN_AssociateDataManagementController.assignReferralSources( selectedUser, JSON.stringify(referralData),  
                        function(result, event) {
                            document.getElementById("referralAssignmentCount").innerHTML = result;
                       
                            if(event.type != 'exception') {
                                
                                j$(function($) {
                                    j$('#confirmAssignment').delay(500).fadeIn();
                                });
                            }
                            onPaginationTableSorter('Name', 1,'', false, j$('#inputUser_Hidden').val(), firstPicklistVal, selSourceSystemVal, secPicklistVal,'assign',pageNumber);
                        }, 
                    {escape: false});  
                    stoploading();
                  //  j$('.referralsTableForSort').dataTable({}).fnPageChange(pageNumber,true);
                } 
                else{
                    
                    j$('#noReferralsSelect').show();
                    setTimeout('stoploading()',50);
                    j$('#noReferralsSelect').delay(3000).fadeOut();
                }
                j$('.modal').addClass('displayNone');
                j$('.modal').removeClass('displayBlock');
            }
            catch(err) {
                                        
                    alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }                                                   
        }
        
        //Function is called when reassign button is clicked.
        function reAssignReferralUser(selectedToUser, selectedFromUser) {
            
            try {
                var referralsTableReference = j$('.reassignReferralTable').DataTable();
                var info = referralsTableReference.page.info();
                var pageNumber = info.page;
                //Checks if both from and to user are same, if so, message will be displayed at the top and will not perforn any actions
                if(selectedToUser == selectedFromUser )  {
                    
                    window.scrollTo(0,0);
                    j$('#SaveMessage').html('Referrals cannot be reassigned to same User');
                    j$('#Showfadding').delay(1).fadeIn();
                    j$('#Showfadding').delay(5000).fadeOut();
                } 
                else {
                    
                    if(j$('#reassignTableBody').find('input[type=checkbox]:checked').length == 0 || j$('[id$=inputUser_Hidden]').val() == '' ||
                        j$('[id$=reassignUser_Hidden]').val() == '') {
                            
                        j$('#SaveMessage').html('Make sure Referrals and Assignee are selected.');
                        j$('#Showfadding').delay(1).fadeIn();
                        j$('#Showfadding').delay(5000).fadeOut();
                        document.body.scrollTop = document.documentElement.scrollTop = 0;
                    }
                    else {
                        
                        j$('.modal').removeClass('displayNone');
                        j$('.modal').addClass('displayBlock');
                        reAssignreferralstoUsers(selectedToUser, selectedFromUser, pageNumber);
                    }
                }
            }
            catch(err) {
                                        
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }   
        }
        
        //Function is called from 'reAssignReferralUser' function, which forms the string of Id based on the check box val and sends to 'reAssignReferralSources' action function 
        function reAssignreferralstoUsers(selectedToUser, selectedFromUser, pageNumber) {
            
            try {
                var referralidString = '';
                
                j$("#reassignTableBody").find("[type='checkbox']").each(function() {
            
                    if(j$(this).is(':checked')) {
                        referralidString +=j$(this).attr('id')+'#';
                    }
                });
                
                if(referralidString.length > 0) {
                    
                    TBN_AssociateDataManagementController.reAssignReferralSources( selectedToUser, selectedFromUser, referralidString,
                        function(result, event) {
                            
                            document.getElementById("reassignCount").innerHTML = result;
                            if(event.type != 'exception') {
                                 
                                j$(function($) {
                                    j$('#confirmAssignment').delay(1).fadeIn();
                                    j$('#confirmAssignment').delay(5000).fadeOut();
                                });
                            }
                            var reassignuser = j$('#reassignUser_Hidden').val();
							
                           // getReassignReferralSourcesTableSorter('ReassignName', 1,'descending', '', '', '', '', 'true',reassignuser);
							onPaginationTableSorterReassign ('ReassignName', 1,'ascending',reassignuser, pageNumber, 'reassign');
                        }, 
                    {escape: false});    
                }
            }
            catch(err) {
                                        
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }
        }
        
        //Function is called on sorting or searching on reassign tab.
        function onPaginationTableSorterReassign(sorterFieldId, dataColNumber, varAriaSort, selUserId, pageNumber, fromReassgin){
            
            try {
                var sortedClass;  
                var dataColValue; 
                var ariaSortVal; 
				sortedClass = j$(".clsSortedFieldReassign").attr('id');
				dataColValue = j$('#'+sortedClass).data('column');
				ariaSortVal = j$('#'+sortedClass).attr('aria-sort');
				if(fromReassgin == 'reassign' || fromReassgin == 'search'){
                    var sortcol = j$('.reassignReferralTable').dataTable({}).fnSettings().aaSorting;
                    var sortColVal = sortcol[0];
                    if(sortColVal[0] != ''){
                        sortedClass = sortColVal[0] +'-'+ 'unassign';
                        dataColValue = sortColVal[0];
                        if(sortColVal[1]  == 'desc')
                            varAriaSort = 'descending';
                        else if(sortColVal[1] == 'asc') 
                            varAriaSort = 'ascending';
                        ariaSortVal = varAriaSort;    
                    }
                       
                }
				
                if(sortedClass != undefined && (sortedClass.indexOf('reassign') >= 0 || sortedClass.indexOf('reassiHH') >= 0 || sortedClass.indexOf('reassiHP') >= 0)) 
                    sortedClass = sortedClass.substring(0, sortedClass.length - 9);
                
                  
                if(sortedClass == undefined){
                    sortedClass = 'ReassignName';
                    ariaSortVal = 'ascending';
                    dataColValue = '1';
                }
                
                if(sortedClass == 'ReassignName' && ariaSortVal == 'undefined')
                    ariaSortVal = 'ascending';
                if(sortedClass != 'ReassignName' && ariaSortVal == 'undefined')
                    ariaSortVal = 'descending';  
                var isTypeFilter='';
                var whereQueryAccount = '';
                var whereQueryContact= '';
                var sortedFieldid = ''; 
                var strSpecilaityFilterValue = '';
                if(fromReassgin != 'reassign'){
                    if(varAriaSort == '')
                        var ariaSortVal = j$('#'+sorterFieldId).attr('aria-sort');
                    else    
                        var ariaSortVal = varAriaSort;
                }
                //forms the where condition based on the filters applied in the search.
                j$('.reassignReferralTable .tableFilter').each(function() {
                    
                    var currentElement = j$(this);
                     
                    var value = currentElement.val(); 
                    var dataColNumber = dataColNumber;
                    var dataColNumber1 = j$(this).data('column');
                    var trData = j$('.reassignReferralTable').children().children();
                    sortedFieldid = j$("#tableFilterRowReassign [data-column='" + dataColNumber1 + "']").attr('id');
                    if(sortedFieldid != undefined)
                        sortedFieldid = sortedFieldid.substring(8);
                    
                    if(value != '' && value.trim().length >= 1) {
                        
                        value = value.trim(); 
                        if(sortedFieldid == "Name" || sortedFieldid == "NPI__c" || sortedFieldid == "ShippingCity" || sortedFieldid == "ShippingState" ||
                                sortedFieldid == "ShippingStreet" || sortedFieldid == "ShippingPostalCode") {
                            
                            if(value.length >= 2){  
                                
                                if(sortedFieldid == "ShippingState") {
                                    
                                    whereQueryAccount += ' AND (Account.'+sortedFieldid+' = u2019' + value + 'u2019 ) ';
                                    whereQueryContact += ' AND (Contact__r.'+sortedFieldid+' = u2019' + value + 'u2019 ) ';
                                }
                                else{
                                    whereQueryAccount += ' AND Account.'+sortedFieldid+' like u2019%' + value + '%u2019 ';
                                    whereQueryContact += ' AND Contact__r.'+sortedFieldid+' like u2019%' + value + '%u2019 ';
                                }
                            }
                        }
                        
                        else if(sortedFieldid == "strSpecialties"){
                            
                            if(value.length >= 2)
                                strSpecilaityFilterValue = value;
                        }
                        
                        else if(sortedFieldid == "strType") {
                            
                            if(value.length >= 3) {
                                
                                var typeStringContact = 'contact';
                                var typeStringAccount = 'account';
                                var res = value.toLowerCase();
                                if(typeStringContact.indexOf(res) > -1 ) { 
                                    
                                    isTypeFilter = 'ContactFilter';
                                }
                                else if(typeStringAccount.indexOf(res) > -1 ) {
                                    
                                    isTypeFilter = 'AccountFilter';
                                }
                            }
                        }
						else if(value.indexOf("<") != -1 || value.indexOf("<=") != -1 || value.indexOf(">") != -1 || value.indexOf(">=") != -1 || value.indexOf("=") != -1){
                             
                            var valIndex = value; 
                            if(valIndex == '>' || valIndex == '<' || valIndex == '=' || valIndex == '>=' || valIndex == '<='){
                                
                                value = '>0';
 
								if(sortedFieldid != "strLengthofStay")
									whereQueryAccount += ' AND Account.'+sortedFieldid + '' + value;
								
                                whereQueryContact += ' AND Contact__r.'+sortedFieldid + '' + value;  
                            }
                            else{
                                //value = '='+value;
								if(sortedFieldid != "strLengthofStay")
									whereQueryAccount += ' AND Account.'+sortedFieldid + '' + value;
                                
								whereQueryContact += ' AND Contact__r.'+sortedFieldid + '' + value;
                                
                            }
                        }
                        else{
                            
                            value = '='+value;
							if(sortedFieldid != "strLengthofStay")
								whereQueryAccount += ' AND Account.'+sortedFieldid + '' + value;
                            
							whereQueryContact += ' AND Contact__r.'+sortedFieldid + '' + value;
                        }
					}
                      
                });
                var onTableLoad = false;
                getReassignReferralSourcesTableSorter(sortedClass, dataColValue, ariaSortVal, strSpecilaityFilterValue, whereQueryAccount, whereQueryContact, isTypeFilter, onTableLoad, selUserId, pageNumber);
            }
            catch(err) {
                                        
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }
        }
    
        //Function is called on user select in the from user picklist and reassignment button click which will call the remote action 'fetchReassignReferralSourcesTableSorter' 
        function getReassignReferralSourcesTableSorter(sortedField, dataColNumber, ariaSortVal, strSpecilaityFilterValue, whereQueryAccount, whereQueryContact, isTypeFilter, onTableLoad, selectedReassignUser, pageNumber){
            
            try {
                
                var recCountReassign = 0;
                var dataColNumber = dataColNumber;
                if(selectedReassignUser == undefined)  
                    selectedReassignUser = j$('[id$=inputUser_HiddenSalesRep]').val();
                
                if(ariaSortVal == undefined)
                    ariaSortVal = 'ascending';
                    
                TBN_AssociateDataManagementController.fetchReassignReferralSourcesTableSorter(sortedField, ariaSortVal, strSpecilaityFilterValue, whereQueryAccount, whereQueryContact, isTypeFilter, selectedReassignUser,
                
                function(result,event){
                    
                    getReassignReferralSourcesTableSorter2(sortedField, dataColNumber, ariaSortVal, strSpecilaityFilterValue, whereQueryAccount, whereQueryContact, isTypeFilter, onTableLoad, selectedReassignUser, pageNumber);
                    
                }, {buffer: false, escape: false, timeout: 120000});  
                setTimeout('stoploading()',1500);
                
            }
            catch(err) {
                                        
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }
        }
        
        //Function is called on user select in the from user picklist and reassignment button click which will call the remote action 'fetchReassignReferralSourcesTableSorter' 
        function getReassignReferralSourcesTableSorter2(sortedField, dataColNumber, ariaSortVal, strSpecilaityFilterValue, whereQueryAccount, whereQueryContact, isTypeFilter, onTableLoad, selectedReassignUser, pageNumber) {
            
            try {
                var recCountReassign = 0;
                var dataColNumber = dataColNumber;
                if(selectedReassignUser == undefined)  
                    selectedReassignUser = j$('[id$=inputUser_HiddenSalesRep]').val();
                
                if(ariaSortVal == undefined)
                    ariaSortVal = 'ascending';
                    
                TBN_AssociateDataManagementController.fetchReassignReferralSourcesTableSorter(sortedField, ariaSortVal, strSpecilaityFilterValue, whereQueryAccount, whereQueryContact, isTypeFilter, selectedReassignUser,
                
                function(result,event){
                    
                    if(event.type != 'exception') {
                        
                        var tableData = ''; 
                        var isAssigned = true;
                        if(result == null || ((result.lstAccounts == null || result.lstAccounts.length == 0) && 
                                                    (result.lstContacts == null || result.lstContacts.length == 0))){
                            
                            j$('#reassignViewButtons').show();
                            j$('#noReassignmentuser').show();
                            j$('#paginateBtnsReassignment').hide();
                            if(onTableLoad == 'true'){   
                                j$('#hasReassingment').hide();
                                j$('#noReassignmentuser').show();
                                j$('#reassignViewButtons').hide();
                            }
                            j$("#reassignTableBody").html('');
                            
                        }
                        else{
                            document.getElementById('reassignViewButtons').style.display = "block";
                            j$('#noReassignmentuser').hide();
                            j$('#hasReassingment').show();
                            j$('#paginateBtnsReassignment').show();
                        
                            tableData += formAccountsDataReassign(result.lstAccounts, result.lstATMsAssigned, result.lstATMsIcons);
                            tableData += formContactsDataReassign(result.lstContacts, result.lstCTMsAssigned, result.lstCTMsIcons);
                                  
                            if((result.lstAccounts.length + result.lstContacts.length) > 2000) {
                                        
                                if(j$('#endBtnReassign').is(":visible")) {
            
                                    j$('#endBtnReassign').attr("disabled",true); 
                                }
                                j$('#recordCountMessageReassign').show();
                            }
                            else {
                                
                                j$('#endBtnReassign').attr("disabled",false);
                                j$('#recordCountMessageReassign').hide();
                                j$('#nxtBtnReassign').attr("disabled",false);
                            }
                                 
                            var sorting;
            
                            if(ariaSortVal == 'none')  {
                                
                                sorting = [[dataColNumber, ((ariaSortVal == 'none') ? 'asc' : 'desc')]];
                            }
                            else    
                                sorting = [[dataColNumber, ((ariaSortVal == 'ascending') ? 'asc' : 'desc')]]; 
                                
                            j$('.reassignReferralTable').dataTable({
                            }).fnDestroy();
                            
                            j$("#reassignTableBody").html(tableData); 
                            j$("#referralAllReassign").prop( "checked", true );
                            
                            //document.getElementById('ReassignAddress').style.checked = "checked"; 
                            if(j$("#ReassignAddress").is(":checked") == false && j$("#ReassignhmsView1").is(":checked") == false && j$("#ReassignhmsView2").is(":checked") == false && j$("#ReassignhmsView").is(":checked") == false){
                                
                                j$("#ReassignAddress").prop( "checked", true );
                            }
                           // if(j$("#ReassignAddress").is(":checked")) DisplayAddressFields(true, true, "reassign"); else if(j$("#ReassignhmsView1").is(":checked")) DisplayHmsView1(true, "reassign"); else if(j$("#ReassignhmsView2").is(":checked")) DisplayHmsView2(true, "reassign");else if(j$("#ReassignhmsView").is(":checked")) DisplayHmsView(true, "reassign");
                            
                            j$.extend( true, j$.fn.dataTable.defaults, {
                                
                                "searching": false,
                                "ordering": true,
                                "order": sorting,
                                "bLengthChange": false,
                                "bFilter": true,
                                "bInfo": false,
                                "pagingType" : "full",
                                "autoWidth": false,
                                "bSort": false,
                                "destroy": true,
                                "responsive": true,
                                "stateSave": false,
								"aoColumnDefs": [
									{ 'bSortable': false, 'aTargets': [ 0 ] }
								],
                                "fnDrawCallback": function( settings ) {
                                    
                                    if(j$("#ReassignAddress").is(":checked")) 
                                        DisplayAddressFields(true, true, "reassign"); 
                                    else if(j$("#ReassignhmsView1").is(":checked")) 
                                        DisplayHmsView1(true, "reassign"); 
                                    else if(j$("#ReassignhmsView2").is(":checked")) 
                                        DisplayHmsView2(true, "reassign");
                                    else if(j$("#ReassignhmsView").is(":checked")) 
                                        DisplayHmsView(true, "reassign");
                                }
                            } );
                            
                            var referralsTableReference = j$('.reassignReferralTable').DataTable();  
                            j$('#reassignReferralTable_paginate').hide(); 
                            var page;
                            var info = referralsTableReference.page.info();
                            if(pageNumber != 0){
                                page = pageNumber + 1;
                            }
                            else{
                               
                                page = info.page + 1;
                            }
							if(info.pages == pageNumber){
								pageNumber = pageNumber - 1;
							}
                          //  var info = referralsTableReference.page.info();
                           // var page = info.page+1;
                            
                            if(page == 1) {
                                
                                j$('#firstBtnReassign').attr('disabled', 'disabled');
                                j$('#preBtnReassign').attr('disabled', 'disabled');
                                
                                if(page != info.pages && info.pages > 1) {
                                    
                                    j$('#nxtBtnReassign').removeAttr('disabled');
                                    j$('#endBtnReassign').removeAttr('disabled');
                                }
                                
                                if(j$("#ReassignAddress").is(":checked")) 
                                    DisplayAddressFields(true, true, "reassign"); 
                                else if(j$("#ReassignhmsView1").is(":checked")) 
                                    DisplayHmsView1(true, "reassign"); 
                                else if(j$("#ReassignhmsView2").is(":checked")) 
                                    DisplayHmsView2(true, "reassign");
                                else if(j$("#ReassignhmsView").is(":checked")) 
                                    DisplayHmsView(true, "reassign");
                            }
                            else if(page > 1 && page != info.pages && info.pages > 1) {
                                
                                j$('#firstBtnReassign').removeAttr('disabled');
                                j$('#preBtnReassign').removeAttr('disabled');
                            }
                            
                            if(page == info.pages || info.pages <= 1) {
                                
                                j$('#nxtBtnReassign').attr('disabled', 'disabled');
                                j$('#endBtnReassign').attr('disabled', 'disabled');
                                
                                if(page > 1) {
                                    
                                    j$('#firstBtnReassign').removeAttr('disabled');
                                    j$('#preBtnReassign').removeAttr('disabled');
                                }
                            }
                            else if(info.pages > 1) {
                                
                                j$('#nxtBtnReassign').removeAttr('disabled');
                                j$('#endBtnReassign').removeAttr('disabled');
                                
                                if((result.lstAccounts.length + result.lstContacts.length) > 2000)
                                    j$('#endBtnReassign').attr("disabled",true); 
                            }
                            
                            j$('.reassignReferralTable').on('page.dt', function() {
                                j$('#reassignReferralTable_paginate').hide();
                                var referralsTableReference = j$('.reassignReferralTable').DataTable();  
                                var info = referralsTableReference.page.info();
                                var page = info.page+1;
                                
                                if(j$("#ReassignAddress").is(":checked")) 
                                    DisplayAddressFields(true, true, "reassign"); 
                                else if(j$("#ReassignhmsView1").is(":checked")) 
                                    DisplayHmsView1(true, "reassign"); 
                                else if(j$("#ReassignhmsView2").is(":checked")) 
                                    DisplayHmsView2(true, "reassign");
                                else if(j$("#ReassignhmsView").is(":checked")) 
                                    DisplayHmsView(true, "reassign");
                                    
                                if(page == 1) {
                                
                                    j$('#firstBtnReassign').attr('disabled', 'disabled');
                                    j$('#preBtnReassign').attr('disabled', 'disabled');
                                    
                                    if(page != info.pages && info.pages > 1) {
                                        
                                        j$('#nxtBtnReassign').removeAttr('disabled');
                                        j$('#endBtnReassign').removeAttr('disabled');
                                    }
                                }
                                else if(page > 1 && page != info.pages && info.pages > 1) {
                                    
                                    j$('#firstBtnReassign').removeAttr('disabled');
                                    j$('#preBtnReassign').removeAttr('disabled');
                                }
                                
                                if(page == info.pages || info.pages <= 1) {
                                    
                                    j$('#nxtBtnReassign').attr('disabled', 'disabled');
                                    j$('#endBtnReassign').attr('disabled', 'disabled');
                                    
                                    if(page > 1) {
                                        
                                        j$('#firstBtnReassign').removeAttr('disabled');
                                        j$('#preBtnReassign').removeAttr('disabled');
                                    }
                                }
                                else if(info.pages > 1) {
                                    
                                    j$('#nxtBtnReassign').removeAttr('disabled');
                                    j$('#endBtnReassign').removeAttr('disabled');
                                    
                                    if((result.lstAccounts.length + result.lstContacts.length) > 2000)
                                        j$('#endBtnReassign').attr("disabled",true); 
                                }
                            });
        
                            j$('#reassignReferralAllAssignTH').removeClass('tablesorter-header');
                            
                            j$('td[data-column="10"]').attr('class', 'tdBgColor');
                            j$('td[data-column="11"]').attr('class', 'tdBgColor');
                            j$('td[data-column="14"]').attr('class', 'tdBgColor');
                            j$('td[data-column="15"]').attr('class', 'tdBgColor');
                        }
                            
                    }   
                    else {
                        var varTimeout = 'timeout';
                        if((event.message).indexOf(varTimeout) > -1){
                            j$('#popupDivIdReassign').show();
                            j$('#divFormId').addClass("parentDisable");
                            window.scrollTo(0,0);
                            stoploading();
                            
                        }
                        else{
                            alert('An error has occured in the page. '+event.message);
                            stoploading();
                        }
                    } 
                }, {buffer: false, escape: false, timeout: 120000});  
                setTimeout('stoploading()',1000);
                setTimeout(function(){if(pageNumber != 0){
                    j$('#reassignReferralTable_paginate').hide();
                    j$('.reassignReferralTable').dataTable({
                    }).fnPageChange(pageNumber,true);
                }},800);
                
            }
            catch(err) { 
                                        
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }
        }
    
    
        function getReferralSourcesTableSorter(sorterFieldId, dataColNumber, ariaSortVal, isSort, strSpecilaityFilterValue, whereQueryAccount, whereQueryContact, onTableLoad, isTypeFilter, selectedUser, selReferralFilter, strSourcefilter, selsecondReferralFilter, resetFilters, pageNumber) {
             
            try {
				
                if(selectedUser == undefined)
                    selectedUser = j$('[id$=inputUser_HiddenSalesRep]').val();
                
                var dataColNumber = dataColNumber;  
                
                j$("#userSearchTextPanelDiv").hide();
                document.getElementById('lstOption1').style.display = "none";
                document.getElementById('lstOption2').style.display = "none";
                document.getElementById("fromUserHeadingDiv").innerHTML = '';
                
                var selectedOption = document.getElementById('idSelectlist');
                if(ariaSortVal == undefined) 
                    ariaSortVal = 'ascending';
				
                TBN_AssociateDataManagementController.fetchReferralSourcesTableSorter(sorterFieldId, ariaSortVal, strSpecilaityFilterValue, whereQueryAccount, whereQueryContact, onTableLoad, isTypeFilter, selectedUser, selReferralFilter, strSourcefilter, selsecondReferralFilter, 
                
                function(result, event) { 
                    if(event.type != 'exception') {
                        processTableResult(result, onTableLoad, ariaSortVal, dataColNumber, pageNumber);
                    }
                    else {
                        getReferralSourcesTableSorter2(sorterFieldId, dataColNumber, ariaSortVal, isSort, strSpecilaityFilterValue, whereQueryAccount, whereQueryContact, onTableLoad, isTypeFilter, selectedUser, selReferralFilter, strSourcefilter, selsecondReferralFilter, resetFilters, pageNumber);
                    }
                }, { buffer: false, escape: false, timeout: 1000}); 
                
            }
            catch(err) {
                                        
                alert('An error has occured in the page.');
            }   
            finally {
                
            }
        }
        
        function processTableResult(result, onTableLoad, ariaSortVal, dataColNumber, pageNumber) {
            if(result != null && ((result.lstAccounts == null || result.lstAccounts.length == 0) && 
                                (result.lstContacts == null || result.lstContacts.length == 0)) && result.errMessage == 'showError Message') {
                            
                j$("#tableBody").html('');
                
                j$('#allSelectDivMsgId').hide();
                j$('#referralsTableForSort').hide();
                j$('#referralTableDiv').hide(); 
                j$('#noHomeFacilityMsg').show();
                j$('#noRreferralsMsg').hide();
                j$('#referralPaginaitionButtons').hide();
                j$('#recordCountMessage').hide();
                //setTimeout('stoploading()', 2000);
                stoploading();
                
            }
            else if(result == null || ((result.lstAccounts == null || result.lstAccounts.length == 0) && 
                                            (result.lstContacts == null || result.lstContacts.length == 0))) {
                
                j$("#tableBody").html('');
                j$('#noRreferralsMsg').show();
                j$('#noHomeFacilityMsg').hide();
                j$('#allSelectDivMsgId').hide();
                j$('#referralPaginaitionButtons').hide();
                j$('#recordCountMessage').hide();
              
                stoploading();   
            }
            else {
                
                var tableData = formReferralSourcesData(result, onTableLoad);
                j$('#referralPaginaitionButtons').show();
                var sorting;
                
                if(ariaSortVal == 'none')  {
                    
                    sorting = [[dataColNumber, ((ariaSortVal == 'none') ? 'asc' : 'desc')]];
                }
                else    
                    sorting = [[dataColNumber, ((ariaSortVal == 'ascending') ? 'asc' : 'desc')]]; 
				
				j$('.referralsTableForSort').dataTable({
                }).fnDestroy();
				 
                j$("#tableBody").html(tableData); 
                j$('#allSelectDivMsgId').hide();
                
                var varRecursionHadler = true;
                j$.extend( true, j$.fn.dataTable.defaults, {
                    
				
                    "searching": false,
                    "ordering": true,
                    "order": sorting,
                    "bLengthChange": false,
                    "bFilter": true,
                    "bInfo": false,
                    "pagingType" : "full",
                    "autoWidth": false,
                    "bSort": false,
                    "responsive": true,
					"aoColumnDefs": [
						{ 'bSortable': false, 'aTargets': [ 0 ] }
					],
                    "fnDrawCallback": function( settings ) {
                        
                        if(j$("#Address").is(":checked")) 
                            DisplayAddressFields(true, true, "assign"); 
                        
                        else if(j$("#hmsView1").is(":checked")) 
                            DisplayHmsView1(true, "assign");  
                        
                        else if(j$("#hmsView2").is(":checked")) 
                            DisplayHmsView2(true, "assign");
                            
                        else if(j$("#hmsView").is(":checked")) 
                            DisplayHmsView(true, "assign");
                            
                        else if(j$("#SysId").is(":checked")) 
                            DisplayHMSSystemIds(true, "assign");    
                    }
                } );
                
                var referralsTableReference = j$('.referralsTableForSort').DataTable(); 
				j$('#referralsTableForSort_paginate').hide(); 
                
                var page;
                var info = referralsTableReference.page.info();
                
                if(pageNumber != 0){
                    page = pageNumber + 1;
                }
                else{
                   
                    page = info.page + 1;
                }
                if(info.pages == pageNumber){
                    pageNumber = pageNumber - 1;
                    
                }
                if(page == 1) { 
                    j$('#firstBtn').attr('disabled', 'disabled');
                    j$('#preBtn').attr('disabled', 'disabled');
                    
                    if(page != info.pages && info.pages > 1) {
                        j$('#nxtBtn').removeAttr('disabled');
                        j$('#endBtn').removeAttr('disabled');
                    }
                    
                    if(j$("#Address").is(":checked")) 
                        DisplayAddressFields(true, true, "assign"); 
                        
                    else if(j$("#hmsView1").is(":checked")) 
                        DisplayHmsView1(true, "assign"); 
                        
                    else if(j$("#hmsView2").is(":checked")) 
                        DisplayHmsView2(true, "assign");
                        
                    else if(j$("#hmsView").is(":checked")) 
                        DisplayHmsView(true, "assign");
                    
                    else if(j$("#SysId").is(":checked")) 
                        DisplayHMSSystemIds(true, "assign");     
                }
                else if(page > 1 && page != info.pages && info.pages > 1) {
                    
                    j$('#firstBtn').removeAttr('disabled');
                    j$('#preBtn').removeAttr('disabled');
                }
                
                if(page == info.pages || info.pages <= 1) {
                    j$('#nxtBtn').attr('disabled', 'disabled');
                    j$('#endBtn').attr('disabled', 'disabled');
                    
                    if(page > 1) {
                        j$('#firstBtn').removeAttr('disabled');
                        j$('#preBtn').removeAttr('disabled');
                    }
                }
                else if(info.pages > 1) {
                    j$('#nxtBtn').removeAttr('disabled');
                    j$('#endBtn').removeAttr('disabled');
                    
                    if((result.lstAccounts.length + result.lstContacts.length) > 2000)
                        j$('#endBtn').attr("disabled",true); 
                }
                
				
                j$('.referralsTableForSort').on('page.dt', function() {
                    
					var referralsTableReference = j$('.referralsTableForSort').DataTable(); 
                    var info = referralsTableReference.page.info();
                    var page = info.page+1;
                    if(page == 1) {
                        j$('#firstBtn').attr('disabled', 'disabled');
                        j$('#preBtn').attr('disabled', 'disabled');
                        
                        if(page != info.pages && info.pages > 1) {
                            j$('#nxtBtn').removeAttr('disabled');
                            j$('#endBtn').removeAttr('disabled');
                        }
                        
                        if(j$("#Address").is(":checked")) 
                            DisplayAddressFields(true, true, "assign"); 
                            
                        else if(j$("#hmsView1").is(":checked")) 
                            DisplayHmsView1(true, "assign"); 
                            
                        else if(j$("#hmsView2").is(":checked")) 
                            DisplayHmsView2(true, "assign");
                            
                        else if(j$("#hmsView").is(":checked")) 
                            DisplayHmsView(true, "assign");
                        
                        else if(j$("#SysId").is(":checked")) 
                            DisplayHMSSystemIds(true, "assign");     
                    }
                    else if(page > 1 && page != info.pages && info.pages > 1) {
                        j$('#firstBtn').removeAttr('disabled');
                        j$('#preBtn').removeAttr('disabled');
                    }
                    
                    if(page == info.pages || info.pages <= 1) {
                        j$('#nxtBtn').attr('disabled', 'disabled');
                        j$('#endBtn').attr('disabled', 'disabled');
                        
                        if(page > 1) {
                            j$('#firstBtn').removeAttr('disabled');
                            j$('#preBtn').removeAttr('disabled');
                        }
                    }
                    else if(info.pages > 1) {
                        j$('#nxtBtn').removeAttr('disabled');
                        j$('#endBtn').removeAttr('disabled');
                        
                        if((result.lstAccounts.length + result.lstContacts.length) > 2000)
                            j$('#endBtn').attr("disabled",true); 
                    }
                }).on('order.dt', function(e){
                    e.preventDefault();
                    e.stopPropagation();
                    return false;
                });
                
                if(j$("#Address").is(":checked")) DisplayAddressFields(true, true, "assign"); else if(j$("#hmsView1").is(":checked")) DisplayHmsView1(true, "assign"); else if(j$("#hmsView2").is(":checked")) DisplayHmsView2(true, "assign");else if(j$("#hmsView").is(":checked")) DisplayHmsView(true, "assign"); else if(j$("#SysId").is(":checked")) DisplayHMSSystemIds(true, "assign");
                if(onTableLoad == 'true')   
                    j$('.referralsTableForSort').children().children().next().children().children().val('');

                j$('td[data-column="10"]').attr('class', 'tdBgColor');
                j$('td[data-column="11"]').attr('class', 'tdBgColor');
                j$('td[data-column="14"]').attr('class', 'tdBgColor');
                j$('td[data-column="15"]').attr('class', 'tdBgColor');
                j$('#referralAllAssignTH').removeClass('tablesorter-header');
                
                j$('.referralsTableForSort').dataTable({}).fnPageChange(pageNumber,true);
                toggleHeaderCheckboxReferrals(); 
                //setTimeout('stoploading()',5000);
                stoploading();
                j$('#confirmAssignment').delay(6000).fadeOut();
            }
        }
        
        function toggleHeaderCheckboxReferrals() {
            
            try {
                
                j$( ".notAssignedtoUser" ).each(function() {
                    
                    j$(this).prop("checked", false);
                });
                j$( ".assignedToUser" ).each(function() {
                    
                    j$(this).prop("checked", true);
                });
                
                setTimeout(function(){

                    if(j$(".CheckboxAssignment:visible").length == j$(".CheckboxAssignment:checked:visible").length) {
                    j$("#referralAllAssign").prop('checked', true);
                    } else {
                    j$("#referralAllAssign").removeAttr("checked");
                    }
                },600);
            }
            catch(err) {
                                        
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }
        }
    
        var strToBeSaved = '';  
           
        function onFromUserSelect(selectedUserFrom) {
            
            try {
                loading();
                j$('#reassignUser').blur();
                j$('#tabsDivs').css('display', 'block');
                onReassignmentSelect(selectedUserFrom);
            }
            catch(err) {
                                        
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }
        }
            
        function formReferralSourcesData(result, onTableLoad) {
            
            try {
                var countOfRecords = 1;
                var tableData = '';
                var isAllChecked = true;
                var isAccountTeamMemberStyle = 'blank';
                var recCountForPagination = 0; 
                
                if( result != null ) {
						if( result.lstAccounts.length == 0 && result.lstContacts.length == 0 ) { 
                          if(onTableLoad == 'true') {
                            j$('#referralTableDiv').hide();
                        }
                    }
                    else {
                        j$('#referralTableDiv').show();
                        j$('#noRreferralsMsg').hide();
                    }
                    
                    if(result.lstAccounts.length == 0 && result.lstContacts.length == 0) {
                        
                        j$('#referralTableDiv').hide();
                        j$('#noRreferralsMsg').show();
                    }
                    else {
                        
                        j$('#noHomeFacilityMsg').hide();
                        tableData += formAccountsData(result.lstAccounts, result.lstATMsAssigned, result.lstATMsIcons);
                        tableData += formContactsData(result.lstContacts, result.lstCTMsAssigned, result.lstCTMsIcons);
                        if((result.lstAccounts.length + result.lstContacts.length)  > 2000) {
                            
                            if(j$('#endBtn').is(":visible")){
                                
                                j$('#endBtn').attr("disabled",true);
                            }
                            
                            j$('#recordCountMessage').show();
                            j$('#endBtn').attr("disabled",true);
                        }
                        else {
                            
                            j$('#endBtn').attr("disabled",false);
                            j$('#recordCountMessage').hide();
                            j$('#nxtBtn').attr("disabled",false);
                        }
                    }
                }
                else {
                    j$('#referralTableDiv').hide();
                    j$('#noRreferralsMsg').show();
                }
                
                return tableData;
            }
            catch(err) {
                                        
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }
        }
    
        function formContactsData(Contacts, CTMsAssigned, CTMsIcons) {
            
            try {
                var tableData = '';
                
                for(var i=0; i< Contacts.length; i++) {
                    
                    var contact = Contacts[i];
                    var strLastName = contact.LastName;
                    var strName;
                    strLastName = strLastName.replace(',', " ");
                    
                    if(contact.FirstName != undefined) {
                        
                        var strFirstName = contact.FirstName;
                        strFirstName = strFirstName.replace(',', " ");
                        strName = strLastName+', '+strFirstName;
                    }
                    else
                        strName = strLastName;
                    
                    var isAssignVal = (JSON.stringify(CTMsAssigned).indexOf(contact.Id) > -1);
                    tableData += '<tr class="tableFilterRow"><td width="10%" id="' +contact.Id+ '-' + isAssignVal + '-false">';
                    
                    if(isAssignVal == true) {
                    
                        tableData += '<input type="checkbox" class="CheckboxAssignment assignedToUser CheckboxAssignmentReassign" id="' + contact.Id + '" onmousedown="toggleInputCheckbox();" value="'+isAssignVal+'" ' + 
                                    ((isAssignVal) ? ('checked="' +isAssignVal+ '"') : '') + '/>';
                        tableData += '</td>';
                    }
                    else if(isAssignVal == false) {
                        tableData += '<input type="checkbox" class="CheckboxAssignment notAssignedtoUser" id="' + contact.Id + '" onmousedown="toggleInputCheckbox();" value="'+isAssignVal+'" ' + 
                                    ((isAssignVal) ? ('checked="' +isAssignVal+ '"') : '') + '/>';
                        tableData += '</td>';
                    }
                    
                    isContactTeamMemberStyle = (JSON.stringify(CTMsIcons).indexOf(contact.Id) > -1) ? 'blank' : 'none';
                    tableData += '<td> <a href = "/' +contact.Id+ '" target="_blank">' +strName+  '</a> <img src="/img/icon/profile16.png" style="display:'+isContactTeamMemberStyle+'" onclick="showAccountTeamMembers(\''+contact.Id+'\');"/></td>';
                    
                    var strNPI = contact.NPI__c != undefined ? contact.NPI__c : '';
                        tableData +='<td class = "classAddress">'+strNPI+'</td>';
                        
                    var strShippingStreet = contact.MailingStreet != undefined ? contact.MailingStreet: '';
                        tableData +='<td  class = "classAddress">'+strShippingStreet+'</td>';    
                        
                    var strShippingCity = contact.MailingCity != undefined ? contact.MailingCity :''; 
                        tableData +='<td class = "classAddress">'+strShippingCity+'</td>';
                        
                    var strShippingState = contact.MailingState != undefined ?  contact.MailingState : '';
                        tableData +='<td  class = "classAddress">'+strShippingState+'</td>';
                        
                    var strShippingPostalCode = contact.MailingPostalCode != undefined ? contact.MailingPostalCode: '';
                        tableData +='<td  class = "classAddress">'+strShippingPostalCode+'</td>';
                        
                    var strType = 'Contact';
                         tableData +='<td  class = "classAddress" id="' +contact.Id+ 'Type">'+strType+'</td>';   
                        
                    var strSpecialties = contact.Specialties__c != undefined ? contact.Specialties__c :'';
                         tableData +='<td class = "classAddress" style="word-wrap: break-word;word-break: break-word;">'+strSpecialties+'</td>';

                    var KAHTotalPatientVolumeDr = contact.KAH_HMS_Total_Patient_Volume_DR__c != undefined ? contact.KAH_HMS_Total_Patient_Volume_DR__c : '';
                        tableData +='<td  class = "clsHMS1">'+KAHTotalPatientVolumeDr+'</td>';
                        
                   /* var KAHHMSDischargeVolumeDecileranking = contact.HMS_Discharge_Volume_Decile_ranking__c != undefined ? contact.HMS_Discharge_Volume_Decile_ranking__c : '';
                        tableData +='<td  class = "clsHMS1">'+KAHHMSDischargeVolumeDecileranking+'</td>'; */
                            
                    var KAHHHAdmitsYTD = contact.KAH_HH_Admits_YTD__c != undefined ? contact.KAH_HH_Admits_YTD__c : '';
                        tableData +='<td  class = "clsHMS1 tdBgColor">'+KAHHHAdmitsYTD+'</td>';  
                        
                    var KAHHHAdmitsPY = contact.HH_Admits_PY__c != undefined ? contact.HH_Admits_PY__c : '';
                        tableData +='<td  class = "clsHMS1 tdBgColor">'+KAHHHAdmitsPY+'</td>'; 
                        
                    var KAHHPAdmitsYTD = contact.KAH_HP_Admits_YTD__c != undefined ? contact.KAH_HP_Admits_YTD__c : '';
                        tableData +='<td  class = "clsHMS1">'+KAHHPAdmitsYTD+'</td>';    
                        
                    var KAHHPAdmitsPY = contact.HP_Admits_PY__c != undefined ? contact.HP_Admits_PY__c : '';
                        tableData +='<td  class = "clsHMS1">'+KAHHPAdmitsPY+'</td>'; 
                        
                    var KAHHDAdmitsYTD = contact.KAH_HD_Admits_YTD__c != undefined ? contact.KAH_HD_Admits_YTD__c : '';
                        tableData +='<td  class = "clsHMS1 tdBgColor">'+KAHHDAdmitsYTD+'</td>';  
                        
                    var KAHHDAdmitsPY = contact.HD_Admits_PY__c != undefined ? contact.HD_Admits_PY__c : '';
                        tableData +='<td  class = "clsHMS1 tdBgColor">'+KAHHDAdmitsPY+'</td>'; 
                    
                    var KAHNCDAdmitsYTD = contact.KAH_NCD_Admits_YTD__c != undefined ? contact.KAH_NCD_Admits_YTD__c : '';
                        tableData +='<td  class = "clsHMS1">'+KAHNCDAdmitsYTD+'</td>';    
                        
                    var KAHNCDAdmitsPY = contact.NCD_Admits_PY__c != undefined ? contact.NCD_Admits_PY__c : '';
                        tableData +='<td  class = "clsHMS1">'+KAHNCDAdmitsPY+'</td>';    
                    
                    var KAHHHPPSPriorYearAdmits = contact.KAH_HH_PPS_Prior_Year_Admits_Prior__c != undefined ? contact.KAH_HH_PPS_Prior_Year_Admits_Prior__c : '';
                        tableData +='<td  class = "clsHMS2">'+KAHHHPPSPriorYearAdmits+'</td>';  
                        
                    var KAHHHAdmitsYTD = contact.KAH_HH_Admits_YTD__c != undefined ? contact.KAH_HH_Admits_YTD__c : '';
                        tableData +='<td  class = "clsHMS2">'+KAHHHAdmitsYTD+'</td>'; 
                        
                    var KAHHHReferralsYTD = contact.KAH_HH_Referrals_YTD__c != undefined ? contact.KAH_HH_Referrals_YTD__c : '';
                        tableData +='<td  class = "clsHMS2">'+KAHHHReferralsYTD+'</td>'; 
                    
                    var KAHTotalPatientVolumeDr1 = contact.KAH_HMS_Total_Patient_Volume_DR__c != undefined ? contact.KAH_HMS_Total_Patient_Volume_DR__c : '';
                        tableData +='<td  class = "clsHMS2">'+KAHTotalPatientVolumeDr1+'</td>';
                        
                    var KAHAllHHDr = contact.KAH_HMS_All_HH_DR__c != undefined ? contact.KAH_HMS_All_HH_DR__c : '';         
                        tableData +='<td  class = "clsHMS2">'+KAHAllHHDr+'</td>'; 
                        
                    var KAHHHCancerBoldVascularDr = contact.KAH_HMS_HH_Cancer_Bold_Vascular_DR__c != undefined ? contact.KAH_HMS_HH_Cancer_Bold_Vascular_DR__c : '';
                        tableData +='<td class = "clsHMS2">'+KAHHHCancerBoldVascularDr+'</td>';
                        
                    var HMSCCS = contact.KAH_HMS_HH_CHF_Stroke_COPD_DR__c != undefined ? contact.KAH_HMS_HH_CHF_Stroke_COPD_DR__c :'';
                        tableData +='<td class = "clsHMS2">'+HMSCCS+'</td>';      
                        
                    var KAHHHEndoWoundsDr = contact.KAH_HMS_HH_Endo_Wounds_DR__c != undefined ? contact.KAH_HMS_HH_Endo_Wounds_DR__c : '';
                        tableData +='<td class = "clsHMS2">'+KAHHHEndoWoundsDr+'</td>';
                        
                    var KAHHHUrinaryKidneyGiDr = contact.KAH_HMS_HH_Urinary_Kidney_GI_DR__c != undefined ? contact.KAH_HMS_HH_Urinary_Kidney_GI_DR__c : '';
                        tableData +='<td class = "clsHMS2">'+KAHHHUrinaryKidneyGiDr+'</td>'; 
                        
                    var KAHHHOrthoDr = contact.KAH_HMS_HH_Ortho_DR__c != undefined ? contact.KAH_HMS_HH_Ortho_DR__c : '';
                        tableData +='<td  class = "clsHMS2">'+KAHHHOrthoDr+'</td>';                            

                    var KAHHPPPSPriorYearAdmitsPrior = contact.KAH_HP_PPS_Prior_Year_Admits_Prior__c != undefined ? contact.KAH_HP_PPS_Prior_Year_Admits_Prior__c :'';
                        tableData +='<td class = "clsHMS">'+KAHHPPPSPriorYearAdmitsPrior+'</td>';
                        
                    var KAHHPReferralsYTD = contact.KAH_HP_Referrals_YTD__c != undefined ? contact.KAH_HP_Referrals_YTD__c : '';
                        tableData +='<td  class = "clsHMS">'+KAHHPReferralsYTD+'</td>'; 

					var KAHHPAdmitsPY = contact.KAH_HP_Admits_YTD__c != undefined ? contact.KAH_HP_Admits_YTD__c : '';
                        tableData +='<td  class = "clsHMS">'+KAHHPAdmitsPY+'</td>';                         
                    
					var KAHHPLOS = contact.KAH_HMS_HP_LOS__c != undefined ? contact.KAH_HMS_HP_LOS__c : '';
                        tableData +='<td  class = "clsHMS">'+KAHHPLOS+'</td>';   
					
                    var KAHTotalPatientVolumeDr2 = contact.KAH_HMS_Total_Patient_Volume_DR__c != undefined ? contact.KAH_HMS_Total_Patient_Volume_DR__c : '';
                        tableData +='<td  class = "clsHMS">'+KAHTotalPatientVolumeDr2+'</td>';
                        
                    var KAHAllHPDr = contact.KAH_HMS_All_HP_DR__c != undefined ? contact.KAH_HMS_All_HP_DR__c : '';
                        tableData +='<td class = "clsHMS">'+KAHAllHPDr+'</td>';
                        
                    var KAHHPInfluencerNetworkDr =  contact.KAH_HMS_HP_Influencer_Network_DR__c != undefined ? contact.KAH_HMS_HP_Influencer_Network_DR__c : '';
                        tableData +='<td  class = "clsHMS">'+KAHHPInfluencerNetworkDr+'</td>';
                    
                    var KAHHPCancerDr = contact.KAH_HMS_HP_Cancer_DR__c != undefined ? contact.KAH_HMS_HP_Cancer_DR__c :'';
                        tableData +='<td class = "clsHMS">'+KAHHPCancerDr+'</td>'; 
                        
                    var KAHHPChfDr =  contact.KAH_HMS_HP_CHF_DR__c != undefined ? contact.KAH_HMS_HP_CHF_DR__c : '';
                        tableData +='<td class = "clsHMS">'+KAHHPChfDr+'</td>';
                        
                    var KAHHPCopdDr = contact.KAH_HMS_HP_COPD_DR__c != undefined ? contact.KAH_HMS_HP_COPD_DR__c : '';
                        tableData +='<td class = "clsHMS">'+KAHHPCopdDr+'</td>';
                        
                    var KAHHPDementiaDr = contact.KAH_HMS_HP_Dementia_DR__c != undefined ? contact.KAH_HMS_HP_Dementia_DR__c : '';
                        tableData +='<td class = "clsHMS">'+KAHHPDementiaDr+'</td>';     
                        
                    var KAHHPdebilityDr = contact.KAH_HMS_HP_Debility_DR__c != undefined ? contact.KAH_HMS_HP_Debility_DR__c : '';
                        tableData +='<td  class = "clsHMS">'+KAHHPdebilityDr+'</td>';
                        
                    var KAHId = contact.Id != undefined ? contact.Id : '';
                    KAHId = KAHId.substring(0, KAHId.length - 3);
                        tableData +='<td  class = "clsHMSIDs">'+KAHId+'</td>';
                        
                    var KAHNPI = contact.NPI__c != undefined ? contact.NPI__c : '';
                        tableData +='<td  class = "clsHMSIDs">'+KAHNPI+'</td>';
                        
                    var KAHHMSId = contact.HMS_PIID__c != undefined ? contact.HMS_PIID__c : '';
                        tableData +='<td  class = "clsHMSIDs">'+KAHHMSId+'</td>';
                    
                    var KAHHPASId = contact.HPAS_Contact_ID__c != undefined ? contact.HPAS_Contact_ID__c : '';
                        tableData +='<td  class = "clsHMSIDs">'+KAHHPASId+'</td>';

                    var KAHHMSHorizonId = contact.Horizon_ID__c != undefined ? contact.Horizon_ID__c : '';
                        tableData +='<td  class = "clsHMSIDs">'+KAHHMSHorizonId+'</td>';

                    var KAHHMSMeditechId = contact.Meditech_Contact_ID__c != undefined ? contact.Meditech_Contact_ID__c : '';
                        tableData +='<td  class = "clsHMSIDs">'+KAHHMSMeditechId+'</td>';   

                    var KAHHMSUnityId = contact.Unity_ID__c != undefined ? contact.Unity_ID__c : '';
                        tableData +='<td  class = "clsHMSIDs">'+KAHHMSUnityId+'</td>';  
                }
                
                return tableData;
            }
            catch(err) {
                                        
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }
        }
    
        function formAccountsData( Accounts, ATMsAssigned, ATMsIcons ) {
                
            try { 
                var tableData = '';
            
                for(var i=0; i< Accounts.length; i++) {
                    
                    var account = Accounts[i];
                    var strName = account.Name;
                    var strNameLen = strName.length;
                    if(strName.indexOf(',') > -1){
                        if((strName.indexOf(',') == 0) || (strName.indexOf(',') == strNameLen-1)){
                            strName = strName.replace(',', "");
                        }
                    }
                    var isAssignVal = (JSON.stringify(ATMsAssigned).indexOf(account.Id) > -1);
                    tableData += '<tr class="tableFilterRow"><td width="10%" id="' +account.Id+ '-' + isAssignVal + '-false">';
                    
                    if(isAssignVal == true){
                        
                        tableData += '<input type="checkbox" class="CheckboxAssignment assignedToUser CheckboxAssignmentReassign" id="' + account.Id + '" onmousedown="toggleInputCheckbox();" value="'+isAssignVal+'" ' + 
                                    ((isAssignVal) ? ('checked="' +isAssignVal+ '"') : '') + '/>';
                        tableData += '</td>';
                    }
                    
                    else if(isAssignVal == false){
                     
                        tableData += '<input type="checkbox" class="CheckboxAssignment notAssignedtoUser" id="' + account.Id + '" onmousedown="toggleInputCheckbox();" value="'+isAssignVal+'" ' + 
                                    ((isAssignVal) ? ('checked="' +isAssignVal+ '"') : '') + '/>';
                        tableData += '</td>';
                    }
                    
                    isAccountTeamMemberStyle = (JSON.stringify(ATMsIcons).indexOf(account.Id) > -1) ? 'blank' : 'none';
                    tableData += '<td> <a href = "/' +account.Id+ '" target="_blank">' +strName+  '</a> <img src="/img/icon/profile16.png" style="display:'+isAccountTeamMemberStyle+'" onclick="showAccountTeamMembers(\''+account.Id+'\');"/></td>';
                    
                    var strNPI = account.NPI__c != undefined ? account.NPI__c : '';
                        tableData +='<td class = "classAddress">'+strNPI+'</td>';
                        
                    var strShippingStreet = account.ShippingStreet != undefined ? account.ShippingStreet: '';
                        tableData +='<td  class = "classAddress">'+strShippingStreet+'</td>';    
                        
                    var strShippingCity = account.ShippingCity != undefined ? account.ShippingCity :''; 
                        tableData +='<td class = "classAddress">'+strShippingCity+'</td>';
                     
                    var strShippingState = account.ShippingState != undefined ?  account.ShippingState : '';
                        tableData +='<td  class = "classAddress">'+strShippingState+'</td>';
                        
                    var strShippingPostalCode = account.ShippingPostalCode != undefined ? account.ShippingPostalCode: '';
                        tableData +='<td  class = "classAddress">'+strShippingPostalCode+'</td>';
                        
                    var strType = 'Account';
                         tableData +='<td  class = "classAddress" id="' +account.Id+ 'Type">'+strType+'</td>';   
                         tableData +='<td class = "classAddress">&nbsp;</td>';
                    
                    var KAHTotalPatientVolumeDr = account.KAH_HMS_Total_Patient_Volume_DR__c != undefined ? account.KAH_HMS_Total_Patient_Volume_DR__c : '';
                        tableData +='<td  class = "clsHMS1">'+KAHTotalPatientVolumeDr+'</td>';
          
                   /* var KAHHMSDischargeVolumeDecileranking = account.HMS_Discharge_Volume_Decile_ranking__c != undefined ? account.HMS_Discharge_Volume_Decile_ranking__c : '';
                        tableData +='<td  class = "clsHMS1">'+KAHHMSDischargeVolumeDecileranking+'</td>'; */
                            
                    var KAHHHAdmitsYTD = account.KAH_HH_Admits_YTD__c != undefined ? account.KAH_HH_Admits_YTD__c : '';
                        tableData +='<td  class = "clsHMS1 tdBgColor">'+KAHHHAdmitsYTD+'</td>';  
                        
                    var KAHHHAdmitsPY = account.HH_Admits_PY__c != undefined ? account.HH_Admits_PY__c : '';
                        tableData +='<td  class = "clsHMS1 tdBgColor">'+KAHHHAdmitsPY+'</td>'; 
                        
                    var KAHHPAdmitsYTD = account.KAH_HP_Admits_YTD__c != undefined ? account.KAH_HP_Admits_YTD__c : '';
                        tableData +='<td  class = "clsHMS1">'+KAHHPAdmitsYTD+'</td>';    
                        
                    var KAHHPAdmitsPY = account.HP_Admits_PY__c != undefined ? account.HP_Admits_PY__c : '';
                        tableData +='<td  class = "clsHMS1">'+KAHHPAdmitsPY+'</td>'; 
                        
                    var KAHHDAdmitsYTD = account.KAH_HD_Admits_YTD__c != undefined ? account.KAH_HD_Admits_YTD__c : '';
                        tableData +='<td  class = "clsHMS1 tdBgColor">'+KAHHDAdmitsYTD+'</td>';  
                        
                    var KAHHDAdmitsPY = account.HD_Admits_PY__c != undefined ? account.HD_Admits_PY__c : '';
                        tableData +='<td  class = "clsHMS1 tdBgColor">'+KAHHDAdmitsPY+'</td>'; 
                        
                    var KAHNCDAdmitsYTD = account.KAH_NCD_Admits_YTD__c != undefined ? account.KAH_NCD_Admits_YTD__c : '';
                        tableData +='<td  class = "clsHMS1">'+KAHNCDAdmitsYTD+'</td>';    
                        
                    var KAHNCDAdmitsPY = account.NCD_Admits_PY__c != undefined ? account.NCD_Admits_PY__c : '';
                        tableData +='<td  class = "clsHMS1">'+KAHNCDAdmitsPY+'</td>'; 
                    
                    var KAHHHPPSPriorYearAdmits = account.KAH_HH_PPS_Prior_Year_Admits_Prior__c != undefined ? account.KAH_HH_PPS_Prior_Year_Admits_Prior__c : '';
                        tableData +='<td  class = "clsHMS2">'+KAHHHPPSPriorYearAdmits+'</td>';  
    
                    var KAHHHAdmitsYTD = account.KAH_HH_Admits_YTD__c != undefined ? account.KAH_HH_Admits_YTD__c : '';
                        tableData +='<td  class = "clsHMS2">'+KAHHHAdmitsYTD+'</td>'; 
    
                    var KAHHHReferralsYTD = account.KAH_HH_Referrals_YTD__c != undefined ? account.KAH_HH_Referrals_YTD__c : '';
                        tableData +='<td  class = "clsHMS2">'+KAHHHReferralsYTD+'</td>'; 
                    
                    var KAHTotalPatientVolumeDr1 = account.KAH_HMS_Total_Patient_Volume_DR__c != undefined ? account.KAH_HMS_Total_Patient_Volume_DR__c : '';
                        tableData +='<td  class = "clsHMS2">'+KAHTotalPatientVolumeDr1+'</td>';
                        
                    var KAHAllHHDr = account.KAH_HMS_ALL_HH_DR__c != undefined ? account.KAH_HMS_ALL_HH_DR__c : '';                            
                        tableData +='<td  class = "clsHMS2">'+KAHAllHHDr+'</td>';
                        
                   var KAHHHCancerBoldVascularDr = account.KAH_HMS_HH_Cancer_Bold_Vascular_DR__c != undefined ? account.KAH_HMS_HH_Cancer_Bold_Vascular_DR__c : '';
                        tableData +='<td class = "clsHMS2">'+KAHHHCancerBoldVascularDr+'</td>';
                        
                   var HMSCCS = account.KAH_HMS_HH_CHF_Stroke_COPD_DR__c != undefined ? account.KAH_HMS_HH_CHF_Stroke_COPD_DR__c :'';
                        tableData +='<td class = "clsHMS2">'+HMSCCS+'</td>';      
                        
                   var KAHHHEndoWoundsDr = account.KAH_HMS_HH_Endo_Wounds_DR__c != undefined ? account.KAH_HMS_HH_Endo_Wounds_DR__c : '';
                        tableData +='<td class = "clsHMS2">'+KAHHHEndoWoundsDr+'</td>';
                        
                    var KAHHHUrinaryKidneyGiDr = account.KAH_HMS_HH_Urinary_Kidney_GI_DR__c != undefined ? account.KAH_HMS_HH_Urinary_Kidney_GI_DR__c : '';
                        tableData +='<td class = "clsHMS2">'+KAHHHUrinaryKidneyGiDr+'</td>'; 
                        
                     var KAHHHOrthoDr = account.KAH_HMS_HH_Ortho_DR__c != undefined ? account.KAH_HMS_HH_Ortho_DR__c : '';
                        tableData +='<td  class = "clsHMS2">'+KAHHHOrthoDr+'</td>';   
                    
                    var KAHHPPPSPriorYearAdmitsPrior = account.KAH_HP_PPS_Prior_Year_Admits_Prior__c != undefined ? account.KAH_HP_PPS_Prior_Year_Admits_Prior__c :'';
                        tableData +='<td class = "clsHMS">'+KAHHPPPSPriorYearAdmitsPrior+'</td>';
                        
                    var KAHHPReferralsYTD = account.KAH_HP_Referrals_YTD__c != undefined ? account.KAH_HP_Referrals_YTD__c : '';
                        tableData +='<td  class = "clsHMS">'+KAHHPReferralsYTD+'</td>'; 
                    
                    var KAHHPAdmitsPY = account.KAH_HP_Admits_YTD__c != undefined ? account.KAH_HP_Admits_YTD__c : '';
                        tableData +='<td  class = "clsHMS">'+KAHHPAdmitsPY+'</td>'; 
					
					tableData +='<td  class = "clsHMS">'+'&nbsp;'+'</td>'; 
					
                    var KAHTotalPatientVolumeDr2 = account.KAH_HMS_Total_Patient_Volume_DR__c != undefined ? account.KAH_HMS_Total_Patient_Volume_DR__c : '';
                        tableData +='<td  class = "clsHMS">'+KAHTotalPatientVolumeDr2+'</td>';
                        
                    var KAHAllHPDr = account.KAH_HMS_All_HP_DR__c != undefined ? account.KAH_HMS_All_HP_DR__c : '';
                        tableData +='<td class = "clsHMS">'+KAHAllHPDr+'</td>';
                        
                    var KAHHPInfluencerNetworkDr =  account.KAH_HMS_HP_Influencer_Network_DR__c != undefined ? account.KAH_HMS_HP_Influencer_Network_DR__c : '';
                        tableData +='<td  class = "clsHMS">'+KAHHPInfluencerNetworkDr+'</td>';
                    
                    var KAHHPCancerDr = account.KAH_HMS_HP_Cancer_DR__c != undefined ? account.KAH_HMS_HP_Cancer_DR__c :'';
                        tableData +='<td class = "clsHMS">'+KAHHPCancerDr+'</td>'; 
                        
                    var KAHHPChfDr =  account.KAH_HMS_HP_CHF_DR__c != undefined ? account.KAH_HMS_HP_CHF_DR__c : '';
                        tableData +='<td class = "clsHMS">'+KAHHPChfDr+'</td>';
                    
                    var KAHHPCopdDr = account.KAH_HMS_HP_COPD_DR__c != undefined ? account.KAH_HMS_HP_COPD_DR__c : '';
                        tableData +='<td class = "clsHMS">'+KAHHPCopdDr+'</td>';
                       
                    var KAHHPDementiaDr = account.KAH_HMS_HP_Dementia_DR__c != undefined ? account.KAH_HMS_HP_Dementia_DR__c : '';
                        tableData +='<td class = "clsHMS">'+KAHHPDementiaDr+'</td>';     
                        
                    var KAHHPdebilityDr = account.KAH_HMS_HP_Debility_DR__c != undefined ? account.KAH_HMS_HP_Debility_DR__c : '';
                        tableData +='<td  class = "clsHMS">'+KAHHPdebilityDr+'</td>';
                        
                    var KAHId = account.Id != undefined ? account.Id : '';
                    KAHId = KAHId.substring(0, KAHId.length - 3);
                        tableData +='<td  class = "clsHMSIDs">'+KAHId+'</td>';
                        
                    var KAHNPI = account.NPI__c != undefined ? account.NPI__c : '';
                        tableData +='<td  class = "clsHMSIDs">'+KAHNPI+'</td>';
                        
                    var KAHHMSId = account.HMS_POID__c != undefined ? account.HMS_POID__c : '';
                        tableData +='<td  class = "clsHMSIDs">'+KAHHMSId+'</td>';
                    
                    var KAHHPASId = account.HPAS_ID__c != undefined ? account.HPAS_ID__c : '';
                        tableData +='<td  class = "clsHMSIDs">'+KAHHPASId+'</td>';

                    var KAHHMSHorizonId = account.Horizon_ID__c != undefined ? account.Horizon_ID__c : '';
                        tableData +='<td  class = "clsHMSIDs">'+KAHHMSHorizonId+'</td>';

                    var KAHHMSMeditechId = account.Meditech_ID__c != undefined ? account.Meditech_ID__c : '';
                        tableData +='<td  class = "clsHMSIDs">'+KAHHMSMeditechId+'</td>';   

                    var KAHHMSUnityId = account.Unity_ID__c != undefined ? account.Unity_ID__c : '';
                        tableData +='<td  class = "clsHMSIDs">'+KAHHMSUnityId+'</td>';      
                }
                
                return tableData;
            }
            catch(err) {
                                        
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }
        }
        
        function formContactsDataReassign(Contacts, CTMsAssigned, CTMsIcons) {
            
            try {
                
                var tableData = '';
                
                for(var i=0; i< Contacts.length; i++) {
                    
                    var contact = Contacts[i];
                    var strLastName = contact.LastName;
                    var strName;
                    strLastName = strLastName.replace(',', " ");
                    
                    if(contact.FirstName != undefined) {
                        
                        var strFirstName = contact.FirstName;
                        strFirstName = strFirstName.replace(',', " ");
                        strName = strLastName+', '+strFirstName;
                    }
                    else
                        strName = strLastName;
                    
                    var isAssignVal = (JSON.stringify(CTMsAssigned).indexOf(contact.Id) > -1);
                    tableData += '<tr class="tableFilterRow"><td width="10%" id="' +contact.Id+ '-' + isAssignVal + '-false">';
                    
                    if(isAssignVal == true) {
                    
                        tableData += '<input type="checkbox" class="CheckboxAssignment assignedToUser CheckboxAssignmentReassign" id="' + contact.Id + '" onmousedown="toggleInputCheckbox();" value="'+isAssignVal+'" ' + 
                                    ((isAssignVal) ? ('checked="' +isAssignVal+ '"') : '') + '/>';
                        tableData += '</td>';
                    }
                    else if(isAssignVal == false) {
                        tableData += '<input type="checkbox" class="CheckboxAssignment notAssignedtoUser" id="' + contact.Id + '" onmousedown="toggleInputCheckbox();" value="'+isAssignVal+'" ' + 
                                    ((isAssignVal) ? ('checked="' +isAssignVal+ '"') : '') + '/>';
                        tableData += '</td>';
                    }
                    
                    isContactTeamMemberStyle = (JSON.stringify(CTMsIcons).indexOf(contact.Id) > -1) ? 'blank' : 'none';
                    tableData += '<td> <a href = "/' +contact.Id+ '" target="_blank">' +strName+  '</a> <img src="/img/icon/profile16.png" style="display:'+isContactTeamMemberStyle+'" onclick="showAccountTeamMembers(\''+contact.Id+'\');"/></td>';
                    
                    var strNPI = contact.NPI__c != undefined ? contact.NPI__c : '';
                        tableData +='<td class = "classAddress">'+strNPI+'</td>';
                        
                    var strShippingStreet = contact.MailingStreet != undefined ? contact.MailingStreet: '';
                        tableData +='<td  class = "classAddress">'+strShippingStreet+'</td>';    
                        
                    var strShippingCity = contact.MailingCity != undefined ? contact.MailingCity :''; 
                        tableData +='<td class = "classAddress">'+strShippingCity+'</td>';
                        
                    var strShippingState = contact.MailingState != undefined ?  contact.MailingState : '';
                        tableData +='<td  class = "classAddress">'+strShippingState+'</td>';
                        
                    var strShippingPostalCode = contact.MailingPostalCode != undefined ? contact.MailingPostalCode: '';
                        tableData +='<td  class = "classAddress">'+strShippingPostalCode+'</td>';
                        
                    var strType = 'Contact';
                         tableData +='<td  class = "classAddress" id="' +contact.Id+ 'Type">'+strType+'</td>';   
                        
                    var strSpecialties = contact.Specialties__c != undefined ? contact.Specialties__c :'';
                         tableData +='<td class = "classAddress" style="word-wrap: break-word;word-break: break-word;">'+strSpecialties+'</td>';

                    var KAHTotalPatientVolumeDr = contact.KAH_HMS_Total_Patient_Volume_DR__c != undefined ? contact.KAH_HMS_Total_Patient_Volume_DR__c : '';
                        tableData +='<td  class = "clsHMS1">'+KAHTotalPatientVolumeDr+'</td>';
                        
                   /* var KAHHMSDischargeVolumeDecileranking = contact.HMS_Discharge_Volume_Decile_ranking__c != undefined ? contact.HMS_Discharge_Volume_Decile_ranking__c : '';
                        tableData +='<td  class = "clsHMS1">'+KAHHMSDischargeVolumeDecileranking+'</td>'; */
                            
                    var KAHHHAdmitsYTD = contact.KAH_HH_Admits_YTD__c != undefined ? contact.KAH_HH_Admits_YTD__c : '';
                        tableData +='<td  class = "clsHMS1 tdBgColor">'+KAHHHAdmitsYTD+'</td>';  
                        
                    var KAHHHAdmitsPY = contact.HH_Admits_PY__c != undefined ? contact.HH_Admits_PY__c : '';
                        tableData +='<td  class = "clsHMS1 tdBgColor">'+KAHHHAdmitsPY+'</td>'; 
                        
                    var KAHHPAdmitsYTD = contact.KAH_HP_Admits_YTD__c != undefined ? contact.KAH_HP_Admits_YTD__c : '';
                        tableData +='<td  class = "clsHMS1">'+KAHHPAdmitsYTD+'</td>';    
                        
                    var KAHHPAdmitsPY = contact.HP_Admits_PY__c != undefined ? contact.HP_Admits_PY__c : '';
                        tableData +='<td  class = "clsHMS1">'+KAHHPAdmitsPY+'</td>'; 
                        
                    var KAHHDAdmitsYTD = contact.KAH_HD_Admits_YTD__c != undefined ? contact.KAH_HD_Admits_YTD__c : '';
                        tableData +='<td  class = "clsHMS1 tdBgColor">'+KAHHDAdmitsYTD+'</td>';  
                        
                    var KAHHDAdmitsPY = contact.HD_Admits_PY__c != undefined ? contact.HD_Admits_PY__c : '';
                        tableData +='<td  class = "clsHMS1 tdBgColor">'+KAHHDAdmitsPY+'</td>'; 
                    
                    var KAHNCDAdmitsYTD = contact.KAH_NCD_Admits_YTD__c != undefined ? contact.KAH_NCD_Admits_YTD__c : '';
                        tableData +='<td  class = "clsHMS1">'+KAHNCDAdmitsYTD+'</td>';    
                        
                    var KAHNCDAdmitsPY = contact.NCD_Admits_PY__c != undefined ? contact.NCD_Admits_PY__c : '';
                        tableData +='<td  class = "clsHMS1">'+KAHNCDAdmitsPY+'</td>';    
                    
                    var KAHHHPPSPriorYearAdmits = contact.KAH_HH_PPS_Prior_Year_Admits_Prior__c != undefined ? contact.KAH_HH_PPS_Prior_Year_Admits_Prior__c : '';
                        tableData +='<td  class = "clsHMS2">'+KAHHHPPSPriorYearAdmits+'</td>';  
                        
                    var KAHHHAdmitsYTD = contact.KAH_HH_Admits_YTD__c != undefined ? contact.KAH_HH_Admits_YTD__c : '';
                        tableData +='<td  class = "clsHMS2">'+KAHHHAdmitsYTD+'</td>'; 
                        
                    var KAHHHReferralsYTD = contact.KAH_HH_Referrals_YTD__c != undefined ? contact.KAH_HH_Referrals_YTD__c : '';
                        tableData +='<td  class = "clsHMS2">'+KAHHHReferralsYTD+'</td>'; 
                    
					var KAHTotalPatientVolumeDr1 = contact.KAH_HMS_Total_Patient_Volume_DR__c != undefined ? contact.KAH_HMS_Total_Patient_Volume_DR__c : '';
                        tableData +='<td  class = "clsHMS2">'+KAHTotalPatientVolumeDr1+'</td>';
						
                    var KAHAllHHDr = contact.KAH_HMS_All_HH_DR__c != undefined ? contact.KAH_HMS_All_HH_DR__c : '';         
                        tableData +='<td  class = "clsHMS2">'+KAHAllHHDr+'</td>'; 
                        
                    var KAHHHCancerBoldVascularDr = contact.KAH_HMS_HH_Cancer_Bold_Vascular_DR__c != undefined ? contact.KAH_HMS_HH_Cancer_Bold_Vascular_DR__c : '';
                        tableData +='<td class = "clsHMS2">'+KAHHHCancerBoldVascularDr+'</td>';
                        
                    var HMSCCS = contact.KAH_HMS_HH_CHF_Stroke_COPD_DR__c != undefined ? contact.KAH_HMS_HH_CHF_Stroke_COPD_DR__c :'';
                        tableData +='<td class = "clsHMS2">'+HMSCCS+'</td>';      
                        
                    var KAHHHEndoWoundsDr = contact.KAH_HMS_HH_Endo_Wounds_DR__c != undefined ? contact.KAH_HMS_HH_Endo_Wounds_DR__c : '';
                        tableData +='<td class = "clsHMS2">'+KAHHHEndoWoundsDr+'</td>';
                        
                    var KAHHHUrinaryKidneyGiDr = contact.KAH_HMS_HH_Urinary_Kidney_GI_DR__c != undefined ? contact.KAH_HMS_HH_Urinary_Kidney_GI_DR__c : '';
                        tableData +='<td class = "clsHMS2">'+KAHHHUrinaryKidneyGiDr+'</td>'; 
                        
                    var KAHHHOrthoDr = contact.KAH_HMS_HH_Ortho_DR__c != undefined ? contact.KAH_HMS_HH_Ortho_DR__c : '';
                        tableData +='<td  class = "clsHMS2">'+KAHHHOrthoDr+'</td>';                            

                    var KAHHPPPSPriorYearAdmitsPrior = contact.KAH_HP_PPS_Prior_Year_Admits_Prior__c != undefined ? contact.KAH_HP_PPS_Prior_Year_Admits_Prior__c :'';
                        tableData +='<td class = "clsHMS">'+KAHHPPPSPriorYearAdmitsPrior+'</td>';
                        
                    var KAHHPReferralsYTD = contact.KAH_HP_Referrals_YTD__c != undefined ? contact.KAH_HP_Referrals_YTD__c : '';
                        tableData +='<td  class = "clsHMS">'+KAHHPReferralsYTD+'</td>'; 
                        
                    var KAHHPAdmitsPY = contact.KAH_HP_Admits_YTD__c != undefined ? contact.KAH_HP_Admits_YTD__c : '';
                        tableData +='<td  class = "clsHMS">'+KAHHPAdmitsPY+'</td>'; 
                    
					var KAHHPLOS = contact.KAH_HMS_HP_LOS__c != undefined ? contact.KAH_HMS_HP_LOS__c : '';
                        tableData +='<td  class = "clsHMS">'+KAHHPLOS+'</td>';
						
					var KAHTotalPatientVolumeDr2 = contact.KAH_HMS_Total_Patient_Volume_DR__c != undefined ? contact.KAH_HMS_Total_Patient_Volume_DR__c : '';
                        tableData +='<td  class = "clsHMS">'+KAHTotalPatientVolumeDr2+'</td>';
						
                    var KAHAllHPDr = contact.KAH_HMS_All_HP_DR__c != undefined ? contact.KAH_HMS_All_HP_DR__c : '';
                        tableData +='<td class = "clsHMS">'+KAHAllHPDr+'</td>';
                        
                    var KAHHPInfluencerNetworkDr =  contact.KAH_HMS_HP_Influencer_Network_DR__c != undefined ? contact.KAH_HMS_HP_Influencer_Network_DR__c : '';
                        tableData +='<td  class = "clsHMS">'+KAHHPInfluencerNetworkDr+'</td>';
                        
                    var KAHHPCancerDr = contact.KAH_HMS_HP_Cancer_DR__c != undefined ? contact.KAH_HMS_HP_Cancer_DR__c :'';
                        tableData +='<td class = "clsHMS">'+KAHHPCancerDr+'</td>'; 
                        
                    var KAHHPChfDr =  contact.KAH_HMS_HP_CHF_DR__c != undefined ? contact.KAH_HMS_HP_CHF_DR__c : '';
                        tableData +='<td class = "clsHMS">'+KAHHPChfDr+'</td>';
                        
                    var KAHHPCopdDr = contact.KAH_HMS_HP_COPD_DR__c != undefined ? contact.KAH_HMS_HP_COPD_DR__c : '';
                        tableData +='<td class = "clsHMS">'+KAHHPCopdDr+'</td>';
                        
                    var KAHHPDementiaDr = contact.KAH_HMS_HP_Dementia_DR__c != undefined ? contact.KAH_HMS_HP_Dementia_DR__c : '';
                        tableData +='<td class = "clsHMS">'+KAHHPDementiaDr+'</td>';     
                        
                    var KAHHPdebilityDr = contact.KAH_HMS_HP_Debility_DR__c != undefined ? contact.KAH_HMS_HP_Debility_DR__c : '';
                        tableData +='<td  class = "clsHMS">'+KAHHPdebilityDr+'</td>';
                }
                
                return tableData;
            }
            catch(err) {
                                        
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }
        }
    
        function formAccountsDataReassign( Accounts, ATMsAssigned, ATMsIcons ) {
                
            try {       
                var tableData = '';
            
                for(var i=0; i< Accounts.length; i++) {
                    
                    var account = Accounts[i];
                    var strName = account.Name;
                    var strNameLen = strName.length;
                    if(strName.indexOf(',') > -1){
                        if((strName.indexOf(',') == 0) || (strName.indexOf(',') == strNameLen-1)){
                            strName = strName.replace(',', "");
                        }
                    }
                    var isAssignVal = (JSON.stringify(ATMsAssigned).indexOf(account.Id) > -1);
                    tableData += '<tr class="tableFilterRow"><td width="10%" id="' +account.Id+ '-' + isAssignVal + '-false">';
                    
                    if(isAssignVal == true){
                        
                        tableData += '<input type="checkbox" class="CheckboxAssignment assignedToUser CheckboxAssignmentReassign" id="' + account.Id + '" onmousedown="toggleInputCheckbox();" value="'+isAssignVal+'" ' + 
                                    ((isAssignVal) ? ('checked="' +isAssignVal+ '"') : '') + '/>';
                        tableData += '</td>';
                    }
                    
                    else if(isAssignVal == false){
                     
                        tableData += '<input type="checkbox" class="CheckboxAssignment notAssignedtoUser" id="' + account.Id + '" onmousedown="toggleInputCheckbox();" value="'+isAssignVal+'" ' + 
                                    ((isAssignVal) ? ('checked="' +isAssignVal+ '"') : '') + '/>';
                        tableData += '</td>';
                    }
                    
                    isAccountTeamMemberStyle = (JSON.stringify(ATMsIcons).indexOf(account.Id) > -1) ? 'blank' : 'none';
                    tableData += '<td> <a href = "/' +account.Id+ '" target="_blank">' +strName+  '</a> <img src="/img/icon/profile16.png" style="display:'+isAccountTeamMemberStyle+'" onclick="showAccountTeamMembers(\''+account.Id+'\');"/></td>';
                    
                    var strNPI = account.NPI__c != undefined ? account.NPI__c : '';
                        tableData +='<td class = "classAddress">'+strNPI+'</td>';
                        
                    var strShippingStreet = account.ShippingStreet != undefined ? account.ShippingStreet: '';
                        tableData +='<td  class = "classAddress">'+strShippingStreet+'</td>';    
                        
                    var strShippingCity = account.ShippingCity != undefined ? account.ShippingCity :''; 
                        tableData +='<td class = "classAddress">'+strShippingCity+'</td>';
                     
                    var strShippingState = account.ShippingState != undefined ?  account.ShippingState : '';
                        tableData +='<td  class = "classAddress">'+strShippingState+'</td>';
                        
                    var strShippingPostalCode = account.ShippingPostalCode != undefined ? account.ShippingPostalCode: '';
                        tableData +='<td  class = "classAddress">'+strShippingPostalCode+'</td>';
                        
                    var strType = 'Account';
                         tableData +='<td  class = "classAddress" id="' +account.Id+ 'Type">'+strType+'</td>';   
                         tableData +='<td class = "classAddress">&nbsp;</td>';
                    
                    var KAHTotalPatientVolumeDr = account.KAH_HMS_Total_Patient_Volume_DR__c != undefined ? account.KAH_HMS_Total_Patient_Volume_DR__c : '';
                        tableData +='<td  class = "clsHMS1">'+KAHTotalPatientVolumeDr+'</td>';
          
                   /* var KAHHMSDischargeVolumeDecileranking = account.HMS_Discharge_Volume_Decile_ranking__c != undefined ? account.HMS_Discharge_Volume_Decile_ranking__c : '';
                        tableData +='<td  class = "clsHMS1">'+KAHHMSDischargeVolumeDecileranking+'</td>'; */
                            
                    var KAHHHAdmitsYTD = account.KAH_HH_Admits_YTD__c != undefined ? account.KAH_HH_Admits_YTD__c : '';
                        tableData +='<td  class = "clsHMS1 tdBgColor">'+KAHHHAdmitsYTD+'</td>';  
                        
                    var KAHHHAdmitsPY = account.HH_Admits_PY__c != undefined ? account.HH_Admits_PY__c : '';
                        tableData +='<td  class = "clsHMS1 tdBgColor">'+KAHHHAdmitsPY+'</td>'; 
                        
                    var KAHHPAdmitsYTD = account.KAH_HP_Admits_YTD__c != undefined ? account.KAH_HP_Admits_YTD__c : '';
                        tableData +='<td  class = "clsHMS1">'+KAHHPAdmitsYTD+'</td>';    
                        
                    var KAHHPAdmitsPY = account.HP_Admits_PY__c != undefined ? account.HP_Admits_PY__c : '';
                        tableData +='<td  class = "clsHMS1">'+KAHHPAdmitsPY+'</td>'; 
                        
                    var KAHHDAdmitsYTD = account.KAH_HD_Admits_YTD__c != undefined ? account.KAH_HD_Admits_YTD__c : '';
                        tableData +='<td  class = "clsHMS1 tdBgColor">'+KAHHDAdmitsYTD+'</td>';  
                        
                    var KAHHDAdmitsPY = account.HD_Admits_PY__c != undefined ? account.HD_Admits_PY__c : '';
                        tableData +='<td  class = "clsHMS1 tdBgColor">'+KAHHDAdmitsPY+'</td>'; 
                        
                    var KAHNCDAdmitsYTD = account.KAH_NCD_Admits_YTD__c != undefined ? account.KAH_NCD_Admits_YTD__c : '';
                        tableData +='<td  class = "clsHMS1">'+KAHNCDAdmitsYTD+'</td>';    
                        
                    var KAHNCDAdmitsPY = account.NCD_Admits_PY__c != undefined ? account.NCD_Admits_PY__c : '';
                        tableData +='<td  class = "clsHMS1">'+KAHNCDAdmitsPY+'</td>'; 
                    
                    var KAHHHPPSPriorYearAdmits = account.KAH_HH_PPS_Prior_Year_Admits_Prior__c != undefined ? account.KAH_HH_PPS_Prior_Year_Admits_Prior__c : '';
                        tableData +='<td  class = "clsHMS2" data-column="19">'+KAHHHPPSPriorYearAdmits+'</td>';  
    
                    var KAHHHAdmitsYTD = account.KAH_HH_Admits_YTD__c != undefined ? account.KAH_HH_Admits_YTD__c : '';
                        tableData +='<td  class = "clsHMS2" data-column="20">'+KAHHHAdmitsYTD+'</td>'; 
    
                    var KAHHHReferralsYTD = account.KAH_HH_Referrals_YTD__c != undefined ? account.KAH_HH_Referrals_YTD__c : '';
                        tableData +='<td  class = "clsHMS2" data-column="21">'+KAHHHReferralsYTD+'</td>'; 
					
					var KAHTotalPatientVolumeDr1 = account.KAH_HMS_Total_Patient_Volume_DR__c != undefined ? account.KAH_HMS_Total_Patient_Volume_DR__c : '';
                        tableData +='<td  class = "clsHMS2">'+KAHTotalPatientVolumeDr1+'</td>';
						
                    var KAHAllHHDr = account.KAH_HMS_ALL_HH_DR__c != undefined ? account.KAH_HMS_ALL_HH_DR__c : '';                            
                        tableData +='<td  class = "clsHMS2" data-column="22">'+KAHAllHHDr+'</td>';
                        
                   var KAHHHCancerBoldVascularDr = account.KAH_HMS_HH_Cancer_Bold_Vascular_DR__c != undefined ? account.KAH_HMS_HH_Cancer_Bold_Vascular_DR__c : '';
                        tableData +='<td class = "clsHMS2" data-column="23">'+KAHHHCancerBoldVascularDr+'</td>';
                        
                   var HMSCCS = account.KAH_HMS_HH_CHF_Stroke_COPD_DR__c != undefined ? account.KAH_HMS_HH_CHF_Stroke_COPD_DR__c :'';
                        tableData +='<td class = "clsHMS2" data-column="24">'+HMSCCS+'</td>';      
                        
                   var KAHHHEndoWoundsDr = account.KAH_HMS_HH_Endo_Wounds_DR__c != undefined ? account.KAH_HMS_HH_Endo_Wounds_DR__c : '';
                        tableData +='<td class = "clsHMS2" data-column="25">'+KAHHHEndoWoundsDr+'</td>';
                        
                    var KAHHHUrinaryKidneyGiDr = account.KAH_HMS_HH_Urinary_Kidney_GI_DR__c != undefined ? account.KAH_HMS_HH_Urinary_Kidney_GI_DR__c : '';
                        tableData +='<td class = "clsHMS2" data-column="26">'+KAHHHUrinaryKidneyGiDr+'</td>'; 
                        
                     var KAHHHOrthoDr = account.KAH_HMS_HH_Ortho_DR__c != undefined ? account.KAH_HMS_HH_Ortho_DR__c : '';
                        tableData +='<td  class = "clsHMS2" data-column="27">'+KAHHHOrthoDr+'</td>';   
                    
                    var KAHHPPPSPriorYearAdmitsPrior = account.KAH_HP_PPS_Prior_Year_Admits_Prior__c != undefined ? account.KAH_HP_PPS_Prior_Year_Admits_Prior__c :'';
                        tableData +='<td class = "clsHMS">'+KAHHPPPSPriorYearAdmitsPrior+'</td>';
    
                    var KAHHPReferralsYTD = account.KAH_HP_Referrals_YTD__c != undefined ? account.KAH_HP_Referrals_YTD__c : '';
                        tableData +='<td  class = "clsHMS">'+KAHHPReferralsYTD+'</td>'; 
						
                    var KAHHPAdmitsPY = account.KAH_HP_Admits_YTD__c != undefined ? account.KAH_HP_Admits_YTD__c : '';
                        tableData +='<td  class = "clsHMS">'+KAHHPAdmitsPY+'</td>'; 

                        tableData +='<td  class = "clsHMS">'+'&nbsp;'+'</td>';
                    
					var KAHTotalPatientVolumeDr2 = account.KAH_HMS_Total_Patient_Volume_DR__c != undefined ? account.KAH_HMS_Total_Patient_Volume_DR__c : '';
                        tableData +='<td  class = "clsHMS">'+KAHTotalPatientVolumeDr2+'</td>';
						
                    var KAHAllHPDr = account.KAH_HMS_All_HP_DR__c != undefined ? account.KAH_HMS_All_HP_DR__c : '';
                        tableData +='<td class = "clsHMS">'+KAHAllHPDr+'</td>';
                        
                    var KAHHPInfluencerNetworkDr =  account.KAH_HMS_HP_Influencer_Network_DR__c != undefined ? account.KAH_HMS_HP_Influencer_Network_DR__c : '';
                        tableData +='<td  class = "clsHMS">'+KAHHPInfluencerNetworkDr+'</td>';
                        
                    var KAHHPCancerDr = account.KAH_HMS_HP_Cancer_DR__c != undefined ? account.KAH_HMS_HP_Cancer_DR__c :'';
                        tableData +='<td class = "clsHMS">'+KAHHPCancerDr+'</td>'; 
                        
                    var KAHHPChfDr =  account.KAH_HMS_HP_CHF_DR__c != undefined ? account.KAH_HMS_HP_CHF_DR__c : '';
                        tableData +='<td class = "clsHMS">'+KAHHPChfDr+'</td>';
                    
                    var KAHHPCopdDr = account.KAH_HMS_HP_COPD_DR__c != undefined ? account.KAH_HMS_HP_COPD_DR__c : '';
                        tableData +='<td class = "clsHMS">'+KAHHPCopdDr+'</td>';
                       
                    var KAHHPDementiaDr = account.KAH_HMS_HP_Dementia_DR__c != undefined ? account.KAH_HMS_HP_Dementia_DR__c : '';
                        tableData +='<td class = "clsHMS">'+KAHHPDementiaDr+'</td>';     
                        
                    var KAHHPdebilityDr = account.KAH_HMS_HP_Debility_DR__c != undefined ? account.KAH_HMS_HP_Debility_DR__c : '';
                        tableData +='<td  class = "clsHMS">'+KAHHPdebilityDr+'</td>';
					
                }
                
                return tableData;
            }
            catch(err) {
                                        
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }
        }
        // Function to disable the picklists when Organization Alignment Tab is loaded
        function disableSelect() {
            
            try {
                
                j$('#tabs a[href="Details"]').tab('show');
                j$('.addDisabled').each(function() {
                    
                    j$(this).attr('disabled', 'disabled');
                });
            }
            catch(err) {
                                        
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }   
        }
    
        function removeErrorMessage(errorMsgOP) {
            
            try {
                
                j$(escApexId(errorMsgOP)).hide();
            }
            catch(err) {
                                        
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }
        }
		var strToBeSaved = '';
		
        // Function to escape apex component Id 
        function escApexId(myid) {
            try {
            return '#' + myid.replace(/(:|\.)/g,'\\\\$1');
            }
            catch(err) {
                                    
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }
        }
		
		//Function is called on click of submit button in details and org allignment tabs, to show the success or error message on the top of the page.
         function showConfirmation(isSuccess, isValidationVisible) {
            
            try {
                
                if(isSuccess == 'true' && isValidationVisible == 'false') {
            
                    j$('#SaveMessage').html('Save successful');
                    document.body.scrollTop = document.documentElement.scrollTop = 0;
                    j$('#Showfadding').delay(1).fadeIn();
                    j$('#Showfadding').delay(5000).fadeOut();
                }
                else {
                  //  if(j$('#SaveMessage').is(":visible"))
                   //     j$('#SaveMessage').style.display = 'none'; 
                }
        
                if(j$('#accountErrorMessage').is(":visible")) { 
                    
                    j$('#SaveMessage').hide();
                }
               
                j$('.modal').addClass('displayNone');
                j$('.modal').removeClass('displayBlock');
            }
            catch(err) {
                                        
                alert('An error has occured in the page: ' + err.message + ' Please try again in sometime.');
            }
        }
        
         
        
		