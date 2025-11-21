using DG.Tweening;
using System.Collections;
using UnityEngine;
using UnityEngine.UI;

public class ItemCrate : PooledAsset
{
    [SerializeField] SOType _powerUp;

    private PooledAsset _prefab;
    private Image _iconDisplayed;
    private Text _textDisplayed;
    private SquashAndStretch _sNS;

    private void Start()
    {
        _sNS = GetComponent<SquashAndStretch>();
    }

    private void OnEnable()
    {
        transform.localScale = new Vector3(.2f, .2f, .2f);
        transform.DOScale(Vector3.one, 1f);

        StartCoroutine(StretchDelay());
    }

    IEnumerator StretchDelay()
    {
        yield return new WaitForSeconds(1f);

        transform.localScale = Vector3.one;
        yield return new WaitForSeconds(1.3f);
        _sNS.CheckForAndStartCoroutine();
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.transform.TryGetComponent<CharacterShooting>(out var player))
        {
            switch (_powerUp)
            {
                case SOType.ChocoProjectile:
                    player._queueHability = SOType.ChocoProjectile;
                    player.HasItem = true;
                    break;

                case SOType.RollerProjectile:
                    player._queueHability = SOType.RollerProjectile;
                    player.HasItem = true;
                    break;
                case SOType.CottonProjectile:
                    player._queueHability = SOType.ChocoProjectile;
                    player.HasItem = true;
                    break;
                case SOType.HealPack:
                    player._queueHability = SOType.HealPack;
                    player.HasItem = true;
                    break;
            }
            returnItem();
        }
    }
}
