global with sharing class oppProductQuickAdd {
    global oppProductQuickAdd(ApexPages.StandardController stdController) {
        
    }
    global string pricebook {   get   {     return 'Standard';  }   set;    }
    global String productInfo {get{
        List<productInfoItem> returnList = new List<productInfoItem>();
        for(Product2 dbItem : [SELECT Id,Name,(SELECT Id,UnitPrice FROM PriceBookEntries WHERE PriceBook2.Name=:this.pricebook)  FROM Product2]){
            returnList.add(new productInfoItem(dbItem.Name,dbItem.Id, dbItem.PriceBookEntries[0].Id, dbItem.PriceBookEntries[0].UnitPrice));
        }
        return JSON.serialize(returnList);
    } set;}

    

    @RemoteAction
    global static List<OpportunityLineItem> getLineItemsForOpp(Id opportunityId){
        List<OpportunityLineItem> returnList = [SELECT Id,Quantity,PricebookEntryId,UsefulSort__c,TotalPrice FROM OpportunityLineItem WHERE OpportunityId=:opportunityId ORDER BY UsefulSort__c];
        return returnList;
    }


    @RemoteAction
    global static List<OpportunityLineItem> upsertLineItemsForOpp(Id opportunityId, List<OpportunityLineItem> lineItems){
        List<OpportunityLineItem> delList = [SELECT Id,Quantity,PricebookEntryId,UsefulSort__c,TotalPrice FROM OpportunityLineItem WHERE OpportunityId=:opportunityId ORDER BY UsefulSort__c];
        delete delList;
        upsert lineItems;
        List<OpportunityLineItem> returnList = [SELECT Id,Quantity,PricebookEntryId,UsefulSort__c,TotalPrice FROM OpportunityLineItem WHERE OpportunityId=:opportunityId ORDER BY UsefulSort__c];
        return returnList;
    }

    @RemoteAction
    global static List<OpportunityLineItem> deleteOppLineItem(String lineItemId, String opportunityId){
        lineItemId=String.escapeSingleQuotes(lineItemId);
        String dbQuery='SELECT Id,Quantity FROM OpportunityLineItem WHERE Id=\''+lineItemId+'\'';
        OpportunityLineItem itemToDel=Database.query(dbQuery);
        delete itemToDel;
        List<OpportunityLineItem> returnList = [SELECT Id,Quantity,PricebookEntryId,UsefulSort__c,TotalPrice FROM OpportunityLineItem WHERE OpportunityId=:opportunityId ORDER BY UsefulSort__c];
        return returnList;
    }
    /*Object wrappers*/
    global class productInfoItem{
        global String productName{get; set;}
        global Id productId{get; set;}
        global Id priceBookId{get; set;}
        global Decimal productUnitPrice{get; set;}

        global productInfoItem(String productName, Id productId, Id priceBookId, Decimal productUnitPrice){
            this.productName=productName;
            this.productId=productId;
            this.priceBookId=priceBookId;
            this.productUnitPrice=productUnitPrice;
        }
    }

}