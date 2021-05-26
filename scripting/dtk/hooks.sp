
/**
 * Hooks
 * ----------------------------------------------------------------------------------------------------
 */

Action Hook_OnTakeDamage(int victim, int& attacker, int& inflictor, float& damage, int& damagetype, int& weapon, float damageForce[3], float damagePosition[3], int damagecustom)
{
	bool changed;
	
	// Cap Boss Backstab Damage Received
	//if (damagecustom == TF_CUSTOM_BACKSTAB && victim == g_iBoss)
	if (damagecustom == TF_CUSTOM_BACKSTAB && Player(victim).IsActivator)
	{
		damage = 100.0;		// Multipled to 300
		changed = true;
	}
	
	// Blast Pushing / Self Damage
	if (attacker == victim)
	{
		damage = 0.0;		// Negate all self damage
		changed = true;
	}
	
	if (changed) return Plugin_Changed;
	return Plugin_Continue;
}



/**
 * Logic entity health bar control
 * 
 * @param		char	Name of output fired
 * @param		int		Index of caller entity
 * @param		int		Index of activator entity
 * @param		float	Delay before output was(?) fired
 * @noreturn
 */
void Hook_HealthEnts(const char[] output, int caller, int activator, float delay)
{
	// Fired from math_counters
	if (StrEqual(output, "OutValue", false))
	{
		float min 	= GetEntPropFloat(caller, Prop_Data, "m_flMin");
		float max 	= GetEntPropFloat(caller, Prop_Data, "m_flMax");
		int offset 	= FindDataMapInfo(caller, "m_OutValue");
		float val 	= GetEntDataFloat(caller, offset);

		max -= min;		// Shift range to accept any minimum value
		val -= min;
		
		int index = g_NPCs.FindValue(caller);
		
		if (index != -1)
		{
			g_NPCs.Set(index, val, AL_Health);
			g_NPCs.Set(index, max, AL_MaxHealth);
			Debug("Set health of math_counter %d to %f and max health to %f", caller, val, max);
		}
		
		//int percent = RoundToNearest((val / max) * 255);
		//SetEntProp(healthbar.Index, Prop_Send, "m_iBossHealthPercentageByte", percent);
		RefreshBossHealthHUD();
	}
	
/*	// Fired From logic_relay TODO Replace with logic_case
	if (StrEqual(output, "OnTrigger", false))
	{
		char targetname[256];
		GetEntPropString(caller, Prop_Data, "m_iName", targetname, sizeof(targetname));
		
		if (StrEqual(targetname, DTKENT_HEALTHSCALE_MAX, false))
		{
			Player player = new Player(g_iBoss);
			player.ScaleHealth(3);
		}
		else if (StrEqual(targetname, DTKENT_HEALTHSCALE_OVERHEAL, false))
		{
			// TODO Grab the mode from somewhere
			Player player = new Player(g_iBoss);
			player.ScaleHealth(1);
		}
	}
*/
}
