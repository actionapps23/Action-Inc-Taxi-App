'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "abb36797a244f3c8e39626a92c1518aa",
"assets/AssetManifest.bin.json": "218e9560910e861cd98911d8b1027826",
"assets/AssetManifest.json": "24ec0fbfcc099bbde660d8e54f569e66",
"assets/assets/icons/car_details.svg": "3148e6f167c2fdf2a5eeecd707b03f75",
"assets/assets/icons/cash.svg": "0df90b506d5a0d1f34a42b263fecc3a1",
"assets/assets/icons/close_procedure.svg": "61644783fa6da52a8cd4533ad768618f",
"assets/assets/icons/dashboard.svg": "9193b87a49d8707b270fdfb765630061",
"assets/assets/icons/entry_list.svg": "aa93182f44dc979a204e2f463ab747eb",
"assets/assets/icons/entry_section.svg": "3a61183d294a2c2e4e58296729e4d4cb",
"assets/assets/icons/expenses.svg": "9523a0b73fe503ee8ea61044030e8fc2",
"assets/assets/icons/gcash.svg": "2efbdadf0405a7e10e73f5987f42ab47",
"assets/assets/icons/inventory.svg": "3b8523d9e63bcbd67fdf5be5a46243ba",
"assets/assets/icons/logout.svg": "ffaca93045ff0daadf840c73493162e5",
"assets/assets/icons/maintainence.svg": "d3c9d596eb16f3d4b2df73c47b32179d",
"assets/assets/icons/notifications.svg": "a7e3d53fcba3e6cc8e1d1bd08d5494af",
"assets/assets/icons/open_procedure.svg": "5035bc00c46e812a8edbed0fb28caa59",
"assets/assets/icons/renewal_n_status.svg": "9accb7baffeab34760468cbd52689e5a",
"assets/assets/icons/taxi_inspection.svg": "5035bc00c46e812a8edbed0fb28caa59",
"assets/assets/images/bottom_view.png": "69919a88a40dd2fe09d4d5f82d5eba30",
"assets/assets/images/front_view.png": "e0e2f5b2ae823133673e30f4254fa9ff",
"assets/assets/images/interior.png": "a1cf7ace90a1e92583e44782b3f95962",
"assets/assets/images/left_view.png": "da972de5aaafa13d7f68d75f610463cc",
"assets/assets/images/logo.png": "8a74c7a083fd6032c5f5245a3b08c7c3",
"assets/assets/images/mechanical_part.png": "01c611b5e29c30f20d5a8823257cff8a",
"assets/assets/images/rear_view.png": "74d3b312b1f7239ff0792e419cd492de",
"assets/assets/images/right_view.png": "9fb033d2d1087af9f0aba8b3fb1172ba",
"assets/assets/images/top_view.png": "00ca2cf81342b621090e4c166e8a41bd",
"assets/assets/images/user_avatar.png": "659ac4c45a4b4dc8ea1e1a8cb3b232bb",
"assets/assets/logo/complete_logo.svg": "4cd7be6e96157e4115a442bcc94642bf",
"assets/assets/logo/logo.svg": "2dd3f598063cbdb1b7f1a95ed1ff5931",
"assets/assets/logo/logo_text.svg": "b9c8a1ad27f7e93498df88280768ca95",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "67304e0a8c25161b65c0f661d7e40d85",
"assets/NOTICES": "678e63fe3dd443c95bc0edfe38943e25",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"flutter_bootstrap.js": "9cf4a06513015205aa3b6ebe230a34ac",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "9ce91ac38bc46139067cbb0580a789ef",
"/": "9ce91ac38bc46139067cbb0580a789ef",
"main.dart.js": "5ac90f28cab9e2bf12742804d38faf22",
"manifest.json": "7cf7a7936f03cecb21fdd2641b95e202",
"version.json": "16c9cd3c69a49c281f0f1803c90c17e2"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
