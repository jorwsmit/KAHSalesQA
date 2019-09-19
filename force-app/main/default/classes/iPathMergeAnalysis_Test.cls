@isTest
private class iPathMergeAnalysis_Test {
  
  static testMethod void testNull() {
  	Set<Id> output = iPathMergeAnalysis.ConvertToWinnerIds(null);
  	
  	System.assertEquals(output, new Set<Id>());
  }
  
  static testMethod void testEmpty() {
  	Set<Id> output = iPathMergeAnalysis.ConvertToWinnerIds(new Set<Id>());
  	
  	System.assertEquals(output, new Set<Id>());
  }
  
  static testMethod void testLeadMerge() {
    
    // Make a few test objects
    Lead x1 = new Lead(LastName = 'Test Lead 1', Company = 'TestCo');
    insert x1;
    Lead x2 = new Lead(LastName = 'Test Lead 2', Company = 'TestCo');
    insert x2;
    Lead x3 = new Lead(LastName = 'Test Lead 3', Company = 'TestCo');
    insert x3;
    
    // Verify that if we pass these three in (none are presently losers) we get them all back
    Set<Id> input = new Set<Id> { x1.Id, x2.Id, x3.Id };
    Set<Id> output = iPathMergeAnalysis.ConvertToWinnerIds(input);
    System.assertEquals(output.size(), 3);
    System.assert(true, output.contains(x1.Id));
    System.assert(true, output.contains(x2.Id));
    System.assert(true, output.contains(x3.Id));
    
    // Verify we get the right results if we do a merge on one of them (merge #3 into #2)
    merge x2 x3;
    output = iPathMergeAnalysis.ConvertToWinnerIds(input);
    System.assertEquals(output.size(), 2);
    System.assert(true, output.contains(x1.Id));
    System.assert(true, output.contains(x2.Id));    
    
    // Verify for cascaded merge (merge #2 into #1)
    merge x1 x2; 
    output = iPathMergeAnalysis.ConvertToWinnerIds(input);
    System.assertEquals(output.size(), 1);
    System.assert(true, output.contains(x1.Id));
    
    // Verify single replace loser with winner
    output = iPathMergeAnalysis.ConvertToWinnerIds(new Set<Id> { x3.Id });
    System.assertEquals(output.size(), 1);
    System.assert(true, output.contains(x1.Id));
    
  }
  
  static testMethod void testContactMerge() {
    
    // Make a few test objects
    Contact x1 = new Contact(LastName = 'TestContact1');
    insert x1;
    Contact x2 = new Contact(LastName = 'TestContact2');
    insert x2;
    Contact x3 = new Contact(LastName = 'TestContact3');
    insert x3;
    
    // Verify that if we pass these three in (none are presently losers) we get them all back
    Set<Id> input = new Set<Id> { x1.Id, x2.Id, x3.Id };
    Set<Id> output = iPathMergeAnalysis.ConvertToWinnerIds(input);
    System.assertEquals(output.size(), 3);
    System.assert(true, output.contains(x1.Id));
    System.assert(true, output.contains(x2.Id));
    System.assert(true, output.contains(x3.Id));
    test.startTest();
    // Verify we get the right results if we do a merge on one of them (merge #3 into #2)
    merge x2 x3;
    output = iPathMergeAnalysis.ConvertToWinnerIds(input);
    System.assertEquals(output.size(), 2);
    System.assert(true, output.contains(x1.Id));
    System.assert(true, output.contains(x2.Id));    
    
    // Verify for cascaded merge (merge #2 into #1)
    merge x1 x2; 
    output = iPathMergeAnalysis.ConvertToWinnerIds(input);
    System.assertEquals(output.size(), 1);
    System.assert(true, output.contains(x1.Id));
    
    // Verify single replace loser with winner
    output = iPathMergeAnalysis.ConvertToWinnerIds(new Set<Id> { x3.Id });
    System.assertEquals(output.size(), 1);
    System.assert(true, output.contains(x1.Id));
    test.stopTest();
  }
  
  static testMethod void testAccountMerge() {
    
    // Make a few test objects
    Account x1 = new Account(Name = 'TestAccount1');
    insert x1;
    Account x2 = new Account(Name = 'TestAccount2');
    insert x2;
    Account x3 = new Account(Name = 'TestAccount3');
    insert x3;
    
    // Verify that if we pass these three in (none are presently losers) we get them all back
    Set<Id> input = new Set<Id> { x1.Id, x2.Id, x3.Id };
    Set<Id> output = iPathMergeAnalysis.ConvertToWinnerIds(input);
    System.assertEquals(output.size(), 3);
    System.assert(true, output.contains(x1.Id));
    System.assert(true, output.contains(x2.Id));
    System.assert(true, output.contains(x3.Id));
    
    // Verify we get the right results if we do a merge on one of them (merge #3 into #2)
    test.startTest();
    merge x2 x3;
    output = iPathMergeAnalysis.ConvertToWinnerIds(input);
    System.assertEquals(output.size(), 2);
    System.assert(true, output.contains(x1.Id));
    System.assert(true, output.contains(x2.Id));    
    
    // Verify for cascaded merge (merge #2 into #1)
    merge x1 x2; 
    output = iPathMergeAnalysis.ConvertToWinnerIds(input);
    System.assertEquals(output.size(), 1);
    System.assert(true, output.contains(x1.Id));
    
    // Verify single replace loser with winner
    output = iPathMergeAnalysis.ConvertToWinnerIds(new Set<Id> { x3.Id });
    System.assertEquals(output.size(), 1);
    System.assert(true, output.contains(x1.Id));
    test.stopTest();
  }
 
}