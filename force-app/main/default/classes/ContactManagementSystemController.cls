public with sharing class ContactManagementSystemController {
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(Id accountId, String searchKey) {
        Map<String, Object> bindVariables = new Map<String, Object>{
            'accountId' => accountId,
            'searchPattern' => '%' + String.escapeSingleQuotes(searchKey) + '%'
        };

        String additionalFilter = String.isNotBlank(searchKey) ? 'AND Name LIKE :searchPattern' : '';

        String query = String.format(
            'SELECT FirstName, LastName, Email, Phone ' +
            'FROM Contact ' +
            'WHERE AccountId = :accountId {0} ' +
            'ORDER BY CreatedDate DESC LIMIT 10',
            new List<String>{
                additionalFilter
            }
        );

        return Database.queryWithBinds(
            query, 
            bindVariables, 
            AccessLevel.USER_MODE
        );
    }

    @AuraEnabled
    public static List<Contact> createContact(Contact contact) {
        try {
            validateContacts(new List<Contact>{contact});

            SObjectAccessDecision securityDecision = Security.stripInaccessible(
                AccessType.CREATABLE,
                new List<Contact>{contact}
            );
            List<Contact> contacts = securityDecision.getRecords();
            insert as User contacts;
            return contacts;
       } catch (DmlException dmle) {
            throw new AuraHandledException(dmle.getMessage());
        }
    }

    @AuraEnabled
    public static void updateContacts(List<Contact> contacts) {
        try {
            List<Contact> cts = [SELECT Email FROM Contact WHERE Id IN :contacts WITH USER_MODE LIMIT 10];
            validateContacts(cts);
            SObjectAccessDecision securityDecision = Security.stripInaccessible(
                AccessType.UPDATABLE,
                contacts
            );
            update as User securityDecision.getRecords();
        } catch (DmlException dmle) {
            throw new AuraHandledException(dmle.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteContacts(List<Contact> contacts) {
        try {
            delete as User contacts;
        } catch (DmlException dmle) {
            throw new AuraHandledException(dmle.getMessage());
        }
    }

    private static void validateContacts(List<Contact> contacts) {
        for (Contact item : contacts) {
            Boolean isMissingRequiredFields = item.Email == null;

            if (isMissingRequiredFields) {
                throw new SecurityException(Label.Contact_Required_Fields);
            }
        }
    }

}