//
//  SciptableTests.m
//  Tests
//
//  Created by Alexey Yakovenko on 4/22/19.
//  Copyright © 2019 Alexey Yakovenko. All rights reserved.
//

#import <XCTest/XCTest.h>
#include "conf.h"
#include "../../common.h"
#include "../../logger.h"
#include "scriptable.h"
#include "scriptable_dsp.h"
#include "scriptable_encoder.h"

@interface SciptableTests : XCTestCase

@end

@implementation SciptableTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSString *path = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingString:@"/PresetManagerData"];
    strcpy (dbconfdir, [path UTF8String]);
    ddb_logger_init ();
    conf_init ();
    conf_enable_saving (0);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)test_LoadDSPPreset_ReturnsExpectedData {
    scriptableDspLoadPresets ();
    scriptableItem_t *dspRoot = scriptableDspRoot ();
    XCTAssertEqual(1, scriptableItemNumChildren (dspRoot));
    scriptableFree();
}

- (void)test_DSPPreset_Has3Plugins {
    scriptableDspLoadPresets ();
    scriptableItem_t *dspRoot = scriptableDspRoot ();

    scriptableItem_t *preset = dspRoot->children;
    XCTAssertEqual(3, scriptableItemNumChildren (preset));

    scriptableFree();
}

- (void)test_DSPPreset_HasExpectedPluginIds {
    scriptableDspLoadPresets ();
    scriptableItem_t *dspRoot = scriptableDspRoot ();

    scriptableItem_t *preset = dspRoot->children;
    scriptableItem_t *plugin = preset->children;

    const char *pluginId = scriptableItemPropertyValueForKey(plugin, "pluginId");
    XCTAssert(pluginId);
    XCTAssertEqualObjects([NSString stringWithUTF8String:pluginId], @"supereq");

    plugin = plugin->next;
    pluginId = scriptableItemPropertyValueForKey(plugin, "pluginId");
    XCTAssert(pluginId);
    XCTAssertEqualObjects([NSString stringWithUTF8String:pluginId], @"SRC");

    plugin = plugin->next;
    pluginId = scriptableItemPropertyValueForKey(plugin, "pluginId");
    XCTAssert(pluginId);
    XCTAssertEqualObjects([NSString stringWithUTF8String:pluginId], @"m2s");

    scriptableFree();
}

- (void)test_LoadEncoderPreset_ReturnsExpectedData {
    scriptableEncoderLoadPresets ();
    scriptableItem_t *encoderRoot = scriptableEncoderRoot ();
    XCTAssertEqual(1, scriptableItemNumChildren (encoderRoot));
    scriptableFree();
}

- (void)test_EncoderPreset_HasNoChildren {
    scriptableEncoderLoadPresets ();
    scriptableItem_t *encoderRoot = scriptableEncoderRoot ();

    scriptableItem_t *preset = encoderRoot->children;
    XCTAssertTrue(preset->children == NULL);

    scriptableFree();
}

- (void)test_EncoderPreset_HasEncoderProperty {
    scriptableEncoderLoadPresets ();
    scriptableItem_t *encoderRoot = scriptableEncoderRoot ();

    scriptableItem_t *preset = encoderRoot->children;

    const char *val = scriptableItemPropertyValueForKey(preset, "encoder");
    XCTAssert(val);
    XCTAssertEqualObjects([NSString stringWithUTF8String:val], @"cp %i %o");

    scriptableFree();
}


@end
