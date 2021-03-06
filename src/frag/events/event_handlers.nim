import
  events

import
  ../assets/asset,
  ../assets/asset_types,
  ../modules/assets,
  ../modules/gui,
  ../modules/input,
  ../modules/graphics,
  event,
  sdl_event

proc handleLoadAssetEvent*(e: EventArgs) {.procvar.} =
  let event = EventMessage(e).event
  if not event.assetManager.isNil:
    let assetId = event.assetManager.load(event.filename, event.assetType, true)
    event.loadAssetCallback(event.producer, event.eventBus, assetId)

proc handleUnloadAssetEvent*(e: EventArgs) {.procvar.} =
  let event = EventMessage(e).event
  if not event.assetManager.isNil:
    event.assetManager.unload(event.filename, true)

proc handleGetAssetEvent*(e: EventArgs) {.procvar.} =
  let event = EventMessage(e).event
  if not event.assetManager.isNil:
    let asset = assets.get[Texture](event.assetManager, event.assetId)
    event.getAssetCallback(event.producer, asset)

proc handleKeyDown*(e: EventArgs) {.procvar.} =
  let event = SDLEventMessage(e).event
  if not event.input.isNil:
    input.onKeyDown(event.input, event.sdlEventData)
  if not event.gui.isNil:
    gui.onkeyDown(event.gui, event.sdlEventData)

proc handleKeyUp*(e: EventArgs) {.procvar.} =
  let event = SDLEventMessage(e).event
  if not event.input.isNil:
    event.input.onKeyUp(event.sdlEventData)

proc handleWindowResizeEvent*(e: EventArgs) {.procvar.} =
  let event = SDLEventMessage(e).event
  if not event.graphics.isNil:
    event.graphics.onWindowResize(event.sdlEventData)
