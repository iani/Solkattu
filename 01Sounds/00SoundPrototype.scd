
~test = { Ringz.ar(K2A.ar(Impulse.kr(1) /100), 400, 0.1) }.play;

//:Basic pulse
~impulse = { Out.kr(0, Impulse.kr(1)) }.play;
~ringz = { Ringz.ar(K2A.ar(In.kr(0) / 100)) }.play;
//:Basic pulse with phase difference
~impulse = { Out.kr(0, Impulse.kr(1)) }.play;
~ringz1 = { Ringz.ar(K2A.ar(In.kr(0) / 100), 500) }.play;
~ringz2 = { Ringz.ar(DelayN.ar(K2A.ar(In.kr(0) / 100), 0.2)) }.play;
//:Towards a synthdef
{ Ringz.ar(Impulse.ar(1e-10) / 20, 400) }.play;
// -----------------------------------------------
//: SynthDef
SynthDef(\ping, { | freq = 440 |
	var src;
	src = Ringz.ar(Impulse.ar(1e-10) / 50, freq);
	DetectSilence.ar(src, 0.001, 0.1, 2);
	Out.ar(0, src.dup)
}).add;
//: Test SynthDef
Synth(\ping);
//:
{
	(40..50).midicps * 2 do: { | f |
		Synth(\ping, args: [\freq, f]);
		0.1.wait;
	}
}.fork;