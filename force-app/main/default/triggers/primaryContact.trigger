trigger primaryContact on Contact(before insert, after update) {
  Set < Id > setOfAccIds = new Set < Id > ();
  for (Contact con: trigger.new) {
    if (con.AccountId != null) {
      setOfAccIds.add(con.AccountId);
    }
  }

  Map<Id,Account> mapOfAccounts = new Map<Id,Account>([select (select id,Primary_Contact_Phone__c,Is_Primary_Contact__c from Contacts) from Account where Id IN :setOfAccIds]);
    System.debug('***myLogg***'+mapOfAccounts);
  if (trigger.isBefore && trigger.isInsert) {
    for (Contact con: trigger.new) {
      if (con.AccountId != null && mapOfAccounts.containsKey(con.AccountId)) {
        for (Contact childCon: mapOfAccounts.get(con.AccountId).Contacts) {
          if (childCon.Is_Primary_Contact__c == true) {
          }
        }
      }
    }
  }

  if (trigger.isAfter && trigger.isUpdate) {
    List < Contact > listOfContactsToUpdate = new List < Contact > ();
    System.debug('***myLogg2***'+listOfContactsToUpdate);
    for (Contact con: trigger.new) {
      if (con.Is_Primary_Contact__c == true && con.Is_Primary_Contact__c != trigger.oldMap.get(con.id).Is_Primary_Contact__c && mapOfAccounts.containsKey(con.AccountId)) {
        for (Contact childCon: mapOfAccounts.get(con.AccountId).Contacts) {
          childCon.Primary_Contact_Phone__c = con.Primary_Contact_Phone__c;
          listOfContactsToUpdate.add(childCon);
        }
      }
    }
    if (listOfContactsToUpdate.size() > 0) {
      update listOfContactsToUpdate;
    }
  }
}