/*
 * JBoss, Home of Professional Open Source.
 * Copyright Red Hat, Inc., and individual contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "AGValidator.h"

@implementation AGValidator

+ (BOOL)isValidText:(NSString *)text {
    if (text && ![text isEqualToString:@""]) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isValidEmail:(NSString *)email {
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:NULL];
    NSArray *matches = [detector matchesInString:email options:0 range:NSMakeRange(0, email.length)];
    for (NSTextCheckingResult *match in matches) {
        if (match.resultType == NSTextCheckingTypeLink &&
            [match.URL.absoluteString rangeOfString:@"mailto:"].location != NSNotFound) {
            return YES;
        }
    }
    
    return NO;
}

+ (BOOL)isValidPhone:(NSString *)phone {
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber error:NULL];
    NSArray *matches = [detector matchesInString:phone options:0 range:NSMakeRange(0, phone.length)];
    return (NSInteger)matches.count;
}

+ (BOOL)isValidBirthdate:(NSString *)birthdate {
    return YES;
}

@end
