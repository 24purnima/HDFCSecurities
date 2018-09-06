//
//  NotificationService.m
//  NotificationService
//
//  Created by Rajeev Ranjan on 14/07/17.
//  Copyright © 2017 ShepHertz Technologies Pvt Ltd. All rights reserved.
//

#import "NotificationService.h"

#define richPushKey @"_app42RichPush"
#define geoBaseKey @"app42_geoBase"
#define richPushContent @"content"
#define richPushType @"type"

const static NSString *app42RichPushTypeText                = @"text";


@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    // check for media attachment, example here uses custom payload keys mediaUrl and mediaType
    NSDictionary *userInfo = request.content.userInfo;
    NSLog(@"advance push notification user info: %@", userInfo);
    NSString *geoBaseStr = [userInfo objectForKey:geoBaseKey];
    NSString *richPushStr = [userInfo objectForKey:richPushKey];
    
    if (geoBaseStr != nil && [geoBaseStr isEqualToString:@""]) {
        userInfo = [self getJSonFromString:geoBaseStr];
        NSLog(@"geo push userinfo: %@", userInfo);
        
        self.bestAttemptContent.body = [request.content.userInfo objectForKey:@"app42_message"];
        [self contentComplete];
    }
    else {
        userInfo = [self getJSonFromString:richPushStr];
        NSLog(@"rich push userinfo: %@", userInfo);
        
        NSString *mediaUrl = userInfo[richPushContent];
        NSString *mediaType = userInfo[richPushType];
        
        
        
        if (userInfo == nil) {
            [self contentComplete];
            return;
        }
        
        if([app42RichPushTypeText isEqualToString:mediaType]){
            NSLog(@"self.bestAttemptContent.body: %@", self.bestAttemptContent.body);
            self.bestAttemptContent.title = self.bestAttemptContent.body;
            self.bestAttemptContent.body = [userInfo objectForKey:richPushContent];
            [self contentComplete];
            return;
        }
        
        if (mediaUrl == nil || mediaType == nil) {
            [self contentComplete];
            return;
        }
        
        // load the attachment
        [self loadAttachmentForUrlString:mediaUrl
                                withType:mediaType
                       completionHandler:^(UNNotificationAttachment *attachment) {
                           if (attachment) {
                               NSLog(@"attachment added");
                               self.bestAttemptContent.attachments = [NSArray arrayWithObject:attachment];
                           }
                           [self contentComplete];
                       }];
    }
    
    
    
    
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}


- (void)contentComplete {
    self.contentHandler(self.bestAttemptContent);
}

- (NSString *)fileExtensionForMediaType:(NSString *)type {
    NSString *ext = type;
    
    if ([type isEqualToString:@"image"]) {
        ext = @"jpg";
    }
    
    if ([type isEqualToString:@"video"]) {
        ext = @"mp4";
    }
    
    if ([type isEqualToString:@"audio"]) {
        ext = @"mp3";
    }
    
    if ([type isEqualToString:@"gif"]) {
        ext = @"gif";
    }
    
    return [@"." stringByAppendingString:ext];
}

- (void)loadAttachmentForUrlString:(NSString *)urlString withType:(NSString *)type
                 completionHandler:(void(^)(UNNotificationAttachment *))completionHandler  {
    
    __block UNNotificationAttachment *attachment = nil;
    NSURL *attachmentURL = [NSURL URLWithString:urlString];
    NSString *fileExt = [self fileExtensionForMediaType:type];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session downloadTaskWithURL:attachmentURL
                completionHandler:^(NSURL *temporaryFileLocation, NSURLResponse *response, NSError *error) {
                    if (error != nil) {
                        NSLog(@"%@", error.localizedDescription);
                    } else {
                        NSFileManager *fileManager = [NSFileManager defaultManager];
                        NSURL *localURL = [NSURL fileURLWithPath:[temporaryFileLocation.path stringByAppendingString:fileExt]];
                        [fileManager moveItemAtURL:temporaryFileLocation toURL:localURL error:&error];
                        
                        NSError *attachmentError = nil;
                        attachment = [UNNotificationAttachment attachmentWithIdentifier:@"" URL:localURL options:nil error:&attachmentError];
                        if (attachmentError) {
                            NSLog(@"%@", attachmentError.localizedDescription);
                        }
                    }
                    completionHandler(attachment);
                }] resume];
}

-(NSDictionary *)getJSonFromString:(id)str{
    NSData *strData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:strData options:NSJSONReadingAllowFragments error:nil];
    return jsonDict;
}

@end
