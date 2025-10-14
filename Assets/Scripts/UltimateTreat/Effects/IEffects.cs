using NUnit.Framework;
using System;
using UnityEngine;

public interface IEffect<TTarget>
{
    void Apply(TTarget target);
    void Cancel();
}

/*[Serializable]
public class DamageEffect : IEffect<HealthSystem>
{
    public int damageAmount = 10;
    public void Apply(HealthSystem target)
    {
        target.TakeDamage(damageAmount);
    }
    public void Cancel()
    {
        //noop
    }
}*/

[Serializable] public class DamageOverTime : IEffect<HealthSystem>
{
    public float Duration = 5f;
    public float TickInterval = 1f;
    public int DamagePerTick;
    
    public void Apply(HealthSystem player)
    {

    }

    public void Cancel()
    {

    }
}