dofile("app0:/LUA_CLASSES/Line.lua");

LOADEDBACKGROUNDS = {};
LOADEDBACKGROUNDS["op_snowywoods"] = Graphics.loadImage("app0:/graphics/backgrounds/op_snowywoods.jpg");

LOADEDSFX = {};
LOADEDSFX["sfx_rustling"] = Sound.openOgg("app0:/sfx/rustling.ogg");

ACTIVE_SCRIPT = {

	Line.new("", Color.new(255, 255, 255), "A light breeze causes the naked branches overhead to rattle like wooden windchimes."),
	Line.new("", Color.new(255,255,255), "This is a popular retreat for couples in the summer. The deciduous trees provide a beautiful green canopy, far out of sight of teachers and fellow students."),
	Line.new("", Color.new(255,255,255), "But now, in late winter, it feels like I'm standing under a pile of kindling."),
	Line.new("", Color.new(255,255,255), "I breathe into my cupped hands and rub them together furiously to prevent them from numbing in this cold."),
	Line.new("Hisao", Color.new(96,145,116), "\"Just how long am I expected to wait out here, anyway? I'm sure the note said 4:00 PM.\""),
	Line.new("", Color.new(255,255,255), "Ah yes\u{2026} the note… slipped between the pages of my math book while I wasn't looking."),
	Line.new("", Color.new(255,255,255), "As far as clichés go, I'm more a fan of the letter-in-the-locker, but at least this way shows a bit of initiative."),
	Line.new("", Color.new(255,255,255), "As I ponder the meaning of the note, the snowfall gradually thickens."),
	Line.new("", Color.new(255,255,255), "The snowflakes silently falling from the white-painted sky are the only sign of time passing in this stagnant world."),
	Line.new("", Color.new(255,255,255), "Their slow descent upon the frozen forest makes it seem like time has slowed to a crawl."),
	Line.new("", Color.new(255,255,255), "", function() Sound.play(LOADEDSFX["sfx_rustling"],NO_LOOP); March22.NextLine(); end ),
	Line.new("", Color.new(255,255,255), "The rustling of dry snow underfoot startles me, interrupting the quiet mood. Someone is approaching me from behind."),
	Line.new("???", Color.new(255,255,255), "Hi… Hisao? You came?"),
	Line.new("", Color.new(255,255,255), "A hesitating, barely audible question."),
	Line.new("", Color.new(255,255,255), "However, I recognize the owner of that dainty voice instantly."),
	Line.new("", Color.new(255,255,255), "I feel my heart skip a beat."),
	Line.new("", Color.new(255,255,255), "It's a voice I've listened to hundreds of times, but never as more than an eavesdropper to a conversation.")
};