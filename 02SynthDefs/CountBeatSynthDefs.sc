// Add synthdefs from scd files in the present folder.
// Each file should return a single synthdef.
// SynthDefs are added every time that the default Server boots.

CountBeatSynthDefs {
	*initClass {
		ServerBoot add: { this.loadSynthDefs }
	}
	
	*loadSynthDefs {
		"CountBeats: Loading Synthdefs".postln;
		(PathName(this.filenameSymbol.asString).pathOnly +/+ "*.scd").pathMatch
		do: { | p |
			postf("Loading: %\n", p);
			p.load.add.name.postln;
		};
	}
}