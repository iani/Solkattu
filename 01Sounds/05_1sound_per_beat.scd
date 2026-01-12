// Play one sound per beat
//: SynthDef
SynthDef(\ping, { | freq = 440 |
	var src;
	src = Ringz.ar(Impulse.ar(1e-10) / 50, freq);
	DetectSilence.ar(src, 0.001, 0.1, 2);
	Out.ar(0, src.dup)
}).add;
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
~beats = [
	{ Synth(\ping, [\freq, 400]) },
	{ Synth(\ping, [\freq, 500]) }
];
//
OSCdef(\count, { | msg |
	var count, beat;
	count = msg[3].asInteger;
	beat = count % 3;
	~beats[beat].value;
}, '/count'
)
//:
~clock.set(\bpm, 180);