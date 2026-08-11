// Copyright 2026 FindIP
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "FindIP Shield",
  "brand": {
    "id": "findip",
    "displayName": "FindIP",
    "thumbnail": ""
  },
  "description": "Visitor risk detection for your website: VPN/proxy/Tor/hosting/malicious flags and a risk score for every session. Loads the FindIP Shield SDK from cdn.findip.net.",
  "categories": [
    "UTILITY",
    "ANALYTICS"
  ],
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "siteKey",
    "displayName": "Public site key",
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      },
      {
        "type": "REGEX",
        "args": [
          "^pub_[a-f0-9]+$"
        ]
      }
    ],
    "help": "From your Shield dashboard (Sites → Install). Starts with pub_ and is safe to expose."
  },
  {
    "type": "CHECKBOX",
    "name": "autoTrack",
    "checkboxText": "Auto-track page views and forms",
    "simpleValueType": true,
    "defaultValue": true
  },
  {
    "type": "SELECT",
    "name": "privacyMode",
    "displayName": "Privacy mode",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "strict",
        "displayValue": "Strict"
      },
      {
        "value": "balanced",
        "displayValue": "Balanced (recommended)"
      },
      {
        "value": "advanced",
        "displayValue": "Advanced"
      }
    ],
    "simpleValueType": true,
    "defaultValue": "balanced"
  },
  {
    "type": "CHECKBOX",
    "name": "pushToDataLayer",
    "checkboxText": "Push risk results to the dataLayer (findip_risk_result events)",
    "simpleValueType": true,
    "defaultValue": true
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const injectScript = require('injectScript');
const callInWindow = require('callInWindow');
const logToConsole = require('logToConsole');

const SDK_URL = 'https://cdn.findip.net/shield/v1.js';

const onSuccess = () => {
  callInWindow('FindIP.init', {
    siteKey: data.siteKey,
    autoTrack: data.autoTrack,
    privacyMode: data.privacyMode,
    pushToDataLayer: data.pushToDataLayer,
  });
  data.gtmOnSuccess();
};

const onFailure = () => {
  logToConsole('FindIP Shield SDK failed to load');
  data.gtmOnFailure();
};

injectScript(SDK_URL, onSuccess, onFailure, 'findip-shield');


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "inject_script",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://cdn.findip.net/"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "FindIP.init"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: Injects the SDK and initializes with configured values
  code: |-
    const mockData = {
      siteKey: 'pub_0123456789abcdef',
      autoTrack: true,
      privacyMode: 'balanced',
      pushToDataLayer: true
    };

    mock('injectScript', (url, onSuccess) => {
      assertThat(url).isEqualTo('https://cdn.findip.net/shield/v1.js');
      onSuccess();
    });

    let initArgs;
    mock('callInWindow', (path, options) => {
      assertThat(path).isEqualTo('FindIP.init');
      initArgs = options;
    });

    runCode(mockData);

    assertThat(initArgs.siteKey).isEqualTo('pub_0123456789abcdef');
    assertThat(initArgs.privacyMode).isEqualTo('balanced');
    assertApi('gtmOnSuccess').wasCalled();
- name: Fails gracefully when the CDN is unreachable
  code: |-
    const mockData = {
      siteKey: 'pub_0123456789abcdef',
      autoTrack: true,
      privacyMode: 'balanced',
      pushToDataLayer: true
    };

    mock('injectScript', (url, onSuccess, onFailure) => {
      onFailure();
    });

    runCode(mockData);

    assertApi('gtmOnFailure').wasCalled();


___NOTES___

Created 2026-08-08. Import via GTM → Templates → Tag Templates → New → menu →
Import. Pairs with docs/shield/google-tag-manager.md (Custom HTML alternative,
dataLayer contract, consent mode).
