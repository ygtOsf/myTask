public with sharing class testWeather {
    public string city      {get;set;}
    public string controllerTemp     {get;set;}
    public string controllerDescription    {get;set;}
    public string controllerIcon      {get;set;}

    public testWeather(ApexPages.StandardController stdController) {

    Account account        =  (Account) stdController.getRecord();
    account                =  [Select Id, ShippingCity From Account Where Id = :account.Id];
    String accountCity     =  account.ShippingCity;
    string apiKey          =  '82d20f125a0758048d350f1706cf2709';
    string requestEndPoint =  'https://api.openweathermap.org/data/2.5/weather';

    requestEndPoint+= '?q=' + accountCity;
    requestEndPoint+= '&APPID=' + apiKey;
    Http http           = new Http();
    HttpRequest request = new HttpRequest();

    request.setEndPoint(requestEndPoint);
    request.setMethod('GET');
    HttpResponse response = http.send(request);

    if (response.getStatusCode() == 200){
        Map <String,Object> results = (Map <String, Object> ) JSON.deserializeUntyped(response.getBody());
        system.debug(results);

        city = String.valueOf(results.get('name'));
        List <Object> weatherList =  (List <Object>)(results.get('weather'));
        Map < String,Object > weatherResults = (Map < String, Object > )(weatherList[0]);
        Map < String,Object > mainResults = (Map < String, Object > )(results.get('main'));

        for (String resultKey: results.keySet()){
            system.debug(resultKey + '**=' + results.get(resultKey));
        }

        controllerTemp    = String.valueOf(mainResults.get('temp'));
        controllerDescription  = String.valueOf(weatherResults.get('description'));
        controllerIcon    = String.valueOf(weatherResults.get('icon'));
        }

        else {
            ApexPages.message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'There was an error in reading data.');
            ApexPages.addMessage(myMsg);
    }
}

}