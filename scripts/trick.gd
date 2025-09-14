extends RefCounted
class_name Trick

var text:String
var type:TYPES
enum TYPES {MULTIPLICATIVE, ADDITIVE}
var value:float


func _init(_text, _type, _value):
	text = _text
	type = _type
	value = _value

static func newPencilTrick() -> Trick:
	return Trick.new("- Pencilled", TYPES.MULTIPLICATIVE, 4)
static func newFrontflipTrick() -> Trick:
	return Trick.new("- Frontflip", TYPES.ADDITIVE, 200)
static func newFrontspringTrick() -> Trick:
	return Trick.new("- Frontspring", TYPES.ADDITIVE, 150)
static func newSlideTrick() -> Trick:
	return Trick.new("- Slide", TYPES.MULTIPLICATIVE, 2)
