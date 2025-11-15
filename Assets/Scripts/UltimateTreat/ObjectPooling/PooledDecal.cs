using DG.Tweening;
using System.Collections;
using UnityEngine;

public class PooledDecal : PooledAsset
{
    [SerializeField] private float _lifeSpan = 3f;

    private void OnEnable()
    {
        transform.DOScale(1, 0.4f).SetEase(Ease.OutBounce);
        StartCoroutine(TimeEnabled());
    }

    IEnumerator TimeEnabled()
    {
        yield return new WaitForSeconds(_lifeSpan/2);
        transform.DOScale(0.2f, _lifeSpan / 2).SetEase(Ease.InOutElastic);
        yield return new WaitForSeconds(_lifeSpan / 2);
        returnItem();
    }
}
