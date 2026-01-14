//:
a = CountBeats().verbose_(true);
//:
a.spawnCount(2);
//:
b = CountBeats(beatMessage: '/test').verbose_(true);
b.permanent;
b.start;
b.permanent(false);
//:
b.stop;
b.reset.start;
a.stop;
