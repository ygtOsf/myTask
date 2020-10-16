public class searchDetailsController {
    public list <Contact> ct {get;set;}
    public String searchKey {get;set;}
    public searchDetailsController( ) {
    }
    public void search(){
        string searchquery='select Name,Title,Phone,Is_Primary_Contact__c from Contact where name like \'%'+searchKey+'%\' Limit 20';
        ct= Database.query(searchquery);
    }
    public void clear(){
        ct.clear();
    }
}