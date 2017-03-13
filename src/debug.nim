import
  hashes,
  logging

import
  assets/asset,
  event_bus,
  events/event

type
  DebugMode* = enum
    TEXT

  Debug* = ref EventProducer

proc debugFontRetrieved*(producer: ref EventProducer, debugFont: ref Asset) =
  let debug = cast[Debug](producer)
  debug.debugFont = debugFont

  debug.initialized = true
    
proc debugFontLoaded*(producer: ref EventProducer, events: EventBus, debugFontAssetId: Hash) =
  let debug = cast[Debug](producer)
  debug.debugFontAssetId = debugFontAssetId

  var getDebugFontEvent = FragEvent(
    producer: debug,
    eventType: GetAsset,
    assetId: debug.debugFontAssetId,
    getAssetCallback: debugFontRetrieved
  )

  events.dispatch(
    getDebugFontEvent
  )

proc init*(debug: Debug, events: EventBus) =
  if debug.initialized:
    warn "Debug subsystem already initialized."
    return

  var loadDebugFontEvent = FragEvent(
      eventBus: events,
      producer: debug,
      eventType: LoadAsset,
      filename: "fonts/FiraCode/distr/ttf/FiraCode-Regular.ttf",
      assetType: TTF,
      loadAssetCallback: debugFontLoaded
    )

  events.dispatch(
    loadDebugFontEvent
  )

proc shutdown*(debug: Debug, events: EventBus) =
  var unloadDebugFontEvent = FragEvent(
    eventType: UnloadAsset,
    filename: "fonts/FiraCode/distr/ttf/FiraCode-Regular.ttf"
  )
  
  events.dispatch(
    unloadDebugFontEvent
  )