	
	var userLat ;
	var userLong;
	
	var isAutoCompContact = false;
	var contactAutoSelected = '';
	
	var isAutoCompPatient = false;
	var patientAutoSelected = '';
	var activeTabId = '';
	var firstSwitchCount = 0;
	
	/*-------------------AutoComplete Code Start-------------
	Js Code to maintain Autocomplete functionality
	--auto-populate field based on selection from autoComplete List
	*/
	function checkOldSelection(){

		if(isAutoCompContact && contactAutoSelected != $('[id$=contactFName]').val() +' '+$('[id$=contactLName]').val())
		{
			isAutoCompContact = false;
			clearContactFields();
			updateMap('', '', '', '', 'false');
		}
	}
	function initializeAutoComplete()
	{
		var availableNames;
		var queryTerm; 
		
		var street;
		var city;
		var state;
		var zipCode; 
		var localAddress;
		
		$('[id$=contactFName], [id$=contactLName]').autocomplete({
			minLength: 2,
			source: function(request, response) { 
						queryTerm = request.term;
						TBN_CaseEntry.searchContacts(request.term, function(result, event){
							if(event.type == 'exception') {
								  alert(event.message); 
							} 
							else{
								 availableNames = result;
								 response(availableNames);
							}
						});
				   },
			focus: function( event, ui ) {
						// Changed on 10/18 as per Nick's request to disable autocomplete on focus
						/*$('[id$=contactFName]').val( ui.item.FirstName );
						$('[id$=contactLName]').val( ui.item.LastName );*/
						return false;
					},
			select: function( event, ui ) {
						var phoneNo = '';
						isAutoCompContact = true;
						contactAutoSelected = (ui.item.FirstName != undefined) ? (ui.item.FirstName + ' ' + ui.item.LastName) : (' ' + ui.item.LastName);
						$('[id$=contactFName]').val( ui.item.FirstName );
						$('[id$=contactLName]').val( ui.item.LastName );
						$('[id$=caseContactEmail]').val( ui.item.Email );
						$('#hiddenArea [id$=contactId]').val( ui.item.Id );
						$('#hiddenArea [id$=accountId]').val( ui.item.AccountId );
						$('#row4_Street [id$=contactStreetAdd]').val( ui.item.MailingStreet );
						$('#row4_Location #row4_City [id$=contactMailingCity]').val( ui.item.MailingCity );
						$('#row4_Location #row4_State [id$=contactMailingState]').val( ui.item.MailingState );
						$('#row4_Location #row4_PostalCode [id$=contactMailingPostalCode]').val( ui.item.MailingPostalCode );
						
						var phoneType = $('#row3_Phone1 select').val();
						
						if(ui.item[phoneType] != undefined)
							$('[id$=contactPhone]').val( ui.item[phoneType] );
						else{
							
							if(ui.item.Phone != undefined) {

								if(ui.item.Phone != undefined && ui.item.Phone.length > 0)                     	
									$('[id$=contactPhone]').val( ui.item.Phone );

								$('#row3_Phone1 select').val('Phone');
							}
							else if(ui.item.MobilePhone != undefined){
								
								if(ui.item.MobilePhone != undefined && ui.item.MobilePhone.length > 0) 	
									$('[id$=contactPhone]').val( ui.item.MobilePhone );
								
								$('#row3_Phone1 select').val('MobilePhone');
							}
							else if(ui.item.HomePhone != undefined){

								if(ui.item.HomePhone != undefined && ui.item.HomePhone.length > 0) 
									$('[id$=contactPhone]').val( ui.item.HomePhone );
								
								$('#row3_Phone1 select').val('HomePhone');
							}
							else{

								if(ui.item.OtherPhone != undefined && ui.item.OtherPhone.length > 0) 
									$('[id$=contactPhone]').val( ui.item.OtherPhone );
								
								$('#row3_Phone1 select').val('OtherPhone');
							}								
						}
							
						/* generating address for Case 21st March*/
						street = (ui.item.MailingStreet == undefined || ui.item.MailingStreet == 'None' ) ? '' : ui.item.MailingStreet;
						city = (ui.item.MailingCity == undefined || ui.item.MailingCity == 'None' ) ? '' : ui.item.MailingCity;
						state = (ui.item.MailingState == undefined || ui.item.MailingState == '' ) ? '' : ui.item.MailingState;
						zipCode = (ui.item.MailingPostalCode == undefined || ui.item.MailingPostalCode == '' ) ? '' : ui.item.MailingPostalCode;
						
						if(street == '' && city == '' && state == '' && zipCode == '')
							updateMap(street, city, state, zipCode, 'false');
						else
							updateMap(street, city, state, zipCode, 'true');
					   
					   return false;
					},
			change: function( event, ui ) {
						if(ui.item == null && $('#hiddenArea [id$=contactId]').val() != '')
						{
							clearContactFields();

							street = $('#row4_Street [id$=contactStreetAdd]').val();
							state = $('#row4_Location #row4_State [id$=contactMailingState]').val();
							city = $('#row4_Location #row4_City [id$=contactMailingCity]').val();
							zipCode = $('#row4_Location #row4_PostalCode [id$=contactMailingPostalCode]').val();

							if(street == '' && city == '' && state == '' && zipCode == '')
								updateMap(street, city, state, zipCode, 'false');
							else
								updateMap(street, city, state, zipCode, 'true');
						}
						if(ui.item == null)
						{

							/*street = $('#row4_Street [id$=contactStreetAdd]').val();
							state = $('#row4_Location #row4_State [id$=contactMailingState]').val();
							city = $('#row4_Location #row4_City [id$=contactMailingCity]').val();
							zipCode = $('#row4_Location #row4_PostalCode [id$=contactMailingPostalCode]').val();

							if(street == '' && city == '' && state == '' && zipCode == '' )
								updateMap(street, city, state, zipCode, 'false');
							else
								updateMap(street, city, state, zipCode, 'true');*/
						}
				 },
				 
		 }).each(function() {
				$(this).data("ui-autocomplete")._renderItem = function(ul, item) {
					var entry = "<a>" + item.Name;
					entry = entry + "</a>";
					entry = entry.replace(queryTerm, "<b>" + queryTerm + "</b>");
					return $('<li></li>')
						.data("item.autocomplete", item)
						.append( entry )
						.appendTo(ul);
				};
			});
	}
	
	function clearContactFields()
	{
		$('#hiddenArea [id$=contactId]').val('');
		$('#hiddenArea [id$=accountId]').val('');
		$('#row3_FName [id$=contactFName]').val('');
		$('#row3_LName [id$=contactLName]').val('');
		$('[id$=caseContactEmail]').val('');
		
		if($('[id$=callerId]').val() == '')
			$('[id$=contactPhone]').val('');
		
		$('#row3_Phone1 select').val('Phone');
		$('#row4_Street [id$=contactStreetAdd]').val('');
		$('#row4_Location #row4_City [id$=contactMailingCity]').val('');
		$('#row4_Location #row4_State [id$=contactMailingState]').val( '');
		$('#row4_Location #row4_PostalCode [id$=contactMailingPostalCode]').val( '' );
		$('#row5_Description [id$=caseDescription]').val('');
		$('#row6_CaseSource #row6_Source [id$=CaseSource]').val('');
		$('#row6_CaseSource #row6_CaseOrigin [id$=CaseOriginEnabled]').val('');
		$('#row6_CaseSource #row6_CaseOrigin [id$=CaseOriginDisabled]').val('');
	}
		    
	    /*-------------AutoComplete Code End---------*/
	  
    
   <!-------------Google Map Code Start--------- -->

	var geocoder;
	var isSearch  = false;
	var mapObject;
	var markersArray = [];
	var mapAccIdToMarker = {};
	var bounds;
	var initialMapCenter;
	var locationsArray;  
	var contentString = '<div style="width:100%;height:30px;"> </div>';
	var AddressContent = '<span>Address: </span><br/>';
	var infowindow;
	var searchedPosition;
	var file = 1;
	var lp = 0;
	var limitCrossed = false;
							 
	var TypeTocolorMarker = '';
	
	$( document ).ready(function() {

		    var street;
    		var city;
    		var state;
    		var zipCode; 
    		
    		$('#part2Middle').css('height',$('#part1Left').css('height'));
            $('#part3Right').css('height',$('#part1Left').css('height'));
            
            $('#rowPatientAge__Assessment [id$=patientAge]').attr('readOnly', true); 
    		
    		startMapping();
    		
    		if($('[id$=caseType1]').val() == 'Referral') {
    			
    			$('#referralChange').show();
    			toggleSectionsButtons('caseTab', 'caseSection', 'true');
    			$('.select-icon').css('display','block');
    		}
    		else {
    			
    			street = $('#row4_Street [id$=contactStreetAdd]').val();
    			city = $('#row4_Location #row4_City [id$=contactMailingCity]').val();
    			state = $('#row4_Location #row4_State [id$=contactMailingState]').val();
    			zipCode = $('#row4_Location #row4_PostalCode [id$=contactMailingPostalCode]').val();
    			
    			updateMap(street, city, state, zipCode, 'true');
    		}
    		
    		$('#OwnerId').find("div").css('padding-left', '2px');
    	//	$('#OwnerId').find("div").css('padding-top', '4px');
			$('#OwnerId').find("div").css('border', 'none');
			$('#OwnerId').find("div").css('background-color', '#f5f5f5');
			
		TBN_CaseEntry.getColorCodesFromCS(function(result, event){
			
			TypeTocolorMarker = result;
		});
		
     });

	var labels = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
	var labelIndex = 1;
	
	// method to calculate age of Patient based on date of birth
       function calculateAge(dateString) {
           
            var today = new Date();
            var birthDate = new Date(dateString);
            var age = today.getFullYear() - birthDate.getFullYear();
            var m = today.getMonth() - birthDate.getMonth();
            if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) 
            {
                age--;
            }
            $('#rowPatientAge__Assessment [id$=patientAge]').val(age);
    }
	
	/*
	Method to be called on load of page to initialize map object
	*/
	function startMapping()
	{
		geocoder = new google.maps.Geocoder();
		
		initialMapCenter = new google.maps.LatLng(userLat, userLong);
		var myOptions = {
				center: initialMapCenter,
				zoom:4,
				mapTypeId: google.maps.MapTypeId.ROADMAP
				};
		mapObject = new google.maps.Map(document.getElementById('mapAccount'), myOptions);
		currentLocMarker = new google.maps.Marker({
								position: initialMapCenter
							});
	} 
	
	
	/*
	To mark address of account facility on map.
	*/
	function codeAddresses(accountObj)
	{ 
	
		if(accountObj != undefined && accountObj.Shipping_Geolocation__Latitude__s == undefined && accountObj.Shipping_Geolocation__Longitude__s == undefined)
		{
			geocoder.geocode( { 'address': accountObj.address.replace(undefined,'')}, function(results, status) {
				if (status == google.maps.GeocoderStatus.OK)
				{
					createMarkerAndBoundIt(accountObj, results[0].geometry.location);
				}
				else
				{
					limitCrossed = true;
				}
			});
			
			
			if(lp < locationsArray.length && !limitCrossed)
					setTimeout(function(){codeAddresses(locationsArray[lp]);}, 250);
			else if(lp < locationsArray.length && limitCrossed)
				setTimeout(function(){codeAddresses(locationsArray[lp]);}, 1200);
			else if(lp == locationsArray.length)
				mapObject.fitBounds(bounds);
		
		}
		else if(accountObj != undefined && accountObj.Shipping_Geolocation__Latitude__s != undefined && accountObj.Shipping_Geolocation__Longitude__s != undefined)
		{
			createMarkerAndBoundIt(accountObj, new google.maps.LatLng(accountObj.Shipping_Geolocation__Latitude__s, accountObj.Shipping_Geolocation__Longitude__s));
			if(lp < locationsArray.length)
				codeAddresses(locationsArray[lp]);
			else if(lp == locationsArray.length)
				mapObject.fitBounds(bounds);
		}
	}    
	
	//generic method to create marker on map based on latitude and longitude and bounding that marker
	function createMarkerAndBoundIt(accountObj, markerPosition)
	{
		var markerText = labelIndex++;
			
		marker = new google.maps.Marker({
					position: markerPosition,
					icon: createLabeledMarkerIcon(TypeTocolorMarker[accountObj.Type], markerText),
					title: accountObj.address,
				});
		markersArray.push({'accId':accountObj.Id ,'marker':marker});
		mapAccIdToMarker[accountObj.Id] = marker;
		marker.setMap(mapObject);
		bounds.extend(marker.position);	
		$('#facilityTile'+accountObj.Id+' #fromDistance').html((google.maps.geometry.spherical.computeDistanceBetween(searchedPosition.position, markerPosition)/1609.34).toFixed(2) + ' mi');
		google.maps.event.addListener(marker, 'click', function() {
			infowindow.open(mapObject, this);
			infowindow.setContent('<b>'+ accountObj.Name + '</b><br/>' +   AddressContent + accountObj.address );
		});
		lp++;
		limitCrossed = false;
	}
	
	
	// Sets the map on all markers in the array.
	function setAllMap(map)
	{
		for (var i = 0; i < markersArray.length; i++)
			markersArray[i].marker.setMap(map);
	}
	
	// Deletes all markers in the array by removing references to them.
	function deleteMarkers()
	{
		setAllMap(null);
		markersArray = [];
		mapAccIdToMarker = {};
	}
	
	/*
	Mehtod to focus on location when clicked on alphabet tag of facility tiles
	*/
	function foucsToMarker(accId)
	{
		var clickedAccountPosition = mapAccIdToMarker[accId].position;
		var boundTo = new google.maps.LatLngBounds();
		boundTo.extend(clickedAccountPosition);
		mapObject.fitBounds(boundTo);
		mapObject.setZoom(mapObject.getZoom()-4);
	}
		
	/*
	Method will be called when ever value changes in Street/City/State/PinCode fields
	*/
	 function changeFocus(obj)
     {

		if(($('#row4_Location #row4_City [id$=contactMailingCity]').val() == 'None') || ($('#row4_Location #row4_City [id$=contactMailingCity]').val() == ''))
		{
			$('#legendData').removeClass('legentData');
		}
		var zoomTo;
		isSearch = true;
		
		var street;
        var state;
        var city;
        var zipCode;

        if( $(obj).is('#row4_Street [id$=contactStreetAdd]') ||
          	$(obj).is('#row4_Location #row4_State [id$=contactMailingState]') ||
          	$(obj).is('#row4_Location #row4_City [id$=contactMailingCity]') ||
          	$(obj).is('#row4_Location #row4_PostalCode [id$=contactMailingPostalCode]') ) {
        	
        	street = $('#row4_Street [id$=contactStreetAdd]').val();
			state = $('#row4_Location #row4_State [id$=contactMailingState]').val();
			city = $('#row4_Location #row4_City [id$=contactMailingCity]').val();
            zipCode = $('#row4_Location #row4_PostalCode [id$=contactMailingPostalCode]').val();
        }
        else if( $(obj).is('#rowPatientStreet__Assessment [id$=patientStreet]') ||
				 $(obj).is('#rowPatientLocation #rowPatientState [id$=patientState]') ||
				 $(obj).is('#rowPatientLocation #rowPatientCity [id$=patientCity]') ||
				 $(obj).is('#rowPatientLocation #rowPatientZip [id$=patientZip]') ) {

			street = $('#rowPatientStreet__Assessment [id$=patientStreet]').val();
			state = $('#rowPatientLocation #rowPatientState [id$=patientState]').val();
			city = $('#rowPatientLocation #rowPatientCity [id$=patientCity]').val();
            zipCode = $('#rowPatientLocation #rowPatientZip [id$=patientZip]').val();

        }
		
		// removes the inner content when no legend present
		$('#legendData').children().remove();
		
			startMapping();
			updateMap(street, city, state, zipCode, 'true');
        		
       }
        	
	/* update geo-location based on the value entered for street, city, state, zipCode 21st March */
	function updateMap(street, city, state, zipCode, hasMapUpdate) 
	{
		var localAddressTemp = '';

		if(street != '' && street != undefined)
			localAddressTemp =  street + ',' ;

		if(city != '' && city!= undefined)	
			localAddressTemp +=  city + ',' ;
			
		if(state != '' && state != undefined)
			localAddressTemp += state + ',' ;
			
		if(zipCode != '' && zipCode!= undefined)
			localAddressTemp += zipCode;

		localAddressTemp += (localAddressTemp != '' && state != 'PR' )?'USA':'';

	   if(localAddressTemp.lastIndexOf(',') != -1 && localAddressTemp.length == localAddressTemp.lastIndexOf(',') + 1)
			localAddressTemp = localAddressTemp.substring(0, localAddressTemp.lastIndexOf(','));
			
		if(searchedPosition != undefined)
			searchedPosition.setMap(null);
		
		if(localAddressTemp.length == 0){

			isSearch = false;
			mapObject.setCenter(initialMapCenter);
			mapObject.setZoom(4);
			$('#idMapErrors').html('');
			deleteMarkers();
			$('#mapAddress').children().remove();
			$('#facilitySelect').children().remove();
			$('#facilitySelect').append('<option>Select facility type</option>');
			
			if((hasMapUpdate == 'true') || (($('#row4_Location #row4_State [id$=contactMailingState]').val() != $('#rowPatientLocation #rowPatientState [id$=patientState]').val()) ||
			    ($('#rowPatientLocation #rowPatientZip [id$=patientZip]').val() != $('#row4_Location #row4_PostalCode [id$=contactMailingPostalCode]').val()) || 
				($('#row4_Location #row4_City [id$=contactMailingCity]').val() != $('#rowPatientLocation #rowPatientCity [id$=patientCity]').val())) )  {

				deleteMarkers();
				$('#mapAddress').children().remove();
				$('#facilitySelect').children().remove();
				$('#facilitySelect').append('<option>Select facility type</option>');
			}
		}
		
		else
		{	

			geocoder.geocode( { 'address': localAddressTemp}, function(results, status){ 
				if (status == google.maps.GeocoderStatus.OK)
				{	
					lat = results[0].geometry.location.lat();
					lan = results[0].geometry.location.lng();
					searchedPosition = new google.maps.Marker({
					position: results[0].geometry.location,
						title: localAddressTemp
					});
					mapObject.setCenter(searchedPosition.position);
					//mapObject.setZoom(4);
					$('#idMapErrors').html('');
				}
				else if(status == google.maps.GeocoderStatus.OVER_QUERY_LIMIT){
					setTimeout(function() {
						updateMap(street, city, state, zipCode, hasMapUpdate);
					}, 200);
				}
				else{
					$('#idMapErrors').html('Invalid Location');
					deleteMarkers();
				}

				if( (hasMapUpdate == 'true') || (($('#row4_Location #row4_State [id$=contactMailingState]').val() != $('#rowPatientLocation #rowPatientState [id$=patientState]').val()) ||
					($('#rowPatientLocation #rowPatientZip [id$=patientZip]').val() != $('#row4_Location #row4_PostalCode [id$=contactMailingPostalCode]').val()) || 
					($('#row4_Location #row4_City [id$=contactMailingCity]').val() != $('#rowPatientLocation #rowPatientCity [id$=patientCity]').val()))) {

						updateMapAccount(city, state, zipCode, lat, lan);
				}				
			});
		}
	}
	
	/*
	Will be called onComplete of actionFunction which has been called on change at Street/City/State/PinCode
	*/
	function mapNearByAccount()
	{
		deleteMarkers();
		file = 1;
		lp = 0;
		labelIndex = 1;
		bounds = new google.maps.LatLngBounds();
		if(locationsArray.length !=0)
			codeAddresses(locationsArray[lp]);
	}
	
	
	function locError(err) {
		$('#idMapErrors').html('Please allow to find your geolocation');
		//console.warn('ERROR(' + err.code + '): ' + err.message);
		userLat = 0;
		userLong = 0;
		startMapping();
		updateMapAccount('', '', '', 0, 0);
	}
	
	function GetLocation(location) 
	{
		userLat = location.coords.latitude;
		userLong = location.coords.longitude;
		$('#idMapErrors').html('');
		startMapping();
		updateMapAccount('', '', '', location.coords.latitude, location.coords.longitude);
	}
	/*-------------GoogleMap Code End---------*/

	/*
	Method called based on latitude & longitude of address and get related accounts
	and also form address string
	*/
	function updateMapAccount(city, state, zipCode, lat,lan)
	{
		
		fullAccounts = [];
		facilityTypes = [];
		
		if(city != '' || state != '' || zipCode!= '') {
			
			TBN_CaseEntry.getNearByAccounts(city, state, zipCode, lat, lan, function(result, event){
				if(event.status){
				fullAccounts = [];
					for(idx = 0; idx < result.length; idx++){
						var address = '';
						if(result[idx].ShippingStreet != '')
							address = result[idx].ShippingStreet + ", ";
						if(result[idx].ShippingCity != undefined && result[idx].ShippingCity != '')
							address += result[idx].ShippingCity + ", ";
						if(result[idx].ShippingState != undefined && result[idx].ShippingState != '')
							address += result[idx].ShippingState + ", " ;
						if(result[idx].ShippingCountry != undefined && result[idx].ShippingCountry != '')
							address += result[idx].ShippingCountry + ", ";
						if(result[idx].ShippingPostalCode != '')
							address += result[idx].ShippingPostalCode;
						
						if(result[idx].Phone!= '')
							address += result[idx].Phone;
						
						if(address.lastIndexOf(',') != -1 && address.length == address.lastIndexOf(',') + 1)
						address = address.substring(0, address.lastIndexOf(','));
						result[idx].address = address;
						facilityTypes.push(result[idx].Type);
					}
					
					fullAccounts = result;
					facilityTypes.sort();
					
					//code for making faclityType array with Unique entries
					var temp = {};
					for(var i = 0; i < facilityTypes.length; i++)
						temp[facilityTypes[i]] = true;
					var r = [];
					
					for(var k in temp)
						r.push(k);
					facilityTypes = r;
					
					//facilityTypes = new Set(facilityTypes); can't use in IE9 and safari also
					
					if(facilityTypes.length > 0)
					{
						var legendData = '';
						$('#facilitySelect').children().remove();
						$('#legendData').children().remove();
						
						var refreshOption = '<option>Select facility type</option>';
						for(var i= 0; i < facilityTypes.length; i++){
							refreshOption += '<option>'+facilityTypes[i]+'</option>';
							legendData += '<div><img src="'+ createLabeledMarkerIcon(TypeTocolorMarker[facilityTypes[i]],'') +'"</>&nbsp;&nbsp;' + facilityTypes[i] + '</div>';
						}
						
						$('#facilitySelect').append(refreshOption);
						$('#legendData').append(legendData);
						
					}
					else
					{
						$('#legendData').hide();
						$('#facilitySelect').children().remove();
						$('#legendData').children().remove();
						$('#facilitySelect').append('<option>Select facility type</option>');
					}

					if( $('#rowAssessPreferredFacility [id$=preferredFacility]').is(':visible') && 
                            $('#rowAssessPreferredFacility [id$=preferredFacility]').val() != '' ) {
                        
                             $('#rowAssessPreferredFacility [id$=preferredFacility]').val('');
                    }
					
					filterAccount();
					$('#slideContentMain').animate({'right':'-329px'}, 800);
					$('#contentDataSlide').html('<b>No Content Found</b>');
					
				}
				else
				{
					//console.log('error',event);
				}
			});
		}
	}
	
	/*
	Method to filter accounts on change of Picklist
	*/
	function filterAccount()
	{
		labelIndex = 1;
		
		var filteredAccount = [];
		/*
		var valuesToBeFilter = [];
		$('#checkboxes input[type=checkbox]').each(function(){
			if(this.checked)
				valuesToBeFilter.push(this.value);
		});
				
		if(valuesToBeFilter.length > 0){
			filteredAccount = fullAccounts.filter(function(e1){ return valuesToBeFilter.indexOf(e1.Type) >= 0; });
			$('.selectBox select option').text(valuesToBeFilter.join());
		}
		else{
			filteredAccount = fullAccounts;
			$('.selectBox select option').text('Select facility type'); 
			
		}
		*/
		
		selectedType = $('.multiselect select').val().trim();
		if(selectedType != 'Select facility type')
			filteredAccount = fullAccounts.filter(function(e1){ return e1.Type == selectedType; });
		else
			filteredAccount = fullAccounts;
		mapDynamicAccount(filteredAccount);
	}
	
	/*
	Method to create Account(Facility) tiles dynamically and next map those account into gMap.
	*/
	function mapDynamicAccount(arrayDynamic)
	{
		var dynamicTile = '';
		iconNo = 0;
		var markerTextAcc = '';
		
		for(idx = 0; idx < arrayDynamic.length; idx++){
			
			markerTextAcc = labelIndex++;
			
			iconNo++;
			dynamicTile += '<div class = "accountWrapperTile">'+
								'<div class = "accountMarker">'+
									'<img class="result-icon" onclick = "foucsToMarker(\''+arrayDynamic[idx].Id+'\');" src="'+createLabeledMarkerIcon(TypeTocolorMarker[arrayDynamic[idx].Type], markerTextAcc)+'"/>'+
									'<input type="checkbox" style = "margin-left:5px;display:none" class = "select-icon" id = "selectIcon'+arrayDynamic[idx].Id+'" onclick = "selectFacility(\''+arrayDynamic[idx].Id+'\',\''+arrayDynamic[idx].Name+'\')" </>'+
								'</div>'+
								'<div class = "accountTiles" id = "facilityTile' + arrayDynamic[idx].Id + '">'+
									'<span><b>'+ arrayDynamic[idx].Name +':'+ arrayDynamic[idx].Facility_Number__c+'</b></span><br/>'+
										((arrayDynamic[idx].ShippingStreet != undefined && arrayDynamic[idx].ShippingStreet != '') ? (arrayDynamic[idx].ShippingStreet + '<br/>') : '') +
										((arrayDynamic[idx].ShippingCity != undefined && arrayDynamic[idx].ShippingCity != '') ? arrayDynamic[idx].ShippingCity : '') +										
										((arrayDynamic[idx].ShippingState != undefined && arrayDynamic[idx].ShippingState != '') ? (', ' + arrayDynamic[idx].ShippingState) : ' ') +
										((arrayDynamic[idx].ShippingPostalCode != undefined && arrayDynamic[idx].ShippingPostalCode != '') ? (' ' + arrayDynamic[idx].ShippingPostalCode) : ' ') + 
										((arrayDynamic[idx].Phone != undefined && arrayDynamic[idx].Phone != '') ? ('<br/>' + arrayDynamic[idx].Phone) : ' ') +
										'<span id = "fromDistance" style = "float:right;"></span><br/>'+
									'<span class = "viewContent" id = "showContentUnderTiles'+ arrayDynamic[idx].Id +'" ><a onclick="getFacilityContent(\''+arrayDynamic[idx].Id+'\',\'' +arrayDynamic[idx].Name+ '\');">View Content</a></span>'+
									'<span class = "closeContent" id = "closeContentUnderTiles'+ arrayDynamic[idx].Id +'" style = "display:none"><a onclick="getItIn($(\'#slideContentMain #InOutArrow\')[0]);">Hide</a></span>'+
								'</div>'+
							'</div>';
		}
		locationsArray = arrayDynamic;
		if(locationsArray.length == 0)
		{ 
			$('#legendData').removeClass('legentData');
		}
		else
		{
			$('#legendData').addClass('legentData');
		}
		if(($('#row4_Location #row4_City [id$=contactMailingCity]').val() == 'None'))
		{
			$('#legendData').removeClass('legentData');
		}
		$('#mapAddress').children().remove();
		$('#mapAddress').append(dynamicTile);
		if($('[id$=caseType1]').val() == 'Referral'){
            $('.select-icon').show();
        }
			
		mapNearByAccount();
	}
	
	/* ------ Method to be called on "Cancel" button to clear all form data ------ */
	function clearForm()
	{
		$('#part1Left input[type=text], #part1Left textarea, #part1Left select').val('');
		$('#row3_Phone1 select').val('Phone');
		$('.formPartition').hide();
		$('#caseSection').show()
		$('#referralChange').hide();
		$('#caseTab').addClass('active');$('#patientTab').removeClass('active');
	}
	
	
	/*--------
	common method to get related Knowledge article based on case type selection and based on search performed
	----------*/
	function searchKeyUp(caseTypelocal, isRerenderMap, isEdit)
	{
		
		offset = 0;
		if(!isEdit)
			$('#row2_Subject [id$=caseSubject]').val(caseTypelocal); //adding default text to Subject field
		
		if(caseTypelocal)
			$('#dateCategroyHeading').html(caseTypelocal +' Articles');
		else
			$('#dateCategroyHeading').html('All Articles');
		$('#caseType').val(caseTypelocal);
		
		if(caseTypelocal == '') {
			
			clearContactFields();
			clearPatientFields();
			updateMap('','','','', isRerenderMap);
		}
		if(caseTypelocal == 'Referral'){
			
			firstSwitchCount = 0;
			
			initializePatientAutoComplete();
			$('#referralChange').show();
			$('[Id$=assessStatusDetail]').addClass('form-control');
			toggleSectionsButtons('caseTab', 'caseSection', isRerenderMap);
			$('.select-icon').show();
		}
		else
		{	
			$('.select-icon').hide();
			$('#caseButtonSave').show();
			$('#caseButtonSaveClose').show();
			$('#proceedToPatient').hide();
			$('#referralChange').hide();
			$('#caseSection').show()
			$('#patientSection').hide();
			$('#assessmentSection').hide();
			//$('#contactInformationSection').hide();
			//$('#proceedToAddContacts').hide();
			$('#proceedToAssessment').hide();
		}
	}
	
	function searchKeyUpRadio(caseTypelocal, isRerenderMap)
	{
		offset = 0;
		
		$('#row2_Subject [id$=caseSubject]').val(caseTypelocal); //adding default text to Subject field
		if(caseTypelocal)
			$('#dateCategroyHeading').html(caseTypelocal +' Articles');
		else
			$('#dateCategroyHeading').html('All Articles');
		$('#caseType').val(caseTypelocal);
		
		var isGentive = $('#gentivaKnowledgeBase').is(':checked');
		var isKindred = $('#kindredKnowledgeBase').is(':checked');
		var isAll = $('#AllKnowledgeBase').is(':checked');
		var categoryFilter =  caseTypelocal.replace(' ','_');
		
		if(categoryFilter == '')
			categoryFilter = isAll ? '(Gentiva__c,Kindred__c)' : (isKindred ? 'Kindred__c' : 'Gentiva__c');
		else
			categoryFilter = isAll ? '('+categoryFilter + '_Gen__c,'+categoryFilter +'__c)' : (isKindred ? categoryFilter + '__c' : categoryFilter +'_Gen__c');	
		
		
		TBN_CaseEntry.filterArticles($('#theSearchstring').val(), caseTypelocal, 0, categoryFilter, function(result, event) { 
			if (event.status) {                     
				var moreArticles = ''; 
				for(var i = 0; i < result.records.length; i++) {
					 moreArticles += '<div class="articleBox"><b><a href="/'+result.records[i].Id+'" target="_blank">'+result.records[i].Title+'</a></b><br/>'+
									'<div class="textEllpisis">'+$("<p/>").html(result.records[i].How_To_Resolve__c).text()+'</div></div>';
				 }
				$('#scrollArticle').children().remove();
				$("#scrollArticle").append(moreArticles);
				
				offset += limit;
				setHasNext = result.hasMore;
				if(result.records.length > 0 && !setHasNext)
					$("#scrollArticle").append('<span style = "margin-left:4px;font-size: 13px;"><b>That\'s all folk!</b></span>');
					
				if(result.records.length<1)
					$('#noRecordFoundJS').show();
				else
					$('#noRecordFoundJS').hide();
			  
			} 
			else
			{
				alert('Oops, we messed up. Something went wrong and we are terribly embarrassed by it.');
			}
		 
		}); 
	}
	
	/*------------
	Method to be called when scroll reached to bottom on knowledge section
	used by infinite scroll script
	------------*/
	function showmoreOffset() {
		$('#noMoreRecordFoundJS').hide();
		
		var caseTypelocal = $('#caseType').val();
		var isGentive = $('#gentivaKnowledgeBase').is(':checked');
		var isKindred = $('#kindredKnowledgeBase').is(':checked');
		var isAll = $('#AllKnowledgeBase').is(':checked');
		var categoryFilter =  caseTypelocal.replace(' ','_');
		
		if(categoryFilter == '')
			categoryFilter = isAll ? '(Gentiva__c,Kindred__c)' : (isKindred ? 'Kindred__c' : 'Gentiva__c');
		else
			categoryFilter = isAll ? '('+categoryFilter + '_Gen__c,'+categoryFilter +'__c)' : (isKindred ? categoryFilter + '__c' : categoryFilter +'_Gen__c');	
		
		TBN_CaseEntry.filterArticles($('#theSearchstring').val(), $('#caseType').val(), offset,categoryFilter, function(result, event) { 
			if (event.status) {                     
				if (event.status == true) {
					var moreArticles = ''; 
					
					for(var i = 0; i < result.records.length; i++) {
						moreArticles += '<div class="articleBox"><b><a href="/'+result.records[i].Id+'" target="_blank">'+result.records[i].Title+'</a></b><br/>'+
										'<div class="textEllpisis">'+$("<p/>").html(result.records[i].How_To_Resolve__c).text()+'</div></div>';
					} 
					
					$("#scrollArticle").append(moreArticles);
					offset += limit;
					setHasNext = result.hasMore;
					if(!setHasNext)
						$("#scrollArticle").append('<span style = "margin-left:4px;font-size: 13px;"><b>That\'s all folk!</b></span>');
				} 
			}
			else if (event.type === 'exception')    
				alert('Oops, we messed up. Something went wrong and we are terribly embarrassed by it.');
			else 
				alert('Oops, we messed up. Something went wrong and we are terribly embarrassed by it.');
		}, {escape:true}); 
	}
	
	
	var accIdClickedNew = ''; // assigned account id and use it for show/hide of close/view content link
	var accIdClickedOld = ''; // assigned account id and use it for show/hide of close/view content link
   
	// method for Content section display
	function getItOut(imgObj)
	{
		var imgsrc = imgObj.src;
		imgsrc = imgsrc.replace('Arrowhead-Left', 'Arrowhead-Right');
		$(imgObj).attr({'src':imgsrc , 'onclick': 'getItIn(this);'});
		$('#slideContentMain').animate({'right':'0px'},800);
		$('#closeContentUnderTiles'+accIdClickedNew).show();
		$('#showContentUnderTiles'+accIdClickedNew).hide();
		if(accIdClickedOld != '' && accIdClickedOld != accIdClickedNew)
		{
			$('#closeContentUnderTiles'+accIdClickedOld).hide();
			$('#showContentUnderTiles'+accIdClickedOld).show();
		}
		accIdClickedOld = accIdClickedNew;
	}
	
	//Method for Content section hide
	function getItIn(imgObj)
	{
		var imgsrc = imgObj.src;
		imgsrc = imgsrc.replace('Arrowhead-Right', 'Arrowhead-Left');
		$(imgObj).attr({'src':imgsrc , 'onclick': 'getItOut(this);'});
		$('#slideContentMain').animate({'right':'-329px'},800);
		$('#closeContentUnderTiles'+accIdClickedNew).hide();
		$('#showContentUnderTiles'+accIdClickedNew).show();
	}
	
	/*-------------- method will be called on-click of facility tile to retrieve related content of that facility------*/
	function getFacilityContent(accId, accName)
	{
		TBN_CaseEntry.retreiveFacilityContent(accId, function(result, event){
			if(event.status){
				$('#contentDataSlide').html('');
				if(result.length !=0)
				{
					var dynamicContent = '';
					dynamicContent += '<div class = "contentItems"><div style="margin-bottom: 6px;font-size:13px"><b>'+accName+'</b></div>';
					dynamicContent += '<div class="articleBox"><b><a href="/'+result[0].Id+'" target="_blank">'+result[0].Title+'</a></b></div>';
					dynamicContent += '</div>';
					$('#contentDataSlide').append(dynamicContent);
				}
				else
					$('#contentDataSlide').append('<b>No Content Found</b>');
				
				accIdClickedNew = accId;
				getItOut($('#slideContentMain #InOutArrow')[0]);
			}
			else
			{
				//console.log('error',event);
			}
		});
	}
	
	/*
	function showCheckboxes() {
		$("#checkboxes").css('display') == 'none' ? $("#checkboxes").show() : $("#checkboxes").hide();
	}
	
	$(document).click(function(e) {
		// check that your clicked
		// element has no id=mscbpl
		// and is not child of "mscbpl" && "overselect"
	   if ( e.target.id != 'overselect' && e.target.id != 'mscbpl' && !$('#mscbpl').find(e.target).length) {
			$("#checkboxes").hide();
		}
	});
	*/
	
	var offset = 0;
	var limit;
	var setHasNext = true;
	//on DOM ready adding extra years to Date Picker
	$(function() {
		var addTo = '';
		var maxTo = new Date().getFullYear();
		for(var i=1900;i<maxTo;i++){addTo +='<option value='+ i +'>'+ i +'</option>';}
		$('#calYearPicker').html(addTo);
		infowindow = new google.maps.InfoWindow({
						content: contentString,
						maxWidth: 200
					 });
		var bounds = new google.maps.LatLngBounds();
		initializeAutoComplete();
		//To be called on load of page to get user current location
		navigator.geolocation.getCurrentPosition(GetLocation, locError);
		showMarkerLegend();
		$('[Id$=assessStatus]').change(function(){
			setTimeout(function(){$('[Id$=assessStatusDetail]').addClass('form-control')},0);});
		/* ---------- Infinite Scroll code for Knowledge section ---------*/
		
		$('#scrollArticle').endlessScroll({
			fireOnce: true,
			fireDelay: 1000,
			bottomPixels: 10,
			callback: function(p) {
			   if (setHasNext)
				showmoreOffset();
			}
		});
		$('#noRecordFoundJS').hide(); //To hide "no record message" on knowledge section on load of page	
		
	});
	
	/*-----
	Will be called when Case type is referral and Patient/Case Radio button is selected
	to change the page layout form
	-------*/
	function showPatientSection(activeId,idToShow){
		$('#'+activeId).siblings().removeClass('active');
		$('#'+activeId).addClass('active');
		$('.formPartition').hide();
		$('.formPartition').each(function()
		{
			if(this.id == idToShow)
				$(this).show();
			
		});
		if(idToShow == 'caseSection')
		{
			$('#caseButtonSave').hide();
			$('#caseButtonSaveClose').hide();
			$('#proceedToPatient').show();
			$('.select-icon').show();
		}
		
		else
		{
			$('#caseButtonSave').show();
			$('#caseButtonSaveClose').show();
			$('#proceedToPatient').hide();
		}
		
	
	}
	
	function copyCaseDataToPatient()
	{
		var street;
		var city;
		var state;
		var zipcode;
		
		var isUpdateMap = ( ($('#row4_Location #row4_City [id$=contactMailingCity]').val() != '' || $('#row4_Location #row4_State [id$=contactMailingState]').val() != '' || 
				$('#row4_Location #row4_PostalCode [id$=contactMailingPostalCode]').val() != '') && 
						( $('[id$=patientState]').val() == '' && $('[id$=patientZip]').val() == '' && $('[id$=patientCity]').val() == '' ) ||
						(($('#row4_Location #row4_State [id$=contactMailingState]').val() != $('#rowPatientLocation #rowPatientState [id$=patientState]').val()) ||
						($('#rowPatientLocation #rowPatientZip [id$=patientZip]').val() != $('#row4_Location #row4_PostalCode [id$=contactMailingPostalCode]').val()) || 
						($('#row4_Location #row4_City [id$=contactMailingCity]').val() != $('#rowPatientLocation #rowPatientCity [id$=patientCity]').val())));
						
		isAutoCompPatient = false;
		clearPatientFields();
		$('[id$=patientName]').val($('#row3_FName [id$=contactFName]').val() +' '+  $('#row3_LName [id$=contactLName]').val());
		$('[id$=patientFirstName]').val($('#row3_FName [id$=contactFName]').val());
		$('[id$=patientName]').val($('#row3_LName [id$=contactLName]').val());
		$('[id$=patientPhone]').val($('[id$=contactPhone]').val());
		$('[id$=patientCity]').val($('#row4_Location #row4_City [id$=contactMailingCity]').val());
		$('[id$=patientState]').val($('#row4_Location #row4_State [id$=contactMailingState]').val());
		$('[id$=patientStreet]').val($('#row4_Street [id$=contactStreetAdd]').val());
		$('[id$=patientZip]').val($('#row4_Location #row4_PostalCode [id$=contactMailingPostalCode]').val());
		$('[id$=patientEmail]').val($('[id$=caseContactEmail]').val());

		/* generating address for Assesment 30th March */
		street = $('#rowPatientStreet__Assessment [id$=patientStreet]').val();
		city = $('#rowPatientLocation #rowPatientCity [id$=patientCity]').val();
		state = $('#rowPatientLocation #rowPatientState [id$=patientState]').val();
		zipCode = $('#rowPatientLocation #rowPatientZip [id$=patientZip]').val();
	
	    if(isUpdateMap) {
			
			updateMap(street, city, state, zipCode, 'true');
		}
		else{

			updateMap(street, city, state, zipCode, 'false');
		}
	}
	
	
	 function createLabeledMarkerIcon (iconColor, label) {
		
		/*var strokeColor = "FFFFFF";
		var labelColor = "FFFFFF";  
		var pinProgram = "pin";
		var baseUrl = "https://chart.googleapis.com/chart?cht=d&chdp=mapsapi&chl=";
		var iconUrl = baseUrl + pinProgram + "'i\\" + "'[" + label + 
					  "'-2'f\\"  + "hv'a\\]" + "h\\]o\\" + 
					  primaryColor  + "'fC\\" + 
					  labelColor  + "'tC\\" + 
					  strokeColor  + "'eC\\";
			  
		iconUrl += "Lauto'f\\";
		iconUrl = iconUrl + "&ext=.png";*/
		
		var primaryColor = iconColor;
		var label = label || "";
		var baseUrl = "https://chart.googleapis.com/chart?chst=d_map_spin&chld=0.6|0|";
		var iconUrl = baseUrl + primaryColor + "|9||"+ label;

	  return iconUrl;
	}
	
	function showMarkerLegend()
	{
		/*
		var legendData = '';
		$.each( TypeTocolorMarker, function( key, value ) {
		  legendData +='<div><img src="'+ createLabeledMarkerIcon(value,'') +'"</>&nbsp;&nbsp;' + key + '</div>';
		});
		$('#legendData').append(legendData);
		*/
	}
	
	var newFacilityId = '';
	var oldFacilityId = '';
	function selectFacility(facilityId, facilityName)
	{
		newFacilityId = facilityId;
		
	 	//$('#assessFacility').val(facilityName);
		$('[id$=preferredFacility]').val(facilityName);
		$('[id$=preferredFacility_lkold]').val( facilityName );
		$('[id$=preferredFacility_lkid]').val( facilityId );
		if( !$('#selectIcon'+newFacilityId).prop('checked') )
		{
			//$('#assessFacility').val('');
			$('[id$=preferredFacility]').val('');
			$('[id$=preferredFacility_lkold]').val( '' );
			$('[id$=preferredFacility_lkid]').val( '' );
		}
		
		if(oldFacilityId != '' && oldFacilityId != newFacilityId)
		{
			$('#selectIcon'+oldFacilityId).removeProp('checked');
		}
		
		oldFacilityId = newFacilityId;
		
	}

	function toggleSectionsButtons(activeId,idToShow, isRerenderMap)
	{
		var street;
        var city;
        var state;
        var zipCode; 
        var localAddress;
        //firstSwitchCount = 0;
		
		$('#'+activeId).siblings().removeClass('active');
		$('#'+activeId).addClass('active');
		$('.formPartition').hide();
		$('.formPartition').each(function()
		{
			if(this.id == idToShow)
				$(this).show();
			
		});

		street = $('#row4_Street [id$=contactStreetAdd]').val();
		city = $('#row4_Location #row4_City [id$=contactMailingCity]').val();
		state = $('#row4_Location #row4_State [id$=contactMailingState]').val();
		zipCode = $('#row4_Location #row4_PostalCode [id$=contactMailingPostalCode]').val();

		if(idToShow == 'caseSection')
		{
			$('#part2Middle').css('height',$('#part1Left').css('height'));
            $('#part3Right').css('height',$('#part1Left').css('height'));
			
			$('#proceedToPatient').show();
			$('#caseButtonCancel').show();
			$('#caseButtonSave').hide();
			$('#caseButtonSaveClose').hide();
			$('#proceedToAssessment').hide();
			//$('#proceedToAddContacts').hide();
			$('.select-icon').show();
			/* generating address for Case 21st March*/
			
		   if(($('#row4_Location #row4_State [id$=contactMailingState]').val() != $('#rowPatientLocation #rowPatientState [id$=patientState]').val()) ||
			    ($('#rowPatientLocation #rowPatientZip [id$=patientZip]').val() != $('#row4_Location #row4_PostalCode [id$=contactMailingPostalCode]').val()) || 
				($('#row4_Location #row4_City [id$=contactMailingCity]').val() != $('#rowPatientLocation #rowPatientCity [id$=patientCity]').val())) {
		   		
		   		updateMap(street, city, state, zipCode, 'true');
			}
			else {
				updateMap(street, city, state, zipCode, isRerenderMap);
			}
		   
		}
		else if(idToShow == 'assessmentSection')
		{
			$('#part2Middle').css('height',$('#part1Left').css('height'));
            $('#part3Right').css('height',$('#part1Left').css('height'));
			
			$('#caseButtonCancel').show();
			
		    $('#proceedToPatient').hide();
			$('#caseButtonSaveClose').show();
			//$('#proceedToAddContacts').show();
			$('#caseButtonSave').show();
			$('#caseButtonSaveClose').show();
			$('.select-icon').show();
			
			/* generating address for Assesment 21st March */

			if( (state != '' || zipCode != '' || city != '') && 
						( $('[id$=patientState]').val() == '' && $('[id$=patientZip]').val() == '' && $('[id$=patientCity]').val() == '' )) {

				firstSwitchCount+=1;
			    /* copy case values to assesment on first switch */
			    if(firstSwitchCount == 1) {

					$('[id$=patientState]').val($('#row4_Location #row4_State [id$=contactMailingState]').val());
					$('[id$=patientZip]').val($('#row4_Location #row4_PostalCode [id$=contactMailingPostalCode]').val());
					$('[id$=patientCity]').val($('#row4_Location #row4_City [id$=contactMailingCity]').val());
			    }	
			}
			
			street = $('#rowPatientStreet__Assessment [id$=patientStreet]').val();
			city = $('#rowPatientLocation #rowPatientCity [id$=patientCity]').val();
			state = $('#rowPatientLocation #rowPatientState [id$=patientState]').val();
			zipCode = $('#rowPatientLocation #rowPatientZip [id$=patientZip]').val();
				
		   if(($('#row4_Location #row4_State [id$=contactMailingState]').val() != $('#rowPatientLocation #rowPatientState [id$=patientState]').val()) ||
			    ($('#rowPatientLocation #rowPatientZip [id$=patientZip]').val() != $('#row4_Location #row4_PostalCode [id$=contactMailingPostalCode]').val()) || 
				($('#row4_Location #row4_City [id$=contactMailingCity]').val() != $('#rowPatientLocation #rowPatientCity [id$=patientCity]').val())) {
		   		
		   		updateMap(street, city, state, zipCode, 'true');
			}
			else {
				updateMap(street, city, state, zipCode, isRerenderMap);
			}
			
		}
		
	}
	
	var isFileUpload = false;
	var methodToBeCalled;
	var btnObject;
	function beforeSave(callMethod, btnObj)
	{
		activeTabId = $("[id$=tabsPanel] .active").attr("id");
		
		$('#caseButtonSave').prop('disabled', true);
		$('#caseButtonSaveClose').prop('disabled', true);
		
		if($('#caseType').val() != 'Referral')
			$('[id$=patientName]').parent().remove();
		//to upload file
		if($('#uploadFileIframe').contents().find('[id$=inputUpload]').val() != undefined && $('#uploadFileIframe').contents().find('[id$=inputUpload]').val() != '')
		{
			isFileUpload = true;
			btnObject = btnObj;
			methodToBeCalled = callMethod;
			document.getElementById('uploadFileIframe').contentWindow.uploadFile();
		}
		
		if(!isFileUpload)
		{
			var errorCounter = 0;
			
			/*
			// Check for Case Type error
			var caseTypeObj = $('[id$=caseType1]').val();
			if(caseTypeObj == null || caseTypeObj.trim() == '' && $('[id$=caseType1] ~ .errorMsg').size() == 0){
				$('[id$=caseType1]').after('<div class="errorMsg"><strong>Error:</strong> You must enter a value</div>');
				errorCounter++;
				$('#pageViewSelection').css('margin-top','0');
			}
			else if(caseTypeObj != null && caseTypeObj.trim() != '' && $('[id$=caseType1] ~ .errorMsg').size() >= 0){
				//$('[id$=caseType1]').siblings()[1].remove();
				$('[id$=caseType1] ~ .errorMsg').remove();
				$('#pageViewSelection').css('margin-top','14px')
			}
			else if(caseTypeObj == null || caseTypeObj.trim() == '')
					errorCounter++;
			
			// Check for Case Type subject and LastName error
			$('#caseSection .emptyCheck').each(function(){
				if( ($(this).val() == null || $(this).val().trim() == '') && $(this).siblings().length == 1){
					$(this).after('<div class="errorMsg"><strong>Error:</strong> You must enter a value</div>');
					errorCounter++;
				}
				else if($(this).val()!= null && $(this).val().trim() != '' && $(this).siblings()[1] != undefined)
						$(this).siblings()[1].remove();
				else if($(this).val() == null || $(this).val().trim() == '')
						errorCounter++;
			});
			if(errorCounter)
				$('#part1Left, #part2Middle, #part3Right').css('height','765px');
			if(errorCounter && $('#caseType').val() == 'Referral'){
				toggleSectionsButtons('caseTab', 'caseSection');
				$('#caseButtonSave').prop('disabled', false);
				$('#caseButtonSaveClose').prop('disabled', false);
			}
			
			
			else if(!errorCounter){
				$('#part1Left, #part2Middle, #part3Right').css('height','735px');
				var noError = true;
				if($('#caseType').val() != 'Referral' || noError  && $('[id$=lNameCont] ~ .errorMsg').size() == 0)
					callMethod(attId);
				else{
					$('#caseButtonSave').prop('disabled', false);
					$('#caseButtonSaveClose').prop('disabled', false);
				}
			}
			else{
				$('#caseButtonSave').prop('disabled', false);
				$('#caseButtonSaveClose').prop('disabled', false);
			}
			*/
			console.log('>>>>>>>> ' , $('[id$=contactPhone]').val());
			callMethod(attId, $('[id$=contactPhone]').val());
			
		}
	}
	
	function showErrorSection(callMethod)
 	{
		if($('[id$=caseType1]').val() != '')
			$('[id$=caseType1] :first-child').before('<option value="None">--None--</option>');
		
		if($('#caseType').val() == 'Referral')
		{
			searchKeyUp('Referral','false');
			
			if(activeTabId == 'assessmentTab')
				toggleSectionsButtons('assessmentTab', 'assessmentSection','false');
			
			$('#rowPatientAge__Assessment [id$=patientAge]').attr('readOnly', true); 
		}
		
		if($('.errorMsg').length > 0)
		{
			$('#part1Left').css('height','auto');
			$('#part2Middle').css('height',$('#part1Left').css('height'));
			$('#part3Right').css('height',$('#part1Left').css('height'));	
		}
 	}
	
	var attId = '';
	function sendDocId(attachmentId)
	{
		attId = attachmentId;
		isFileUpload = false;
		beforeSave(methodToBeCalled, btnObject);
	}
	
	
	/*-------------PATIENT AutoComplete-------------------*/
	
	function initializePatientAutoComplete()
	{
		var availableNames;
		var queryTerm; 
		
		var street;
		var city;
		var state;
		var zipCode; 
		var localAddress;
		
		$('[id$=patientName]').autocomplete({
			minLength: 2,
			source: function(request, response) { 
						queryTerm = request.term;
						TBN_CaseEntry.searchPatients(request.term, function(result, event){
							if(event.type == 'exception') {
								  alert(event.message); 
							} 
							else{
								 availableNames = result;
								 response(availableNames);
							}
						});
				   },
			focus: function( event, ui ) {
						// Changed on 10/18 as per Nick's request to disable autocomplete on focus
						/*$('[id$=patientName]').val( ui.item.Last_Name__c );
						$('[id$=patientAge]').val( ui.item.Age__c );
						if(ui.item.Date_of_Birth__c != null && ui.item.Date_of_Birth__c != undefined && ui.item.Date_of_Birth__c != '')
							$('[id$=patientDOB]').val( new Date(ui.item.Date_of_Birth__c).toLocaleDateString()) ;
						else
							$('[id$=patientDOB]').val('') ;*/
						/*
						$('#hiddenArea [id$=patientId]').val( ui.item.Id );
						$('#rowPatientSex [id$=patientSex]').val( ui.item.Sex__c );
						$('#rowPatient_Email__Assessment [id$=patientEmail]').val( ui.item.E_mail__c );
						$('#rowPatientPhone [id$=patientPhone]').val( ui.item.Phone__c );
						$('#rowPatientStreet [id$=patientStreet]').val( ui.item.Street__c );
						$('#rowPatientCity [id$=patientCity]').val( ui.item.City__c );
						$('#rowPatientState [id$=patientState]').val( ui.item.State__c );
						$('#rowPatientZip [id$=patientZip]').val( ui.item.Postal_Code__c );
						*/
						return false;
					},
			select: function( event, ui ) {
				
				
						var phoneNo = '';
						$('[id$=patientName]').val( ui.item.Last_Name__c );
						patientAutoSelected = ui.item.Name;
						isAutoCompPatient = true;
						$('[id$=patientAge]').val( ui.item.Age__c );
						if(ui.item.Date_of_Birth__c != null && ui.item.Date_of_Birth__c != undefined && ui.item.Date_of_Birth__c != '')
							$('[id$=patientDOB]').val( new Date(ui.item.Date_of_Birth__c).toLocaleDateString()) ;
						else
							$('[id$=patientDOB]').val('') ;

						$('#hiddenArea [id$=patientId]').val( ui.item.Id );
						
						$('#rowPatientSuffix__Assessment [id$=patientSuffix]').val( ui.item.Suffix__c );
						$('#rowPatientFirstName__Assessment [id$=patientFirstName]').val( ui.item.First_Name__c );
						$('#rowPatientMiddleInitial__Assessment [id$=patientMiddleInitial]').val( ui.item.Middle_Initial__c );
						$('#rowPatientSex [id$=patientSex]').val( ui.item.Sex__c );
						$('#rowPatient_Email__Assessment [id$=patientEmail]').val( ui.item.E_mail__c );
						$('#rowPatientPhone [id$=patientPhone]').val( ui.item.Phone__c );
						$('#rowPatientStreet [id$=patientStreet]').val( ui.item.Street__c );
						$('#rowPatientCity [id$=patientCity]').val( ui.item.City__c );
						$('#rowPatientState [id$=patientState]').val( ui.item.State__c );
						$('#rowPatientZip [id$=patientZip]').val( ui.item.Postal_Code__c );
						
						/* generating address for Case 21st March*/
						street = (ui.item.Street__c == undefined || ui.item.Street__c == 'None' ) ? '' : ui.item.Street__c;
						city = (ui.item.City__c == undefined || ui.item.City__c == 'None' ) ? '' : ui.item.City__c;
						state = (ui.item.State__c == undefined || ui.item.State__c == '' ) ? '' : ui.item.State__c;
						zipCode = (ui.item.Postal_Code__c == undefined || ui.item.Postal_Code__c == '' ) ? '' : ui.item.Postal_Code__c;
						
					    if(street == '' && city == '' && state == '' && zipCode == '')
							updateMap(street, city, state, zipCode, 'false');
						else
							updateMap(street, city, state, zipCode, 'true');
						
						return false;
					},
			change: function( event, ui ) {
						
						if(ui.item == null && $('#hiddenArea [id$=patientId]').val() != '')
						{
							
							clearPatientFields();

							street = $('#rowPatientStreet__Assessment [id$=patientStreet]').val();
							state = $('#rowPatientLocation #rowPatientState [id$=patientState]').val();
							city = $('#rowPatientLocation #rowPatientCity [id$=patientCity]').val();
							zipCode = $('#rowPatientLocation #rowPatientZip [id$=patientZip]').val();
							
							updateMap(street, city, state, zipCode, 'false');
						}
						else if(ui.item == null){
					
							$('[id$=patientAge]').val('');
							$('[id$=patientDOB]').val('') ;
							
							/*street = $('#rowPatientStreet__Assessment [id$=patientStreet]').val();
							state = $('#rowPatientLocation #rowPatientState [id$=patientState]').val();
							city = $('#rowPatientLocation #rowPatientCity [id$=patientCity]').val();
							zipCode = $('#rowPatientLocation #rowPatientZip [id$=patientZip]').val();
							
							if(street == '' && state == '' && city == '' && zipCode == '')
								updateMap(street, city, state, zipCode, 'false');
							else
								updateMap(street, city, state, zipCode, 'true');*/
						}
						//event.preventDefault();
						
				 },
				 
				 
		 }).each(function() {
			
				$(this).data("ui-autocomplete")._renderItem = function(ul, item) {
					var entry = "<a>" ;
					if(item.Name != '' && item.Name != undefined)
						entry += ' '+item.Name;
					
					if(item.Age__c != null && item.Age__c != undefined && item.Age__c != '')
						entry += '<b> - Age:</b> '+item.Age__c;
					if(item.Date_of_Birth__c != null && item.Date_of_Birth__c != undefined && item.Date_of_Birth__c != '')
						entry += '<b> - DOB:</b> '+new Date(item.Date_of_Birth__c).toLocaleDateString();
					entry = entry + "</a>";
					//entry = entry.replace(queryTerm, "<b>" + queryTerm + "</b>");
					return $('<li></li>')
						.data("item.autocomplete", item)
						.append( entry )
						.appendTo(ul);
				};
			});
	}
		    
	function clearPatientFields(){
		$('[id$=patientAge]').val('');
		$('[id$=patientDOB]').val('') ;
		$('#hiddenArea [id$=patientId]').val('');
		$('#rowPatientSex [id$=patientSex]').val('');
		$('#rowPatient_Email__Assessment [id$=patientEmail]').val('');
		$('#rowPatientPhone__Assessment [id$=patientPhone]').val('');
		$('#rowPatientStreet__Assessment [id$=patientStreet]').val('');
		$('#rowPatientCity [id$=patientCity]').val('');
		$('#rowPatientState [id$=patientState]').val('');
		$('#rowPatientZip [id$=patientZip]').val('');
		$('#rowPatientSuffix__Assessment [id$=patientSuffix]').val('');
		$('#rowPatientFirstName__Assessment [id$=patientFirstName]').val('');
		$('#rowPatientMiddleInitial__Assessment [id$=patientMiddleInitial]').val('');
	}
	
	function patientCheckOldSelection(){
		var patientFullName = $('[id$=patientName]').val() + 
									(($('[id$=patientSuffix]').val() != undefined && $('[id$=patientSuffix]').val() != '') ? (', ' + $('[id$=patientSuffix]').val()) : '') + 
									(($('[id$=patientFirstName]').val() != undefined && $('[id$=patientFirstName]').val() != '') ? (', ' + $('[id$=patientFirstName]').val()) : '') + 
									(($('[id$=patientMiddleInitial]').val() != undefined && $('[id$=patientMiddleInitial]').val() != '') ? (' ' + $('[id$=patientMiddleInitial]').val()) : '');
									
		if(isAutoCompPatient && patientAutoSelected != patientFullName)
		{
			isAutoCompPatient = false;
			clearPatientFields();
			updateMap('','','','', 'false');
		}
	}
	    /*-------------AutoComplete Code End---------*/
	
	
	