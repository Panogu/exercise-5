// personal assistant agent 

/* Task 2 Start of your solution */

// Initial beliefs about states of devices and the owner
// These will be updated by perceptions from the environment

// Task 1: Plans for belief changes about device states and owner state
+lights("on") : true <- .print("Lights are now on.").
+lights("off") : true <- .print("Lights are now off.").
-lights(_) : true <- .print("Light state has changed.").

+blinds("raised") : true <- .print("Blinds are now raised.").
+blinds("lowered") : true <- .print("Blinds are now lowered.").
-blinds(_) : true <- .print("Blind state has changed.").

+mattress("idle") : true <- .print("Mattress is now in idle mode.").
+mattress("vibrating") : true <- .print("Mattress is now vibrating.").
-mattress(_) : true <- .print("Mattress state has changed.").

+owner_state("awake") : true <- .print("Owner is now awake.").
+owner_state("asleep") : true <- .print("Owner is now asleep.").
-owner_state(_) : true <- .print("Owner state has changed.").

// Task 2: React to an upcoming event
+upcoming_event("now") : owner_state("awake") <- 
    .print("Enjoy your event").

+upcoming_event("now") : owner_state("asleep") <- 
    .print("Starting wake-up routine");
    !wake_up_user.

// Task 3: Initialize beliefs about user preferences for waking up
// Lower rank = more preferred method
wakeup_preference(artificial_light, 2).
wakeup_preference(natural_light, 1).
wakeup_preference(vibrations, 0).

// Task 3: Inference rule to determine the best option
best_option(Option) :- 
    wakeup_preference(Option, Rank) & 
    not used_method(Option) & 
    not (wakeup_preference(Other, OtherRank) & 
         not used_method(Other) & 
         OtherRank < Rank).

// Task 4: Plans to wake up the user using different methods
+!wake_up_user : owner_state("asleep") & best_option(vibrations) <-
    .print("Attempting to wake up the user with mattress vibrations");
    setVibrationsMode;
    +used_method(vibrations);
    .wait(2000);  // Wait a bit to see if it works
    !wake_up_user.

+!wake_up_user : owner_state("asleep") & best_option(natural_light) <-
    .print("Attempting to wake up the user with natural light");
    raiseBlinds;
    +used_method(natural_light);
    .wait(2000);
    !wake_up_user.

+!wake_up_user : owner_state("asleep") & best_option(artificial_light) <-
    .print("Attempting to wake up the user with artificial light");
    turnOnLights;
    +used_method(artificial_light);
    .wait(2000);
    !wake_up_user.

// Task 5: Handle the case when all methods have been tried
+!wake_up_user : owner_state("asleep") & used_method(vibrations) & used_method(natural_light) & used_method(artificial_light) <-
    .print("All wake-up methods attempted, but user is still asleep. Continuing to monitor.").

// Success case - user is now awake
+!wake_up_user : owner_state("awake") <-
    .print("Design objective achieved: User is now awake").

/* Task 2 End of your solution */

/* Import behavior of agents that work in CArtAgO environments */
{ include("$jacamoJar/templates/common-cartago.asl") }