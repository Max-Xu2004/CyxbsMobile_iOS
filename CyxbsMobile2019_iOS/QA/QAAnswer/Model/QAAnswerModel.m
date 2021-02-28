//
//  QAAnswerModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/1/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "QAAnswerModel.h"

@implementation QAAnswerModel
- (void)commitAnswer:(NSNumber *)questionId content:(NSString *)content imageArray:(NSArray *)imageArray{
    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *parameters = @{@"question_id":questionId,@"content":content};
    //测试数据
    [client requestWithPath:QA_ANSWER_QUESTION_API method:HttpRequestPost parameters:parameters prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *info = [responseObject objectForKey:@"info"];
        if ([info isEqualToString:@"success"]) {
            //            self.dataDic = [responseObject objectForKey:@"data"];
            self.answerId = [responseObject objectForKey:@"data"];
            if (imageArray.count == 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"QAAnswerCommitSuccess" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"QADetailDataReLoad" object:nil];
            }else{
                [self uploadPhoto:imageArray];
            }
            
            
        }else{
            //这个通知貌似没有接受者啊，改成failure算了
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"QAAnswerCommitError" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QAAnswerCommitFailure" object:nil];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QAAnswerCommitFailure" object:nil];
    }];
}
- (void)uploadPhoto:(NSArray *)photoArray{
    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *parameters = @{@"answer_id":self.answerId};
    //    for (int i = 0; i < photoArray.count; i++) {
    //        UIImage *image = photoArray[i];
    //        NSData *imageData = UIImagePNGRepresentation(image);
    //        NSString *imageName = [NSString stringWithFormat:@"photo_url%d",i];
    //        [parameters setObject:imageData forKey:imageName];
    //    }
    NSMutableArray *imageNamesx = [NSMutableArray array];
    for (int i = 0; i < photoArray.count; i++) {
        [imageNamesx addObject:[NSString stringWithFormat:@"photo%d",i+1]];
        
    }
    NSArray *imageNames =  [NSArray arrayWithArray:imageNamesx];
    [client uploadImageWithJson:QA_ANSWER_ANSWERIMAGE_UPLOAD method:HttpRequestPost parameters:parameters imageArray:photoArray imageNames:imageNames prepareExecute:nil progress:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSString *info = [responseObject objectForKey:@"info"];
        if ([info isEqualToString:@"success"]) {
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QAAnswerCommitSuccess" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QADetailDataReLoad" object:nil];
            
        }else{
            //这个通知貌似没有接受者啊，改成failure算了
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"QAAnswerCommitError" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QAAnswerCommitFailure" object:nil];
        }
        
    }  failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSDictionary *dic = [operation.responseObject objectForKey:@"info"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QAAnswerCommitFailure" object:nil];
    }];
    
}

- (void)addItemInDraft:(NSString *)title questionId:(NSNumber *)questionId{
    NSDictionary *contentDic = @{@"title":title};
    NSData *contentData = [NSJSONSerialization dataWithJSONObject:contentDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *content = [contentData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSDictionary *parameters = @{@"type":@"answer",@"content":content,@"target_id":questionId};
    
    [[HttpClient defaultClient] requestWithPath:QA_ADD_DRAFT_API method:HttpRequestPost parameters:parameters prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *info = [responseObject objectForKey:@"info"];
        if ([info isEqualToString:@"success"]) {
            
            
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QAQuestionCommitError" object:nil];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QAQuestionCommitFailure" object:nil];
    }];
    
}
- (void)updateItemInDraft:(NSString *)title draftId:(NSNumber *)draftId{
    NSDictionary *contentDic = @{@"title":title};
       NSData *contentData = [NSJSONSerialization dataWithJSONObject:contentDic options:NSJSONWritingPrettyPrinted error:nil];
       NSString *content = [contentData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
       NSDictionary *parameters = @{@"content":content,@"id":draftId};
       
       [[HttpClient defaultClient] requestWithPath:QA_UPDATE_DRAFT_API method:HttpRequestPost parameters:parameters prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
           NSString *info = [responseObject objectForKey:@"info"];
           if ([info isEqualToString:@"success"]) {
               
               
           }else{
               [[NSNotificationCenter defaultCenter] postNotificationName:@"QAQuestionCommitError" object:nil];
           }
           
       } failure:^(NSURLSessionDataTask *task, NSError *error) {
           [[NSNotificationCenter defaultCenter] postNotificationName:@"QAQuestionCommitFailure" object:nil];
       }];
}
@end
