//
//  ViewController.m
//  NSURLSession
//
//  Created by patrick on 2021/2/6.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [self downloadTaks];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)downloadTaks {
    //NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/googlechrome.dmg"];
    
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/RD_FS.zip"];
    [[[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"response is >>>> %@", response);
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        
        if (!error) {
            if (httpResponse.statusCode == 200) {
                NSLog(@"function downloadTasks location is %@", location);
                
                NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                NSString *newDownloadFilePath = [doc stringByAppendingPathComponent:@"RD_FS.zip"];
                NSString *scriptPath = [[NSBundle mainBundle] pathForResource:@"Script" ofType:@"sh"];
                NSString *newScriptPath = [doc stringByAppendingPathComponent:@"Script.sh"];
                
                NSLog(@"function downloadTasks doc is %@", doc);
                
                [[NSFileManager defaultManager] copyItemAtPath:location.path toPath:newDownloadFilePath error:nil];
                
                [[NSFileManager defaultManager] copyItemAtPath:scriptPath toPath:newScriptPath error:nil];
                NSString *scriptCMD = [NSString stringWithFormat:@"%@ %@ %@", newScriptPath, doc, newDownloadFilePath];
                [self RunCMD:[NSString stringWithFormat:@"chmod 777 %@", newScriptPath]];
                [self RunCMD:scriptCMD];
            } else {
                NSLog(@"服务器内部错误");
            }
        } else {
            NSLog(@"连接错误，错误代码 >>>>> %@", error);
        }

    }] resume];
}

-(void)RunCMD:(NSString *)scriptCMD {
    NSString *script = [NSString stringWithFormat:@"do shell script \"%@\"",scriptCMD];
    NSAppleScript *appleScript = [[NSAppleScript alloc] initWithSource:script];
    [appleScript executeAndReturnError:nil];
}



@end
