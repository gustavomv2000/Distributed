public class Auxiliar {
    
    public Boolean isFinished;
    public Boolean confirm;
    public Integer numCallouts;
    public Integer page;
    public IntegrationSetup__c org;
    public Integer numOrgs;

    public Auxiliar() {
        isFinished = false;
        numCallouts = 0;
        page = 0;
        numOrgs = 0;
    }
}
