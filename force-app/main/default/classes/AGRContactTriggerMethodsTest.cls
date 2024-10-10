/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 *
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
public with sharing class AGRContactTriggerMethodsTest {
  @TestSetup
  public static void makeData() {
    // create common test accounts
    List<Account> testAccountRecords = new List<Account>();
    // List<Account> testAccountRecords = new List<Account>();
    Account newAccountOne = new Account(Name = 'TestAccountOne');
    Account newAccountTwo = new Account(Name = 'TestAccountTwo');
    testAccountRecords.add(newAccountOne);
    testAccountRecords.add(newAccountTwo);
    insert testAccountRecords;

    List<Contact> testContactRecords = new List<Contact>();
    Contact testContactOne = new Contact(
      LastName = 'TestContactOne',
      AccountId = testAccountRecords[0].Id
    );
    Contact testContactTwo = new Contact(
      LastName = 'TestContactTwo',
      AccountId = testAccountRecords[1].Id
    );
    testContactRecords.add(testContactOne);
    testContactRecords.add(testContactTwo);

    insert testContactRecords;

    /*
    List<Account> testAccounts = new List<Account>();
    for (Integer i = 0; i < 2; i++) {
      testAccounts.add(new Account(nameof = 'testAcct' + i));
    }
    insert testAccounts;
    */
  }

  @isTest
  public static void afterInsertHandlerTestOne() {
    // TO DO: sample account records
    // sample contact records

    // create a list, add accounts
    /*
    List<Account> testAccountRecords = new List<Account>();
    Account newAccountOne = new Account(Name = 'TestAccountOne');
    Account newAccountTwo = new Account(Name = 'TestAccountTwo');
    testAccountRecords.add(newAccountOne);
    testAccountRecords.add(newAccountTwo);
    insert testAccountRecords;
    */

    /*
    List<Contact> testContactRecords = new List<Contact>();
    Contact testContactOne = new Contact(
      LastName = 'TestContactOne',
      AccountId = testAccountRecords[0].Id
    );
    Contact testContactTwo = new Contact(
      LastName = 'TestContactTwo',
      AccountId = testAccountRecords[1].Id
    );
    testContactRecords.add(testContactOne);
    testContactRecords.add(testContactTwo);

    insert testContactRecords;
    */

    List<Account> accountsToTest = [SELECT Id, Active_Contacts__c FROM Account];
    System.assertEquals(2, 2, accountsToTest.size());
    System.assertEquals(null, accountsToTest[0].Active_Contacts__c);
    System.assertEquals(null, accountsToTest[1].Active_Contacts__c);

    List<Contact> contactsToTest = [SELECT Id FROM Contact];

    System.assertEquals(2, contactsToTest.size());
  }

  @isTest
  public static void afterInsertHandlerTestTwo() {
    // TO DO: sample account records
    // sample contact records

    // create a list, add accounts
    /*
    List<Account> testAccountRecords = new List<Account>();
    Account newAccountOne = new Account(Name = 'TestAccountOne');
    Account newAccountTwo = new Account(Name = 'TestAccountTwo');
    testAccountRecords.add(newAccountOne);
    testAccountRecords.add(newAccountTwo);
    insert testAccountRecords;
    */
    // prepareData();

    //
    // for (Contact ctc : testContactRecords) {
    //   if (ctc.Name == 'TestContactOne') {
    //     ctc.Active__c = true;
    //   }
    // }

    /*
    List<Contact> testContactRecords = new List<Contact>();
    Contact testContactOne = new Contact(
      LastName = 'TestContactOne',
      AccountId = testAccountRecords[0].Id,
      Active__c = true
    );
    Contact testContactTwo = new Contact(
      LastName = 'TestContactTwo',
      AccountId = testAccountRecords[1].Id
    );
    testContactRecords.add(testContactOne);
    testContactRecords.add(testContactTwo);
    */
    //

    // insert testContactRecords;

    List<Account> accountsToTest = [
      SELECT Id, Name, Active_Contacts__c
      FROM Account
    ];
    System.assertEquals(2, 2, accountsToTest.size());

    for (Account acc : accountsToTest) {
      if (acc.Name == 'TestAccountOne') {
        System.assertEquals(1, acc.Active_Contacts__c);
      }
      if (acc.Name == 'TestAccountTwo') {
        System.assertEquals(null, acc.Active_Contacts__c);
      }
    }

    /*
    System.assertEquals(1, accountsToTest[0].Active_Contacts__c);
    System.assertEquals(null, accountsToTest[1].Active_Contacts__c);
    */

    List<Contact> contactsToTest = [SELECT Id FROM Contact];

    System.assertEquals(2, contactsToTest.size());
  }

  @isTest
  public static void afterInsertHandlerTestBulk() {
    List<Account> testAccounts = new List<Account>();
    testAccounts.add(new Account(Name = 'testAccountOne'));
    testAccounts.add(new Account(Name = 'testAccountTwo'));

    insert testAccounts;

    // add contacts to the accounts
    List<Contact> contactsListToTest = new List<Contact>();
    // create 100 contacts
    for (Integer i = 0; i < 100; i++) {
      contactsListToTest.add(
        new Contact(
          LastName = 'testContact 0' + i,
          AccountId = testAccounts[0].id,
          Active__c = true
        )
      );
    }
    contactsListToTest.add(
      new Contact(
        LastName = 'testContact, inactive 1',
        AccountId = testAccounts[1].id
      )
    );
    contactsListToTest.add(
      new Contact(
        LastName = 'testContact, inactive 2',
        AccountId = testAccounts[1].id
      )
    );
    contactsListToTest.add(
      new Contact(
        LastName = 'testContact, inactive 3',
        AccountId = testAccounts[1].id
      )
    );

    insert contactsListToTest;

    //
    List<Account> accounts = [
      SELECT Id, Name, Active_Contacts__c
      FROM Account
    ];
    //
    System.assertEquals(2, testAccounts.size());
    for (Account acct : accounts) {
      if (acct.Name == 'testAccountOne') {
        System.assertEquals(100, acct.Active_Contacts__c);
      }
      if (acct.Name == 'testAccountTwo') {
        System.assertEquals(null, acct.Active_Contacts__c);
      }
    }
  }

  @isTest
  public static void afterUpdateHandlerTest() {
    // when a Contact is updated, the Account Active_Contacts__c value is updated

    /*
    List<Account> testAccountRecords = new List<Account>();
    Account newAccountOne = new Account(Name = 'TestAccountOne');
    Account newAccountTwo = new Account(Name = 'TestAccountTwo');
    testAccountRecords.add(newAccountOne);
    testAccountRecords.add(newAccountTwo);
    insert testAccountRecords;
    */
    // prepareData();

    /*
    List<Contact> testContactRecords = new List<Contact>();
    Contact testContactOne = new Contact(
      LastName = 'TestContactOne',
      AccountId = testAccountRecords[0].Id
    );
    Contact testContactTwo = new Contact(
      LastName = 'TestContactTwo',
      AccountId = testAccountRecords[1].Id
    );
    testContactRecords.add(testContactOne);
    testContactRecords.add(testContactTwo);

    insert testContactRecords;
    */

    List<Contact> contactsToTest = [SELECT Id, LastName FROM Contact];
    for (Contact person : contactsToTest) {
      if (person.LastName == 'TestContactOne') {
        person.Active__c = true;
      }
    }
    Test.startTest();
    update contactsToTest;
    Test.stopTest();

    //
    List<Account> accounts = [
      SELECT Id, Name, Active__c
      FROM Account
    ];
    System.assertEquals(2, accounts.size());

    //
    for (Account anAccount : accounts) {
      if (anAccount.Name == 'TestContactOne') {
        System.assertEquals(1, anAccount.Active_Contacts__c);
      }

      if (anAccount.Name == 'TestContactOne') {
        System.assertEquals(null, anAccount.Active_Contacts__c);
      }
    }

    //
    List<Contact> allContacts = [
      SELECT Id
      FROM Contact
    ];
    System.assertEquals(2, allContacts.size());
  }

  @isTest
  public static void afterUpdateHandlerTestTwo() {
    // when a Contact is updated, the Account Active_Contacts__c value is updated

    /*
    List<Account> testAccountRecords = new List<Account>();
    Account newAccountOne = new Account(Name = 'TestAccountOne');
    Account newAccountTwo = new Account(Name = 'TestAccountTwo');
    testAccountRecords.add(newAccountOne);
    testAccountRecords.add(newAccountTwo);
    insert testAccountRecords;
    */
    // prepareData();

    /*
    List<Contact> testContactRecords = new List<Contact>();
    Contact testContactOne = new Contact(
      LastName = 'TestContactOne',
      AccountId = testAccountRecords[0].Id
    );
    Contact testContactTwo = new Contact(
      LastName = 'TestContactTwo',
      AccountId = testAccountRecords[1].Id
    );
    testContactRecords.add(testContactOne);
    testContactRecords.add(testContactTwo);

    insert testContactRecords;
    */

    Account secondTestAccount = [
      SELECT Id
      FROM Account
      WHERE Name = 'TestAccountTwo'
    ];

    List<Contact> contactsToTest = [SELECT Id, LastName FROM Contact];
    for (Contact person : contactsToTest) {
      if (person.LastName == 'TestContactOne') {
        person.Active__c = true;
        person.AccountId = secondTestAccount.Id; // testAccountRecords[1].Id;
      }
    }
    Test.startTest();
    update contactsToTest;
    Test.stopTest();

    //
    List<Account> accounts = [
      SELECT Id, Name, Active__c
      FROM Account
    ];
    System.assertEquals(2, accounts.size());

    //
    for (Account anAccount : accounts) {
      if (anAccount.Name == 'TestContactOne') {
        System.assertEquals(null, anAccount.Active_Contacts__c);
      }

      if (anAccount.Name == 'TestContactOne') {
        System.assertEquals(1, anAccount.Active_Contacts__c);
      }
    }

    //
    List<Contact> allContacts = [
      SELECT Id
      FROM Contact
    ];
    System.assertEquals(2, allContacts.size());
  }
}