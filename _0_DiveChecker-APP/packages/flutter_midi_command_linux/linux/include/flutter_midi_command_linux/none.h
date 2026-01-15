// Dummy header for FFI-only plugin
// This plugin uses Dart FFI and does not have a native plugin class

#ifndef FLUTTER_PLUGIN_NONE_H_
#define FLUTTER_PLUGIN_NONE_H_

#include <flutter_linux/flutter_linux.h>

G_BEGIN_DECLS

// Dummy registration function (no-op)
static inline void none_register_with_registrar(FlPluginRegistrar* registrar) {
  // This plugin uses Dart FFI, no native registration needed
  (void)registrar;
}

G_END_DECLS

#endif  // FLUTTER_PLUGIN_NONE_H_
