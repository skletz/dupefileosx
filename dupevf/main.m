//
//  main.m
//  Duplicate finder for video filenames containing extensions like .mp4, .mpg, .mpg, .avi
//  Search duplicates within a given directory.
//
//  Created by Sabrina Kletz on 10.05.16.
//  Copyright © 2016 Sabrina Kletz. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {

        NSLog(@"Squashly; Video Duplicate Finder ... ");
        
        if(argc < 2){
            NSLog(@"Missing command line arguments ...");
            return EXIT_FAILURE;
        }
        
    
        NSString *directory = [NSString stringWithUTF8String:argv[1]];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        BOOL isDirectory;
        
        if(!directory)
        {
            
            NSLog(@"No valid Path ...");
            return EXIT_FAILURE;
        }
        
        if(![fileManager fileExistsAtPath:directory isDirectory:&isDirectory])
        {
            
            NSLog(@"Path not exist ...");
            return EXIT_FAILURE;
        }
        
        if(!isDirectory){
            NSLog(@"Path is no directory ...");
            return EXIT_FAILURE;
        }
        
        //prepare directroy entry
        if(![directory hasSuffix:@"/"])
        {
            directory = [directory stringByAppendingString:@"/"];
        }

        NSString *mp4 = @"mp4";
        NSString *mpg = @"mpg";
        NSString *mpeg = @"mpeg";
        NSString *avi = @"avi";
        
        NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:directory];
        NSString *file;
        NSString *fqfilename;
        
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        NSMutableArray *duplicates = [[NSMutableArray alloc] init];
        
        
        //walks the directiry recursively and add all files to the dictionary
        while((file = [enumerator nextObject]))
        {
            //create a fully qualified filename
            fqfilename = [directory stringByAppendingString:file];
            
            if([fileManager fileExistsAtPath:fqfilename isDirectory:&isDirectory] && isDirectory)
            {
                //append backslah to the end of the directory entrie
                fqfilename = [fqfilename stringByAppendingString:@"/"];
            }else
            {
                NSString *extension = [file pathExtension];
                //TODO Create a list of possible file extensions
                if([extension isEqualToString:mp4] || [extension isEqualToString:mpg] || [extension isEqualToString:mpeg] || [extension isEqualToString:avi])
                {
                    
                    if([[dictionary allKeys] containsObject:file])
                    {
                        [duplicates addObject: fqfilename];
                        NSLog(@"Duplicate founded: %@", file);
                    }
                    
                    [dictionary setObject:fqfilename forKey:file];
                    NSLog(@"File: %@", file);
                }
 
   
            }
        }
        
        NSLog(@"Video Files: %lu", (unsigned long)[[dictionary allKeys] count]);
        
        if([duplicates count] == 0)
        {
            NSLog(@"No Duplicates founded.");
        }
        else
        {
            for (NSString *duplicate in duplicates) {
                NSLog(@"Duplicate: %@", duplicate);
            }
        }

    }
    
    return EXIT_SUCCESS;
}
