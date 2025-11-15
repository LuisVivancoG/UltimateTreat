using System.Collections;
using UnityEngine;

public class ParticlesPooled : PooledAsset
{
    private ParticleSystem _pSystem;
    private float _particlesDuration;

    private void Awake()
    {
        _pSystem = GetComponent<ParticleSystem>();
        _particlesDuration = _pSystem.main.duration;
    }

    private void OnEnable()
    {
        _pSystem.Play();
        StartCoroutine(BackToPool());
    }

    IEnumerator BackToPool()
    {
        yield return new WaitForSeconds(_particlesDuration);
        returnItem();
    }
}
