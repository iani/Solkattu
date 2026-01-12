// Generate the beats in the server.
// This should have less drift than scheduling in the client.
//:
~clock = { | bpm = 60 |
	var trig;
	trig = 	Impulse.kr(bpm / 60);
	SendReply.kr(
		trig,
		'/count',
		Demand.kr(trig, 0, Dseries(0, 1, inf))
	)
}.play;
//:
OSCdef(\count, { | msg |
	msg.postln;
	Synth(\ping);
}, '/count'
)
//:
~clock.set(\bpm, 120);
~clock.set(\bpm, 90);
~clock.set(\bpm, 60);
//:add some other action
OSCdef(\count2, { | msg |
	postf("[%, %]\n",
		(msg[3].asInteger / 3).floor.asInteger,
		msg[3].asInteger.floor.asInteger
	);
}, '/count'
)
