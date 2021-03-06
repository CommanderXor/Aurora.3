//Uses combos. Basic attacks bypass armor and never miss
#define WRIST_WRENCH_COMBO "DD"
#define BACK_KICK_COMBO "HG"
#define STOMACH_KNEE_COMBO "GH"
#define HEAD_KICK_COMBO "DHH"
#define ELBOW_DROP_COMBO "HDHDH"

/datum/martial_art/the_sleeping_carp
	name = "The Sleeping Carp"
	deflection_chance = 100
	help_verb = /datum/martial_art/the_sleeping_carp/proc/sleeping_carp_help
	no_guns = TRUE
	no_guns_message = "Use of ranged weaponry would bring dishonor to the clan."

/datum/martial_art/the_sleeping_carp/proc/check_streak(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(findtext(streak,WRIST_WRENCH_COMBO))
		streak = ""
		wristWrench(A,D)
		return 1
	if(findtext(streak,BACK_KICK_COMBO))
		streak = ""
		backKick(A,D)
		return 1
	if(findtext(streak,STOMACH_KNEE_COMBO))
		streak = ""
		kneeStomach(A,D)
		return 1
	if(findtext(streak,HEAD_KICK_COMBO))
		streak = ""
		headKick(A,D)
		return 1
	if(findtext(streak,ELBOW_DROP_COMBO))
		streak = ""
		elbowDrop(A,D)
		return 1
	return 0

/datum/martial_art/the_sleeping_carp/proc/wristWrench(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(!D.stat && !D.stunned && !D.weakened)
		A.do_attack_animation(D)
		D.visible_message("<span class='warning'>[A] grabs [D]'s wrist and wrenches it sideways!</span>", \
						  "<span class='userdanger'>[A] grabs your wrist and violently wrenches it to the side!</span>")
		playsound(get_turf(A), 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		D.drop_item()
		D.apply_damage(5, BRUTE, pick("l_arm", "r_arm"))
		D.Stun(3)
		return 1
	return basic_hit(A,D)

/datum/martial_art/the_sleeping_carp/proc/backKick(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(A.dir == D.dir && !D.stat && !D.weakened)
		A.do_attack_animation(D)
		D.visible_message("<span class='warning'>[A] kicks [D] in the back!</span>", \
						  "<span class='danger'>[A] kicks you in the back, making you stumble and fall!</span>")
		step_to(D,get_step(D,D.dir),1)
		D.Weaken(4)
		playsound(get_turf(D), 'sound/weapons/punch1.ogg', 50, 1, -1)

		return 1
	return basic_hit(A,D)

/datum/martial_art/the_sleeping_carp/proc/kneeStomach(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(!D.stat && !D.weakened)
		A.do_attack_animation(D)
		D.visible_message("<span class='warning'>[A] knees [D] in the stomach!</span>", \
						  "<span class='danger'>[A] winds you with a knee in the stomach!</span>")
		D.audible_message("<b>[D]</b> gags!")
		D.losebreath += 3
		D.Stun(2)
		playsound(get_turf(D), 'sound/weapons/punch1.ogg', 50, 1, -1)

		return 1
	return basic_hit(A,D)

/datum/martial_art/the_sleeping_carp/proc/headKick(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(!D.stat && !D.weakened)
		A.do_attack_animation(D)
		D.visible_message("<span class='warning'>[A] kicks [D] in the head!</span>", \
						  "<span class='danger'>[A] kicks you in the jaw!</span>")
		D.apply_damage(20, BRUTE, "head")
		D.drop_item()
		playsound(get_turf(D), 'sound/weapons/punch1.ogg', 50, 1, -1)

		D.Stun(4)
		return 1
	return basic_hit(A,D)

/datum/martial_art/the_sleeping_carp/proc/elbowDrop(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(D.weakened || D.resting || D.stat)
		A.do_attack_animation(D)
		D.visible_message("<span class='danger'>[A] elbow drops [D]!</span>", \
						  "<span class='danger'>[A] piledrives you with their elbow!</span>")
		if(D.stat)
			D.death() //FINISH HIM!
		D.apply_damage(50, BRUTE, "chest")
		playsound(get_turf(D), 'sound/weapons/punch1.ogg', 75, 1, -1)
		return 1
	return basic_hit(A,D)

/datum/martial_art/the_sleeping_carp/grab_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	add_to_streak("G",D)
	if(check_streak(A,D))
		return 1
	D.grabbedby(A,1)
	var/obj/item/weapon/grab/G = A.get_active_hand()
	if(G)
		G.state = GRAB_AGGRESSIVE //Instant aggressive grab

/datum/martial_art/the_sleeping_carp/harm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	add_to_streak("H",D)
	if(check_streak(A,D))
		return 1
	A.do_attack_animation(D)
	var/atk_verb = pick("punches", "kicks", "chops", "hits", "slams")
	D.visible_message("<span class='danger'>[A] [atk_verb] [D]!</span>", \
					  "<span class='danger'>[A] [atk_verb] you!</span>")
	D.apply_damage(rand(10,15), BRUTE)
	playsound(get_turf(D), 'sound/weapons/punch1.ogg', 25, 1, -1)

	if(prob(D.getBruteLoss()) && !D.lying)
		D.visible_message("<span class='warning'>[D] stumbles and falls!</span>", "<span class='userdanger'>The blow sends you to the ground!</span>")
		D.Weaken(4)
	return 1


/datum/martial_art/the_sleeping_carp/disarm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	add_to_streak("D",D)
	if(check_streak(A,D))
		return 1
	return ..()

/datum/martial_art/the_sleeping_carp/proc/sleeping_carp_help()
	set name = "Recall Teachings"
	set desc = "Remember the martial techniques of the Sleeping Carp clan."
	set category = "Sleeping Carp"

	to_chat(usr, "<b><i>You retreat inward and recall the teachings of the Sleeping Carp...</i></b>")

	to_chat(usr, "<span class='notice'>Wrist Wrench</span>: Disarm Disarm. Forces opponent to drop item in hand.")
	to_chat(usr, "<span class='notice'>Back Kick</span>: Harm Grab. Opponent must be facing away. Knocks down.")
	to_chat(usr, "<span class='notice'>Stomach Knee</span>: Grab Harm. Knocks the wind out of opponent and stuns.")
	to_chat(usr, "<span class='notice'>Head Kick</span>: Disarm Harm Harm. Decent damage, forces opponent to drop item in hand.")
	to_chat(usr, "<span class='notice'>Elbow Drop</span>: Harm Disarm Harm Disarm Harm. Opponent must be on the ground. Deals huge damage, instantly kills anyone in critical condition.")

/obj/item/sleeping_carp_scroll
	name = "mysterious scroll"
	desc = "A scroll filled with strange markings. It seems to be drawings of some sort of martial art."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "scroll2"

/obj/item/sleeping_carp_scroll/attack_self(mob/living/carbon/human/user as mob)
	if(!istype(user) || !user)
		return
	to_chat(user, "<span class='sciradio'>You have learned the ancient martial art of the Sleeping Carp! \
					Your hand-to-hand combat has become much more effective, and you are now able to deflect any projectiles directed toward you. \
					However, you are also unable to use any ranged weaponry. \
					You can learn more about your newfound art by using the Recall Teachings verb in the Sleeping Carp tab.</span>")


	var/datum/martial_art/the_sleeping_carp/theSleepingCarp = new(null)
	theSleepingCarp.teach(user)
	user.drop_item()
	visible_message("<span class='warning'>[src] lights up in fire and quickly burns to ash.</span>")
	new /obj/effect/decal/cleanable/ash(get_turf(src))
	qdel(src)