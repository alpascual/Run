//
//  InAppManager.m
//  Run
//
//  Created by Albert Pascual on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InAppManager.h"

@implementation InAppManager

@synthesize productCode = _productCode;
@synthesize alert = _alert;
@synthesize request = _request;

- (BOOL) alreadyPurchased:(NSString*)productCode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ( [defaults objectForKey:productCode] == nil )
        return NO;
    
    return YES;
}

- (void) tryPurchase:(NSString*)productCode
{
    self.productCode = productCode;
    
    if ([SKPaymentQueue canMakePayments]) {
        // Display a store to the user.
        NSLog(@"Display store with self %@", self);
        self.alert = [[UIAlertView alloc] initWithTitle:@"In-App Purchase" message:@"Do you want to more information to access the feature?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        
        [self.alert show];
    } else {
        // Warn the user that purchases are disabled.
        NSLog(@"no store");
    }
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0)
    {
        NSLog(@"cancel");
        
    }
    else
    {        
        // Purchase from the store In-App
        self.request= [[SKProductsRequest alloc] initWithProductIdentifiers:
                                     [NSSet setWithObject:self.productCode]];
        self.request.delegate = self;
        [self.request start];        
    }
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *myProducts = response.products;
    NSLog(@"product count %d", myProducts.count);
    if ( myProducts.count > 0 ) {
        
        for (SKProduct *product in myProducts) {
        
        if ( product.productIdentifier == self.productCode ) {
            [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
            //SKPayment *payment = [SKPayment paymentWithProductIdentifier:self.productCode];
            SKPayment *payment = [SKPayment paymentWithProduct:product];
            
            [[SKPaymentQueue defaultQueue] addPayment:payment]; 
            }
        }
        
    }
    else {
        UIAlertView *noProduct = [[UIAlertView alloc] initWithTitle:@"In-App Purchase" message:@"No feature set up, sorry" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [noProduct show];
        
        [self enableFeature];
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                //[self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                //[self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
    // Your application should implement these two methods.
    /*[self recordTransaction:transaction];
     [self provideContent:transaction.payment.productIdentifier];*/
    
    [self enableFeature];
    
    // Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"In-App Purchase Completed" message:@"You now have access to that feature, thanks." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    
    [alert show];
}

- (void) enableFeature {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"1" forKey:self.productCode];
    [defaults synchronize];
}

- (void) failedTransaction:  (SKPaymentTransaction *)transaction {
    NSLog(@"Failed");
}
- (void) restoreTransaction: (SKPaymentTransaction *)transaction {
    NSLog(@"Restoring");
}


@end
