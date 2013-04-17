$j=jQuery.noConflict();
	
var nameAutoCompleteArr=[];
var namePriceBookIdMap={};
var priceBookIdPriceMap={};
var idPriceBookNameMap={};

$j(document).ready(function(){
	//Generate the template for a line item
	lineItemTemplate = Handlebars.compile($j("#lineItemTemplate").html().trim());

	//Generate a Id -> Name map 
	$j.each(productInfo,function(index,value){
		nameAutoCompleteArr.push(value.productName);
		namePriceBookIdMap[value.productName]=value.priceBookId;
		idPriceBookNameMap[value.priceBookId]=value.productName;
		priceBookIdPriceMap[value.priceBookId]=value.productUnitPrice;
	});

	refreshFromServer();

	$j('.add-new-line-item').click(function(){
		$j(lineItemTemplate({})).insertBefore($j('.bottom-controls'));
		attachLineItemMethods();
	});
});

function refreshFromServer(){
	oppcreator.getLineItemsForOpp(currentOppId,function(result,status){
		refreshTableContents(result);
	});
}

function refreshTableContents(result){
	$j('.lineitem').remove();
	$j.each(result,function(index,value){
		var templateObj={};
		templateObj['productName']=idPriceBookNameMap[value.PricebookEntryId];
		templateObj['quantity']=value.Quantity;
		templateObj['lineItemId']=value.Id;
		templateObj['priceBookId']=value.PricebookEntryId;
		$j(lineItemTemplate(templateObj)).insertBefore($j('.bottom-controls'));
	});
	attachLineItemMethods();
	updateTotals();
}

function attachLineItemMethods(){
	//point the typeahead element to the proper source
	$j('.lineitem-product-name').typeahead({source: nameAutoCompleteArr, updater: function(item){ 
		this.$element.attr('pricebookid',namePriceBookIdMap[item]);
		this.$element.val(item);
		updateTotals();
		changeDetected();
		return item; 
	}});
	$j('.lineitem-product-qty').change(function(){changeDetected(); updateTotals();});

	$j('.remove-line-item').click(function(){
		var lineItemId=$j(this).closest('.lineitem').find('.lineitem-product-name').attr('lineitemid');
		oppcreator.deleteOppLineItem(lineItemId,currentOppId,function(result,status){
			refreshTableContents(result);
		});
	});
}


function updateTotals(){
	var total=0;
	$j('.lineitem').each(function(){
		unitPrice=priceBookIdPriceMap[$j(this).find('.lineitem-product-name').attr('pricebookid')];
		qty=$j(this).find('.lineitem-product-qty').val();
		$j(this).find('.lineitem-opp-price').val(unitPrice*qty);
		total=total+(unitPrice*qty);
	});
	sendPostMessage(accounting.formatMoney(total));
	//parent.document.getElementById('test').innerHTML='hello there';
	//parent.updateOppTotals('hello');
}

function pushUpdate(){
	var newLineItems=[];
	var i=0;
	$j('.lineitem').each(function(){
		var lineItem={};
		lineItem['Quantity']=parseFloat($j(this).find('.lineitem-product-qty').val());
		//This is read only??? WTF?
		lineItem['PricebookEntryId']=$j(this).find('.lineitem-product-name').attr('pricebookid');
		lineItem['TotalPrice']=parseFloat($j(this).find('.lineitem-opp-price').val());
		//Can't update any id's because we can't change the product name. delete them all and start over.
		//lineItem['Id']=$j(this).find('.lineitem-product-name').attr('lineitemid');
		lineItem['OpportunityId']=currentOppId;
		//Can't write to default sortorder field via apex... try a custom field?
		lineItem['UsefulSort__c']=i;
		newLineItems.push(lineItem);
		i++;
	});
	oppcreator.upsertLineItemsForOpp(currentOppId,newLineItems,function(result,status){
		refreshTableContents(result);
	});
}

var updateTimeout;
function changeDetected(){
	if(typeof(updateTimeout) !='undefined'){clearTimeout(updateTimeout);}
	updateTimeout=setTimeout(function(){pushUpdate();},2500)
}

function sendPostMessage(text){
    parent.postMessage(text,'https://na15.salesforce.com');
}