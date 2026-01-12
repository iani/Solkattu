//: SynthDef
SynthDef(\ping, { | freq = 440 |
	var src;
	src = Ringz.ar(Impulse.ar(1e-10) / 50, freq);
	DetectSilence.ar(src, 0.001, 0.1, 2);
	Out.ar(0, src.dup)
}).add;
