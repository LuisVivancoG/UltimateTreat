using System.Collections;
using UnityEngine;

public class ParticleEffect : PooledAsset
{
    private float _lifeTime;

    private void Awake()
    {
        var particleSystem = transform.GetComponent<ParticleSystem>();
        _lifeTime = particleSystem.main.duration;
    }
    private void OnEnable()
    {
        StartCoroutine(Countdown());
    }

    IEnumerator Countdown()
    {
        yield return new WaitForSeconds(_lifeTime);
        PoolsManagment.Instance.RemoveObject(this);
    }
}
