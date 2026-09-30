# Visual References

These images establish the preferred visual grammar for architecture diagrams.
They are NOT architecture templates.

Inspect the references relevant to the diagram's visual needs. Adapt their drawing
conventions to the user's architecture; derive components, counts, and connections
from the task requirements.

## [chat-websocket-routing.png](chat-websocket-routing.png)

Learn:

- centered infrastructure around two WebSocket server groups
- circular clients
- WebSocket connections shown inside server boundaries
- red Redis stacked-layer representation
- red Pub/Sub queue/channel representation
- selective green highlighting
- spacious arrows

Do not generalize:

- exact number of WebSocket servers
- client IDs
- receiver count
- architecture itself

## [url-shortener-read-write.png](url-shortener-read-write.png)

Learn:

- clean left-to-right entry path
- vertically separated read/write paths
- stacked rectangles for scalable services
- grouped replica topology
- optional design alternatives isolated in their own inset

## [notification-multichannel.png](notification-multichannel.png)

Learn:

- one central routing/processing spine
- separate provider subsystems
- dotted subsystem boundaries
- queue + DLQ visual vocabulary
- long status-return paths routed around the outside

## [news-feed-fanout.png](news-feed-fanout.png)

Learn:

- separation between write path and read path
- Kafka placed as a central asynchronous backbone
- grouped Redis caches
- worker fleets using stacked cards
- secondary stream consumers branching downward

## [media-upload-pipeline.png](media-upload-pipeline.png)

Learn:

- large architectural boundary
- horizontal primary request flow
- asynchronous processing underneath
- cylinder queues
- worker stacks
- long perimeter arrows instead of cutting through the diagram
