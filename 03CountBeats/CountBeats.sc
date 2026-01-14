
CountBeats {
	var <bps, <numBeats, <offset = 0, <phase = 0, <count = 0, <beatMessage;
	var <bus, <synth, <oscFunc, <time, <synthBps;
	var <>verbose = false;

	*new { | bps = 1, numBeats, offset = 0, phase = 0, count = 0, beatMessage |
		^this.newCopyArgs(bps, numBeats ? inf, offset, phase, count, beatMessage).init;
	}

	init {
		this.makeBeatMessage;
		this.makeOscFunc;
		this.makeBus;
		this.makeSynth;
		ServerBoot add: { this.makeBus }
	}

	reset { | argCount = 0 | count = argCount }
	permanent { | flag = true |
		if (flag) { CmdPeriod add: this } { CmdPeriod remove: this }
	}

	start { 
		if (synth.isPlaying) {
			postf("CountBeats % is already playing\n", beatMessage)
		}{ oscFunc.enable; this.makeSynth }
	}
	stop { synth.free; }
	
	makeBeatMessage {
		beatMessage ?? { beatMessage = format("/beat%", UniqueID.next).asSymbol }
	}
	
	makeOscFunc {
		oscFunc = OSCFunc({ | msg, argTime |
			#count, synthBps = msg[3..];
			count = count.asInteger;
			time = argTime;
			if (verbose) {
				postf("countbeats % count % bps %\n", beatMessage, count, bps)
			};
			this.changed(\count, count, time);
		}, beatMessage);
	}
	makeBus { bus = Bus.control(Server.default, 1) }
	makeSynth {
		{
			offset.wait;
			synth = { | out = 0, bps = 1, offset = 0, phase = 0  |
				var trig;
				trig = Impulse.kr(bps, phase);
				SendReply.kr(
					trig, beatMessage,
					Demand.kr(trig, 0, [Dseries(count, 1, numBeats), bps])
				);
				Out.kr(out, trig);
			}.play(args: [out: bus.index, bps: bps,
				numBeats: numBeats ? inf, phase: phase]);
			synth.isPlaying = true;
			synth.register;
			
		}.fork;
	}

	// create a new CountBeats instance at the next beat.  
	spawnCount { | argBps = 1, argNumBeats, argOffset = 0, argPhase = 0 |
		this doOnNextBeat: {
			CountBeats(argBps, argNumBeats ? inf, argOffset, argPhase);
		};
	}

	doOnNextBeat { | action |
		var controller;
		controller = SimpleController(this);
		controller.put(\count, { action.value; this removeDependant: controller });
	}
	
	doOnCmdPeriod {
		"Restarting after cmd period".postln;
		postf("count: %, numBeats %\n", count, numBeats);
		{
			oscFunc.enable;
			this.start;
		}.defer(0.1); // ensure cmdPeriod is over before restarting!
	}
}