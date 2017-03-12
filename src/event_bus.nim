import
  events,
  logging

import 
  sdl2 as sdl

import
  assets,
  events/event

type
  EventBus* = ref object
    eventEmitter: EventEmitter
    assetManager: AssetManager

proc registerEventHandler*(
  eventBus: EventBus
  , eventHandler: event.EventHandler
  , eventType: dEngineEventType
) =
  events.on(eventBus.eventEmitter, $eventType, eventHandler)

proc dispatch*(eventBus: EventBus, e: var dEngineEvent) =
  if e of SDLEvent:
    var sdlEvent = SDLEvent(e).sdlEventData
    case sdlEvent.kind
    of sdl.WindowEvent:
      let eventMessage  = SDLEventMessage(event: sdlEvent)
      eventBus.eventEmitter.emit($sdlEvent.window.event, eventMessage)
    else:
      warn "Unable to dispatch event with unknown type : " & $sdlEvent.kind
  else:
    case e.eventType
    of LOAD_ASSET:
      e.assetManager = eventBus.assetManager
      let eventMessage = dEngineEventMessage(event: e)
      eventBus.eventEmitter.emit($e.eventType, eventMessage)

proc registerAssetManager*(eventBus: EventBus, assetManager: AssetManager) =
  eventBus.assetManager = assetManager

proc init*(eventBus: EventBus) =
  eventBus.eventEmitter = initEventEmitter()