extends Node

var paletteList:Array = [
	[Color("311d3f"),Color("522546"),Color("88304e"),Color("e23e57")], #0
	[Color("300532"),Color("aa3763"),Color("f6dec4"),Color("fef8dd")],
	[Color("003459"),Color("028090"),Color("02c39a"),Color("fce38a")],
	[Color("ac005d"),Color("f85959"),Color("ff9f68"),Color("feff89")],
	[Color("011f3f"),Color("0960bd"),Color("429ffd"),Color("fef2bf")],
	[Color("2c2d34"),Color("e94822"),Color("f2910a"),Color("efd510")], #5
	[Color("212121"),Color("3a4042"),Color("50717b"),Color("8ecccc")],
	[Color("552244"),Color("596157"),Color("5b8c5a"),Color("cfd186")],
	[Color("3c3352"),Color("359768"),Color("a7d46f"),Color("ffed8f")],
	[Color("241023"),Color("883c82"),Color("b7569a"),Color("ffbf00")],
	[Color("5d5b6a"),Color("758184"),Color("cfb495"),Color("f5cdaa")], #10
	[Color("26466f"),Color("a888ff"),Color("8bdeff"),Color("c2ffff")],
	[Color("23425f"),Color("a64942"),Color("ff7844"),Color("ffab5e")],
	[Color("412135"),Color("84243b"),Color("de4242"),Color("ffe165")],
	[Color("6a2c70"),Color("b83b5e"),Color("f08a5d"),Color("f9ed69")],
	[Color("620808"),Color("a53f3f"),Color("f4ce74"),Color("ffe9c1")], #15
	[Color("25161b"),Color("453953"),Color("975a5e"),Color("f3cba5")],
	[Color("623448"),Color("973961"),Color("d62b70"),Color("ff006c")],
	[Color("520556"),Color("8b104e"),Color("ca431d"),Color("ff9900")],
	[Color("35635b"),Color("529471"),Color("a3cd9e"),Color("e5f1e3")],
	[Color("581845"),Color("900c3f"),Color("c70039"),Color("ff5733")], #20
	[Color("33030d"),Color("5a082d"),Color("9d0b28"),Color("ff004d")],
	[Color("2f1b41"),Color("9f1e49"),Color("fecd51"),Color("f2f2f2")],
	[Color("363434"),Color("5c5757"),Color("62929a"),Color("efecec")],
	[Color("381460"),Color("b21f66"),Color("fe346e"),Color("ffbd69")],
	[Color("6c5b7c"),Color("c06c84"),Color("f67280"),Color("f8b595")], #25
	[Color("241e92"),Color("5432d3"),Color("7b6cf6"),Color("e5a5ff")],
	[Color("8c54a1"),Color("aea1ea"),Color("b2ebf9"),Color("fafbd4")],
	[Color("346473"),Color("25a55f"),Color("9bdf46"),Color("e9f679")],
	[Color("304d4e"),Color("4b7551"),Color("8a9e52"),Color("f0d699")],
	[Color("071a52"),Color("086972"),Color("17b978"),Color("a7ff83")], #30
	[Color("383746"),Color("3b445b"),Color("49d292"),Color("e8f79a")]
	]
var size = paletteList.size()
var previous: Array
var current:Array

func _ready()->void:
	current = random_palette()

func random_palette()->Array:
	var index:int = randi() % size
	print('palette ', index)
	return paletteList[index]

func new_palette()->void:
	previous = current
	current = random_palette()




