extends Resource
class_name Act

@export var index: int # index within the current linked list of choices
@export var name: String
@export var default_timeline: DialogicTimeline
@export var success_timeline: DialogicTimeline
@export var next: Act

