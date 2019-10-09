//
//  NSLogDebug.h
//  TestCollectionView
//
//  Created by Rafael on 09/10/19.
//  Copyright © 2019 Rafael. All rights reserved.
//

#ifndef NSLogDebug_h
#define NSLogDebug_h

//
//  0 - turn of NSLog(...) messages
//  1 - turn on NSLog(...) messages
//
#define DEBUG_TO_TERMINAL 0


//
// NSLOG_DEBUG define
//
#if (DEBUG_TO_TERMINAL)
#define NSLOG_DEBUG(...) NSLog(__VA_ARGS__);
#else
#define NSLOG_DEBUG(...) false;
#endif


#endif /* NSLogDebug_h */
