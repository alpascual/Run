//
//  InAppManager.h
//  Run
//
//  Created by Albert Pascual on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface InAppManager : UIViewController <UIAlertViewDelegate,SKProductsRequestDelegate,SKPaymentTransactionObserver>

@property (nonatomic,strong) NSString *productCode;
@property (nonatomic,strong) UIAlertView *alert;
@property (nonatomic,strong) SKProductsRequest *request;

- (BOOL) alreadyPurchased:(NSString*)productCode;
- (void) tryPurchase:(NSString*)productCode;
- (void) enableFeature;

- (void) completeTransaction:(SKPaymentTransaction *)transaction;
- (void) failedTransaction:  (SKPaymentTransaction *)transaction;
- (void) restoreTransaction: (SKPaymentTransaction *)transaction;

@end
