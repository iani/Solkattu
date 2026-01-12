// Count:
// 1. the number of cycles,
// 2. the beat in cycle and
// 3. the total number of beats
//:
~clock.free;
~clock = { | bpm = 60 |
	var trig;
	trig = 	Impulse.kr(bpm / 60);
	SendReply.kr(
		trig,
		'/count',
		Demand.kr(trig, 0, Dseries(0, 1, inf))
	)
}.play;
//
OSCdef(\count, { | msg |
	var count, cycle, beat;
	count = msg[3].asInteger;
	cycle = (count / 3).floor.asInteger;
	beat = count % 3;
	postf("beat: %, cycle: %, count: %]\n", 
		beat, cycle, count,
	);
}, '/count'
)
