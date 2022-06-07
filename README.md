# SSEG-DisplayVHDL
SSEG is controlled by SW(0 to 4).
SW(0) controls the speed as follows:
o SW(0)=’0’ is fast. Precisely one jump per 1 second; approximate timing is not accepted
o SW(1)=’1’ is slow. Precisely one jump per 2 seconds; approximate timing is not accepted
 SW(1) controls the direction as follows:
o SW(1)=’0’ is moving left: _ _ _ 8  _ _ 8 _  _ 8 _ _  8 _ _ _  _ _ _ 8 …
o SW(1)=’1’ is moving right: 8 _ _ _  _ 8 _ _  _ _ 8 _  _ _ _ 8  8 _ _ _ …
 SW(2) is the meltdown switch.
o SW(2)=’0’ is normal. It has no effect
o SW(2)=’1’ melts down the character on the current SSEG.
 Melt-down is a visual effect, which is shown below; it depicts what happens to the character
on one of the segments as a time sequence.
 When the SW(2) is set to ‘1’, the segment-to-segment movement stops and the segment
that has the 8 character melts down that character 1 second per cathode. During the
meltdown, the 8 character turns into 0 initially since the “g” cathode melts down. In the
next second, the “f” cathode melts down, and “e” melts down, and if the melting is not
stopped, the character turns into the last one shown below (upper dash, leaving only “a”
cathode turned ON) and one more second later, it totally disappears. It doesn’t melt beyond
totally blank.

o If during melting, the SW(2) switch is changed back to ‘0’, the melting of that segment stops and
the character resumes its moving; however, the “melted” version moves;
o for example if the melting was 5 seconds, the character melted down to the second from the right
(leaving only “a” and “b” cathodes active); this is the character that continues moving (left or right, based on the direction switches).
 SW(3) is the UNmeltdown switch.
o SW(3)=’0’ is normal. It has no effect
o SW(3)=’1’ does exactly the opposite of what SW(2) does; i.e., it keeps adding dashes until it
reaches 8. It doesn’t unmelt beyond 8; it stays there.
o When SW(3) is flicked back to 0, whatever is on the segment starts moving based on the direction
switch…
 Implement a TURTLE mode as follows:
 SW(4) is TURTLE mode as follows:
o SW(4)=’0’ has no effect
o SW(4)=’1’ is TURTLE mode. This mode ignores the SW(0) switch. Everything is identical to what
is described, except the movement speed is 3 seconds per move.
 TURTLE switch has no effect on meltdown or unmeltdown speeds; the only change in TURTLE mode is
the movement speed, which becomes 3 seconds per move (whether left or right).
 You must use additional states to implement this functionality
